import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:envqmon/presentation/providers/auth_provider.dart';
import 'package:envqmon/presentation/providers/ble_provider.dart';
import 'package:envqmon/presentation/providers/device_provider.dart';
import 'package:envqmon/presentation/widgets/app_button.dart';
import 'package:envqmon/presentation/widgets/app_text_field.dart';
import 'package:envqmon/presentation/widgets/loading_indicator.dart';
import 'package:envqmon/presentation/widgets/error_dialog.dart';
import 'package:envqmon/data/models/ble_device_model.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imeiController = TextEditingController();
  final _ssidController = TextEditingController();
  final _passwordController = TextEditingController();

  BleDeviceModel? _selectedDevice;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bleProvider = Provider.of<BleProvider>(context, listen: false);
      bleProvider.initialize();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imeiController.dispose();
    _ssidController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _startScan() async {
    final bleProvider = Provider.of<BleProvider>(context, listen: false);
    await bleProvider.startScan();
  }

  Future<void> _stopScan() async {
    final bleProvider = Provider.of<BleProvider>(context, listen: false);
    await bleProvider.stopScan();
  }

  Future<void> _configureDevice() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDevice == null) {
      showDialog(
        context: context,
        builder: (context) => const ErrorDialog(
          title: 'Error',
          message: 'Please select a device',
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bleProvider = Provider.of<BleProvider>(context, listen: false);
    final deviceProvider = Provider.of<DeviceProvider>(context, listen: false);

    if (authProvider.currentUser == null || authProvider.token == null) {
      showDialog(
        context: context,
        builder: (context) => const ErrorDialog(
          title: 'Error',
          message: 'User not authenticated',
        ),
      );
      return;
    }

    try {
      // Connect to the selected BLE device
      if (_selectedDevice!.device != null) {
        final connected = await bleProvider.connectToDevice(_selectedDevice!.device!);
        if (!connected) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              title: 'Connection Error',
              message: bleProvider.error ?? 'Failed to connect to device',
            ),
          );
          return;
        }

        // Configure WiFi on the BLE device
        final wifiConfigured = await bleProvider.configureWifi(
          _ssidController.text.trim(),
          _passwordController.text.trim(),
        );

        if (!wifiConfigured) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              title: 'WiFi Configuration Error',
              message: bleProvider.error ?? 'Failed to configure WiFi',
            ),
          );
          return;
        }

        // Disconnect from BLE device
        await bleProvider.disconnect();
      }

      // Create the device in the API
      final success = await deviceProvider.createDevice(
        name: _nameController.text.trim(),
        imei: _imeiController.text.trim(),
        userId: authProvider.currentUser!.userId,
        token: authProvider.token!,
      );

      if (!success) {
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(
            title: 'Error',
            message: deviceProvider.error ?? 'Failed to create device',
          ),
        );
        return;
      }
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Device configured and added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(
            title: 'Error',
            message: e.toString(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Device'),
        centerTitle: true,
      ),
      body: Consumer<BleProvider>(
        builder: (context, bleProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  const Icon(
                    Icons.bluetooth,
                    size: 80,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Add New Device',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Configure your ESP32 device via Bluetooth',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  
                  // Device Selection
                  const Text(
                    'Select Device',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  if (bleProvider.isScanning)
                    const LoadingIndicator(message: 'Scanning for devices...')
                  else if (bleProvider.discoveredDevices.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'No devices found. Tap "Scan" to discover devices.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        itemCount: bleProvider.discoveredDevices.length,
                        itemBuilder: (context, index) {
                          final device = bleProvider.discoveredDevices[index];
                          
                          return ListTile(
                            title: Text(device.name),
                            subtitle: Text('ID: ${device.id}'),
                            leading: Radio<BleDeviceModel>(
                              value: device,
                              groupValue: _selectedDevice,
                              onChanged: (value) {
                                setState(() {
                                  _selectedDevice = value;
                                });
                              },
                            ),
                            onTap: () {
                              setState(() {
                                _selectedDevice = device;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: bleProvider.isScanning ? 'Stop Scan' : 'Scan',
                          onPressed: bleProvider.isScanning ? _stopScan : _startScan,
                          backgroundColor: bleProvider.isScanning 
                              ? Colors.red 
                              : Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Device Information
                  const Text(
                    'Device Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  AppTextField(
                    controller: _nameController,
                    labelText: 'Device Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter device name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _imeiController,
                    labelText: 'IMEI',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter IMEI';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // WiFi Configuration
                  const Text(
                    'WiFi Configuration',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  AppTextField(
                    controller: _ssidController,
                    labelText: 'WiFi SSID',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter WiFi SSID';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _passwordController,
                    labelText: 'WiFi Password',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter WiFi password';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  
                  Consumer<DeviceProvider>(
                    builder: (context, deviceProvider, child) {
                      if (deviceProvider.isLoading) {
                        return const LoadingIndicator(message: 'Configuring device...');
                      }
                      return AppButton(
                        text: 'Configure Device',
                        onPressed: _configureDevice,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
