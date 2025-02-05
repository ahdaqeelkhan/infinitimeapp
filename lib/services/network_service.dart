import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  
  // Stream controller to broadcast network status changes
  final _connectionStatusController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  // Initialize the network service
  void initialize() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    // Check initial connection status
    checkConnection();
  }

  // Check current connection status
  Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    final isConnected = _isConnected(result);
    _connectionStatusController.add(isConnected);
    return isConnected;
  }

  // Helper method to determine if connected
  bool _isConnected(ConnectivityResult result) {
    return result == ConnectivityResult.wifi || 
           result == ConnectivityResult.mobile ||
           result == ConnectivityResult.ethernet;
  }

  // Update connection status based on connectivity changes
  void _updateConnectionStatus(ConnectivityResult result) {
    _connectionStatusController.add(_isConnected(result));
  }

  // Get current connection type as string
  Future<String> getConnectionType() async {
    final result = await _connectivity.checkConnectivity();
    switch (result) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.none:
        return 'Offline';
      default:
        return 'Unknown';
    }
  }

  // Dispose of resources
  void dispose() {
    _connectivitySubscription.cancel();
    _connectionStatusController.close();
  }
}
