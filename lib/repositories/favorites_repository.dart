import 'dart:collection';
import 'dart:io';

import 'package:Leiturando/adapters/book_adapter.dart';
import 'package:Leiturando/models/book.dart';
import 'package:Leiturando/utils/misc.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';

class FavoritesRepository extends ChangeNotifier {
  final List<Book> _list = [];
  late LazyBox box;
  bool _isLoading = false;

  UnmodifiableListView<Book> get list => UnmodifiableListView(_list);

  bool get isLoading => _isLoading;

  FavoritesRepository() {
    _startRepository();
  }

  _startRepository() async {
    await _openBox();
    await _readFavorites();
    await _downloadAll();
  }

  _openBox() async {
    _isLoading = true;
    notifyListeners();
    Hive.registerAdapter(BookAdapter());
    box = await Hive.openLazyBox<Book>('favorites');
    _isLoading = false;
    notifyListeners();
  }

  save(List<Book> books) {
    for (var book in books) {
      if (!_list.any((cur) => cur.id == book.id)) {
        _list.add(book);
        notifyListeners();
        box.put(book.id, book);
      }
    }
    _downloadAll();
  }

  _readFavorites() async {
    for (var key in box.keys) {
      Book book = await box.get(key);
      _list.add(book);
      notifyListeners();
    }
  }

  remove(Book book) {
    _isLoading = true;
    notifyListeners();
    Misc().deleteFile(book.id);
    _list.removeWhere((cur) => cur.id == book.id);
    box.delete(book.id);
    _isLoading = false;
    notifyListeners();
  }

  bool isBookMarked(Book book) {
    return _list.any((cur) => cur.id == book.id);
  }

  _downloadAll() async {
    if (Platform.isIOS) {
      await requestPermissionAndStartDownload();
    } else if (Platform.isAndroid) {
      await fetchAndroidVersion();
    } else {
      PlatformException(code: '500');
    }
  }

  Future<void> requestPermissionAndStartDownload() async {
    final PermissionStatus status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      await startDownload();
    } else {
      await Permission.storage.request();
    }
  }

  Future<void> fetchAndroidVersion() async {
    final int? version = await getAndroidVersion();
    if (version != null) {
      if (version >= 13) {
        await startDownload();
      } else {
        await requestPermissionAndStartDownload();
      }
      print("ANDROID VERSION: $version");
    }
  }

  Future<int?> getAndroidVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String? version = androidInfo.version.release;
    return int.tryParse(version);
  }

  Future<void> startDownload() async {
    for (var book in _list) {
      await Misc().downloadFile(book.download_url, book.id);
    }
  }
}
