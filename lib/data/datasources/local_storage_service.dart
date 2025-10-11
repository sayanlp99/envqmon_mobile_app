import 'package:shared_preferences/shared_preferences.dart';
import 'package:envqmon/core/constants/pref_keys.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> saveToken(String token) async {
    await _prefs?.setString(PrefKeys.token, token);
  }

  Future<String?> getToken() async {
    return _prefs?.getString(PrefKeys.token);
  }

  Future<void> saveUserData({
    required String userId,
    required String email,
    required String name,
  }) async {
    await _prefs?.setString(PrefKeys.userId, userId);
    await _prefs?.setString(PrefKeys.userEmail, email);
    await _prefs?.setString(PrefKeys.userName, name);
    await _prefs?.setBool(PrefKeys.isLoggedIn, true);
  }

  Future<String?> getUserId() async {
    return _prefs?.getString(PrefKeys.userId);
  }

  Future<String?> getUserEmail() async {
    return _prefs?.getString(PrefKeys.userEmail);
  }

  Future<String?> getUserName() async {
    return _prefs?.getString(PrefKeys.userName);
  }

  Future<bool> isLoggedIn() async {
    return _prefs?.getBool(PrefKeys.isLoggedIn) ?? false;
  }

  Future<void> clearUserData() async {
    await _prefs?.remove(PrefKeys.token);
    await _prefs?.remove(PrefKeys.userId);
    await _prefs?.remove(PrefKeys.userEmail);
    await _prefs?.remove(PrefKeys.userName);
    await _prefs?.setBool(PrefKeys.isLoggedIn, false);
  }

  Future<void> saveString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  Future<String?> getString(String key) async {
    return _prefs?.getString(key);
  }

  Future<void> saveBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    return _prefs?.getBool(key);
  }

  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }
}
