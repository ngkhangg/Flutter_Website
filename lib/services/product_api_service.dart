import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Product.dart';

class ProductApiService {
  static const String _baseUrl =
      "https://67da427535c87309f52bac20.mockapi.io/product";

  // Lấy danh sách sản phẩm
  static Future<List<Product>> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse(_baseUrl)); // Không cần `_endpoint`
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((json) => Product.fromJson(json)).toList();
      }
      throw Exception("Lỗi tải sản phẩm: ${response.statusCode}");
    } catch (e) {
      throw Exception("Lỗi Product API: ${e.toString()}");
    }
  }

  // Thêm sản phẩm mới
  static Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(product.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception("Thêm sản phẩm thất bại: ${response.body}");
      }
    } catch (e) {
      throw Exception("Lỗi Product API: ${e.toString()}");
    }
  }

  // Cập nhật sản phẩm
  static Future<void> updateProduct(Product product) async {
    if ((product.id ?? "").isEmpty) {
      throw Exception("Sản phẩm cần có ID để cập nhật.");
    }

    try {
      final response = await http.put(
        Uri.parse("$_baseUrl/${product.id}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(product.toJson(shouldIncludeId: true)),
      );

      if (response.statusCode != 200) {
        throw Exception("Cập nhật sản phẩm thất bại: ${response.body}");
      }
    } catch (e) {
      throw Exception("Lỗi Product API: ${e.toString()}");
    }
  }

  static Future<void> deleteProduct(String productId) async {
    if ((productId ?? "").isEmpty) {
      throw Exception("Không thể xóa: ID sản phẩm trống.");
    }

    try {
      final response = await http.delete(
        Uri.parse("$_baseUrl/$productId"),
      );

      if (response.statusCode != 200) {
        throw Exception("Xóa sản phẩm thất bại: ${response.body}");
      }
    } catch (e) {
      throw Exception("Lỗi Product API: ${e.toString()}");
    }
  }
}
