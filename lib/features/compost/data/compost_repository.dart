import '../../../models/compost_batch.dart';
import '../../../models/sensor_data.dart';
import '../../../core/services/api_client.dart';

/// Compost repository for managing compost batches
class CompostRepository {
  final ApiClient _apiClient;

  CompostRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Get all compost batches
  Future<List<CompostBatch>> getAllBatches() async {
    try {
      // TODO: Replace with actual API call
      // final response = await _apiClient.get('/compost/batches');
      
      // Mock data for now
      await Future.delayed(const Duration(milliseconds: 500));
      
      return _getMockBatches();
    } catch (e) {
      throw Exception('Failed to load batches: $e');
    }
  }

  /// Get all compost batches (alias for backwards compatibility)
  Future<List<CompostBatch>> getBatches() async {
    return getAllBatches();
  }

  /// Get active batch
  Future<CompostBatch?> getActiveBatch() async {
    try {
      final batches = await getBatches();
      return batches.firstWhere(
        (batch) => batch.status == CompostStatus.active,
        orElse: () => batches.first,
      );
    } catch (e) {
      throw Exception('Failed to load active batch: $e');
    }
  }

  /// Get batch by ID
  Future<CompostBatch?> getBatchById(String id) async {
    try {
      // TODO: Replace with actual API call
      // final response = await _apiClient.get('/compost/batches/$id');
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      final batches = _getMockBatches();
      try {
        return batches.firstWhere((batch) => batch.id == id);
      } catch (e) {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to load batch: $e');
    }
  }

  /// Create new batch
  Future<CompostBatch> createBatch({
    required String name,
    required double initialWeight,
    required String location,
  }) async {
    try {
      // TODO: Replace with actual API call
      // final response = await _apiClient.post('/compost/batches', data: {
      //   'name': name,
      //   'initialWeight': initialWeight,
      //   'location': location,
      // });
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      return CompostBatch(
        id: '${DateTime.now().millisecondsSinceEpoch}',
        batchNumber: name,
        startDate: DateTime.now(),
        status: CompostStatus.active,
        initialWeight: initialWeight,
        currentWeight: initialWeight,
        notes: 'Location: $location',
      );
    } catch (e) {
      throw Exception('Failed to create batch: $e');
    }
  }

  /// Update batch status
  Future<CompostBatch?> updateBatchStatus(String id, CompostStatus status) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final batch = await getBatchById(id);
      if (batch == null) return null;
      return batch.copyWith(status: status);
    } catch (e) {
      throw Exception('Failed to update batch: $e');
    }
  }

  /// Get sensor data for batch
  Future<List<SensorData>> getSensorData(
    String batchId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      return _getMockSensorData();
    } catch (e) {
      throw Exception('Failed to load sensor data: $e');
    }
  }

  /// Delete batch
  Future<void> deleteBatch(String batchId) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      throw Exception('Failed to delete batch: $e');
    }
  }

  /// Get sensor readings for batch
  Future<List<SensorData>> getSensorReadings(String batchId) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      return _getMockSensorData();
    } catch (e) {
      throw Exception('Failed to load sensor data: $e');
    }
  }

  /// Mock data generators
  List<CompostBatch> _getMockBatches() {
    return [
      CompostBatch(
        id: '1',
        batchNumber: 'BATCH-2025-001',
        startDate: DateTime.now().subtract(const Duration(days: 15)),
        status: CompostStatus.active,
        initialWeight: 100.0,
        currentWeight: 75.0,
        sensorReadings: _getMockSensorData(),
      ),
      CompostBatch(
        id: '2',
        batchNumber: 'BATCH-2025-002',
        startDate: DateTime.now().subtract(const Duration(days: 45)),
        endDate: DateTime.now().subtract(const Duration(days: 10)),
        status: CompostStatus.ready,
        initialWeight: 120.0,
        currentWeight: 85.0,
        finalWeight: 85.0,
        rating: 5,
      ),
      CompostBatch(
        id: '3',
        batchNumber: 'BATCH-2024-025',
        startDate: DateTime.now().subtract(const Duration(days: 70)),
        endDate: DateTime.now().subtract(const Duration(days: 35)),
        status: CompostStatus.harvested,
        initialWeight: 110.0,
        finalWeight: 78.0,
        rating: 4,
      ),
    ];
  }

  List<SensorData> _getMockSensorData() {
    final now = DateTime.now();
    return List.generate(
      24,
      (index) => SensorData(
        id: '${index + 1}',
        timestamp: now.subtract(Duration(hours: 24 - index)),
        temperature: 40.0 + (index % 10),
        humidity: 60.0 + (index % 15),
        co2Level: 400.0 + (index * 5),
        weight: 75.0 - (index * 0.1),
        sensorType: 'compost',
      ),
    );
  }
}
