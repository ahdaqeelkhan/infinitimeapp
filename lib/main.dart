import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infinitimeapp/screens/home_screen.dart';
import 'package:infinitimeapp/screens/login_screen.dart';
import 'package:infinitimeapp/screens/product_screen.dart';
import 'package:infinitimeapp/screens/cart_screen.dart';
import 'package:infinitimeapp/screens/profile_screen.dart';
import 'package:infinitimeapp/services/network_service.dart';
import 'package:infinitimeapp/services/battery_service.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:infinitimeapp/widgets/network_status_overlay.dart';

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
  bool _isLoading = true; // ⏳ Waiting for token check
  bool _isLoggedIn = false; // 🔐 Track login state
  final NetworkService _networkService = NetworkService();
  final BatteryService _batteryService = BatteryService();
  bool _isConnected = true;
  int _batteryLevel = 100;
  BatteryState _batteryState = BatteryState.full;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // ✅ Check token on app start
    _initializeNetworkService();
    _initializeBatteryService();
  }

  void _initializeNetworkService() {
    _networkService.initialize();
    _networkService.connectionStatus.listen((bool isConnected) {
      setState(() {
        _isConnected = isConnected;
      });
    });
  }

  void _initializeBatteryService() {
    _batteryService.initialize();
    _batteryService.batteryLevel.listen((level) {
      setState(() {
        _batteryLevel = level;
      });
    });
    _batteryService.batteryState.listen((state) {
      setState(() {
        _batteryState = state;
      });
    });
  }

  @override
  void dispose() {
    _networkService.dispose();
    _batteryService.dispose();
    super.dispose();
  }

  // 🛠 Check if token exists in SharedPreferences
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    setState(() {
      _isLoggedIn = token != null; // 🔐 User is logged in if token exists
      _isLoading = false; // ✅ Done checking
    });

    print("Stored Token: $token"); // Debugging
  }

  // 🔄 Toggle between light and dark mode
  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'InfiniTime App',
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
      themeMode: _themeMode,

      home: Stack(
        children: [
          if (_isLoggedIn)
            HomeScreen(
              isDarkMode: _themeMode == ThemeMode.dark,
              toggleTheme: _toggleTheme,
            )
          else
            LoginScreen(
              isDarkMode: _themeMode == ThemeMode.dark,
              toggleTheme: _toggleTheme,
            ),
          const NetworkStatusOverlay(),
        ],
      ),

      routes: {
        '/home': (context) => HomeScreen(
          isDarkMode: _themeMode == ThemeMode.dark,
          toggleTheme: _toggleTheme,
        ),
        '/products': (context) =>
            ProductScreen(isDarkMode: _themeMode == ThemeMode.dark),
        '/cart': (context) =>
            CartScreen(isDarkMode: _themeMode == ThemeMode.dark),
        '/profile': (context) => ProfileScreen(
          isDarkMode: _themeMode == ThemeMode.dark,
          toggleTheme: _toggleTheme,
        ),
      },
    );
  }
}
