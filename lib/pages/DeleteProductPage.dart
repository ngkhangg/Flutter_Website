import 'package:flutter/material.dart';
import '../models/Product.dart';
import '../services/product_api_service.dart';

class DeleteProductPage extends StatelessWidget {
  final Product product;

  const DeleteProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Xóa sản phẩm"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hiển thị thông báo xác nhận xóa
            Text(
              'Bạn chắc chắn muốn xóa sản phẩm "${product.name}"?',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Nút Xóa sản phẩm
            ElevatedButton(
              onPressed: () async {
                try {
                  // Gọi API để xóa sản phẩm
                  await ProductApiService.deleteProduct(product.id!);
                  // Quay lại trang trước sau khi xóa thành công
                  Navigator.pop(context,
                      true); // Trả về true để tải lại danh sách sản phẩm
                } catch (e) {
                  // Hiển thị lỗi nếu có
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Lỗi khi xóa sản phẩm: $e")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red, // Sử dụng backgroundColor thay vì primary
              ),
              child: const Text('Xóa sản phẩm',
                  style: TextStyle(color: Colors.white)),
            ),

            const SizedBox(height: 10),

            // Nút Hủy
            TextButton(
              onPressed: () =>
                  Navigator.pop(context), // Quay lại mà không làm gì
              child: const Text('Hủy'),
            ),
          ],
        ),
      ),
    );
  }
}
