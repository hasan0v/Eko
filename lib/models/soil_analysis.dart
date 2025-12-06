import 'package:equatable/equatable.dart';

/// Soil health status
enum SoilHealth {
  healthy,
  moderate,
  unhealthy,
}

/// Soil analysis model
class SoilAnalysis extends Equatable {
  final String id;
  final DateTime timestamp;
  final double healthScore; // 0-100
  final double nitrogen; // N percentage
  final double phosphorus; // P percentage
  final double potassium; // K percentage
  final double ph;
  final double moisture; // percentage
  final double? organicMatter; // percentage
  final double? temperature; // °C
  final List<String> recommendations;
  final SoilHealth health;

  const SoilAnalysis({
    required this.id,
    required this.timestamp,
    required this.healthScore,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.ph,
    required this.moisture,
    this.organicMatter,
    this.temperature,
    this.recommendations = const [],
    required this.health,
  });

  /// Get NPK ratio as string (e.g., "5-10-10")
  String get npkRatio {
    return '${nitrogen.toStringAsFixed(1)}-${phosphorus.toStringAsFixed(1)}-${potassium.toStringAsFixed(1)}';
  }

  /// Check if pH is in optimal range (6.0-7.0)
  bool get isPhOptimal => ph >= 6.0 && ph <= 7.0;

  /// Check if moisture is adequate (40-60%)
  bool get isMoistureOptimal => moisture >= 40 && moisture <= 60;

  factory SoilAnalysis.fromJson(Map<String, dynamic> json) {
    return SoilAnalysis(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      healthScore: (json['healthScore'] as num).toDouble(),
      nitrogen: (json['nitrogen'] as num).toDouble(),
      phosphorus: (json['phosphorus'] as num).toDouble(),
      potassium: (json['potassium'] as num).toDouble(),
      ph: (json['ph'] as num).toDouble(),
      moisture: (json['moisture'] as num).toDouble(),
      organicMatter: (json['organicMatter'] as num?)?.toDouble(),
      temperature: (json['temperature'] as num?)?.toDouble(),
      recommendations: (json['recommendations'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      health: SoilHealth.values.firstWhere(
        (e) => e.toString().split('.').last == json['health'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'healthScore': healthScore,
      'nitrogen': nitrogen,
      'phosphorus': phosphorus,
      'potassium': potassium,
      'ph': ph,
      'moisture': moisture,
      'organicMatter': organicMatter,
      'temperature': temperature,
      'recommendations': recommendations,
      'health': health.toString().split('.').last,
    };
  }

  SoilAnalysis copyWith({
    String? id,
    DateTime? timestamp,
    double? healthScore,
    double? nitrogen,
    double? phosphorus,
    double? potassium,
    double? ph,
    double? moisture,
    double? organicMatter,
    double? temperature,
    List<String>? recommendations,
    SoilHealth? health,
  }) {
    return SoilAnalysis(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      healthScore: healthScore ?? this.healthScore,
      nitrogen: nitrogen ?? this.nitrogen,
      phosphorus: phosphorus ?? this.phosphorus,
      potassium: potassium ?? this.potassium,
      ph: ph ?? this.ph,
      moisture: moisture ?? this.moisture,
      organicMatter: organicMatter ?? this.organicMatter,
      temperature: temperature ?? this.temperature,
      recommendations: recommendations ?? this.recommendations,
      health: health ?? this.health,
    );
  }

  @override
  List<Object?> get props => [
        id,
        timestamp,
        healthScore,
        nitrogen,
        phosphorus,
        potassium,
        ph,
        moisture,
        organicMatter,
        temperature,
        recommendations,
        health,
      ];
}
