import 'package:Leiturando/models/book.dart';

class BooksRepository {
  static List<Book> list = [
    Book(
      id: 1,
      title: "Livro 1",
      author: "Autor 1",
      cover: "assets/images/interstellar.jpg",
    ),
    Book(
      id: 2,
      title: "Livro 2",
      author: "Autor 2",
      cover: "assets/images/interstellar.jpg",
    ),
    Book(
      id: 3,
      title: "Livro 3",
      author: "Autor 3",
      cover: "assets/images/interstellar.jpg",
    ),
  ];
}