import 'dart:io';

import 'package:breader_app/features/library/home/presentation/screens/library/utils/library_provider.dart';
import 'package:breader_app/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:provider/provider.dart';

import '../../../model/book_model.dart';
import 'reader_screen.dart';


class Book_container extends StatelessWidget {
  final String name;
  final String author;
  final Function ontap;
  final String imagePath;
  const Book_container({super.key,required this.name, required this.author, required this.ontap, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 40,
        height: 20,
        child: Row(
          children: [
            Text(name),
            Text(author),
          ],
        ),
    ));
  }
}


class BookCard extends StatelessWidget {
 final BookModel book;
 
 const BookCard({Key? key, required this.book}) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return Card(
     elevation: 4,
     clipBehavior: Clip.antiAlias,
     child: InkWell(
       onTap: () {
         Navigator.push(
           context,
           MaterialPageRoute(
             builder: (_) => ReaderScreen(book: book),
           ),
         );
       },
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Expanded(
             child: Hero(
               tag: book.filepath,
               child: book.coverPath != null
                 ? Image.file(
                     File(book.coverPath!),
                     fit: BoxFit.cover,
                     width: double.infinity,
                     errorBuilder: (_, __, ___) => _buildPlaceholder(),
                   )
                 : _buildPlaceholder(),
             ),
           ),
           Padding(
             padding: EdgeInsets.all(8),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(
                   book.title.length >= 20 
                   ? book.title.substring(0,book.title.length - 4).substring(0,26) 
                   : book.title.substring(0,book.title.length - 4),
                   style: TextStyle(
                     fontSize: 16,
                     fontWeight: FontWeight.bold
                   ),
                   maxLines: 2,
                   overflow: TextOverflow.ellipsis,
                 ),
                 
                 Row (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                   book.author,
                   style: TextStyle(
                     fontSize: 14,
                     color: Colors.grey[600]
                   ),
                   maxLines: 1,
                 ),
                 IconButton(onPressed: ()async{
                  final provider = Provider.of<LibraryProvider>(context,listen: false);
                  await provider.deleteBook(book);
                 }, icon: Icon(Icons.delete))
                 ],) 
               ],
             ),
           ),
         ],
       ),
     ),
   );
 }

 Widget _buildPlaceholder() {
   return Container(
     color: Colors.grey[200],
     child: Icon(
       Icons.book,
       size: 48,
       color: Colors.grey[400]
     ),
   );
 }
}
