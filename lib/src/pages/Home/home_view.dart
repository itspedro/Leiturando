import 'dart:io';

import 'package:Leiturando/models/book.dart';
import 'package:Leiturando/repositories/books_repository.dart';
import 'package:Leiturando/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

import '../../settings/settings_view.dart';

enum PageEnum {
  home,
  favorites,
}

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
            buildTabView(context, items, PageEnum.home),
            buildTabView(context, items, PageEnum.favorites),
          ],
        ),
      ),
    );
  }
}

Widget buildTabView(BuildContext context, List<Book> items, PageEnum page) {
  return Consumer<FavoritesRepository>(
    builder: (context, box, child) {
      if (box.isLoading) {
        return const Center(
          child: Tab(
            icon: CircularProgressIndicator(),
            text: 'Baixando...',
          )
        );
      } else {
        final favoritesRepository = Provider.of<FavoritesRepository>(context);

        List<Book> books = [];
        String restoreId;

        switch (page) {
          case PageEnum.home:
            books = items;
            restoreId = 'homeView';
            break;
          case PageEnum.favorites:
            books = favoritesRepository.list;
            restoreId = 'favoriteView';
            break;
        }

        if (books.isEmpty) {
          return Center(
            child: Lottie.asset('assets/anim.json'),
          );
        } else {
          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              childAspectRatio: 0.7,
              mainAxisSpacing: 10,
            ),
            restorationId: restoreId,
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
                    onTap: () async {
                      bool fileExists =
                          await favoritesRepository.isFileExists(book);
                      VocsyEpub.setConfig(
                        themeColor: Theme.of(context).primaryColor,
                        identifier: "iosBook",
                        scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
                        allowSharing: true,
                        enableTts: true,
                        nightMode: true,
                      );

                      if (fileExists) {
                        String path =
                            await favoritesRepository.getFilePath(book);

                        VocsyEpub.open(
                          path,
                          lastLocation: EpubLocator.fromJson({
                            "bookId": "2239",
                            "href": "/OEBPS/ch06.xhtml",
                            "created": 1539934158390,
                            "locations": {
                              "cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"
                            }
                          }),
                        );
                      } else {
                        await favoritesRepository.downloadFile(book);
                        String path =
                            await favoritesRepository.getFilePath(book);

                        VocsyEpub.open(
                          path,
                          lastLocation: EpubLocator.fromJson({
                            "bookId": "2239",
                            "href": "/OEBPS/ch06.xhtml",
                            "created": 1539934158390,
                            "locations": {
                              "cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"
                            }
                          }),
                        );
                      }
                    },
                    child: Image.file(
                      File(book.cover_path!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          );
        }
      }
    },
  );
}
