import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'package:infinitimeapp/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  final String id;
  final Product product;
  final int quantity;
  final double totalPrice;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.totalPrice,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'].toString(), // Ensure ID is converted to string
      product: Product.fromJson(json['product']),
      quantity: int.parse(json['quantity'].toString()),
      totalPrice: double.parse(json['total_price'].toString()),
    );
  }
}

class ApiService {
  // Fetch products from the backend
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}products'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> productsData = data['data'] ?? []; // Adjust this if your API response has a different structure
      return productsData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Get product stock
  Future<int> getProductStock(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}products/$productId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          return int.parse(data['data']['stock'].toString());
        }
        throw Exception('Stock data not found');
      } else {
        throw Exception('Failed to get product stock: ${response.body}');
      }
    } catch (e) {
      print('Error getting stock: $e'); // Debug print
      rethrow;
    }
  }

  // Add to cart
  Future<void> addToCart(String productId, int quantity) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Please login to add items to cart');
    }

    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}cart/add'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'product_id': productId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to add item to cart');
      }
    } catch (e) {
      print('Error adding to cart: $e'); // Debug print
      rethrow;
    }
  }

  // Get cart items
  Future<List<CartItem>> getCartItems() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Please login to view cart');
    }

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}cart'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          return (data['data'] as List)
              .map((item) => CartItem.fromJson(item))
              .toList();
        }
        return [];
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to get cart items');
      }
    } catch (e) {
      print('Error getting cart items: $e'); // Debug print
      rethrow;
    }
  }

  // Update cart item quantity
  Future<void> updateCartItemQuantity(String cartItemId, int quantity) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Please login to update cart');
    }

    try {
      final response = await http.put(
        Uri.parse('${AppConfig.baseUrl}cart/$cartItemId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'quantity': quantity,
        }),
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to update cart item');
      }
    } catch (e) {
      print('Error updating cart: $e'); // Debug print
      rethrow;
    }
  }

  // Remove from cart
  Future<void> removeFromCart(String productId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Please login to remove items from cart');
    }

    try {
      print('Removing cart item with product ID: $productId'); // Debug print
      final response = await http.delete(
        Uri.parse('${AppConfig.baseUrl}cart/delete/$productId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Remove response: ${response.body}'); // Debug print
      print('Status code: ${response.statusCode}'); // Debug print

      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to remove item from cart');
      }
    } catch (e) {
      print('Error removing from cart: $e'); // Debug print
      rethrow;
    }
  }

  // Checkout
  Future<String> checkout(String address, String paymentMethod) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Please login to checkout');
    }

    try {
      print('Sending checkout request...'); // Debug print
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}checkout'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'address': address,
          'payment_method': paymentMethod,
        }),
      );

      print('Checkout response: ${response.body}'); // Debug print
      print('Status code: ${response.statusCode}'); // Debug print

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['order'] != null && data['order']['id'] != null) {
          return data['order']['id'].toString();
        }
        throw Exception('Order ID not found in response');
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Checkout failed');
      }
    } catch (e) {
      print('Error during checkout: $e'); // Debug print
      rethrow;
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print("🔑 Retrieved Token: $token"); // Debug print
    return token;
  }
}
