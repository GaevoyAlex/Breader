import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:provider/provider.dart';

import '../../model/book_model.dart';
import 'utils/library_provider.dart';

class LibraryScreen extends StatefulWidget {
 @override
 _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
 @override
 void initState() {
   super.initState();
   WidgetsBinding.instance.addPostFrameCallback((_) {
     Provider.of<LibraryProvider>(context, listen: false).loadBooks();
   });
 }

 @override 
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('Моя библиотека'),
       actions: [
         IconButton(
           icon: Icon(Icons.search),
           onPressed: () {
             // Поиск
           },
         )
       ],
     ),
     body: Consumer<LibraryProvider>(
       builder: (context, provider, child) {
         if (provider.books.isEmpty) {
           return Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Icon(Icons.book, size: 64, color: Colors.grey),
                 SizedBox(height: 16),
                 Text('Добавьте свою первую книгу'),
               ],
             ),
           );
         }

         return GridView.builder(
           padding: EdgeInsets.all(16),
           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
             crossAxisCount: 2,
             childAspectRatio: 0.7,
             mainAxisSpacing: 16,
             crossAxisSpacing: 16
           ),
           itemCount: provider.books.length,
           itemBuilder: (context, index) {
             final book = provider.books[index];
             return BookCard(book: book);
           },
         );
       },
     ),
     floatingActionButton: FloatingActionButton(
       child: Icon(Icons.add),
       onPressed: () async {
         final provider = Provider.of<LibraryProvider>(context, listen: false);
         final book = await provider.pickAndCreateBook();
         if (book != null) {
           await provider.addBook(book);
         }
       },
     ),
   );
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
                   book.title,
                   style: TextStyle(
                     fontSize: 16,
                     fontWeight: FontWeight.bold
                   ),
                   maxLines: 2,
                   overflow: TextOverflow.ellipsis,
                 ),
                 SizedBox(height: 4),
                 Text(
                   book.author,
                   style: TextStyle(
                     fontSize: 14,
                     color: Colors.grey[600]
                   ),
                   maxLines: 1,
                 ),
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

class ReaderScreen extends StatefulWidget {
 final BookModel book;

 const ReaderScreen({Key? key, required this.book}) : super(key: key);

 @override
 _ReaderScreenState createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
 late PdfControllerPinch _pdfController;

 @override
 void initState() {
   super.initState();
   _pdfController = PdfControllerPinch(
     document: PdfDocument.openFile(widget.book.filepath),
   );
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text(widget.book.title)),
     body: PdfViewPinch(
       controller: _pdfController,
       builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
         options: DefaultBuilderOptions(),
         documentLoaderBuilder: (_) => Center(child: CircularProgressIndicator()),
         pageLoaderBuilder: (_) => Center(child: CircularProgressIndicator()),
         errorBuilder: (_, error) => Center(child: Text(error.toString())),
       ),
     ),
   );
 }
}