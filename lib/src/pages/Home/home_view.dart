import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../../settings/settings_view.dart';
import '../Book/book.dart';
import '../Book/book_details_view.dart';

/// Displays a list of SampleItems.
class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    this.items = const [
      Book(1, "Livro 1", "Autor 1", "assets/images/interstellar.jpg"),
      Book(2, "Livro 2", "Autor 2", "assets/images/interstellar.jpg"),
      Book(3, "Livro 3", "Autor 3", "assets/images/interstellar.jpg"),
    ],
  });

  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Livros', icon: Icon(Icons.book)),
    Tab(text: 'Favoritos', icon: Icon(Icons.bookmarks)),
  ];

  static const routeName = '/';

  final List<Book> items;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Leiturando'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
          bottom: const TabBar(
            tabs: myTabs,
          ),
        ),
        body: TabBarView(
          children: [
            buildTabView(context, items, false),
            buildTabView(context, items, true),
          ],
        ),
      ),
    );
  }
}

Widget buildTabView(
    BuildContext context, List<Book> items, bool isFavoritesTab) {
  return ValueListenableBuilder(
    valueListenable: Hive.box('favorites').listenable(),
    builder: (context, Box box, child) {
      final List<Book> books = isFavoritesTab
          ? items.where((item) => box.containsKey(item.id)).toList()
          : items;

      return GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          childAspectRatio: 0.7,
          mainAxisSpacing: 10,
        ),
        restorationId: isFavoritesTab ? 'favoritesView' : 'homeView',
        itemCount: books.length,
        itemBuilder: (BuildContext context, int index) {
          final Book book = books[index];
          final bool isBookMarked = box.containsKey(book.id);

          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: GridTile(
              header: GridTileBar(
                title: const Text(""),
                trailing: IconButton(
                    icon: Icon(
                      isBookMarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookMarked ? Colors.red : Colors.black,
                      size: 30,
                    ),
                    onPressed: () async {
                      if (isBookMarked) {
                        await box.delete(book.id);
                      } else {
                        await box.put(book.id, book.id);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            !isBookMarked
                                ? 'Adicionado aos favoritos'
                                : 'Removido dos favoritos',
                          ),
                          duration: const Duration(milliseconds: 1000),
                        ),
                      );
                    },
                  ),
              ),
              footer: GridTileBar(
                title: Text(book.title),
                subtitle: Text(book.author),
                backgroundColor: Colors.black45,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.restorablePushNamed(
                    context,
                    BookDetailsView.routeName,
                  );
                },
                child: Image.asset(
                  book.cover,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
