import 'package:flutter/material.dart';
import '../../models/sensor_data.dart';
import '../constants/app_colors.dart';
import 'eco_card.dart';

/// Grid widget for displaying sensor data
class SensorGrid extends StatelessWidget {
  final SensorData? sensorData;
  final bool isLoading;

  const SensorGrid({
    super.key,
    this.sensorData,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (sensorData == null) {
      return const Center(
        child: Text('No sensor data available'),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _SensorCard(
          icon: Icons.thermostat,
          label: 'Temperature',
          value: '${sensorData!.temperature?.toStringAsFixed(1) ?? '--'}°C',
          color: AppColors.error,
        ),
        _SensorCard(
          icon: Icons.water_drop,
          label: 'Humidity',
          value: '${sensorData!.humidity?.toStringAsFixed(1) ?? '--'}%',
          color: AppColors.info,
        ),
        _SensorCard(
          icon: Icons.cloud,
          label: 'CO₂ Level',
          value: '${sensorData!.co2Level?.toStringAsFixed(0) ?? '--'} ppm',
          color: AppColors.warning,
        ),
        _SensorCard(
          icon: Icons.scale,
          label: 'Weight',
          value: '${sensorData!.weight?.toStringAsFixed(1) ?? '--'} kg',
          color: AppColors.primary,
        ),
      ],
    );
  }
}

class _SensorCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SensorCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return EcoCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
