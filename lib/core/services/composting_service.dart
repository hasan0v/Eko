import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../../../models/compost_batch.dart';
import '../../../models/sensor_data.dart';

/// Composting service using Supabase
class CompostingService {
  final _supabase = SupabaseService.instance.client;

  // ==================== COMPOST BATCHES ====================

  /// Get all compost batches for current user
  Future<List<CompostBatch>> getAllBatches() async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return [];

    final response = await _supabase
        .from('compost_batches')
        .select()
        .eq('user_id', userId)
        .order('start_date', ascending: false);

    final batches = <CompostBatch>[];
    for (final json in response as List) {
      final batch = await _batchFromJson(json);
      batches.add(batch);
    }

    return batches;
  }

  /// Get active compost batches
  Future<List<CompostBatch>> getActiveBatches() async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return [];

    final response = await _supabase
        .from('compost_batches')
        .select()
        .eq('user_id', userId)
        .eq('status', 'active')
        .order('start_date', ascending: false);

    final batches = <CompostBatch>[];
    for (final json in response as List) {
      final batch = await _batchFromJson(json);
      batches.add(batch);
    }

    return batches;
  }

  /// Get a specific compost batch with sensor readings
  Future<CompostBatch?> getBatch(String batchId) async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return null;

    final response = await _supabase
        .from('compost_batches')
        .select()
        .eq('id', batchId)
        .eq('user_id', userId)
        .maybeSingle();

    return response != null ? await _batchFromJson(response) : null;
  }

  /// Create a new compost batch
  Future<CompostBatch> createBatch(CompostBatch batch) async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('compost_batches')
        .insert({
          'user_id': userId,
          'batch_number': batch.batchNumber,
          'start_date': batch.startDate.toIso8601String(),
          'end_date': batch.endDate?.toIso8601String(),
          'status': batch.status.toString().split('.').last,
          'initial_weight': batch.initialWeight,
          'current_weight': batch.currentWeight,
          'final_weight': batch.finalWeight,
          'rating': batch.rating,
          'notes': batch.notes,
        })
        .select()
        .single();

    return await _batchFromJson(response);
  }

  /// Update a compost batch
  Future<CompostBatch> updateBatch(CompostBatch batch) async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('compost_batches')
        .update({
          'batch_number': batch.batchNumber,
          'start_date': batch.startDate.toIso8601String(),
          'end_date': batch.endDate?.toIso8601String(),
          'status': batch.status.toString().split('.').last,
          'initial_weight': batch.initialWeight,
          'current_weight': batch.currentWeight,
          'final_weight': batch.finalWeight,
          'rating': batch.rating,
          'notes': batch.notes,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', batch.id)
        .eq('user_id', userId)
        .select()
        .single();

    return await _batchFromJson(response);
  }

  /// Delete a compost batch
  Future<void> deleteBatch(String batchId) async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return;

    await _supabase
        .from('compost_batches')
        .delete()
        .eq('id', batchId)
        .eq('user_id', userId);
  }

  // ==================== SENSOR DATA ====================

  /// Get sensor readings for a batch
  Future<List<SensorData>> getSensorReadings(String batchId) async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return [];

    final response = await _supabase
        .from('sensor_data')
        .select()
        .eq('user_id', userId)
        .eq('compost_batch_id', batchId)
        .order('timestamp', ascending: false);

    return (response as List).map((json) => _sensorDataFromJson(json)).toList();
  }

  /// Add sensor reading to a batch
  Future<SensorData> addSensorReading({
    required String batchId,
    required SensorData reading,
  }) async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('sensor_data')
        .insert({
          'user_id': userId,
          'compost_batch_id': batchId,
          'sensor_type': reading.sensorType,
          'temperature': reading.temperature,
          'humidity': reading.humidity,
          'co2_level': reading.co2Level,
          'weight': reading.weight,
          'ph': reading.ph,
          'moisture': reading.moisture,
          'timestamp': reading.timestamp.toIso8601String(),
        })
        .select()
        .single();

    return _sensorDataFromJson(response);
  }

  /// Get latest sensor reading for a batch
  Future<SensorData?> getLatestReading(String batchId) async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return null;

    final response = await _supabase
        .from('sensor_data')
        .select()
        .eq('user_id', userId)
        .eq('compost_batch_id', batchId)
        .order('timestamp', ascending: false)
        .limit(1)
        .maybeSingle();

    return response != null ? _sensorDataFromJson(response) : null;
  }

  /// Stream compost batches (real-time updates)
  Stream<List<CompostBatch>> watchBatches() {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return Stream.value([]);

    return _supabase
        .from('compost_batches')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('start_date', ascending: false)
        .asyncMap((data) async {
          final batches = <CompostBatch>[];
          for (final json in data) {
            final batch = await _batchFromJson(json);
            batches.add(batch);
          }
          return batches;
        });
  }

  // ==================== HELPER METHODS ====================

  Future<CompostBatch> _batchFromJson(Map<String, dynamic> json) async {
    // Fetch sensor readings for this batch
    final readings = await getSensorReadings(json['id'] as String);

    return CompostBatch(
      id: json['id'] as String,
      batchNumber: json['batch_number'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      status: CompostStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      initialWeight: (json['initial_weight'] as num).toDouble(),
      currentWeight: (json['current_weight'] as num?)?.toDouble(),
      finalWeight: (json['final_weight'] as num?)?.toDouble(),
      rating: json['rating'] as int?,
      sensorReadings: readings,
      notes: json['notes'] as String?,
    );
  }

  SensorData _sensorDataFromJson(Map<String, dynamic> json) {
    return SensorData(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      temperature: (json['temperature'] as num?)?.toDouble(),
      humidity: (json['humidity'] as num?)?.toDouble(),
      co2Level: (json['co2_level'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      ph: (json['ph'] as num?)?.toDouble(),
      moisture: (json['moisture'] as num?)?.toDouble(),
      sensorType: json['sensor_type'] as String,
    );
  }
}
