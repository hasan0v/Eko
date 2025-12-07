import 'package:equatable/equatable.dart';

/// Irrigation schedule model
class IrrigationSchedule extends Equatable {
  final String id;
  final DateTime scheduledTime;
  final int duration; // in minutes
  final bool isActive;
  final String? zone;

  const IrrigationSchedule({
    required this.id,
    required this.scheduledTime,
    required this.duration,
    this.isActive = true,
    this.zone,
  });

  @override
  List<Object?> get props => [id, scheduledTime, duration, isActive, zone];

  factory IrrigationSchedule.fromJson(Map<String, dynamic> json) {
    return IrrigationSchedule(
      id: json['id'] as String,
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      duration: json['duration'] as int,
      isActive: json['isActive'] as bool? ?? true,
      zone: json['zone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scheduledTime': scheduledTime.toIso8601String(),
      'duration': duration,
      'isActive': isActive,
      'zone': zone,
    };
  }

  IrrigationSchedule copyWith({
    String? id,
    DateTime? scheduledTime,
    int? duration,
    bool? isActive,
    String? zone,
  }) {
    return IrrigationSchedule(
      id: id ?? this.id,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      duration: duration ?? this.duration,
      isActive: isActive ?? this.isActive,
      zone: zone ?? this.zone,
    );
  }
}

/// Irrigation history event model
class IrrigationEvent extends Equatable {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final int duration; // actual duration in minutes
  final double waterUsed; // in liters
  final String? zone;
  final bool isAutomatic;

  const IrrigationEvent({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.duration,
    required this.waterUsed,
    this.zone,
    this.isAutomatic = true,
  });

  bool get isCompleted => endTime != null;

  @override
  List<Object?> get props => [id, startTime, endTime, duration, waterUsed, zone, isAutomatic];

  factory IrrigationEvent.fromJson(Map<String, dynamic> json) {
    return IrrigationEvent(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
      duration: json['duration'] as int,
      waterUsed: (json['waterUsed'] as num).toDouble(),
      zone: json['zone'] as String?,
      isAutomatic: json['isAutomatic'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'duration': duration,
      'waterUsed': waterUsed,
      'zone': zone,
      'isAutomatic': isAutomatic,
    };
  }
}
