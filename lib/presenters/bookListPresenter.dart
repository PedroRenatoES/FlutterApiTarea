import 'package:flutter_api_mvp/models/book.dart';
import 'package:flutter_api_mvp/services/book_services.dart';

class BookListPresenter {
  final BookService _service = BookService();
  List<Book> books = [];
  Function? onBooksLoaded;
  Function? onError;

  Future<void> loadBooks() async {
    try {
      books = await _service.fetchBooks();
      if (onBooksLoaded != null) onBooksLoaded!();
    } catch (e) {
      if (onError != null) onError!(e.toString());
    }
  }

  Future<void> deleteBook(int id) async {
    try {
      await _service.deleteBook(id);
      books.removeWhere((book) => book.id == id);
      if (onBooksLoaded != null) onBooksLoaded!();
    } catch (e) {
      if (onError != null) onError!(e.toString());
    }
  }
}