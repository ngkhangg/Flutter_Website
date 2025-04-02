import 'package:flutter/material.dart';
import '../models/Product.dart';
import 'package:intl/intl.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  final Map<Product, int>
      cartItems; // Thay đổi từ List<Product> thành Map<Product, int>
  final Function(Product) onAddToCart;

  const ProductDetailPage({
    Key? key,
    required this.product,
    required this.cartItems, // Tham số cartItems
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        elevation: 0, // Bỏ bóng cho AppBar để giao diện nhẹ nhàng hơn
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hiển thị hình ảnh sản phẩm
              ClipRRect(
                borderRadius: BorderRadius.circular(15), // Bo tròn hình ảnh
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.contain,
                  height: 250, // Đặt chiều cao hình ảnh
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 16),

              // Tên sản phẩm
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // Mô tả sản phẩm
              Text(
                product.description ?? "Không có mô tả.",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),

              // Giá sản phẩm
              Text(
                "Giá: ${_formatPrice(product.price)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),

              // Nút "Thêm vào giỏ hàng"
              Center(
                child: ElevatedButton(
                  onPressed: () => onAddToCart(product),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // Màu nền
                    foregroundColor: Colors.white, // Màu văn bản
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Bo tròn góc nút
                    ),
                    elevation: 5, // Thêm bóng đổ
                  ),
                  child: const Text(
                    "Thêm vào giỏ hàng",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(price);
  }
}
