// lib/widgets/product_card.dart
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;

  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    // "Discover More"
                  },
                  child: const Text(
                    'Discover more >',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.purpleAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
