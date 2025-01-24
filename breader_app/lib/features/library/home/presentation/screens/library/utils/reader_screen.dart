import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';


import '../../../../../../../style/colors.dart';
import '../../../model/book_model.dart';

class ReaderScreen extends StatefulWidget {
  final BookModel book;

  const ReaderScreen({Key? key, required this.book}) : super(key: key);

  @override
  _ReaderScreenState createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  late PdfControllerPinch _pdfController;
  List<int> _bookmarks = [];
  bool _isBookmarking = false;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfControllerPinch(
      document: PdfDocument.openFile(widget.book.filepath),
    );
  }

  void _addBookmark(int pageNumber) {
    setState(() {
      if (!_bookmarks.contains(pageNumber)) {
        _bookmarks.add(pageNumber);
        _isBookmarking = true;
      }
    });
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isBookmarking = false;
        });
      }
    });
  }

  void _navigateToBookmark(int pageNumber) {
    _pdfController.jumpToPage( pageNumber);
  }

  Future<int> _getCurrentPage() async {
    final page = await _pdfController.page;
    return page ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: App_Colors.black_main,
      appBar: AppBar(
        title: Text(
          widget.book.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: App_Colors.black_main,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark, color: Colors.white),
            tooltip: 'Добавить закладку',
            onPressed: () async {
              final currentPage = await _getCurrentPage();
              _addBookmark(currentPage);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Закладка добавлена на страницу $currentPage'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
          ),
          PopupMenuButton<int>(
            icon: const Icon(Icons.menu, color: Colors.white),
            itemBuilder: (context) => _bookmarks
                .map((page) => PopupMenuItem(
                      value: page,
                      child: ListTile(
                        leading: Icon(Icons.bookmark, color: App_Colors.black_main),
                        title: Text("Страница $page"),
                        onTap: () => _navigateToBookmark(page),
                      ),
                    ))
                .toList(),
            onSelected: (page) => _navigateToBookmark(page),
          ),
        ],
      ),
      body: PdfViewPinch(
        controller: _pdfController,
        scrollDirection:Axis.horizontal,  // Горизонтальная прокрутка
        padding: 0, // Убираем отступы
        backgroundDecoration: BoxDecoration(
          color: App_Colors.black_main,
          borderRadius: BorderRadius.circular(0),
        ),
        builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
          options: const DefaultBuilderOptions(),
          documentLoaderBuilder: (_) => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
          pageLoaderBuilder: (_) => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
          errorBuilder: (_, error) => Center(
            child: Text(error.toString(), style: const TextStyle(color: Colors.white)),
          ),
        ),
        onPageChanged: (page) {
          // Можно добавить обработку смены страницы
          print('Page changed: $page');
        },
        onDocumentLoaded: (document) {
          // Можно добавить обработку загрузки документа
          print('Document loaded');
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () async {
              final currentPage = await _getCurrentPage();
              if (currentPage > 0) {
                _pdfController.jumpToPage(currentPage - 1);
              }
            },
            child: const Icon(Icons.arrow_back, color: Colors.white),
            backgroundColor: App_Colors.black_main,
            tooltip: 'Предыдущая страница',
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () async {
              final currentPage = await _getCurrentPage();
              if (currentPage < (_pdfController.pagesCount ?? 1) - 1) {
                _pdfController.jumpToPage(currentPage + 1);
              }
            },
            child: const Icon(Icons.arrow_forward, color: Colors.white),
            backgroundColor: App_Colors.black_main,
            tooltip: 'Следующая страница',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }
}