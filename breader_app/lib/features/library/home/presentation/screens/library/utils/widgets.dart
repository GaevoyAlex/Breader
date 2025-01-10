import 'dart:io';

import 'package:flutter/material.dart';

class Last_books_widget extends StatelessWidget {
  const Last_books_widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

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