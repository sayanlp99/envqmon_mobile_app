import 'package:flutter/foundation.dart';
import 'package:envqmon/data/models/device_model.dart';
import 'package:envqmon/data/models/sensor_data_model.dart';
import 'package:envqmon/data/repositories/device_repository.dart';

class DeviceProvider extends ChangeNotifier {
  final DeviceRepository _deviceRepository;

  DeviceProvider({required DeviceRepository deviceRepository}) : _deviceRepository = deviceRepository;

  bool _isLoading = false;
  String? _error;
  List<DeviceModel> _devices = [];
  DeviceModel? _selectedDevice;
  SensorDataModel? _latestData;
  List<SensorDataModel> _historicalData = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<DeviceModel> get devices => _devices;
  DeviceModel? get selectedDevice => _selectedDevice;
  SensorDataModel? get latestData => _latestData;
  List<SensorDataModel> get historicalData => _historicalData;

  Future<void> loadDevices(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _devices = await _deviceRepository.getDevices(token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createDevice({
    required String name,
    required String imei,
    required String userId,
    required String token,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newDevice = await _deviceRepository.createDevice(
        name: name,
        imei: imei,
        userId: userId,
        token: token,
      );
      
      _devices.add(newDevice);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadLatestData(String deviceId, String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _latestData = await _deviceRepository.getLatestData(deviceId, token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadHistoricalData({
    required String deviceId,
    required DateTime startTime,
    required DateTime endTime,
    required String token,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _historicalData = await _deviceRepository.getRangeData(
        deviceId: deviceId,
        startTime: startTime,
        endTime: endTime,
        token: token,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectDevice(DeviceModel device) {
    _selectedDevice = device;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
