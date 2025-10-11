import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:envqmon/presentation/providers/auth_provider.dart';
import 'package:envqmon/presentation/providers/device_provider.dart';
import 'package:envqmon/presentation/widgets/loading_indicator.dart';
import 'package:envqmon/core/constants/app_constants.dart';
import 'package:intl/intl.dart';

class HistoricalDataScreen extends StatefulWidget {
  const HistoricalDataScreen({super.key});

  @override
  State<HistoricalDataScreen> createState() => _HistoricalDataScreenState();
}

class _HistoricalDataScreenState extends State<HistoricalDataScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();
  String _selectedParameter = 'temperature';

  final List<String> _parameters = [
    'temperature',
    'humidity',
    'pressure',
    'co',
    'pm25',
    'noise',
  ];

  @override
  void initState() {
    super.initState();
    _loadHistoricalData();
  }

  Future<void> _loadHistoricalData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final deviceProvider = Provider.of<DeviceProvider>(context, listen: false);

    if (authProvider.token != null && deviceProvider.selectedDevice != null) {
      await deviceProvider.loadHistoricalData(
        deviceId: deviceProvider.selectedDevice!.deviceId,
        startTime: _startDate,
        endTime: _endDate,
        token: authProvider.token!,
      );
    }
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _loadHistoricalData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historical Data'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadHistoricalData,
          ),
        ],
      ),
      body: Consumer2<AuthProvider, DeviceProvider>(
        builder: (context, authProvider, deviceProvider, child) {
          final selectedDevice = deviceProvider.selectedDevice;
          final historicalData = deviceProvider.historicalData;

          if (selectedDevice == null) {
            return const Center(
              child: Text('No device selected'),
            );
          }

          return Column(
            children: [
              // Date Range Selector
              Container(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: ListTile(
                          leading: const Icon(Icons.date_range),
                          title: Text(
                            'From: ${DateFormat('MMM dd, yyyy').format(_startDate)}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          subtitle: Text(
                            'To: ${DateFormat('MMM dd, yyyy').format(_endDate)}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          onTap: _selectDateRange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Parameter Selector
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedParameter,
                  decoration: const InputDecoration(
                    labelText: 'Parameter',
                    border: OutlineInputBorder(),
                  ),
                  items: _parameters.map((String parameter) {
                    return DropdownMenuItem<String>(
                      value: parameter,
                      child: Text(_getParameterDisplayName(parameter)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedParameter = newValue;
                      });
                    }
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Data Display
              Expanded(
                child: deviceProvider.isLoading
                    ? const LoadingIndicator(message: 'Loading historical data...')
                    : historicalData.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.analytics_outlined,
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
                                  'No data found for the selected date range',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: _loadHistoricalData,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Refresh'),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(AppConstants.defaultPadding),
                            itemCount: historicalData.length,
                            itemBuilder: (context, index) {
                              final data = historicalData[index];
                              final value = _getParameterValue(data, _selectedParameter);
                              final unit = _getParameterUnit(_selectedParameter);
                              
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: _getParameterColor(_selectedParameter, value),
                                    child: Icon(
                                      _getParameterIcon(_selectedParameter),
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    '${value.toStringAsFixed(1)}$unit',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    DateFormat('MMM dd, yyyy - HH:mm').format(data.timestamp),
                                  ),
                                  trailing: Text(
                                    _getParameterDisplayName(_selectedParameter),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getParameterDisplayName(String parameter) {
    switch (parameter) {
      case 'temperature':
        return 'Temperature';
      case 'humidity':
        return 'Humidity';
      case 'pressure':
        return 'Pressure';
      case 'co':
        return 'CO Level';
      case 'pm25':
        return 'PM2.5';
      case 'noise':
        return 'Noise';
      default:
        return parameter;
    }
  }

  String _getParameterUnit(String parameter) {
    switch (parameter) {
      case 'temperature':
        return '°C';
      case 'humidity':
        return '%';
      case 'pressure':
        return ' hPa';
      case 'co':
        return ' ppm';
      case 'pm25':
        return ' μg/m³';
      case 'noise':
        return ' dB';
      default:
        return '';
    }
  }

  IconData _getParameterIcon(String parameter) {
    switch (parameter) {
      case 'temperature':
        return Icons.thermostat;
      case 'humidity':
        return Icons.water_drop;
      case 'pressure':
        return Icons.speed;
      case 'co':
        return Icons.dangerous;
      case 'pm25':
        return Icons.cloud;
      case 'noise':
        return Icons.volume_up;
      default:
        return Icons.sensors;
    }
  }

  Color _getParameterColor(String parameter, double value) {
    switch (parameter) {
      case 'temperature':
        if (value < 15) return Colors.blue;
        if (value > 30) return Colors.red;
        return Colors.green;
      case 'humidity':
        if (value < 30) return Colors.orange;
        if (value > 70) return Colors.red;
        return Colors.green;
      case 'pressure':
        return AppConstants.infoColor;
      case 'co':
        if (value > 50) return Colors.red;
        if (value > 25) return Colors.orange;
        return Colors.green;
      case 'pm25':
        if (value > 35) return Colors.red;
        if (value > 15) return Colors.orange;
        return Colors.green;
      case 'noise':
        if (value > 70) return Colors.red;
        if (value > 50) return Colors.orange;
        return Colors.green;
      default:
        return AppConstants.primaryColor;
    }
  }

  double _getParameterValue(dynamic data, String parameter) {
    switch (parameter) {
      case 'temperature':
        return data.temperature;
      case 'humidity':
        return data.humidity;
      case 'pressure':
        return data.pressure;
      case 'co':
        return data.co;
      case 'pm25':
        return data.pm25;
      case 'noise':
        return data.noise;
      default:
        return 0.0;
    }
  }
}
