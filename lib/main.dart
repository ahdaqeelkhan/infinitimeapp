import 'package:flutter/material.dart';
import 'package:infinitimeapp/screens/home_screen.dart';
import 'package:infinitimeapp/screens/login_screen.dart';
import 'package:infinitimeapp/screens/product_screen.dart';
import 'package:infinitimeapp/screens/cart_screen.dart';
import 'package:infinitimeapp/screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  // Toggles between light and dark theme
  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'InfiniTime',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      themeMode: _themeMode, // Toggle

      home: LoginScreen(
        isDarkMode: _themeMode == ThemeMode.dark,
        toggleTheme: _toggleTheme,
      ),

      routes: {
        '/home': (context) => HomeScreen(
          isDarkMode: _themeMode == ThemeMode.dark,
          toggleTheme: _toggleTheme,
        ),
        '/products': (context) => ProductScreen(isDarkMode: _themeMode == ThemeMode.dark),
        '/cart': (context) => CartScreen(isDarkMode: _themeMode == ThemeMode.dark),
        '/profile': (context) => ProfileScreen(
          isDarkMode: _themeMode == ThemeMode.dark,
          toggleTheme: _toggleTheme,
        ),
      },
    );
  }
}
