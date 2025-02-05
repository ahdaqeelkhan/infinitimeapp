import 'package:flutter/material.dart';
import '../services/network_service.dart';

class NetworkStatusOverlay extends StatefulWidget {
  const NetworkStatusOverlay({Key? key}) : super(key: key);

  @override
  _NetworkStatusOverlayState createState() => _NetworkStatusOverlayState();
}

class _NetworkStatusOverlayState extends State<NetworkStatusOverlay> with SingleTickerProviderStateMixin {
  final NetworkService _networkService = NetworkService();
  bool _isConnected = true;
  bool _showBanner = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: -100.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _initializeNetworkService();
  }

  void _initializeNetworkService() {
    _networkService.initialize();
    _networkService.connectionStatus.listen((bool isConnected) {
      if (mounted) {
        setState(() {
          if (_isConnected != isConnected) {
            _isConnected = isConnected;
            _showBanner = true;
            _controller.forward();
            // Hide the "Back Online" message after 3 seconds
            if (isConnected) {
              Future.delayed(const Duration(seconds: 3), () {
                if (mounted) {
                  setState(() {
                    _showBanner = false;
                  });
                  _controller.reverse();
                }
              });
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _networkService.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_showBanner) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: _animation.value,
          left: 0,
          right: 0,
          child: Material(
            child: Container(
              padding: const EdgeInsets.only(top: 35, bottom: 8),
              color: _isConnected ? Colors.green : Colors.red,
              child: Text(
                _isConnected ? 'Back Online' : 'No Internet Connection',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }
}
