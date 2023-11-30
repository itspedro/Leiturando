import 'package:Leiturando/models/book.dart';

class BooksRepository {
  static List<Book> list = [
    Book(
      id: 1,
      title: "Livro 1",
      author: "Autor 1",
      cover_url: "assets/images/interstellar.jpg",
      download_url: "https://vocsyinfotech.in/envato/cc/flutter_ebook/uploads/22566_The-Racketeer---John-Grisham.epub",
    ),
    Book(
      id: 2,
      title: "Livro 2",
      author: "Autor 2",
      cover_url: "assets/images/interstellar.jpg",
      download_url: "https://vocsyinfotech.in/envato/cc/flutter_ebook/uploads/22566_The-Racketeer---John-Grisham.epub",
    ),
    Book(
      id: 3,
      title: "Livro 3",
      author: "Autor 3",
      cover_url: "assets/images/interstellar.jpg",
      download_url: "https://vocsyinfotech.in/envato/cc/flutter_ebook/uploads/22566_The-Racketeer---John-Grisham.epub",
    ),
  ];
}