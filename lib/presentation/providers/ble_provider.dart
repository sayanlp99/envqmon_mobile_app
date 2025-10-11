import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:envqmon/data/models/ble_device_model.dart';
import 'package:envqmon/data/repositories/ble_repository.dart';

class BleProvider extends ChangeNotifier {
  final BleRepository _bleRepository;

  BleProvider({required BleRepository bleRepository}) : _bleRepository = bleRepository;

  bool _isScanning = false;
  bool _isConnected = false;
  bool _isInitialized = false;
  String? _error;
  List<BleDeviceModel> _discoveredDevices = [];
  BluetoothDevice? _connectedDevice;
  StreamSubscription<List<BleDeviceModel>>? _scanSubscription;

  bool get isScanning => _isScanning;
  bool get isConnected => _isConnected;
  bool get isInitialized => _isInitialized;
  String? get error => _error;
  List<BleDeviceModel> get discoveredDevices => _discoveredDevices;
  BluetoothDevice? get connectedDevice => _connectedDevice;

  Future<void> initialize() async {
    try {
      await _bleRepository.initialize();
      _isInitialized = true;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> startScan() async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_isScanning) return;

    _isScanning = true;
    _discoveredDevices.clear();
    _error = null;
    notifyListeners();

    try {
      await _bleRepository.startScan();
      
      _scanSubscription = _bleRepository.scanForDevices().listen(
        (devices) {
          _discoveredDevices = devices;
          notifyListeners();
        },
        onError: (error) {
          _error = error.toString();
          _isScanning = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _error = e.toString();
      _isScanning = false;
      notifyListeners();
    }
  }

  Future<void> stopScan() async {
    if (!_isScanning) return;

    try {
      await _bleRepository.stopScan();
      await _scanSubscription?.cancel();
      _scanSubscription = null;
      _isScanning = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      _connectedDevice = device;
      _isConnected = true;
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isConnected = false;
      _connectedDevice = null;
      notifyListeners();
      return false;
    }
  }

  Future<bool> configureWifi(String ssid, String password) async {
    if (_connectedDevice == null) {
      _error = 'No device connected';
      notifyListeners();
      return false;
    }

    try {
      await _bleRepository.configureWifi(_connectedDevice!, ssid, password);
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> disableBle() async {
    if (_connectedDevice == null) {
      _error = 'No device connected';
      notifyListeners();
      return false;
    }

    try {
      await _bleRepository.disableBle(_connectedDevice!);
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> disconnect() async {
    if (_connectedDevice != null) {
      try {
        await _bleRepository.disconnect(_connectedDevice!);
      } catch (e) {
        // Handle disconnect error silently
      }
    }

    _connectedDevice = null;
    _isConnected = false;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _bleRepository.dispose();
    super.dispose();
  }
}
