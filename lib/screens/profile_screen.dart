import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'login_screen.dart';
import '../services/network_service.dart';
import '../services/battery_service.dart';
import '../services/orientation_service.dart';
import 'package:battery_plus/battery_plus.dart';

class ProfileScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const ProfileScreen({
    Key? key,
    required this.isDarkMode,
    required this.toggleTheme,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = "User";
  String email = "user@example.com";
  String profileImage = "https://via.placeholder.com/150"; // Default placeholder
  bool isLoading = true;
  int _selectedIndex = 3; // Set Profile as selected index
  
  // System status
  final NetworkService _networkService = NetworkService();
  final BatteryService _batteryService = BatteryService();
  final OrientationService _orientationService = OrientationService();
  bool _isConnected = true;
  int _batteryLevel = 100;
  BatteryState _batteryState = BatteryState.full;
  DevicePosition _devicePosition = DevicePosition.portrait;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    _initializeSystemStatus();
  }

  void _initializeSystemStatus() {
    _networkService.initialize();
    _batteryService.initialize();
    _orientationService.initialize();
    
    _networkService.connectionStatus.listen((bool isConnected) {
      setState(() {
        _isConnected = isConnected;
      });
    });
    
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

    _orientationService.orientationStream.listen((position) {
      setState(() {
        _devicePosition = position;
      });
    });
  }

  @override
  void dispose() {
    _networkService.dispose();
    _batteryService.dispose();
    _orientationService.dispose();
    super.dispose();
  }

  Future<void> _fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");

    if (token == null) {
      _logout();
      return;
    }

    try {
      final response = await http.get(
        Uri.parse("${AppConfig.baseUrl}user/profile"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final Map<String, dynamic>? user = data["user"];

        if (user != null) {
          setState(() {
            username = user['name'] ?? "User";
            email = user['email'] ?? "user@example.com";
            profileImage = user['profile_image'] ?? profileImage;
            isLoading = false;
          });
        }
      } else {
        _logout();
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");

    if (token == null) {
      _navigateToLogin();
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("${AppConfig.baseUrl}logout"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print("🔴 Logout Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        print("✅ Logout successful");
      } else {
        print("⚠️ Logout failed: ${response.body}");
      }
    } catch (e) {
      print("🚨 Error during logout: $e");
    }

    // Clear stored token and navigate to login screen
    await prefs.remove("auth_token");
    _navigateToLogin();
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(
          isDarkMode: widget.isDarkMode,
          toggleTheme: widget.toggleTheme,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      if (index == 0) {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (index == 1) {
        Navigator.pushReplacementNamed(context, '/products');
      } else if (index == 2) {
        Navigator.pushReplacementNamed(context, '/cart');
      } else if (index == 3) {
        Navigator.pushReplacementNamed(context, '/profile');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: widget.isDarkMode ? Colors.black : Colors.purpleAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: widget.isDarkMode ? Colors.yellow : Colors.white,
            ),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(profileImage),
                      backgroundColor: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      username,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      email,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    
                    // System Status Section
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: widget.isDarkMode ? Colors.grey[900] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              _isConnected ? Icons.wifi : Icons.wifi_off,
                              color: _isConnected ? Colors.green : Colors.red,
                            ),
                            title: const Text('Network Status'),
                            subtitle: Text(
                              _isConnected ? 'Connected' : 'No Internet Connection',
                              style: TextStyle(
                                color: _isConnected ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: Icon(
                              _batteryState == BatteryState.charging
                                  ? Icons.battery_charging_full
                                  : _batteryLevel > 20
                                      ? Icons.battery_full
                                      : Icons.battery_alert,
                              color: _batteryLevel > 20 ? Colors.green : Colors.red,
                            ),
                            title: const Text('Battery Status'),
                            subtitle: Text(
                              '$_batteryLevel% ${_batteryState == BatteryState.charging ? "(Charging)" : "(Unplugged)"}',
                              style: TextStyle(
                                color: _batteryLevel > 20 ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: Text(
                              _orientationService.getPositionIcon(_devicePosition),
                              style: const TextStyle(fontSize: 24),
                            ),
                            title: const Text('Device Orientation'),
                            subtitle: Text(
                              _orientationService.getPositionDescription(_devicePosition),
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    ElevatedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text("Logout"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
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
}
