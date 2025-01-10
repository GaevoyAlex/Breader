import 'package:hive/hive.dart';

part 'book_model.g.dart';

@HiveType(typeId:0)
class BookModel extends HiveObject{

  @HiveField(0)
  late String title;

  @HiveField(1)
  late String author;

  @HiveField(2)
  late String filepath;

  @HiveField(3)
  String? coverPath;



  BookModel(
    {
      required this.title,      
      required this.author,
      required this.filepath,
      this.coverPath,    
    }
  )
  {

  }
}