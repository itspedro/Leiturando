import 'package:Leiturando/models/book.dart';
import 'package:Leiturando/repositories/books_repository.dart';
import 'package:Leiturando/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../settings/settings_view.dart';
import '../Book/book_details_view.dart';

/// Displays a list of SampleItems.
class HomeView extends StatelessWidget {
  HomeView({
    super.key,
  });

  final items = BooksRepository.list;

  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Livros', icon: Icon(Icons.book)),
    Tab(text: 'Favoritos', icon: Icon(Icons.bookmarks)),
  ];

  static const routeName = '/';

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
  return Consumer<FavoritesRepository>(
    builder: (context, box, child) {
    if (box.isLoading) {
      return const CircularProgressIndicator();
    } else {
      final favoritesRepository =
          Provider.of<FavoritesRepository>(context);

      final List<Book> books =
          isFavoritesTab ? favoritesRepository.list : items;

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
          final bool isBookMarked = box.isBookMarked(book);

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
                  onPressed: () {
                    if (isBookMarked) {
                      favoritesRepository.remove(book);
                    } else {
                      favoritesRepository.save([book]);
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
                  book.cover_url,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      );
    }
    },
  );
}
