import 'package:flutter/material.dart';
import 'package:flutter_api_mvp/models/book.dart';
import 'package:flutter_api_mvp/presenters/bookListPresenter.dart';
import 'package:flutter_api_mvp/views/bookCreateView.dart';
import 'package:flutter_api_mvp/views/bookUpdateView.dart';


class BookListView extends StatefulWidget {
  @override
  _BookListViewState createState() => _BookListViewState();
}

class _BookListViewState extends State<BookListView> {
  final BookListPresenter _presenter = BookListPresenter();

  @override
  void initState() {
    super.initState();
    _presenter.onBooksLoaded = () => setState(() {});
    _presenter.onError = (error) => _showErrorDialog(error);
    _presenter.loadBooks();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Biblioteca', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF4A3933),
      ),
      backgroundColor: Color(0xFFF4ECD8),
      body: _presenter.books.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _presenter.books.length,
              itemBuilder: (ctx, index) {
                Book book = _presenter.books[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  color: Color(0xFFE7DFC6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A3933),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          book.description.isNotEmpty 
                            ? book.description 
                            : 'Sin descripción disponible',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Páginas: ${book.pageCount}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.edit, color: Color(0xFF4A3933)),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookUpdateView(book: book),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(book.id),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookCreateView()),
        ),
        backgroundColor: Color(0xFF4A3933),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirmar Eliminación'),
        content: Text('¿Estás seguro de eliminar este libro?'),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: Text('Eliminar'),
            onPressed: () {
              _presenter.deleteBook(id);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}