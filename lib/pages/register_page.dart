import 'package:flutter/material.dart';
import '../services/auth_api_service.dart';
import '../models/user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false; // Biến để điều khiển ẩn hiện mật khẩu
  bool _isConfirmPasswordVisible =
      false; // Biến để điều khiển ẩn hiện xác nhận mật khẩu

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA0-9.-]+\.[a-zA-Z]{2,}$',
    caseSensitive: false,
  );

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      final newUser = User(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        role: "user", // Mặc định role là "user"
      );

      await AuthApiService.register(newUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng ký thành công!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lỗi đăng ký: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? _emailValidator(String? value) {
    if (value?.isEmpty ?? true) return 'Vui lòng nhập địa chỉ email';
    if (!_emailRegex.hasMatch(value!.trim()))
      return 'Địa chỉ email không hợp lệ';
    return null;
  }

  String? _passwordValidator(String? value) {
    if ((value?.length ?? 0) < 6) return 'Mật khẩu ít nhất 6 ký tự';
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value != _passwordController.text) return 'Mật khẩu không khớp';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Thêm hình minh họa
            Image.asset(
              'assets/logo_image.png', // Đảm bảo file tồn tại
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 16),

            // Trường Họ và tên
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Họ và tên',
                hintText: 'Nhập họ và tên đầy đủ',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  (value?.isEmpty ?? true) ? 'Vui lòng nhập tên' : null,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Trường Email
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'ví dụ: example@email.com',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: _emailValidator,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Trường Mật khẩu
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                hintText: 'Tối thiểu 6 ký tự',
                prefixIcon: const Icon(Icons.lock),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_isPasswordVisible, // Thay đổi trạng thái ẩn hiện
              validator: _passwordValidator,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Trường Xác nhận mật khẩu
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Xác nhận mật khẩu',
                hintText: 'Nhập lại mật khẩu',
                prefixIcon: const Icon(Icons.lock),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText:
                  !_isConfirmPasswordVisible, // Thay đổi trạng thái ẩn hiện
              validator: _confirmPasswordValidator,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 24),

            // Nút đăng ký
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text(
                      'ĐĂNG KÝ TÀI KHOẢN',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
            const SizedBox(height: 16),

            // Lựa chọn đăng nhập nếu đã có tài khoản
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Đã có tài khoản? '),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Quay lại trang đăng nhập
                  },
                  child: const Text(
                    'Đăng nhập',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
