import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'package:crypto/crypto.dart';

class AuthApiService {
  static const String _baseUrl = "https://67da427535c87309f52bac20.mockapi.io";
  static const String _authEndpoint = "/auth";

  static String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // Đăng ký tài khoản
  static Future<void> register(User user) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl$_authEndpoint"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'name': user.name,
          'email': user.email,
          'password': _hashPassword(user.password),
          'role': user.role,
        }),
      );

      // In ra phản hồi từ server
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode != 201) {
        throw Exception("Đăng ký thất bại: ${response.body}");
      }
    } catch (e) {
      throw Exception("Lỗi API: ${e.toString()}");
    }
  }

  // Đăng nhập tài khoản
  static Future<User?> login(String email, String password) async {
    try {
      // Gửi yêu cầu lấy danh sách user từ API
      final response = await http.get(Uri.parse("$_baseUrl$_authEndpoint"));

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);

        for (var userData in users) {
          final user = User.fromJson(userData);

          // Kiểm tra email & mật khẩu
          if (user.email == email && user.password == _hashPassword(password)) {
            return user;
          }
        }
      } else {
        throw Exception("Không thể lấy danh sách user.");
      }
      return null;
    } catch (e) {
      throw Exception("Lỗi kết nối: ${e.toString()}");
    }
  }
}
