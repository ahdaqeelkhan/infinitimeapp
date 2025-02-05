import 'dart:async';
import 'package:battery_plus/battery_plus.dart';

class BatteryService {
  final Battery _battery = Battery();
  late StreamSubscription<BatteryState> _batteryStateSubscription;
  
  // Stream controllers to broadcast battery info
  final _batteryLevelController = StreamController<int>.broadcast();
  final _batteryStateController = StreamController<BatteryState>.broadcast();
  
  // Getters for the streams
  Stream<int> get batteryLevel => _batteryLevelController.stream;
  Stream<BatteryState> get batteryState => _batteryStateController.stream;

  // Initialize the battery service
  void initialize() {
    // Listen to battery state changes
    _batteryStateSubscription = _battery.onBatteryStateChanged.listen((state) {
      _batteryStateController.add(state);
      _updateBatteryLevel(); // Update level when state changes
    });

    // Initial battery check
    _updateBatteryLevel();
  }

  // Update battery level
  Future<void> _updateBatteryLevel() async {
    final level = await _battery.batteryLevel;
    _batteryLevelController.add(level);
  }

  // Get current battery level
  Future<int> getCurrentBatteryLevel() async {
    return await _battery.batteryLevel;
  }

  // Get current battery state
  Future<BatteryState> getCurrentBatteryState() async {
    return await _battery.batteryState;
  }

  // Get battery state as string
  String getBatteryStateString(BatteryState state) {
    switch (state) {
      case BatteryState.charging:
        return 'Charging';
      case BatteryState.discharging:
        return 'Not charging';
      case BatteryState.full:
        return 'Full';
      default:
        return 'Unknown';
    }
  }

  // Dispose of resources
  void dispose() {
    _batteryStateSubscription.cancel();
    _batteryLevelController.close();
    _batteryStateController.close();
  }
}
