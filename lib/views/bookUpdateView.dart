import 'package:flutter/material.dart';
import 'package:flutter_api_mvp/models/book.dart';
import 'package:flutter_api_mvp/services/book_services.dart';

class BookUpdateView extends StatefulWidget {
  final Book book;
  
  const BookUpdateView({Key? key, required this.book}) : super(key: key);

  @override
  _BookUpdateViewState createState() => _BookUpdateViewState();
}

class _BookUpdateViewState extends State<BookUpdateView> {
  final _formKey = GlobalKey<FormState>();
  final BookService _bookService = BookService();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _pageCountController;
  late TextEditingController _excerptController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book.title);
    _descriptionController = TextEditingController(text: widget.book.description);
    _pageCountController = TextEditingController(text: widget.book.pageCount.toString());
    _excerptController = TextEditingController(text: widget.book.excerpt);
  }

  void _updateBook() async {
    if (_formKey.currentState!.validate()) {
      try {
        Book updatedBook = Book(
          id: widget.book.id,
          title: _titleController.text,
          description: _descriptionController.text,
          pageCount: int.parse(_pageCountController.text),
          excerpt: _excerptController.text,
          publishDate: DateTime.now(),
        );

        await _bookService.updateBook(updatedBook);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Libro actualizado exitosamente'),
            backgroundColor: Color(0xFF4A3933),
          ),
        );
        
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar el libro: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Libro', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF4A3933),
      ),
      backgroundColor: Color(0xFFF4ECD8),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            color: Color(0xFFE7DFC6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Editar Detalles del Libro',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A3933),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      controller: _titleController,
                      label: 'Título',
                      validator: (value) => value!.isEmpty ? 'Por favor ingrese un título' : null,
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Descripción',
                      maxLines: 3,
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: _pageCountController,
                      label: 'Número de Páginas',
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Por favor ingrese el número de páginas' : null,
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: _excerptController,
                      label: 'Extracto',
                      maxLines: 3,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateBook,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4A3933),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Actualizar Libro',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color(0xFF4A3933)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF4A3933)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF4A3933), width: 2),
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }
}