import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:provider/provider.dart';


import 'utils/library_provider.dart';
import 'utils/widgets.dart';

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
