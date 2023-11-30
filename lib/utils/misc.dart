import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class Misc {
  String? filePath;

  downloadFile(String url, int id) async {
    Dio dio = Dio();

    Map<String, dynamic> data = await getFilePath(id);
    String path = data['path'];
    File file = data['file'];

    if (!file.existsSync()) {
      await file.create();
      await dio.download(
        url,
        path,
        deleteOnError: true,
      ).whenComplete(() {
        filePath = path;
      });
    } else {
      filePath = path;
    }
  }

   Future<Map<String, dynamic>> getFilePath(int id) async {
    Directory? appDocDir = await getApplicationDocumentsDirectory();

    String path = '${appDocDir.path}/$id.epub';
    File file = File(path);

    return {'path': path, 'file': file};
  }

  Future<void> deleteFile(int id) async {
    Map<String, dynamic> data = await getFilePath(id);
    File file = data['file'];

    if (file.existsSync()) {
      await file.delete();
    }
  }

  Future<bool> isFileExists(int id) async {
    Map<String, dynamic> data = await getFilePath(id);
    File file = data['file'];
    return file.existsSync();
  }

}
