import 'package:flutter/material.dart';
import 'package:products/pages/AdminProductManagementPage.dart';
import '../services/auth_service.dart';
import 'product_list_page.dart';
import 'AccountPage.dart';
import 'CartPage.dart';
import '../models/Product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isAdmin = false;
  String? _userRole;
  Map<Product, int> _cartItems = {};

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    final role = await AuthService.getUserRole();
    setState(() {
      _userRole = role;
      _isAdmin = role == 'admin';
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Hàm thêm sản phẩm vào giỏ hàng
  void _addToCart(Product product) {
    setState(() {
      if (_cartItems.containsKey(product)) {
        _cartItems[product] = _cartItems[product]! + 1;
      } else {
        _cartItems[product] = 1;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Đã thêm ${product.name} vào giỏ hàng")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text("Tech Store",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white)),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.deepPurpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      elevation: 10,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, size: 28),
          onPressed: () async {
            await AuthService.logout();
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_userRole == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Enhanced body transitions
    switch (_selectedIndex) {
      case 0:
        return ProductListPage(
          showManagement: false,
          isAdmin: _isAdmin,
        );
      case 1:
        return const AccountPage();
      case 2:
        if (_isAdmin) {
          return AdminProductManagementPage(
            showManagement: true,
            isAdmin: _isAdmin,
          );
        }
        return const Center(child: Text("Trang không tồn tại"));
      case 3:
        // Chuyển đến trang giỏ hàng và truyền các sản phẩm trong giỏ hàng
        return CartPage(cartItems: _cartItems);
      default:
        return const Center(child: Text("Trang không tồn tại"));
    }
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.deepPurpleAccent,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      elevation: 10,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.list, size: 28),
          label: "Sản phẩm",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 28),
          label: "Tài khoản",
        ),
        if (_isAdmin)
          const BottomNavigationBarItem(
            icon: Icon(Icons.edit, size: 28),
            label: "Quản lý",
          ),
      ],
    );
  }
}
