
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Book {

  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String author;
  @HiveField(3)
  final String cover;

  const Book(
    this.id,
    this.title,
    this.author,
    this.cover
  );

}
