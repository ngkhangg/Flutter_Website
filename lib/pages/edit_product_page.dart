import 'package:flutter/material.dart';
import '../models/Product.dart';
import '../services/product_api_service.dart';

class EditProductPage extends StatefulWidget {
  final Product product;

  const EditProductPage({super.key, required this.product});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    _descriptionController =
        TextEditingController(text: widget.product.description);
    _imageUrlController = TextEditingController(text: widget.product.imageUrl);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _editProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final updatedProduct = Product(
      id: widget.product.id,
      name: _nameController.text,
      price: double.parse(_priceController.text),
      description: _descriptionController.text,
      imageUrl: _imageUrlController.text,
    );

    try {
      await ProductApiService.updateProduct(updatedProduct);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi cập nhật sản phẩm: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sửa sản phẩm"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  controller: _nameController,
                  labelText: "Tên sản phẩm",
                  icon: Icons.shopping_bag,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _priceController,
                  labelText: "Giá sản phẩm",
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _descriptionController,
                  labelText: "Mô tả sản phẩm",
                  icon: Icons.description,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _imageUrlController,
                  labelText: "URL hình ảnh",
                  icon: Icons.image,
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _editProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors
                              .deepPurpleAccent, // Use backgroundColor instead of primary
                          foregroundColor: Colors.white, // Text color (white)
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30), // More rounded button corners
                          ),
                          elevation: 10, // Shadow effect for the button
                          shadowColor: Colors.deepPurpleAccent
                              .withOpacity(0.5), // Slightly transparent shadow
                        ),
                        child: Text(
                          "Cập nhật sản phẩm",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto', // Optional custom font
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget để tạo các trường nhập liệu với biểu tượng và hiệu ứng đẹp mắt
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black54),
        prefixIcon: Icon(icon, color: Colors.deepPurpleAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurpleAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Colors.deepPurpleAccent, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black26),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập $labelText';
        }
        return null;
      },
    );
  }
}
