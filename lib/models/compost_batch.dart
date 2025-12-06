import 'package:equatable/equatable.dart';
import 'sensor_data.dart';

/// Compost batch status
enum CompostStatus {
  active,
  curing,
  ready,
  harvested,
}

/// Compost batch model
class CompostBatch extends Equatable {
  final String id;
  final String batchNumber;
  final DateTime startDate;
  final DateTime? endDate;
  final CompostStatus status;
  final double initialWeight;
  final double? currentWeight;
  final double? finalWeight;
  final int? rating;
  final List<SensorData> sensorReadings;
  final String? notes;

  const CompostBatch({
    required this.id,
    required this.batchNumber,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.initialWeight,
    this.currentWeight,
    this.finalWeight,
    this.rating,
    this.sensorReadings = const [],
    this.notes,
  });

  /// Get progress percentage (0-100)
  double get progress {
    if (status == CompostStatus.ready || status == CompostStatus.harvested) {
      return 100.0;
    }
    
    final now = DateTime.now();
    final elapsed = now.difference(startDate).inDays;
    final typical = 30; // Typical composting duration in days
    
    return (elapsed / typical * 100).clamp(0.0, 100.0);
  }

  /// Get duration in days
  int get durationDays {
    final end = endDate ?? DateTime.now();
    return end.difference(startDate).inDays;
  }

  /// Get weight reduction percentage
  double? get weightReduction {
    if (currentWeight == null) return null;
    return ((initialWeight - currentWeight!) / initialWeight * 100);
  }

  /// Get latest sensor reading
  SensorData? get latestReading {
    if (sensorReadings.isEmpty) return null;
    return sensorReadings.reduce((a, b) => 
      a.timestamp.isAfter(b.timestamp) ? a : b
    );
  }

  factory CompostBatch.fromJson(Map<String, dynamic> json) {
    return CompostBatch(
      id: json['id'] as String,
      batchNumber: json['batchNumber'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      status: CompostStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      initialWeight: (json['initialWeight'] as num).toDouble(),
      currentWeight: (json['currentWeight'] as num?)?.toDouble(),
      finalWeight: (json['finalWeight'] as num?)?.toDouble(),
      rating: json['rating'] as int?,
      sensorReadings: (json['sensorReadings'] as List?)
              ?.map((e) => SensorData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'batchNumber': batchNumber,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'status': status.toString().split('.').last,
      'initialWeight': initialWeight,
      'currentWeight': currentWeight,
      'finalWeight': finalWeight,
      'rating': rating,
      'sensorReadings': sensorReadings.map((e) => e.toJson()).toList(),
      'notes': notes,
    };
  }

  CompostBatch copyWith({
    String? id,
    String? batchNumber,
    DateTime? startDate,
    DateTime? endDate,
    CompostStatus? status,
    double? initialWeight,
    double? currentWeight,
    double? finalWeight,
    int? rating,
    List<SensorData>? sensorReadings,
    String? notes,
  }) {
    return CompostBatch(
      id: id ?? this.id,
      batchNumber: batchNumber ?? this.batchNumber,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      initialWeight: initialWeight ?? this.initialWeight,
      currentWeight: currentWeight ?? this.currentWeight,
      finalWeight: finalWeight ?? this.finalWeight,
      rating: rating ?? this.rating,
      sensorReadings: sensorReadings ?? this.sensorReadings,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        batchNumber,
        startDate,
        endDate,
        status,
        initialWeight,
        currentWeight,
        finalWeight,
        rating,
        sensorReadings,
        notes,
      ];
}
