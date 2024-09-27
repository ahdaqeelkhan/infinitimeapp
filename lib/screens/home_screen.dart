import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'product_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const HomeScreen({
    Key? key,
    required this.isDarkMode,
    required this.toggleTheme,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController(); // ScrollController for Scrollbar
  Timer? _autoScrollTimer;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      if (index == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProductScreen(isDarkMode: widget.isDarkMode),
          ),
        );
      } else if (index == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CartScreen(isDarkMode: widget.isDarkMode),
          ),
        );
      } else if (index == 3) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              isDarkMode: widget.isDarkMode,
              toggleTheme: widget.toggleTheme,
            ),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.page!.round() == 4) {
        _pageController.animateToPage(0, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
      } else {
        _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    _scrollController.dispose(); // Dispose of ScrollController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: Scrollbar(
        controller: _scrollController,
        thumbVisibility: isLandscape, // Show scrollbar only in landscape mode
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: !isLandscape, // AppBar remains pinned in portrait mode
              floating: false,
              title: const Text('InfiniTime'),
              actions: [
                IconButton(
                  icon: Icon(
                    widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                    color: widget.isDarkMode ? Colors.yellow : Colors.black,
                  ),
                  onPressed: widget.toggleTheme,
                ),
              ],
              backgroundColor: widget.isDarkMode ? Colors.black : Colors.purpleAccent,
              elevation: 0,
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    _buildFeaturedCarousel(),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Latest Arrivals'),
                    _buildProductCard(
                      imageUrl: 'lib/assets/images/deepsea2.jpg',
                      title: 'DeepSea',
                      description: 'Extreme divers\' watches',
                    ),
                    _buildProductCard(
                      imageUrl: 'lib/assets/images/submariner.png',
                      title: 'Submariner',
                      description: 'The supreme divers\' watch',
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Categories'),
                    _buildCategoriesList(),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Best Sellers'),
                    _buildBestSellers(),
                    const SizedBox(height: 20),
                    _buildSectionTitle('What Our Customers Say'),
                    _buildTestimonials(),
                    const SizedBox(height: 30),
                    _buildExploreMore(),
                    const SizedBox(height: 20),
                    _buildFooter(),
                  ],
                ),
              ]),
            ),
          ],
        ),
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

  Widget _buildFeaturedCarousel() {
    return Column(
      children: [
        Container(
          height: 300,
          child: PageView(
            controller: _pageController,
            children: [
              _buildCarouselItem('lib/assets/images/rolex.png'),
              _buildCarouselItem('lib/assets/images/watch2.jpg'),
              _buildCarouselItem('lib/assets/images/watch3.jpeg'),
              _buildCarouselItem('lib/assets/images/watch4.jpg'),
              _buildCarouselItem('lib/assets/images/watch4.png'),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SmoothPageIndicator(
          controller: _pageController,
          count: 5,
          effect: ExpandingDotsEffect(
            activeDotColor: Colors.purpleAccent,
            dotHeight: 8,
            dotWidth: 8,
            expansionFactor: 5,
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselItem(String imageUrl) {
    return Image.asset(
      imageUrl,
      fit: BoxFit.cover,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildProductCard({required String imageUrl, required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(description, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      // Navigation logic for more details
                    },
                    child: const Text(
                      'Discover more >',
                      style: TextStyle(fontSize: 16, color: Colors.purpleAccent),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesList() {
    final List<Map<String, dynamic>> _categories = [
      {'title': 'Luxury', 'icon': Icons.watch},
      {'title': 'Diving', 'icon': Icons.pool},
      {'title': 'Casual', 'icon': Icons.access_time},
      {'title': 'Sport', 'icon': Icons.sports},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.5,
        ),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return _buildCategoryCard(_categories[index]['title'], _categories[index]['icon']);
        },
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Colors.purpleAccent),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(fontSize: 15),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBestSellers() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildProductCard(
            imageUrl: 'lib/assets/images/watch2.jpg',
            title: 'Rolex Datejust',
            description: 'Sleek and stylish',
          ),
          _buildProductCard(
            imageUrl: 'lib/assets/images/watch3.jpeg',
            title: 'Rolex Green Adventure',
            description: 'All green, for you',
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonials() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTestimonial('Verona Divani', 'Best watch I have ever bought! Highly recommended.'),
          const SizedBox(height: 10),
          _buildTestimonial('Henry Cavill', 'Super comfortable and looks great on my wrist.'),
        ],
      ),
    );
  }

  Widget _buildTestimonial(String name, String review) {
    return SizedBox(
      height: 130,
      width: 500,// manual height for the card
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 5),
              Text(
                review,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                maxLines: 2, // Limit text lines
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExploreMore() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: () {
          // No need for Navigator.push since ProductScreen is managed by PageView now
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurpleAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
        child: const Text('Explore More', style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: const Text('© 2024 InfiniTime | All Rights Reserved', style: TextStyle(fontSize: 14, color: Colors.grey)),
    );
  }
}
