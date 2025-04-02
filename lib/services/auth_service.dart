import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart'; // Đảm bảo import đúng

class AuthService {
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUserRole = 'userRole';
  static const String _keyName = 'name';
  static const String _keyEmail = 'email';

  // Lưu thông tin người dùng khi đăng nhập
  static Future<void> setLoggedIn(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserRole, user.role);
    await prefs.setString(_keyName, user.name);
    await prefs.setString(_keyEmail, user.email);
  }

  // Kiểm tra xem người dùng có đang đăng nhập không
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Lấy vai trò của người dùng
  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserRole);
  }

  // Lấy tên người dùng
  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName);
  }

  // Lấy email của người dùng
  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  // Lấy toàn bộ thông tin người dùng
  static Future<Map<String, String?>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_keyName),
      'email': prefs.getString(_keyEmail),
      'role': prefs.getString(_keyUserRole),
    };
  }

  // Đăng xuất và xóa toàn bộ thông tin người dùng
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Xóa toàn bộ dữ liệu đăng nhập
  }
}
