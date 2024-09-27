import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const ProfileScreen({
    Key? key,
    required this.isDarkMode,
    required this.toggleTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.black : Colors.purpleAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: isDarkMode ? Colors.yellow : Colors.white,
            ),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background for header
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black : Colors.purpleAccent,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
          ),
          // Profile Content
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),
                _buildProfileHeader(),
                const SizedBox(height: 20),
                _buildActionButtons(),
                const SizedBox(height: 20),
                _buildSettingsList(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3, // Setting current index to profile
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/products');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/cart');
          }
        },
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

  // Profile header widget
  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('lib/assets/images/henrycavill.jpg'), //  profile image
          backgroundColor: Colors.grey.shade300,
        ),
        const SizedBox(height: 10),
        const Text(
          'Henry Cavill', //  username
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'henry@gmail.com', //  email
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // Action buttons widget for settings and theme toggle
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: Icons.edit,
            label: 'Edit Profile',
            onTap: () {
              // Navigate to Edit Profile screen (Add route)
            },
          ),
          _buildActionButton(
            icon: Icons.logout,
            label: 'Logout',
            onTap: () {
              // Handle logout logic
            },
          ),
        ],
      ),
    );
  }

  // Generic action button widget
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.purpleAccent, size: 30),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Settings list widget with options
  Widget _buildSettingsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildSettingsTile(Icons.notifications, 'Notifications', 'Manage notification preferences'),
          _buildSettingsTile(Icons.lock, 'Privacy', 'Manage privacy settings'),
          _buildSettingsTile(Icons.help_outline, 'Help & Support', 'Get assistance with your account'),
          _buildSettingsTile(Icons.info_outline, 'About Us', 'Learn more about the company'),
        ],
      ),
    );
  }

  // Individual settings tile
  Widget _buildSettingsTile(IconData icon, String title, String subtitle) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: Colors.purpleAccent, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          // Handle navigation or action for each settings item
        },
      ),
    );
  }
}
