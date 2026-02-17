import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../../../models/water_tank.dart';
import '../../../models/irrigation.dart';

/// Water management service using Supabase
class WaterManagementService {
  final _supabase = SupabaseService.instance.client;

  // ==================== WATER TANKS ====================

  /// Get all water tanks for current user
  Future<List<WaterTank>> getAllTanks() async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return [];

    final response = await _supabase
        .from('water_tanks')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((json) => _tankFromJson(json)).toList();
  }

  /// Get a specific water tank
  Future<WaterTank?> getTank(String tankId) async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return null;

    final response = await _supabase
        .from('water_tanks')
        .select()
        .eq('id', tankId)
        .eq('user_id', userId)
        .maybeSingle();

    return response != null ? _tankFromJson(response) : null;
  }

  /// Create a new water tank
  Future<WaterTank> createTank(WaterTank tank) async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('water_tanks')
        .insert({
          'user_id': userId,
          'name': tank.name,
          'capacity': tank.capacity,
          'current_level': tank.currentLevel,
          'quality': tank.quality.toString().split('.').last,
          'ph': tank.ph,
          'dissolved_oxygen': tank.dissolvedOxygen,
          'nitrate': tank.nitrate,
          'electrical_conductivity': tank.electricalConductivity,
          'temperature': tank.temperature,
          'turbidity': tank.turbidity,
          'auto_irrigate': tank.autoIrrigate,
          'last_updated': tank.lastUpdated.toIso8601String(),
        })
        .select()
        .single();

    return _tankFromJson(response);
  }

  /// Update a water tank
  Future<WaterTank> updateTank(WaterTank tank) async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('water_tanks')
        .update({
          'name': tank.name,
          'capacity': tank.capacity,
          'current_level': tank.currentLevel,
          'quality': tank.quality.toString().split('.').last,
          'ph': tank.ph,
          'dissolved_oxygen': tank.dissolvedOxygen,
          'nitrate': tank.nitrate,
          'electrical_conductivity': tank.electricalConductivity,
          'temperature': tank.temperature,
          'turbidity': tank.turbidity,
          'auto_irrigate': tank.autoIrrigate,
          'last_updated': DateTime.now().toIso8601String(),
        })
        .eq('id', tank.id)
        .eq('user_id', userId)
        .select()
        .single();

    return _tankFromJson(response);
  }

  /// Delete a water tank
  Future<void> deleteTank(String tankId) async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return;

    await _supabase
        .from('water_tanks')
        .delete()
        .eq('id', tankId)
        .eq('user_id', userId);
  }

  /// Stream water tanks (real-time updates)
  Stream<List<WaterTank>> watchTanks() {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return Stream.value([]);

    return _supabase
        .from('water_tanks')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => _tankFromJson(json)).toList());
  }

  // ==================== IRRIGATION SCHEDULES ====================

  /// Get all irrigation schedules
  Future<List<IrrigationSchedule>> getAllSchedules() async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return [];

    final response = await _supabase
        .from('irrigation_schedules')
        .select()
        .eq('user_id', userId)
        .order('scheduled_time', ascending: true);

    return (response as List).map((json) => _scheduleFromJson(json)).toList();
  }

  /// Create irrigation schedule
  Future<IrrigationSchedule> createSchedule(IrrigationSchedule schedule) async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('irrigation_schedules')
        .insert({
          'user_id': userId,
          'scheduled_time': schedule.scheduledTime.toIso8601String(),
          'duration': schedule.duration,
          'is_active': schedule.isActive,
          'zone': schedule.zone,
        })
        .select()
        .single();

    return _scheduleFromJson(response);
  }

  /// Update irrigation schedule
  Future<IrrigationSchedule> updateSchedule(IrrigationSchedule schedule) async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('irrigation_schedules')
        .update({
          'scheduled_time': schedule.scheduledTime.toIso8601String(),
          'duration': schedule.duration,
          'is_active': schedule.isActive,
          'zone': schedule.zone,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', schedule.id)
        .eq('user_id', userId)
        .select()
        .single();

    return _scheduleFromJson(response);
  }

  /// Delete irrigation schedule
  Future<void> deleteSchedule(String scheduleId) async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return;

    await _supabase
        .from('irrigation_schedules')
        .delete()
        .eq('id', scheduleId)
        .eq('user_id', userId);
  }

  // ==================== IRRIGATION EVENTS (HISTORY) ====================

  /// Get irrigation history
  Future<List<IrrigationEvent>> getIrrigationHistory({int limit = 100}) async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return [];

    final response = await _supabase
        .from('irrigation_events')
        .select()
        .eq('user_id', userId)
        .order('start_time', ascending: false)
        .limit(limit);

    return (response as List).map((json) => _eventFromJson(json)).toList();
  }

  /// Create irrigation event
  Future<IrrigationEvent> createEvent(IrrigationEvent event) async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('irrigation_events')
        .insert({
          'user_id': userId,
          'start_time': event.startTime.toIso8601String(),
          'end_time': event.endTime?.toIso8601String(),
          'duration': event.duration,
          'water_used': event.waterUsed,
          'zone': event.zone,
          'is_automatic': event.isAutomatic,
        })
        .select()
        .single();

    return _eventFromJson(response);
  }

  // ==================== HELPER METHODS ====================

  WaterTank _tankFromJson(Map<String, dynamic> json) {
    return WaterTank(
      id: json['id'] as String,
      name: json['name'] as String,
      capacity: (json['capacity'] as num).toDouble(),
      currentLevel: (json['current_level'] as num).toDouble(),
      quality: WaterQuality.values.firstWhere(
        (e) => e.toString().split('.').last == json['quality'],
      ),
      ph: (json['ph'] as num?)?.toDouble(),
      dissolvedOxygen: (json['dissolved_oxygen'] as num?)?.toDouble(),
      nitrate: (json['nitrate'] as num?)?.toDouble(),
      electricalConductivity:
          (json['electrical_conductivity'] as num?)?.toDouble(),
      temperature: (json['temperature'] as num?)?.toDouble(),
      turbidity: (json['turbidity'] as num?)?.toDouble(),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
      autoIrrigate: json['auto_irrigate'] as bool? ?? false,
    );
  }

  IrrigationSchedule _scheduleFromJson(Map<String, dynamic> json) {
    return IrrigationSchedule(
      id: json['id'] as String,
      scheduledTime: DateTime.parse(json['scheduled_time'] as String),
      duration: json['duration'] as int,
      isActive: json['is_active'] as bool? ?? true,
      zone: json['zone'] as String?,
    );
  }

  IrrigationEvent _eventFromJson(Map<String, dynamic> json) {
    return IrrigationEvent(
      id: json['id'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'] as String)
          : null,
      duration: json['duration'] as int,
      waterUsed: (json['water_used'] as num).toDouble(),
      zone: json['zone'] as String?,
      isAutomatic: json['is_automatic'] as bool? ?? true,
    );
  }
}
