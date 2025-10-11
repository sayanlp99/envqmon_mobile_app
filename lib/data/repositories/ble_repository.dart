import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:envqmon/core/constants/ble_constants.dart';
import 'package:envqmon/data/models/ble_device_model.dart';

class BleRepository {
  bool _isInitialized = false;
  StreamSubscription<List<ScanResult>>? _scanSubscription;

  Future<void> initialize() async {
    if (!_isInitialized) {
      // Check if Bluetooth is supported
      if (await FlutterBluePlus.isSupported == false) {
        throw Exception('Bluetooth not supported by this device');
      }

      // Turn on Bluetooth if we can (Android only)
      if (await FlutterBluePlus.adapterState.first != BluetoothAdapterState.on) {
        await FlutterBluePlus.turnOn();
      }

      _isInitialized = true;
    }
  }

  Future<bool> isBluetoothEnabled() async {
    return await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on;
  }

  Future<void> startScan() async {
    if (!_isInitialized) {
      await initialize();
    }

    // Wait for Bluetooth to be on
    await FlutterBluePlus.adapterState
        .where((state) => state == BluetoothAdapterState.on)
        .first;

    // Start scanning
    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 15),
      withNames: ['${BleConstants.devicePrefix}*'], // Match devices starting with ENVQMON-
    );
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  Stream<List<BleDeviceModel>> scanForDevices() {
    return FlutterBluePlus.scanResults.map((results) {
      return results.where((result) {
        final deviceName = result.advertisementData.advName;
        return deviceName != null && deviceName.startsWith(BleConstants.devicePrefix);
      }).map((result) {
        return BleDeviceModel(
          id: result.device.remoteId.str,
          name: result.advertisementData.advName ?? 'Unknown Device',
          isConnected: false,
          device: result.device,
        );
      }).toList();
    });
  }

  Future<void> configureWifi(BluetoothDevice device, String ssid, String password) async {
    try {

      // Connect to device
      await device.connect(license: License.free);
      
      // Wait for connection to be established
      await device.connectionState
          .where((state) => state == BluetoothConnectionState.connected)
          .first;

      // Discover services
      final services = await device.discoverServices();
      final service = services.firstWhere(
        (s) => s.uuid.toString().toLowerCase() == BleConstants.serviceUuid.toLowerCase(),
      );

      // Write SSID
      await _writeCharacteristic(service, BleConstants.keyCharacteristic, BleConstants.wifiSsidKey);
      await _writeCharacteristic(service, BleConstants.valueCharacteristic, ssid);
      await _writeCharacteristic(service, BleConstants.saveCharacteristic, '0');

      // Write Password
      await _writeCharacteristic(service, BleConstants.keyCharacteristic, BleConstants.wifiPassKey);
      await _writeCharacteristic(service, BleConstants.valueCharacteristic, password);
      await _writeCharacteristic(service, BleConstants.saveCharacteristic, '0');

      // Enable WiFi and reboot
      await _writeCharacteristic(service, BleConstants.keyCharacteristic, BleConstants.wifiEnableKey);
      await _writeCharacteristic(service, BleConstants.valueCharacteristic, 'true');
      await _writeCharacteristic(service, BleConstants.saveCharacteristic, '2');
      
    } catch (e) {
      throw Exception('Failed to configure WiFi: $e');
    }
  }

  Future<void> disableBle(BluetoothDevice device) async {
    try {
      final services = await device.discoverServices();
      final service = services.firstWhere(
        (s) => s.uuid.toString().toLowerCase() == BleConstants.serviceUuid.toLowerCase(),
      );

      await _writeCharacteristic(service, BleConstants.keyCharacteristic, BleConstants.btConfigEnableKey);
      await _writeCharacteristic(service, BleConstants.valueCharacteristic, 'false');
      await _writeCharacteristic(service, BleConstants.saveCharacteristic, '2');
    } catch (e) {
      throw Exception('Failed to disable BLE: $e');
    }
  }

  Future<void> _writeCharacteristic(BluetoothService service, String characteristicUuid, String value) async {
    final characteristic = service.characteristics.firstWhere(
      (c) => c.uuid.toString().toLowerCase() == characteristicUuid.toLowerCase(),
    );
    
    final data = Uint8List.fromList(value.codeUnits);
    await characteristic.write(data);
  }

  Future<void> disconnect(BluetoothDevice device) async {
    await device.disconnect();
  }

  Future<void> dispose() async {
    await stopScan();
    _scanSubscription?.cancel();
    _isInitialized = false;
  }
}
