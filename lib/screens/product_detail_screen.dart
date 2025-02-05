import 'package:flutter/material.dart';
import '../api_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  final int stock;

  const ProductDetailScreen({
    Key? key,
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
  }) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  final ApiService _apiService = ApiService();
  bool isAddingToCart = false;
  int currentStock = 0;
  bool isLoadingStock = true;

  @override
  void initState() {
    super.initState();
    currentStock = widget.stock;
    _refreshStock();
  }

  Future<void> _refreshStock() async {
    try {
      setState(() => isLoadingStock = true);
      final stock = await _apiService.getProductStock(widget.id);
      print('Fetched stock: $stock'); // Debug print
      if (mounted) {
        setState(() {
          currentStock = stock;
          isLoadingStock = false;
          // Adjust quantity if it exceeds new stock
          if (quantity > currentStock) {
            quantity = currentStock > 0 ? currentStock : 1;
          }
        });
      }
    } catch (e) {
      print('Error refreshing stock: $e'); // Debug print
      if (mounted) {
        setState(() => isLoadingStock = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating stock: $e')),
        );
      }
    }
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void _incrementQuantity() {
    if (quantity < currentStock) {
      setState(() {
        quantity++;
      });
    }
  }

  Future<void> _addToCart() async {
    if (currentStock == 0) return;

    setState(() {
      isAddingToCart = true;
    });

    try {
      await _apiService.addToCart(widget.id, quantity);
      
      // Wait a moment for the backend to update
      await Future.delayed(const Duration(milliseconds: 500));
      await _refreshStock(); // Refresh stock after adding to cart
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to cart successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to cart: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isAddingToCart = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshStock,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with Hero animation
              Hero(
                tag: 'product-${widget.imageUrl}',
                child: SizedBox(
                  width: double.infinity,
                  height: 350,
                  child: Image.asset(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                transform: Matrix4.translationValues(0, -24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Price Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.title,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  '\$${widget.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Stock Status with loading indicator
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isLoadingStock
                                  ? Colors.grey.withOpacity(0.1)
                                  : currentStock > 0
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isLoadingStock)
                                  const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                else
                                  Icon(
                                    currentStock > 0
                                        ? Icons.check_circle
                                        : Icons.error,
                                    color: currentStock > 0
                                        ? Colors.green
                                        : Colors.red,
                                    size: 20,
                                  ),
                                const SizedBox(width: 8),
                                Text(
                                  currentStock > 0
                                      ? 'In Stock ($currentStock available)'
                                      : 'Out of Stock',
                                  style: TextStyle(
                                    color: currentStock > 0
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Description
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.description,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Quantity Selector
                          if (currentStock > 0) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildQuantityButton(
                                  Icons.remove,
                                  _decrementQuantity,
                                  quantity > 1,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Text(
                                    quantity.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                _buildQuantityButton(
                                  Icons.add,
                                  _incrementQuantity,
                                  quantity < currentStock,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: currentStock > 0 && !isAddingToCart ? _addToCart : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purpleAccent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isAddingToCart
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    currentStock > 0 ? 'Add to Cart' : 'Out of Stock',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityButton(
    IconData icon,
    VoidCallback onPressed,
    bool enabled,
  ) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: enabled ? Colors.purpleAccent : Colors.grey.shade200,
      ),
      child: IconButton(
        onPressed: enabled ? onPressed : null,
        icon: Icon(icon),
        color: enabled ? Colors.white : Colors.grey,
        padding: const EdgeInsets.all(8),
      ),
    );
  }
}
