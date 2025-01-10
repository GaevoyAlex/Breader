import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'package:pdfx/pdfx.dart';
import '../../../model/book_model.dart';

class LibraryProvider extends ChangeNotifier {
  List<BookModel> _books = [];
  List<BookModel> get books => _books;

  Future<void> loadBooks() async {
    final box = await Hive.openBox<BookModel>('books');
    _books = box.values.toList();
    notifyListeners();
  }


Future<String?> _extractCover(String filePath) async {
  try {
    final document = await PdfDocument.openFile(filePath);
    final page = await document.getPage(1);
    final pageImage = await page.render(width: 200, height: 300);
    
    final appDir = await getApplicationDocumentsDirectory();
    final coverPath = '${appDir.path}/covers/cover_${DateTime.now().millisecondsSinceEpoch}.png';
    
    await Directory(path.dirname(coverPath)).create(recursive: true);
    await File(coverPath).writeAsBytes(pageImage!.bytes);
    
    return coverPath;
  } catch (e) {
    print('Error extracting cover: $e');
    return null;
  }
}
  Future<BookModel?> pickAndCreateBook() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'epub', 'fb2']
    );

    if (result != null) {
      final filePath = result.files.single.path!;
      String? coverPath;

      if (filePath.endsWith('.pdf')) {
        coverPath = await _extractCover(filePath);
      }

      print('ssasasa');

      print(coverPath);

      return BookModel(
        title: result.files.single.name,
        author: 'unknown',
        filepath: filePath,
        coverPath: coverPath,
      );
    }
    return null;
  }

  Future<void> addBook(BookModel book) async {
    final box = await Hive.openBox<BookModel>('books');
    await box.add(book);
    _books.add(book);
    notifyListeners();
  }

  Future<void> deleteBook(BookModel book) async {
    if (book.coverPath != null) {
      final coverFile = File(book.coverPath!);
      if (await coverFile.exists()) {
        await coverFile.delete();
      }
    }

    final box = await Hive.openBox<BookModel>('books');
    await book.delete();
    _books.remove(book);
    notifyListeners();
  }

  Future<void> updateBook(BookModel book) async {
    await book.save();
    notifyListeners();
  }
}