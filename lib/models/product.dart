class Product {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  final int stock;

  Product({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      imageUrl: json['image_url'] ?? '',
      title: json['name'] ?? '',
      description: json['description'] ?? 'No description available',
      price: json['price'] != null ? double.parse(json['price'].toString()) : 0.0,
      stock: json['stock'] != null ? int.parse(json['stock'].toString()) : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'name': title,
      'description': description,
      'price': price,
      'stock': stock,
    };
  }
}
