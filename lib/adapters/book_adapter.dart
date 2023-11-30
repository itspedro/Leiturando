import 'package:Leiturando/models/book.dart';
import 'package:hive/hive.dart';

class BookAdapter extends TypeAdapter<Book> {
  @override
  final typeId = 0;

  @override
  Book read(BinaryReader reader) {
    return Book(
      id: reader.readInt(),
      title: reader.readString(),
      author: reader.readString(),
      cover_url: reader.readString(),
      download_url: reader.readString(),
      cover_path: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.author);
    writer.writeString(obj.cover_url);
    writer.writeString(obj.download_url);
    writer.writeString(obj.cover_path!);
  }

}
