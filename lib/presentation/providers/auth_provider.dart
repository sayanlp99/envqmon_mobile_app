import 'package:flutter/foundation.dart';
import 'package:envqmon/data/models/user_model.dart';
import 'package:envqmon/data/repositories/auth_repository.dart';
import 'package:envqmon/data/datasources/local_storage_service.dart';
import 'package:envqmon/core/services/fcm_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final LocalStorageService _localStorage;
  FcmService? _fcmService;

  AuthProvider({
    required AuthRepository authRepository,
    required LocalStorageService localStorage,
  }) : _authRepository = authRepository,
       _localStorage = localStorage;

  void setFcmService(FcmService fcmService) {
    _fcmService = fcmService;
  }

  bool _isLoading = false;
  String? _error;
  UserModel? _currentUser;
  String? _token;

  bool get isLoading => _isLoading;
  String? get error => _error;
  UserModel? get currentUser => _currentUser;
  String? get token => _token;
  bool get isLoggedIn => _currentUser != null && _token != null;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _localStorage.init();
      final token = await _localStorage.getToken();
      final isLoggedIn = await _localStorage.isLoggedIn();

      if (token != null && isLoggedIn) {
        _token = token;
        final userId = await _localStorage.getUserId();
        final email = await _localStorage.getUserEmail();
        final name = await _localStorage.getUserName();

        if (userId != null && email != null && name != null) {
          _currentUser = UserModel(
            userId: userId,
            name: name,
            email: email,
            roles: [], // Default empty roles
            isActive: true,
          );
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authRepository.login(email: email, password: password);
      
      _currentUser = response.user;
      _token = response.accessToken;

      await _localStorage.saveToken(response.accessToken);
      await _localStorage.saveUserData(
        userId: response.user.userId,
        email: response.user.email,
        name: response.user.name,
      );

      // Register FCM token after successful login (non-blocking)
      if (_fcmService != null) {
        _fcmService!.registerFcmToken(
          userId: response.user.userId,
          authToken: response.accessToken,
        ).then((success) {
          if (success) {
            print('FCM token registered successfully after login');
          } else {
            print('Failed to register FCM token after login');
          }
        }).catchError((error) {
          print('Error in FCM registration after login: $error');
        });
      }

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

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authRepository.register(
        name: name,
        email: email,
        password: password,
      );
      
      _currentUser = response.user;
      _token = response.accessToken;

      await _localStorage.saveToken(response.accessToken);
      await _localStorage.saveUserData(
        userId: response.user.userId,
        email: response.user.email,
        name: response.user.name,
      );

      // Register FCM token after successful registration (non-blocking)
      if (_fcmService != null) {
        _fcmService!.registerFcmToken(
          userId: response.user.userId,
          authToken: response.accessToken,
        ).then((success) {
          if (success) {
            print('FCM token registered successfully after registration');
          } else {
            print('Failed to register FCM token after registration');
          }
        }).catchError((error) {
          print('Error in FCM registration after registration: $error');
        });
      }

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

  Future<void> logout() async {
    _currentUser = null;
    _token = null;
    _error = null;
    
    await _localStorage.clearUserData();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
