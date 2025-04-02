class Product {
  final String? id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? 'Tên không xác định',
      price: _parsePrice(json['price']),
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? 'Không có mô tả',
    );
  }

  static double _parsePrice(dynamic priceValue) {
    if (priceValue is num) {
      return priceValue.toDouble();
    }
    if (priceValue is String) {
      return double.tryParse(priceValue) ?? 0.0;
    }
    return 0.0;
  }

  Map<String, dynamic> toJson({bool shouldIncludeId = false}) {
    final data = <String, dynamic>{
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
    };

    if (shouldIncludeId && id != null) {
      data['id'] = id;
    }

    return data;
  }
}
