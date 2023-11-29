import 'package:Leiturando/adapters/book_adapter.dart';
import 'package:Leiturando/models/book.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class FavoritesRepository extends ChangeNotifier {
  final List<Book> list = [];
  late LazyBox box;

  FavoritesRepository() {
    _startRepository();
  }

  _startRepository() async {
    await _openBox();
    await _readFavorites();
  }

  _openBox() async {
    Hive.registerAdapter(BookAdapter());
    box = await Hive.openLazyBox<Book>('favorites');
  }

  _readFavorites() {
    box.keys.forEach((key) async {
      Book book = await box.get(key);
      list.add(book);
      notifyListeners();
    });
  }

  add(Book book) {
    list.add(book);
    box.put(book.id, book);
    notifyListeners();
  }

  remove(Book book) {
    list.remove(book);
    box.delete(book.id);
    notifyListeners();
  }

  bool isBookMarked(Book book) {
    return list.contains(book);
  }
}
