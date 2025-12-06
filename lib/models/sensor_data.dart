import 'package:equatable/equatable.dart';

/// Sensor data model for real-time monitoring
class SensorData extends Equatable {
  final String id;
  final DateTime timestamp;
  final double? temperature;
  final double? humidity;
  final double? co2Level;
  final double? weight;
  final double? ph;
  final double? moisture;
  final String sensorType; // 'compost', 'water', 'soil'

  const SensorData({
    required this.id,
    required this.timestamp,
    this.temperature,
    this.humidity,
    this.co2Level,
    this.weight,
    this.ph,
    this.moisture,
    required this.sensorType,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      temperature: (json['temperature'] as num?)?.toDouble(),
      humidity: (json['humidity'] as num?)?.toDouble(),
      co2Level: (json['co2Level'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      ph: (json['ph'] as num?)?.toDouble(),
      moisture: (json['moisture'] as num?)?.toDouble(),
      sensorType: json['sensorType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'temperature': temperature,
      'humidity': humidity,
      'co2Level': co2Level,
      'weight': weight,
      'ph': ph,
      'moisture': moisture,
      'sensorType': sensorType,
    };
  }

  @override
  List<Object?> get props => [
        id,
        timestamp,
        temperature,
        humidity,
        co2Level,
        weight,
        ph,
        moisture,
        sensorType,
      ];
}
