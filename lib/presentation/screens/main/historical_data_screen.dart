import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:envqmon/presentation/providers/auth_provider.dart';
import 'package:envqmon/presentation/providers/device_provider.dart';
import 'package:envqmon/presentation/widgets/loading_indicator.dart';
import 'package:envqmon/core/constants/app_constants.dart';
import 'package:envqmon/data/models/sensor_data_model.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

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
    'co2',
    'pm25',
    'noise',
    'light',
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
                    : deviceProvider.error != null && historicalData.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Error loading data',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32),
                                  child: Text(
                                    deviceProvider.error ?? 'Unknown error',
                                    style: const TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    deviceProvider.clearError();
                                    _loadHistoricalData();
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Retry'),
                                ),
                              ],
                            ),
                          )
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
                        : _buildChart(historicalData),
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
      case 'methane':
        return 'Methane Level';
      case 'lpg':
        return 'LPG Level';
      case 'co2':
        return 'CO2 Level';
      case 'pm25':
        return 'PM2.5';
      case 'noise':
        return 'Noise';
      case 'light':
        return 'Light';
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
      case 'co2':
        return ' ppm';
      case 'methane':
        return ' ppm';
      case 'lpg':
        return ' ppm';
      case 'pm25':
        return ' μg/m³';
      case 'noise':
        return ' dB';
      case 'light':
        return ' lux';
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
      case 'co2':
        return Icons.dangerous;
      case 'methane':
        return Icons.dangerous;
      case 'lpg':
        return Icons.dangerous;
      case 'pm25':
        return Icons.cloud;
      case 'noise':
        return Icons.volume_up;
      case 'light':
        return Icons.wb_sunny;
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
      case 'co2':
        if (value > 1000) return Colors.red;
        if (value > 500) return Colors.orange;
        return Colors.green;
      case 'methane':
        if (value > 1000) return Colors.red;
        if (value > 500) return Colors.orange;
        return Colors.green;
      case 'lpg':
        if (value > 1000) return Colors.red;
        if (value > 500) return Colors.orange;
        return Colors.green;
      case 'pm25':
        if (value > 35) return Colors.red;
        if (value > 15) return Colors.orange;
        return Colors.green;
      case 'noise':
        if (value > 70) return Colors.red;
        if (value > 50) return Colors.orange;
        return Colors.green;
      case 'light':
        if (value > 1000) return Colors.red;
        if (value > 500) return Colors.orange;
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
      case 'co2':
        return data.co2;
      case 'methane':
        return data.methane;
      case 'lpg':
        return data.lpg;
      case 'pm25':
        return data.pm25;
      case 'noise':
        return data.noise;
      case 'light':
        return data.light;
      default:
        return 0.0;
    }
  }

  Widget _buildChart(List<SensorDataModel> historicalData) {
    if (historicalData.isEmpty) {
      return Center(
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
          ],
        ),
      );
    }

    // Sort data by timestamp
    final sortedData = List<SensorDataModel>.from(historicalData)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    if (sortedData.isEmpty) {
      return const SizedBox.shrink();
    }

    // Prepare chart spots
    final spots = sortedData.asMap().entries.map((entry) {
      final value = _getParameterValue(entry.value, _selectedParameter);
      return FlSpot(entry.key.toDouble(), value);
    }).toList();

    // Calculate min and max values for y-axis
    final values = sortedData.map((data) => _getParameterValue(data, _selectedParameter)).toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final yAxisMin = minValue > 0 ? (minValue * 0.9) : (minValue * 1.1);
    final yAxisMax = maxValue * 1.1;

    // Get color based on average value
    final avgValue = values.reduce((a, b) => a + b) / values.length;
    final lineColor = _getParameterColor(_selectedParameter, avgValue);

    // Format x-axis labels (show date/time)
    String getXAxisLabel(double value) {
      final index = value.toInt();
      if (index >= 0 && index < sortedData.length) {
        final date = sortedData[index].timestamp;
        // If data spans multiple days, show date, otherwise show time
        if ((sortedData.last.timestamp.difference(sortedData.first.timestamp).inDays) > 1) {
          return DateFormat('MMM dd\nHH:mm').format(date);
        } else {
          return DateFormat('HH:mm').format(date);
        }
      }
      return '';
    }

    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chart title with current value info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getParameterIcon(_selectedParameter),
                        color: lineColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getParameterDisplayName(_selectedParameter),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (sortedData.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: lineColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Latest: ${_getParameterValue(sortedData.last, _selectedParameter).toStringAsFixed(1)}${_getParameterUnit(_selectedParameter)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: lineColor,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              // Chart
              SizedBox(
                height: 300,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: (yAxisMax - yAxisMin) / 5,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withOpacity(0.2),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: sortedData.length > 10 
                              ? (sortedData.length / 5).ceilToDouble()
                              : 1,
                          getTitlesWidget: (value, meta) {
                            final label = getXAxisLabel(value);
                            if (label.isEmpty) return const Text('');
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                label,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          interval: (yAxisMax - yAxisMin) / 5,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toStringAsFixed(1)}${_getParameterUnit(_selectedParameter)}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    minX: 0,
                    maxX: (sortedData.length - 1).toDouble(),
                    minY: yAxisMin,
                    maxY: yAxisMax,
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: lineColor,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: sortedData.length <= 20,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: lineColor,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: lineColor.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard(
                    'Min',
                    '${minValue.toStringAsFixed(1)}${_getParameterUnit(_selectedParameter)}',
                    Colors.blue,
                  ),
                  _buildStatCard(
                    'Max',
                    '${maxValue.toStringAsFixed(1)}${_getParameterUnit(_selectedParameter)}',
                    Colors.red,
                  ),
                  _buildStatCard(
                    'Avg',
                    '${avgValue.toStringAsFixed(1)}${_getParameterUnit(_selectedParameter)}',
                    Colors.orange,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
