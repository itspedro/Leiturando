import 'package:Leiturando/models/book.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class BooksRepository {
  static List<Book> list = [];

  Dio dio = Dio(BaseOptions(baseUrl: 'https://escribo.com/'));

  Future<void> fetchBooks() async {
    try {
      final response = await dio.get('/books.json');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        for (var book in data) {
          if (!list.any((cur) => cur.id == book['id'])) {
            list.add(Book.fromJson(book));
          }
        }
        for (var book in list) {
          String cover_path = await getCoverPath(book.id);
          book.cover_path = cover_path;
        }
        await downloadImages();
      } else {
        throw Exception('Erro ao carregar livros.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> downloadImages() async {
  for (var book in list) {
    final imagePath = await getCoverPath(book.id);
    await dio.download(
      book.cover_url,
      imagePath,
      deleteOnError: true,
    );
    }
  }

  Future<String> getCoverPath(int id) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/$id.jpg';
    return imagePath;
  }

}
