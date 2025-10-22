import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:envqmon/presentation/providers/auth_provider.dart';
import 'package:envqmon/presentation/providers/alert_provider.dart';
import 'package:envqmon/presentation/widgets/loading_indicator.dart';
import 'package:envqmon/core/constants/app_constants.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadAlerts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMoreAlerts();
    }
  }

  Future<void> _loadAlerts() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final alertProvider = Provider.of<AlertProvider>(context, listen: false);

    if (authProvider.token != null) {
      await alertProvider.loadAlerts(authProvider.token!, refresh: true);
    }
  }

  Future<void> _loadMoreAlerts() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final alertProvider = Provider.of<AlertProvider>(context, listen: false);

    if (authProvider.token != null) {
      await alertProvider.loadMoreAlerts(authProvider.token!);
    }
  }

  Future<void> _refreshAlerts() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final alertProvider = Provider.of<AlertProvider>(context, listen: false);

    if (authProvider.token != null) {
      await alertProvider.refreshAlerts(authProvider.token!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshAlerts,
          ),
        ],
      ),
      body: Consumer2<AuthProvider, AlertProvider>(
        builder: (context, authProvider, alertProvider, child) {
          if (alertProvider.isLoading && alertProvider.alerts.isEmpty) {
            return const LoadingIndicator(message: 'Loading alerts...');
          }

          if (alertProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading alerts',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    alertProvider.error!,
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _refreshAlerts,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (alertProvider.alerts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.notifications_off,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No alerts found',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You don\'t have any alerts yet. Alerts will appear here when environmental thresholds are exceeded.',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _refreshAlerts,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshAlerts,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: alertProvider.alerts.length + (alertProvider.hasMoreData ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= alertProvider.alerts.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final alert = alertProvider.alerts[index];
                return _buildAlertCard(alert);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildAlertCard(alert) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getAlertIcon(alert.alertType),
                  color: _getAlertColor(alert.alertType),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    alert.formattedAlertType,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getAlertColor(alert.alertType).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    alert.formattedValue,
                    style: TextStyle(
                      color: _getAlertColor(alert.alertType),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Device: ${alert.deviceTopic.split('/').last}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Alert Time: ${_formatDateTime(alert.createdAtDateTime)}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            if (alert.timestamp != alert.createdAt) ...[
              const SizedBox(height: 4),
              Text(
                'Reading Time: ${_formatDateTime(alert.timestampDateTime)}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getAlertIcon(String alertType) {
    switch (alertType) {
      case 'temperature_high':
        return Icons.thermostat;
      case 'humidity_high':
        return Icons.water_drop;
      case 'pressure_high':
        return Icons.speed;
      case 'co_high':
        return Icons.dangerous;
      case 'methane_high':
        return Icons.local_fire_department;
      case 'lpg_high':
        return Icons.local_fire_department;
      case 'pm25_high':
      case 'pm10_high':
        return Icons.cloud;
      case 'noise_high':
        return Icons.volume_up;
      default:
        return Icons.warning;
    }
  }

  Color _getAlertColor(String alertType) {
    switch (alertType) {
      case 'temperature_high':
        return Colors.red;
      case 'humidity_high':
        return Colors.blue;
      case 'pressure_high':
        return Colors.orange;
      case 'co_high':
      case 'methane_high':
      case 'lpg_high':
        return Colors.red;
      case 'pm25_high':
      case 'pm10_high':
        return Colors.brown;
      case 'noise_high':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
