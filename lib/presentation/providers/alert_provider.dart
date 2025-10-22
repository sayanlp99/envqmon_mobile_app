import 'package:flutter/foundation.dart';
import 'package:envqmon/data/models/alert_model.dart';
import 'package:envqmon/data/repositories/alert_repository.dart';

class AlertProvider extends ChangeNotifier {
  final AlertRepository _alertRepository;

  AlertProvider({
    required AlertRepository alertRepository,
  }) : _alertRepository = alertRepository;

  bool _isLoading = false;
  String? _error;
  List<AlertModel> _alerts = [];
  bool _hasMoreData = true;
  int _currentPage = 1;
  static const int _pageSize = 10;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<AlertModel> get alerts => _alerts;
  bool get hasMoreData => _hasMoreData;
  bool get hasAlerts => _alerts.isNotEmpty;

  Future<void> loadAlerts(String authToken, {bool refresh = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    if (refresh) {
      _alerts.clear();
      _currentPage = 1;
      _hasMoreData = true;
    }
    _error = null;
    notifyListeners();

    try {
      final newAlerts = await _alertRepository.getAlerts(
        authToken: authToken,
        page: _currentPage,
        limit: _pageSize,
      );

      if (refresh) {
        _alerts = newAlerts;
      } else {
        _alerts.addAll(newAlerts);
      }

      _hasMoreData = newAlerts.length == _pageSize;
      _currentPage++;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreAlerts(String authToken) async {
    if (!_hasMoreData || _isLoading) return;
    await loadAlerts(authToken);
  }

  Future<void> refreshAlerts(String authToken) async {
    await loadAlerts(authToken, refresh: true);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearAlerts() {
    _alerts.clear();
    _currentPage = 1;
    _hasMoreData = true;
    _error = null;
    notifyListeners();
  }
}
