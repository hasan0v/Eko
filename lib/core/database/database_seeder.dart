import 'local_database.dart';

/// Seeds the local database with sample data for development/demo
class DatabaseSeeder {
  static final LocalDatabase _db = LocalDatabase();

  static Future<void> seedAll() async {
    await seedCompostBatches();
    await seedSensorData();
    await seedWaterTanks();
    await seedIrrigationEvents();
  }

  static Future<void> seedCompostBatches() async {
    final batches = [
      {
        'id': 'batch-001',
        'batchNumber': 'COM-001',
        'name': 'Bitki Tullantıları Partiyası',
        'status': 'active',
        'startDate': DateTime.now().subtract(const Duration(days: 15)).toIso8601String(),
        'initialWeight': 85.5,
        'currentWeight': 71.2,
        'weightReduction': 16.7,
        'location': 'Bin A',
        'progress': 45.0,
        'durationDays': 15,
        'latestReading': {
          'temperature': 65.0,
          'humidity': 55.0,
          'co2Level': 800.0,
        },
      },
      {
        'id': 'batch-002',
        'batchNumber': 'COM-002',
        'name': 'Qarışıq Üzvi Partiya',
        'status': 'active',
        'startDate': DateTime.now().subtract(const Duration(days: 8)).toIso8601String(),
        'initialWeight': 92.0,
        'currentWeight': 85.4,
        'weightReduction': 7.2,
        'location': 'Bin B',
        'progress': 25.0,
        'durationDays': 8,
        'latestReading': {
          'temperature': 58.0,
          'humidity': 60.0,
          'co2Level': 750.0,
        },
      },
      {
        'id': 'batch-003',
        'batchNumber': 'COM-003',
        'name': 'Bağ Tullantıları',
        'status': 'completed',
        'startDate': DateTime.now().subtract(const Duration(days: 45)).toIso8601String(),
        'endDate': DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
        'initialWeight': 78.0,
        'currentWeight': 58.5,
        'weightReduction': 25.0,
        'location': 'Bin C',
        'progress': 100.0,
        'durationDays': 35,
        'rating': 4.5,
      },
    ];

    for (final batch in batches) {
      await _db.saveCompostBatch(batch['id'] as String, batch);
    }
  }

  static Future<void> seedSensorData() async {
    final now = DateTime.now();
    
    // Compost sensor data
    for (int i = 0; i < 10; i++) {
      await _db.saveSensorData('sensor-compost-$i', {
        'id': 'sensor-compost-$i',
        'timestamp': now.subtract(Duration(hours: i * 2)).toIso8601String(),
        'temperature': 60.0 + (i % 3) * 5,
        'humidity': 50.0 + (i % 4) * 5,
        'co2Level': 700.0 + (i % 5) * 50,
        'sensorType': 'compost',
      });
    }

    // Water sensor data
    for (int i = 0; i < 10; i++) {
      await _db.saveSensorData('sensor-water-$i', {
        'id': 'sensor-water-$i',
        'timestamp': now.subtract(Duration(hours: i * 2)).toIso8601String(),
        'ph': 7.0 + (i % 3) * 0.2,
        'temperature': 22.0 + (i % 2) * 2,
        'sensorType': 'water',
      });
    }

    // Soil sensor data
    for (int i = 0; i < 10; i++) {
      await _db.saveSensorData('sensor-soil-$i', {
        'id': 'sensor-soil-$i',
        'timestamp': now.subtract(Duration(hours: i * 2)).toIso8601String(),
        'moisture': 30.0 + (i % 4) * 10,
        'ph': 6.5 + (i % 3) * 0.3,
        'temperature': 20.0 + (i % 2) * 3,
        'sensorType': 'soil',
      });
    }
  }

  static Future<void> seedWaterTanks() async {
    final tanks = [
      {
        'id': 'tank-001',
        'name': 'Əsas Su Çəni',
        'capacity': 1000.0,
        'currentLevel': 750.0,
        'levelPercentage': 75.0,
        'ph': 7.2,
        'dissolvedOxygen': 8.5,
        'nitrate': 15.0,
        'electricalConductivity': 450.0,
        'temperature': 22.0,
        'turbidity': 2.5,
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'id': 'tank-002',
        'name': 'Ehtiyat Çən',
        'capacity': 500.0,
        'currentLevel': 425.0,
        'levelPercentage': 85.0,
        'ph': 7.0,
        'dissolvedOxygen': 8.0,
        'nitrate': 12.0,
        'electricalConductivity': 420.0,
        'temperature': 23.0,
        'turbidity': 3.0,
        'lastUpdated': DateTime.now().toIso8601String(),
      },
    ];

    for (final tank in tanks) {
      await _db.saveWaterTank(tank['id'] as String, tank);
    }
  }

  static Future<void> seedIrrigationEvents() async {
    final events = [
      {
        'id': 'irr-001',
        'startTime': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        'endTime': DateTime.now().subtract(const Duration(hours: 1, minutes: 45)).toIso8601String(),
        'duration': 15,
        'waterUsed': 45.5,
        'zone': 'Zona A',
        'type': 'automatic',
        'status': 'completed',
      },
      {
        'id': 'irr-002',
        'startTime': DateTime.now().subtract(const Duration(hours: 6)).toIso8601String(),
        'endTime': DateTime.now().subtract(const Duration(hours: 5, minutes: 40)).toIso8601String(),
        'duration': 20,
        'waterUsed': 62.0,
        'zone': 'Zona B',
        'type': 'automatic',
        'status': 'completed',
      },
      {
        'id': 'irr-003',
        'startTime': DateTime.now().subtract(const Duration(days: 1, hours: 3)).toIso8601String(),
        'endTime': DateTime.now().subtract(const Duration(days: 1, hours: 2, minutes: 50)).toIso8601String(),
        'duration': 10,
        'waterUsed': 28.5,
        'zone': 'Zona C',
        'type': 'manual',
        'status': 'completed',
      },
    ];

    for (final event in events) {
      await _db.saveIrrigationEvent(event['id'] as String, event);
    }
  }

  static Future<void> clearAllData() async {
    await _db.clearAllData();
  }
}
