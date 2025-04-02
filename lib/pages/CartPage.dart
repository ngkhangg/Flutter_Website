import 'package:flutter/material.dart';
import '../models/Product.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  final Map<Product, int> cartItems; // Nhận Map<Product, int>

  const CartPage({super.key, required this.cartItems});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Map<Product, int> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = widget.cartItems; // Khởi tạo lại giỏ hàng từ widget.
  }

  void _clearCart() {
    setState(() {
      cartItems.clear(); // Xóa hết sản phẩm trong giỏ hàng
    });
  }

  void _proceedToCheckout() {
    // Xử lý thanh toán ở đây (Ví dụ: Điều hướng đến trang thanh toán)
    // Hiển thị thông báo thanh toán thành công
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Thanh toán thành công!"),
        duration: Duration(seconds: 2), // Hiển thị thông báo trong 2 giây
      ),
    );

    // Xóa giỏ hàng sau khi thanh toán thành công
    _clearCart();

    // Quay lại trang trước (giả sử là trang giỏ hàng)
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Quay lại trang trước
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;
    cartItems.forEach((product, quantity) {
      totalPrice += product.price * quantity;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Giỏ hàng"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _clearCart(); // Gọi phương thức xóa hết giỏ hàng
            },
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text("Giỏ hàng trống", style: TextStyle(fontSize: 18)))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                var product = cartItems.keys.elementAt(index);
                var quantity = cartItems[product]!;
                return Card(
                  elevation: 5, // Tạo bóng cho mỗi sản phẩm
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: product.imageUrl != null
                        ? Image.network(
                            product.imageUrl!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image_not_supported, size: 60),
                    title: Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        "Số lượng: $quantity\nMô tả: ${product.description ?? 'Không có mô tả'}"),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Giá: ${_formatPrice(product.price * quantity)}"),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tổng: ${_formatPrice(totalPrice)}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: _proceedToCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blueAccent, // Màu nền của nút (thay thế primary)
                  foregroundColor:
                      Colors.white, // Màu văn bản của nút (thay thế onPrimary)
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Góc bo tròn
                  ),
                  elevation: 5, // Thêm bóng đổ
                  shadowColor: Colors.black.withOpacity(0.3), // Màu bóng đổ
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text("Thanh toán"),
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
