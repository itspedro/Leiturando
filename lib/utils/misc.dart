import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class Misc {
  String? filePath;

  downloadFile(String url, int id) async {
    Dio dio = Dio();

    Map<String, dynamic> data = await _getFilePath(id);
    String path = data['path'];
    File file = data['file'];

    if (!file.existsSync()) {
      await file.create();
      await dio.download(
        url,
        path,
        deleteOnError: true,
      ).whenComplete(() {
        print('Downloaded file $id.epub');
        filePath = path;
      });
    } else {
      print('file $id.epub already exists.');
      filePath = path;
    }
  }

   Future<Map<String, dynamic>> _getFilePath(int id) async {
    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    String path = '${appDocDir!.path}/$id.epub}';
    File file = File(path);

    return {'path': path, 'file': file};
  }

  Future<void> deleteFile(int id) async {
    Map<String, dynamic> data = await _getFilePath(id);
    File file = data['file'];

    if (file.existsSync()) {
      print('Deleting file $id.epub');
      await file.delete();
    }
  }
}
