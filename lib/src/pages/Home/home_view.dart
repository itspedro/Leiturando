import 'package:flutter/material.dart';

import '../../settings/settings_view.dart';
import '../Book/book.dart';
import '../Book/book_details_view.dart';

/// Displays a list of SampleItems.
class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    this.items = const [Book("Livro 1"), Book("Livro 2"), Book("Livro 3")],
  });

  static const routeName = '/';

  final List<Book> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        restorationId: 'homeView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];
          return GridTile(
            footer: GridTileBar(
              title: Text(item.nome),
              backgroundColor: Colors.black45,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GestureDetector(
                onTap: () {
                  Navigator.restorablePushNamed(
                    context,
                    BookDetailsView.routeName,
                  );
                },
                child: Image.asset(
                  'assets/images/interstellar.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
