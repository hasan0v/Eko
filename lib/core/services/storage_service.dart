import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Local storage service using SharedPreferences
class StorageService {
  static const String _userKey = 'user';
  static const String _authTokenKey = 'auth_token';
  static const String _onboardingKey = 'onboarding_completed';
  static const String _themeKey = 'theme_mode';

  late final SharedPreferences _prefs;

  /// Initialize storage
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ========== User Data ==========

  /// Save user data
  Future<bool> saveUser(Map<String, dynamic> user) async {
    final userJson = json.encode(user);
    return await _prefs.setString(_userKey, userJson);
  }

  /// Get user data
  Map<String, dynamic>? getUser() {
    final userJson = _prefs.getString(_userKey);
    if (userJson == null) return null;
    return json.decode(userJson) as Map<String, dynamic>;
  }

  /// Clear user data
  Future<bool> clearUser() async {
    return await _prefs.remove(_userKey);
  }

  // ========== Authentication ==========

  /// Save auth token
  Future<bool> saveAuthToken(String token) async {
    return await _prefs.setString(_authTokenKey, token);
  }

  /// Get auth token
  String? getAuthToken() {
    return _prefs.getString(_authTokenKey);
  }

  /// Clear auth token
  Future<bool> clearAuthToken() async {
    return await _prefs.remove(_authTokenKey);
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return getAuthToken() != null;
  }

  // ========== Onboarding ==========

  /// Mark onboarding as completed
  Future<bool> setOnboardingCompleted() async {
    return await _prefs.setBool(_onboardingKey, true);
  }

  /// Check if onboarding is completed
  bool isOnboardingCompleted() {
    return _prefs.getBool(_onboardingKey) ?? false;
  }

  // ========== Theme ==========

  /// Save theme mode ('light', 'dark', 'system')
  Future<bool> saveThemeMode(String mode) async {
    return await _prefs.setString(_themeKey, mode);
  }

  /// Get theme mode
  String getThemeMode() {
    return _prefs.getString(_themeKey) ?? 'system';
  }

  // ========== Generic Methods ==========

  /// Save string
  Future<bool> saveString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  /// Get string
  String? getString(String key) {
    return _prefs.getString(key);
  }

  /// Save int
  Future<bool> saveInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  /// Get int
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  /// Save bool
  Future<bool> saveBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  /// Get bool
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  /// Save double
  Future<bool> saveDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  /// Get double
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  /// Remove key
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  /// Clear all data
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }

  /// Check if key exists
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }
}
