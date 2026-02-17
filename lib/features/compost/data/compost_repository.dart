import '../../../models/compost_batch.dart';
import '../../../models/sensor_data.dart';
import '../../../core/services/composting_service.dart';

/// Compost repository for managing compost batches
class CompostRepository {
  final CompostingService _service = CompostingService();

  CompostRepository();

  /// Get all compost batches
  Future<List<CompostBatch>> getAllBatches() async {
    try {
      return await _service.getAllBatches();
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
      final batches = await _service.getActiveBatches();
      return batches.isNotEmpty ? batches.first : null;
    } catch (e) {
      throw Exception('Failed to load active batch: $e');
    }
  }

  /// Get batch by ID
  Future<CompostBatch?> getBatchById(String id) async {
    try {
      return await _service.getBatch(id);
    } catch (e) {
      throw Exception('Failed to load batch: $e');
    }
  }

  /// Create new batch
  Future<CompostBatch> createBatch({
    required String name,
    required double initialWeight,
    String? location,
  }) async {
    try {
      final batch = CompostBatch(
        id: '',
        batchNumber: name,
        startDate: DateTime.now(),
        status: CompostStatus.active,
        initialWeight: initialWeight,
        notes: location != null ? 'Location: $location' : null,
      );

      return await _service.createBatch(batch);
    } catch (e) {
      throw Exception('Failed to create batch: $e');
    }
  }

  /// Update batch
  Future<CompostBatch> updateBatch(CompostBatch batch) async {
    try {
      return await _service.updateBatch(batch);
    } catch (e) {
      throw Exception('Failed to update batch: $e');
    }
  }

  /// Delete batch
  Future<void> deleteBatch(String id) async {
    try {
      await _service.deleteBatch(id);
    } catch (e) {
      throw Exception('Failed to delete batch: $e');
    }
  }

  /// Add sensor reading
  Future<void> addSensorReading({
    required String batchId,
    required double temperature,
    required double humidity,
    double? moisture,
  }) async {
    try {
      final reading = SensorData(
        id: '',
        timestamp: DateTime.now(),
        temperature: temperature,
        humidity: humidity,
        moisture: moisture,
        sensorType: 'compost',
      );

      await _service.addSensorReading(
        batchId: batchId,
        reading: reading,
      );
    } catch (e) {
      throw Exception('Failed to add sensor reading: $e');
    }
  }

  /// Get sensor readings for a batch
  Future<List<SensorData>> getSensorReadings(String batchId) async {
    try {
      return await _service.getSensorReadings(batchId);
    } catch (e) {
      throw Exception('Failed to load sensor readings: $e');
    }
  }
}
