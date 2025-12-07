import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_shadows.dart';

/// Water quality metrics grid
class WaterQualityGrid extends StatelessWidget {
  final double? ph;
  final double? dissolvedOxygen;
  final double? nitrate;
  final double? electricalConductivity;
  final double? temperature;
  final double? turbidity;

  const WaterQualityGrid({
    super.key,
    this.ph,
    this.dissolvedOxygen,
    this.nitrate,
    this.electricalConductivity,
    this.temperature,
    this.turbidity,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive sizing - adjusted aspect ratio for taller cards
        final width = constraints.maxWidth;
        final spacing = width < 360 ? 8.0 : 12.0;
        final aspectRatio = width < 360 ? 1.0 : 1.15; // Made taller to fit content
        
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: aspectRatio,
      children: [
        _QualityCard(
          label: 'pH',
          value: ph?.toStringAsFixed(1) ?? '--',
          unit: '',
          icon: Icons.science,
          gradient: _getPhGradient(ph),
          isDark: isDark,
        ),
        _QualityCard(
          label: 'Həll olmuş O₂',
          value: dissolvedOxygen?.toStringAsFixed(1) ?? '--',
          unit: 'mg/L',
          icon: Icons.air,
          gradient: _getDoGradient(dissolvedOxygen),
          isDark: isDark,
        ),
        _QualityCard(
          label: 'Nitrat',
          value: nitrate?.toStringAsFixed(1) ?? '--',
          unit: 'mg/L',
          icon: Icons.water_drop,
          gradient: _getNitrateGradient(nitrate),
          isDark: isDark,
        ),
        _QualityCard(
          label: 'EC',
          value: electricalConductivity?.toStringAsFixed(0) ?? '--',
          unit: 'μS/cm',
          icon: Icons.electric_bolt,
          gradient: AppGradients.primaryGradient,
          isDark: isDark,
        ),
        _QualityCard(
          label: 'Temperatur',
          value: temperature?.toStringAsFixed(1) ?? '--',
          unit: '°C',
          icon: Icons.thermostat,
          gradient: _getTempGradient(temperature),
          isDark: isDark,
        ),
        _QualityCard(
          label: 'Bulanıqlıq',
          value: turbidity?.toStringAsFixed(1) ?? '--',
          unit: 'NTU',
          icon: Icons.visibility,
          gradient: _getTurbidityGradient(turbidity),
          isDark: isDark,
        ),
      ],
        );
      },
    );
  }

  Gradient _getPhGradient(double? ph) {
    if (ph == null) return AppGradients.inactiveGradient;
    if (ph < 6.5 || ph > 8.5) return AppGradients.errorGradient;
    if (ph < 7.0 || ph > 8.0) return AppGradients.warningGradient;
    return AppGradients.successGradient;
  }

  Gradient _getDoGradient(double? dissolvedOxygen) {
    if (dissolvedOxygen == null) return AppGradients.inactiveGradient;
    if (dissolvedOxygen < 5.0) return AppGradients.errorGradient;
    if (dissolvedOxygen < 6.0) return AppGradients.warningGradient;
    return AppGradients.successGradient;
  }

  Gradient _getNitrateGradient(double? nitrate) {
    if (nitrate == null) return AppGradients.inactiveGradient;
    if (nitrate > 50.0) return AppGradients.errorGradient;
    if (nitrate > 30.0) return AppGradients.warningGradient;
    return AppGradients.successGradient;
  }

  Gradient _getTempGradient(double? temperature) {
    if (temperature == null) return AppGradients.inactiveGradient;
    if (temperature < 15.0 || temperature > 30.0) return AppGradients.warningGradient;
    return AppGradients.successGradient;
  }

  Gradient _getTurbidityGradient(double? turbidity) {
    if (turbidity == null) return AppGradients.inactiveGradient;
    if (turbidity > 5.0) return AppGradients.errorGradient;
    if (turbidity > 2.0) return AppGradients.warningGradient;
    return AppGradients.successGradient;
  }
}

/// Individual quality metric card
class _QualityCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Gradient gradient;
  final bool isDark;

  const _QualityCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.gradient,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive sizing
        final cardWidth = constraints.maxWidth;
        final padding = cardWidth < 140 ? 8.0 : 16.0;
        final iconPadding = cardWidth < 140 ? 6.0 : 10.0;
        final iconSize = cardWidth < 140 ? 18.0 : 24.0;
        final spacing = cardWidth < 140 ? 4.0 : 8.0;
        final valueSize = cardWidth < 140 ? 14.0 : 20.0;
        final labelSize = cardWidth < 140 ? 9.0 : 12.0;
        final unitSize = cardWidth < 140 ? 8.0 : 11.0;
        
        return Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppShadows.cardShadow,
          ),
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
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: iconSize,
                ),
              ),
              SizedBox(height: spacing),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: labelSize,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 2),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: valueSize,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (unit.isNotEmpty) ...[
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          unit,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: unitSize,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
