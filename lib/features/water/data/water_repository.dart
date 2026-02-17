import '../../../models/water_tank.dart';
import '../../../models/irrigation.dart';
import '../../../core/services/water_management_service.dart';

/// Water management repository
class WaterRepository {
  final WaterManagementService _service = WaterManagementService();

  WaterRepository();

  /// Get all water tanks
  Future<List<WaterTank>> getAllTanks() async {
    try {
      return await _service.getAllTanks();
    } catch (e) {
      throw Exception('Failed to load tanks: $e');
    }
  }

  /// Get water tank status (first tank for backward compatibility)
  Future<WaterTank> getTankStatus() async {
    try {
      final tanks = await _service.getAllTanks();
      if (tanks.isEmpty) {
        // Create a default tank if none exists
        return await _service.createTank(
          WaterTank(
            id: '',
            name: 'Su çəni',
            capacity: 1000.0,
            currentLevel: 750.0,
            quality: WaterQuality.good,
            ph: 7.2,
            dissolvedOxygen: 8.5,
            nitrate: 15.0,
            electricalConductivity: 450.0,
            temperature: 22.5,
            turbidity: 2.1,
            lastUpdated: DateTime.now(),
          ),
        );
      }
      return tanks.first;
    } catch (e) {
      throw Exception('Failed to load tank status: $e');
    }
  }

  /// Toggle auto-irrigation
  Future<bool> toggleAutoIrrigation(bool enabled) async {
    try {
      final tank = await getTankStatus();
      await _service.updateTank(tank.copyWith(autoIrrigate: enabled));
      return enabled;
    } catch (e) {
      throw Exception('Failed to toggle auto-irrigation: $e');
    }
  }

  /// Start manual irrigation
  Future<IrrigationEvent> startManualIrrigation({
    required int duration,
    String? zone,
  }) async {
    try {
      final event = IrrigationEvent(
        id: '',
        startTime: DateTime.now(),
        duration: duration,
        waterUsed: 0,
        zone: zone,
        isAutomatic: false,
      );
      return await _service.createEvent(event);
    } catch (e) {
      throw Exception('Failed to start irrigation: $e');
    }
  }

  /// Get irrigation schedules
  Future<List<IrrigationSchedule>> getSchedules() async {
    try {
      return await _service.getAllSchedules();
    } catch (e) {
      throw Exception('Failed to load schedules: $e');
    }
  }

  /// Add irrigation schedule
  Future<IrrigationSchedule> addSchedule({
    required DateTime scheduledTime,
    required int duration,
    String? zone,
  }) async {
    try {
      final schedule = IrrigationSchedule(
        id: '',
        scheduledTime: scheduledTime,
        duration: duration,
        zone: zone,
      );
      return await _service.createSchedule(schedule);
    } catch (e) {
      throw Exception('Failed to add schedule: $e');
    }
  }

  /// Delete irrigation schedule
  Future<void> deleteSchedule(String scheduleId) async {
    try {
      await _service.deleteSchedule(scheduleId);
    } catch (e) {
      throw Exception('Failed to delete schedule: $e');
    }
  }

  /// Get irrigation history
  Future<List<IrrigationEvent>> getHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      return await _service.getIrrigationHistory(limit: 100);
    } catch (e) {
      throw Exception('Failed to load irrigation history: $e');
    }
  }

  /// Get water usage statistics
  Future<Map<String, dynamic>> getUsageStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final history = await _service.getIrrigationHistory(limit: 100);
      final totalUsed = history.fold<double>(
        0,
        (sum, event) => sum + event.waterUsed,
      );

      return {
        'totalUsed': totalUsed,
        'averageDaily': totalUsed / 7,
        'saved': totalUsed * 0.3, // Mock 30% savings
        'cost': totalUsed * 0.002, // Mock cost calculation
      };
    } catch (e) {
      throw Exception('Failed to load usage stats: $e');
    }
  }
}
