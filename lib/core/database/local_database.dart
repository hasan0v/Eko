import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/user.dart';
import '../../models/compost_batch.dart';
import '../../models/sensor_data.dart';
import '../../models/water_tank.dart';
import '../../models/irrigation.dart';

/// Local database service using Hive
class LocalDatabase {
  static final LocalDatabase _instance = LocalDatabase._internal();
  factory LocalDatabase() => _instance;
  LocalDatabase._internal();

  // Box names
  static const String _userBox = 'users';
  static const String _compostBox = 'compost_batches';
  static const String _sensorBox = 'sensor_data';
  static const String _waterBox = 'water_tanks';
  static const String _irrigationBox = 'irrigation_events';
  static const String _settingsBox = 'settings';

  // Initialize Hive
  Future<void> initialize() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocDir.path);

    // Register adapters (will be generated)
    // Hive.registerAdapter(UserAdapter());
    // Hive.registerAdapter(CompostBatchAdapter());
    // Hive.registerAdapter(SensorDataAdapter());
    // Hive.registerAdapter(WaterTankAdapter());
    // Hive.registerAdapter(IrrigationEventAdapter());

    // Open boxes
    await _openBoxes();
  }

  Future<void> _openBoxes() async {
    await Hive.openBox(_userBox);
    await Hive.openBox(_compostBox);
    await Hive.openBox(_sensorBox);
    await Hive.openBox(_waterBox);
    await Hive.openBox(_irrigationBox);
    await Hive.openBox(_settingsBox);
  }

  // User operations
  Future<void> saveUser(String id, Map<String, dynamic> userData) async {
    final box = Hive.box(_userBox);
    await box.put(id, userData);
  }

  Map<String, dynamic>? getUser(String id) {
    final box = Hive.box(_userBox);
    return box.get(id) as Map<String, dynamic>?;
  }

  Future<void> deleteUser(String id) async {
    final box = Hive.box(_userBox);
    await box.delete(id);
  }

  // Current user session
  Future<void> setCurrentUser(String userId) async {
    final box = Hive.box(_settingsBox);
    await box.put('current_user', userId);
  }

  String? getCurrentUserId() {
    final box = Hive.box(_settingsBox);
    return box.get('current_user') as String?;
  }

  Future<void> clearCurrentUser() async {
    final box = Hive.box(_settingsBox);
    await box.delete('current_user');
  }

  // Compost Batch operations
  Future<void> saveCompostBatch(String id, Map<String, dynamic> batchData) async {
    final box = Hive.box(_compostBox);
    await box.put(id, batchData);
  }

  Map<String, dynamic>? getCompostBatch(String id) {
    final box = Hive.box(_compostBox);
    return box.get(id) as Map<String, dynamic>?;
  }

  List<Map<String, dynamic>> getAllCompostBatches() {
    final box = Hive.box(_compostBox);
    return box.values.cast<Map<String, dynamic>>().toList();
  }

  Future<void> deleteCompostBatch(String id) async {
    final box = Hive.box(_compostBox);
    await box.delete(id);
  }

  // Sensor Data operations
  Future<void> saveSensorData(String id, Map<String, dynamic> sensorData) async {
    final box = Hive.box(_sensorBox);
    await box.put(id, sensorData);
  }

  Map<String, dynamic>? getSensorData(String id) {
    final box = Hive.box(_sensorBox);
    return box.get(id) as Map<String, dynamic>?;
  }

  List<Map<String, dynamic>> getAllSensorData() {
    final box = Hive.box(_sensorBox);
    return box.values.cast<Map<String, dynamic>>().toList();
  }

  List<Map<String, dynamic>> getSensorDataByType(String type) {
    final box = Hive.box(_sensorBox);
    return box.values
        .cast<Map<String, dynamic>>()
        .where((data) => data['sensorType'] == type)
        .toList();
  }

  Future<void> deleteSensorData(String id) async {
    final box = Hive.box(_sensorBox);
    await box.delete(id);
  }

  // Water Tank operations
  Future<void> saveWaterTank(String id, Map<String, dynamic> tankData) async {
    final box = Hive.box(_waterBox);
    await box.put(id, tankData);
  }

  Map<String, dynamic>? getWaterTank(String id) {
    final box = Hive.box(_waterBox);
    return box.get(id) as Map<String, dynamic>?;
  }

  List<Map<String, dynamic>> getAllWaterTanks() {
    final box = Hive.box(_waterBox);
    return box.values.cast<Map<String, dynamic>>().toList();
  }

  Future<void> deleteWaterTank(String id) async {
    final box = Hive.box(_waterBox);
    await box.delete(id);
  }

  // Irrigation Event operations
  Future<void> saveIrrigationEvent(String id, Map<String, dynamic> eventData) async {
    final box = Hive.box(_irrigationBox);
    await box.put(id, eventData);
  }

  Map<String, dynamic>? getIrrigationEvent(String id) {
    final box = Hive.box(_irrigationBox);
    return box.get(id) as Map<String, dynamic>?;
  }

  List<Map<String, dynamic>> getAllIrrigationEvents() {
    final box = Hive.box(_irrigationBox);
    return box.values.cast<Map<String, dynamic>>().toList();
  }

  Future<void> deleteIrrigationEvent(String id) async {
    final box = Hive.box(_irrigationBox);
    await box.delete(id);
  }

  // Settings operations
  Future<void> saveSetting(String key, dynamic value) async {
    final box = Hive.box(_settingsBox);
    await box.put(key, value);
  }

  dynamic getSetting(String key, {dynamic defaultValue}) {
    final box = Hive.box(_settingsBox);
    return box.get(key, defaultValue: defaultValue);
  }

  Future<void> deleteSetting(String key) async {
    final box = Hive.box(_settingsBox);
    await box.delete(key);
  }

  // Theme mode
  Future<void> setThemeMode(String mode) async {
    await saveSetting('theme_mode', mode);
  }

  String getThemeMode() {
    return getSetting('theme_mode', defaultValue: 'system') as String;
  }

  // Clear all data
  Future<void> clearAllData() async {
    await Hive.box(_userBox).clear();
    await Hive.box(_compostBox).clear();
    await Hive.box(_sensorBox).clear();
    await Hive.box(_waterBox).clear();
    await Hive.box(_irrigationBox).clear();
  }

  // Close all boxes
  Future<void> close() async {
    await Hive.close();
  }
}
