import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

enum DevicePosition {
  flat, // Device is lying flat
  portrait, // Device is held vertically
  landscape, // Device is held horizontally
  upsideDown // Device is held upside down
}

class OrientationService {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  final _orientationController = StreamController<DevicePosition>.broadcast();
  
  // Stream for other widgets to listen to orientation changes
  Stream<DevicePosition> get orientationStream => _orientationController.stream;
  
  // Initialize the service
  void initialize() {
    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      // Determine device position based on accelerometer data
      final position = _determineDevicePosition(event);
      _orientationController.add(position);
    });
  }

  // Determine device position based on accelerometer readings
  DevicePosition _determineDevicePosition(AccelerometerEvent event) {
    // Convert acceleration to degrees
    double x = event.x;
    double y = event.y;
    double z = event.z;

    // Check if device is lying flat (z-axis is close to 9.8 or -9.8)
    if (z.abs() > 8) {
      return DevicePosition.flat;
    }

    // Check orientation based on x and y values
    if (y.abs() > x.abs()) {
      // Device is in portrait mode
      return y > 0 ? DevicePosition.upsideDown : DevicePosition.portrait;
    } else {
      // Device is in landscape mode
      return x > 0 ? DevicePosition.landscape : DevicePosition.landscape;
    }
  }

  // Get a user-friendly string description of the device position
  String getPositionDescription(DevicePosition position) {
    switch (position) {
      case DevicePosition.flat:
        return 'Flat on surface';
      case DevicePosition.portrait:
        return 'Upright';
      case DevicePosition.landscape:
        return 'Sideways';
      case DevicePosition.upsideDown:
        return 'Upside down';
    }
  }

  // Get an icon for the current position
  String getPositionIcon(DevicePosition position) {
    switch (position) {
      case DevicePosition.flat:
        return '📱';
      case DevicePosition.portrait:
        return '📱';
      case DevicePosition.landscape:
        return '🔄';
      case DevicePosition.upsideDown:
        return '🙃';
    }
  }

  // Cleanup
  void dispose() {
    _accelerometerSubscription?.cancel();
    _orientationController.close();
  }
}
