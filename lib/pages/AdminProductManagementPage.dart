import 'package:flutter/material.dart';
import '../models/Product.dart';
import '../services/product_api_service.dart';
import 'add_product_page.dart';
import 'edit_product_page.dart';
import 'DeleteProductPage.dart';
import 'package:intl/intl.dart';

class AdminProductManagementPage extends StatefulWidget {
  final bool showManagement;
  final bool isAdmin;

  const AdminProductManagementPage({
    super.key,
    required this.showManagement,
    required this.isAdmin,
  });

  @override
  _AdminProductManagementPageState createState() =>
      _AdminProductManagementPageState();
}

class _AdminProductManagementPageState
    extends State<AdminProductManagementPage> {
  List<Product> _products = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final products = await ProductApiService.fetchProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  String _formatPrice(double price) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý sản phẩm"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProducts,
          ),
        ],
      ),
      body: _buildContent(),
      floatingActionButton: widget.showManagement
          ? FloatingActionButton(
              onPressed: _navigateToAddProduct,
              child: const Icon(Icons.add),
              tooltip: 'Thêm sản phẩm',
            )
          : null,
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loadProducts,
              child: const Text("Thử lại"),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProducts,
      child: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: _products.length,
        itemBuilder: (context, index) => _buildProductItem(_products[index]),
      ),
    );
  }

  Widget _buildProductItem(Product product) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: _buildProductImage(product.imageUrl),
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatPrice(product.price),
              style: const TextStyle(
                color: Colors.green,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              product.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 13,
              ),
            ),
          ],
        ),
        trailing: widget.showManagement ? _adminActions(product) : null,
        onTap: () => _navigateToEdit(product),
      ),
    );
  }

  Widget _adminActions(Product product) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () => _navigateToEdit(product),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _navigateToDelete(product),
        ),
      ],
    );
  }

  Widget _buildProductImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        url.isEmpty ? 'default_image_url_here' : url,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 70),
      ),
    );
  }

  void _navigateToEdit(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductPage(product: product),
      ),
    );

    if (result == true) {
      _loadProducts();
    }
  }

  void _navigateToDelete(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeleteProductPage(product: product),
      ),
    );

    if (result == true) {
      _loadProducts();
    }
  }

  void _navigateToAddProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductPage(),
      ),
    ).then((_) {
      _loadProducts();
    });
  }
}
