import 'package:flutter/material.dart';
import '../../models/sensor_data.dart';
import '../constants/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/app_shadows.dart';
import 'eco_card.dart';

/// Grid widget for displaying sensor data
class SensorGrid extends StatelessWidget {
  final SensorData? sensorData;
  final bool isLoading;

  const SensorGrid({super.key, this.sensorData, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (sensorData == null) {
      return const Center(child: Text('No sensor data available'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive aspect ratio based on available width
        final width = constraints.maxWidth;
        final spacing = width < 360 ? 8.0 : 12.0;
        final aspectRatio = width < 360 ? 1.0 : 1.1;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: aspectRatio,
          children: [
            _SensorCard(
              icon: Icons.thermostat,
              label: 'Temperatur',
              value: '${sensorData!.temperature?.toStringAsFixed(1) ?? '--'}C',
              gradient: AppGradients.errorGradient,
            ),
            _SensorCard(
              icon: Icons.water_drop,
              label: 'Nəmlik',
              value: '${sensorData!.humidity?.toStringAsFixed(1) ?? '--'}%',
              gradient: AppGradients.infoGradient,
            ),
            _SensorCard(
              icon: Icons.cloud,
              label: 'CO2 Səviyyəsi',
              value: '${sensorData!.co2Level?.toStringAsFixed(0) ?? '--'} ppm',
              gradient: AppGradients.warningGradient,
            ),
            _SensorCard(
              icon: Icons.scale,
              label: 'Çəki',
              value: '${sensorData!.weight?.toStringAsFixed(1) ?? '--'} kg',
              gradient: AppGradients.successGradient,
            ),
          ],
        );
      },
    );
  }
}

class _SensorCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Gradient gradient;

  const _SensorCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive sizing based on card width
        final cardWidth = constraints.maxWidth;
        final padding = cardWidth < 140 ? 10.0 : 16.0;
        final iconPadding = cardWidth < 140 ? 8.0 : 12.0;
        final iconSize = cardWidth < 140 ? 22.0 : 28.0;
        final spacing = cardWidth < 140 ? 8.0 : 12.0;
        final fontSize = cardWidth < 140 ? 16.0 : 18.0;

        return Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppShadows.cardShadow,
          ),
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(iconPadding),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: iconSize),
              ),
              SizedBox(height: spacing),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.visible,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
