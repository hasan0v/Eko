import 'package:equatable/equatable.dart';

/// Water quality status
enum WaterQuality {
  excellent,
  good,
  fair,
  poor,
}

/// Water tank model
class WaterTank extends Equatable {
  final String id;
  final double capacity; // in liters
  final double currentLevel; // in liters
  final WaterQuality quality;
  final double? ph;
  final double? dissolvedOxygen; // mg/L
  final double? nitrate; // mg/L
  final double? electricalConductivity; // µS/cm
  final double? temperature; // °C
  final double? turbidity; // NTU
  final DateTime lastUpdated;
  final bool autoIrrigate;

  const WaterTank({
    required this.id,
    required this.capacity,
    required this.currentLevel,
    required this.quality,
    this.ph,
    this.dissolvedOxygen,
    this.nitrate,
    this.electricalConductivity,
    this.temperature,
    this.turbidity,
    required this.lastUpdated,
    this.autoIrrigate = false,
  });

  /// Get level percentage (0-100)
  double get levelPercentage => (currentLevel / capacity * 100).clamp(0.0, 100.0);

  /// Check if tank is low (below 20%)
  bool get isLow => levelPercentage < 20;

  /// Check if tank is critical (below 10%)
  bool get isCritical => levelPercentage < 10;

  factory WaterTank.fromJson(Map<String, dynamic> json) {
    return WaterTank(
      id: json['id'] as String,
      capacity: (json['capacity'] as num).toDouble(),
      currentLevel: (json['currentLevel'] as num).toDouble(),
      quality: WaterQuality.values.firstWhere(
        (e) => e.toString().split('.').last == json['quality'],
      ),
      ph: (json['ph'] as num?)?.toDouble(),
      dissolvedOxygen: (json['dissolvedOxygen'] as num?)?.toDouble(),
      nitrate: (json['nitrate'] as num?)?.toDouble(),
      electricalConductivity:
          (json['electricalConductivity'] as num?)?.toDouble(),
      temperature: (json['temperature'] as num?)?.toDouble(),
      turbidity: (json['turbidity'] as num?)?.toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      autoIrrigate: json['autoIrrigate'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'capacity': capacity,
      'currentLevel': currentLevel,
      'quality': quality.toString().split('.').last,
      'ph': ph,
      'dissolvedOxygen': dissolvedOxygen,
      'nitrate': nitrate,
      'electricalConductivity': electricalConductivity,
      'temperature': temperature,
      'turbidity': turbidity,
      'lastUpdated': lastUpdated.toIso8601String(),
      'autoIrrigate': autoIrrigate,
    };
  }

  WaterTank copyWith({
    String? id,
    double? capacity,
    double? currentLevel,
    WaterQuality? quality,
    double? ph,
    double? dissolvedOxygen,
    double? nitrate,
    double? electricalConductivity,
    double? temperature,
    double? turbidity,
    DateTime? lastUpdated,
    bool? autoIrrigate,
  }) {
    return WaterTank(
      id: id ?? this.id,
      capacity: capacity ?? this.capacity,
      currentLevel: currentLevel ?? this.currentLevel,
      quality: quality ?? this.quality,
      ph: ph ?? this.ph,
      dissolvedOxygen: dissolvedOxygen ?? this.dissolvedOxygen,
      nitrate: nitrate ?? this.nitrate,
      electricalConductivity:
          electricalConductivity ?? this.electricalConductivity,
      temperature: temperature ?? this.temperature,
      turbidity: turbidity ?? this.turbidity,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      autoIrrigate: autoIrrigate ?? this.autoIrrigate,
    );
  }

  @override
  List<Object?> get props => [
        id,
        capacity,
        currentLevel,
        quality,
        ph,
        dissolvedOxygen,
        nitrate,
        electricalConductivity,
        temperature,
        turbidity,
        lastUpdated,
        autoIrrigate,
      ];
}
