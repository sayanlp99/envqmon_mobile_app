import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleDeviceModel {
  final String id;
  final String name;
  final bool isConnected;
  final BluetoothDevice? device;

  BleDeviceModel({
    required this.id,
    required this.name,
    this.isConnected = false,
    this.device,
  });

  BleDeviceModel copyWith({
    String? id,
    String? name,
    bool? isConnected,
    BluetoothDevice? device,
  }) {
    return BleDeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isConnected: isConnected ?? this.isConnected,
      device: device ?? this.device,
    );
  }
}
