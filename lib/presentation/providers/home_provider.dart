import 'package:flutter/foundation.dart';
import 'package:envqmon/data/models/home_model.dart';
import 'package:envqmon/data/repositories/home_repository.dart';

class HomeProvider extends ChangeNotifier {
  final HomeRepository _homeRepository;

  HomeProvider({required HomeRepository homeRepository}) : _homeRepository = homeRepository;

  bool _isLoading = false;
  String? _error;
  List<HomeModel> _homes = [];
  HomeModel? _selectedHome;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<HomeModel> get homes => _homes;
  HomeModel? get selectedHome => _selectedHome;

  Future<void> loadHomes(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _homes = await _homeRepository.getHomes(token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createHome({
    required String name,
    required String address,
    required String userId,
    required String token,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newHome = await _homeRepository.createHome(
        name: name,
        address: address,
        userId: userId,
        token: token,
      );
      
      _homes.add(newHome);
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

  void selectHome(HomeModel home) {
    _selectedHome = home;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
