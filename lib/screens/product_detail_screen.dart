import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final double price;

  const ProductDetailScreen({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: !isLandscape, // AppBar remains pinned in portrait, scrolls in landscape
            floating: false,
            title: Text(title),
            backgroundColor: Colors.purpleAccent,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: isLandscape
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image in landscape mode
                    Expanded(
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            imageUrl,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Product Info in landscape mode
                    Expanded(
                      child: _buildProductInfo(context),
                    ),
                  ],
                )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image in portrait mode
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          imageUrl,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Product Info in portrait mode
                    _buildProductInfo(context),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  // product info section
  Widget _buildProductInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Title
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        // Product Price
        Text(
          '\$$price',
          style: const TextStyle(
            fontSize: 22,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 20),

        // Product Description
        Text(
          description,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 20),

        // Add to Cart Button
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              // Handle "Add to Cart" functionality
            },
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Add to Cart'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purpleAccent,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
