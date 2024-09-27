import 'package:flutter/material.dart';
import 'product_detail_screen.dart'; // Import the detail screen

class ProductScreen extends StatefulWidget {
  final bool isDarkMode;

  const ProductScreen({
    Key? key,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> products = [
    {
      'imageUrl': 'lib/assets/images/resec_obsidian.png',
      'title': 'ReSec Obsidian',
      'description': 'A luxury watch with a modern twist and precision engineering.',
      'price': '23400'
    },
    {'imageUrl': 'lib/assets/images/delphis_sapphire.png', 'title': 'Delphis Sapphire'},
    {'imageUrl': 'lib/assets/images/resec_helium.png', 'title': 'ReSec Helium'},
    {'imageUrl': 'lib/assets/images/flying_regulator.png', 'title': 'Flying Regulator'},
    {'imageUrl': 'lib/assets/images/grand_regulator.png', 'title': 'Grand Regulator'},
    {'imageUrl': 'lib/assets/images/open_regulator.png', 'title': 'Open Regulator'},
  ];

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      if (index == 0) {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (index == 2) {
        Navigator.pushReplacementNamed(context, '/cart');
      } else if (index == 3) {
        Navigator.pushReplacementNamed(context, '/profile');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: !isLandscape,
            floating: false,
            title: const Text('Watches'),
            backgroundColor: widget.isDarkMode ? Colors.black : Colors.purpleAccent,
            elevation: 0,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isLandscape ? 3 : 2, // 3 cards in landscape
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(_createScaleTransitionRoute(
                          ProductDetailScreen(
                            imageUrl: products[index]['imageUrl']!,
                            title: products[index]['title']!,
                            description: products[index]['description'] ?? 'No description available',
                            price: double.parse(products[index]['price']!),
                          ),
                        ));
                      },
                      child: _buildProductCard(
                        products[index]['imageUrl']!,
                        products[index]['title']!,
                      ),
                    );
                  }
                  return _buildProductCard(
                    products[index]['imageUrl']!,
                    products[index]['title']!,
                  );
                },
                childCount: products.length,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.watch_rounded), label: 'Watches'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
        selectedItemColor: Colors.purpleAccent,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildProductCard(String imageUrl, String title) {
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
              height: 140,
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Discover more >',
                  style: TextStyle(fontSize: 14, color: Colors.purpleAccent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // scale transition
  Route _createScaleTransitionRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return ScaleTransition(
          scale: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
