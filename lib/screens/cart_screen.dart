import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final bool isDarkMode;

  const CartScreen({
    Key? key,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Map<String, dynamic>> _cartItems = [
    {
      'title': 'Rolex Datejust',
      'price': 7500.0,
      'imageUrl': 'lib/assets/images/watch2.jpg',
      'quantity': 1,
    },
    {
      'title': 'ReSec Obsidian',
      'price': 5000.0,
      'imageUrl': 'lib/assets/images/resec_obsidian.png',
      'quantity': 1,
    },
  ];

  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      if (index == 0) {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (index == 1) {
        Navigator.pushReplacementNamed(context, '/products');
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
        slivers: [
          SliverAppBar(
            pinned: !isLandscape,
            floating: false,
            title: const Text('My Cart'),
            backgroundColor: widget.isDarkMode ? Colors.black : Colors.purpleAccent,
            elevation: 0,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                children: [
                  // Cart items section
                  _cartItems.isEmpty
                      ? Center(
                    child: Text(
                      'Your cart is empty!',
                      style: TextStyle(
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  )
                      : Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _cartItems.length,
                        itemBuilder: (context, index) {
                          return _buildCartItem(index);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // total section scrolls in landscape
                  _buildCartSummary(),
                ],
              ),
            ]),
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

  Widget _buildCartItem(int index) {
    final item = _cartItems[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  item['imageUrl'],
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '\$${item['price'].toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: widget.isDarkMode ? Colors.grey : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle),
                onPressed: () {
                  setState(() {
                    if (_cartItems[index]['quantity'] > 1) {
                      _cartItems[index]['quantity']--;
                    }
                  });
                },
                color: Colors.redAccent,
              ),
              Text(
                '${item['quantity']}',
                style: TextStyle(
                  fontSize: 16,
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle),
                onPressed: () {
                  setState(() {
                    _cartItems[index]['quantity']++;
                  });
                },
                color: Colors.greenAccent,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _cartItems.removeAt(index);
                  });
                },
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? Colors.black : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: widget.isDarkMode ? Colors.white12 : Colors.black12,
            offset: const Offset(0, -1),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Text(
                '\$${_cartItems.fold<double>(0.0, (sum, item) => sum + (item['price'] * item['quantity'])).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Checkout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Proceed to Checkout',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
