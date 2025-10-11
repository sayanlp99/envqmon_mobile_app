import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:envqmon/presentation/providers/auth_provider.dart';
import 'package:envqmon/presentation/providers/device_provider.dart';
import 'package:envqmon/presentation/screens/main/historical_data_screen.dart';
import 'package:envqmon/presentation/widgets/data_card.dart';
import 'package:envqmon/presentation/widgets/loading_indicator.dart';
import 'package:envqmon/core/constants/app_constants.dart';

class DeviceDetailsScreen extends StatefulWidget {
  const DeviceDetailsScreen({super.key});

  @override
  State<DeviceDetailsScreen> createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _loadLatestData();
  }

  Future<void> _loadLatestData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final deviceProvider = Provider.of<DeviceProvider>(context, listen: false);

    if (authProvider.token != null && deviceProvider.selectedDevice != null) {
      await deviceProvider.loadLatestData(
        deviceProvider.selectedDevice!.deviceId,
        authProvider.token!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, DeviceProvider>(
      builder: (context, authProvider, deviceProvider, child) {
        final selectedDevice = deviceProvider.selectedDevice;
        final latestData = deviceProvider.latestData;

        if (selectedDevice == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Device Details')),
            body: const Center(
              child: Text('No device selected'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(selectedDevice.name),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadLatestData,
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Device Info Card
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(AppConstants.defaultPadding),
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                decoration: BoxDecoration(
                  color: selectedDevice.isActive 
                      ? AppConstants.primaryColor.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  border: Border.all(
                    color: selectedDevice.isActive 
                        ? AppConstants.primaryColor 
                        : Colors.grey,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          selectedDevice.isActive ? Icons.check_circle : Icons.cancel,
                          color: selectedDevice.isActive ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          selectedDevice.isActive ? 'Device Active' : 'Device Inactive',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: selectedDevice.isActive ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'IMEI: ${selectedDevice.imei}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    if (latestData != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Last Update: ${_formatDateTime(latestData.timestamp)}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Sensor Data
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Latest Readings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const HistoricalDataScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.history),
                      label: const Text('View History'),
                    ),
                  ],
                ),
              ),

              // Data Cards
              Expanded(
                child: deviceProvider.isLoading
                    ? const LoadingIndicator(message: 'Loading latest data...')
                    : latestData == null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.sensors_off,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'No data available',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Device may be offline or no data has been received yet',
                                  style: TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: _loadLatestData,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Refresh'),
                                ),
                              ],
                            ),
                          )
                        : GridView.count(
                            padding: const EdgeInsets.all(AppConstants.defaultPadding),
                            crossAxisCount: 2,
                            childAspectRatio: 1.2,
                            crossAxisSpacing: AppConstants.defaultPadding,
                            mainAxisSpacing: AppConstants.defaultPadding,
                            children: [
                              DataCard(
                                title: 'Temperature',
                                value: '${latestData.temperature.toStringAsFixed(1)}°C',
                                icon: Icons.thermostat,
                                color: _getTemperatureColor(latestData.temperature),
                              ),
                              DataCard(
                                title: 'Humidity',
                                value: '${latestData.humidity.toStringAsFixed(1)}%',
                                icon: Icons.water_drop,
                                color: _getHumidityColor(latestData.humidity),
                              ),
                              DataCard(
                                title: 'Pressure',
                                value: '${latestData.pressure.toStringAsFixed(1)} hPa',
                                icon: Icons.speed,
                                color: AppConstants.infoColor,
                              ),
                              DataCard(
                                title: 'CO Level',
                                value: '${latestData.co.toStringAsFixed(1)} ppm',
                                icon: Icons.dangerous,
                                color: _getCOColor(latestData.co),
                              ),
                              DataCard(
                                title: 'PM2.5',
                                value: '${latestData.pm25.toStringAsFixed(1)} μg/m³',
                                icon: Icons.cloud,
                                color: _getPMColor(latestData.pm25),
                              ),
                              DataCard(
                                title: 'Noise',
                                value: '${latestData.noise.toStringAsFixed(1)} dB',
                                icon: Icons.volume_up,
                                color: _getNoiseColor(latestData.noise),
                              ),
                            ],
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Color _getTemperatureColor(double temperature) {
    if (temperature < 15) return Colors.blue;
    if (temperature > 30) return Colors.red;
    return Colors.green;
  }

  Color _getHumidityColor(double humidity) {
    if (humidity < 30) return Colors.orange;
    if (humidity > 70) return Colors.red;
    return Colors.green;
  }

  Color _getCOColor(double co) {
    if (co > 50) return Colors.red;
    if (co > 25) return Colors.orange;
    return Colors.green;
  }

  Color _getPMColor(double pm) {
    if (pm > 35) return Colors.red;
    if (pm > 15) return Colors.orange;
    return Colors.green;
  }

  Color _getNoiseColor(double noise) {
    if (noise > 70) return Colors.red;
    if (noise > 50) return Colors.orange;
    return Colors.green;
  }
}
