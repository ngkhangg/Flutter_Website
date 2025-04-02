import 'package:flutter/material.dart';
import '../models/Product.dart';
import '../services/product_api_service.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final product = Product(
      name: _nameController.text,
      price: double.parse(_priceController.text),
      description: _descriptionController.text,
      imageUrl: _imageUrlController.text,
    );

    try {
      await ProductApiService.addProduct(product);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi thêm sản phẩm: $e")),
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
        title: const Text("Thêm sản phẩm"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Thêm hình ảnh minh họa
                Image.asset(
                  'assets/logo_image.png', // Đảm bảo đường dẫn chính xác
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 16),

                // Tên sản phẩm
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên sản phẩm',
                    prefixIcon: Icon(Icons.text_fields),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên sản phẩm';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Giá sản phẩm
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Giá sản phẩm',
                    prefixIcon: Icon(Icons.monetization_on),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập giá sản phẩm';
                    }
                    try {
                      double.parse(value);
                    } catch (e) {
                      return 'Vui lòng nhập giá hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Mô tả sản phẩm
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Mô tả sản phẩm',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mô tả sản phẩm';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // URL hình ảnh
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'URL hình ảnh',
                    prefixIcon: Icon(Icons.image),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập URL hình ảnh';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Nút thêm sản phẩm
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _addProduct,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors
                              .blueAccent, // Sử dụng backgroundColor thay cho primary
                        ),
                        child: const Text(
                          'Thêm sản phẩm',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
