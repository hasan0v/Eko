import 'package:equatable/equatable.dart';

/// Weather data model
class WeatherData extends Equatable {
  final String location;
  final DateTime timestamp;
  final double temperature; // °C
  final double feelsLike; // °C
  final String condition; // 'sunny', 'cloudy', 'rainy', etc.
  final int humidity; // percentage
  final double windSpeed; // km/h
  final double? rainfall; // mm
  final int uvIndex;
  final List<WeatherForecast> forecast;

  const WeatherData({
    required this.location,
    required this.timestamp,
    required this.temperature,
    required this.feelsLike,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    this.rainfall,
    required this.uvIndex,
    this.forecast = const [],
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      location: json['location'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      temperature: (json['temperature'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      condition: json['condition'] as String,
      humidity: json['humidity'] as int,
      windSpeed: (json['windSpeed'] as num).toDouble(),
      rainfall: (json['rainfall'] as num?)?.toDouble(),
      uvIndex: json['uvIndex'] as int,
      forecast: (json['forecast'] as List?)
              ?.map((e) => WeatherForecast.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'timestamp': timestamp.toIso8601String(),
      'temperature': temperature,
      'feelsLike': feelsLike,
      'condition': condition,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'rainfall': rainfall,
      'uvIndex': uvIndex,
      'forecast': forecast.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        location,
        timestamp,
        temperature,
        feelsLike,
        condition,
        humidity,
        windSpeed,
        rainfall,
        uvIndex,
        forecast,
      ];
}

/// Weather forecast for a specific day
class WeatherForecast extends Equatable {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final String condition;
  final int chanceOfRain; // percentage

  const WeatherForecast({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.condition,
    required this.chanceOfRain,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      date: DateTime.parse(json['date'] as String),
      minTemp: (json['minTemp'] as num).toDouble(),
      maxTemp: (json['maxTemp'] as num).toDouble(),
      condition: json['condition'] as String,
      chanceOfRain: json['chanceOfRain'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'minTemp': minTemp,
      'maxTemp': maxTemp,
      'condition': condition,
      'chanceOfRain': chanceOfRain,
    };
  }

  @override
  List<Object?> get props => [date, minTemp, maxTemp, condition, chanceOfRain];
}
