import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../constants/app_colors.dart';

/// Circular progress indicator for compost batch progress
class CircularProgress extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String label;
  final String? subtitle;
  final double radius;
  final double lineWidth;
  final Color? progressColor;
  final Color? backgroundColor;
  final Widget? center;

  const CircularProgress({
    super.key,
    required this.progress,
    required this.label,
    this.subtitle,
    this.radius = 80,
    this.lineWidth = 12,
    this.progressColor,
    this.backgroundColor,
    this.center,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularPercentIndicator(
          radius: radius,
          lineWidth: lineWidth,
          percent: progress.clamp(0.0, 1.0),
          center: center ?? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: progressColor ?? AppColors.primary,
                    ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                ),
              ],
            ],
          ),
          progressColor: progressColor ?? AppColors.primary,
          backgroundColor: backgroundColor ?? 
              (isDark ? AppColors.textSecondaryDark.withOpacity(0.2) : AppColors.backgroundLight),
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
          animationDuration: 1000,
        ),
        const SizedBox(height: 16),
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
