import 'package:flutter/material.dart';
import 'package:infinitimeapp/screens/home_screen.dart'; // Import your HomeScreen

class LoginScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const LoginScreen({
    Key? key,
    required this.isDarkMode,
    required this.toggleTheme,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    double horizontalPadding = isLandscape ? 80 : 20; // Adjust padding for landscape

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: widget.isDarkMode ? Colors.yellow : Colors.black,
            ),
            onPressed: widget.toggleTheme,
          ),
        ],
        backgroundColor: widget.isDarkMode ? Colors.black : Colors.purpleAccent, // Default purple accent in light mode
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1D2671), Color(0xFFC33764)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding), // Responsive padding
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/assets/images/logo.png',
                      height: 100,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "InfiniTime",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'JosefinSans',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Email Input Field
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white24,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.email, color: Colors.white),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Password Input Field
                    TextFormField(
                      obscureText: !_isPasswordVisible,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Enter your password',
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white24,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Forgot Password Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Add forgot password logic here
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate the form before navigating
                          if (_formKey.currentState!.validate()) {
                            // Navigate to HomeScreen if the form is valid
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                  isDarkMode: widget.isDarkMode,
                                  toggleTheme: widget.toggleTheme,
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Log in",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
