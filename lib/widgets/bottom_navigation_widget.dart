// import 'package:flutter/material.dart';
// import 'package:infinitimeapp/screens/home_screen.dart';
// import 'package:infinitimeapp/screens/product_screen.dart';
// import 'package:infinitimeapp/screens/cart_screen.dart'; // Assuming you have CartScreen
//
// class BottomNavigationWidget extends StatefulWidget {
//   final int currentIndex;
//   final bool isDarkMode;
//   final Function(int) onItemTapped; // Callback to handle navigation
//
//   const BottomNavigationWidget({
//     Key? key,
//     required this.currentIndex,
//     required this.isDarkMode,
//     required this.onItemTapped,
//   }) : super(key: key);
//
//   @override
//   _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
// }
//
// class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       items: const <BottomNavigationBarItem>[
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//         BottomNavigationBarItem(icon: Icon(Icons.watch_rounded), label: 'Watches'),
//         BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
//         BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
//       ],
//       currentIndex: widget.currentIndex,
//       selectedItemColor: Colors.purpleAccent,
//       unselectedItemColor: Colors.grey,
//       onTap: (index) => widget.onItemTapped(index), // Pass the tap event to parent screen
//     );
//   }
// }
