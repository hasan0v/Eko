import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../models/water_tank.dart';
import 'dart:math' as math;

/// Animated water tank level indicator
class WaterTankWidget extends StatefulWidget {
  final WaterTank tank;
  final double size;
  final VoidCallback? onTap;

  const WaterTankWidget({
    super.key,
    required this.tank,
    this.size = 200,
    this.onTap,
  });

  @override
  State<WaterTankWidget> createState() => _WaterTankWidgetState();
}

class _WaterTankWidgetState extends State<WaterTankWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _waveAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final levelPercent = (widget.tank.currentLevel / widget.tank.capacity) * 100;
    
    Gradient waterGradient;
    if (levelPercent < 20) {
      waterGradient = AppGradients.errorGradient;
    } else if (levelPercent < 50) {
      waterGradient = AppGradients.warningGradient;
    } else {
      waterGradient = AppGradients.infoGradient;
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: widget.size,
        height: widget.size * 1.2,
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: _getQualityColor(widget.tank.quality).withOpacity(0.15),
              blurRadius: 32,
              offset: const Offset(0, 12),
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Stack(
          children: [
            // Animated background glow
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2,
                    colors: [
                      _getQualityColor(widget.tank.quality).withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Tank outline with waves
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: AnimatedBuilder(
                animation: _waveAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(widget.size - 40, (widget.size * 1.2) - 40),
                    painter: _TankPainter(
                      levelPercent: levelPercent,
                      waterGradient: waterGradient,
                      isDark: isDark,
                      wavePhase: _waveAnimation.value,
                    ),
                  );
                },
              ),
            ),
            // Tank info with animations
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    widget.tank.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF1A1D1F),
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    tween: Tween(begin: 0, end: levelPercent),
                    builder: (context, value, child) {
                      return Text(
                        '${value.toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontSize: 36,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.tank.currentLevel.toStringAsFixed(0)}L / ${widget.tank.capacity.toStringAsFixed(0)}L',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 6,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Quality badge with pulse animation
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeInOut,
                  tween: Tween(begin: 0.95, end: 1.0),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: _getQualityGradient(widget.tank.quality),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: _getQualityColor(widget.tank.quality).withOpacity(0.5),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.water_drop,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _getQualityLabel(widget.tank.quality),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Gradient _getQualityGradient(WaterQuality quality) {
    switch (quality) {
      case WaterQuality.excellent:
        return AppGradients.successGradient;
      case WaterQuality.good:
        return AppGradients.infoGradient;
      case WaterQuality.fair:
        return AppGradients.warningGradient;
      case WaterQuality.poor:
        return AppGradients.errorGradient;
    }
  }

  Color _getQualityColor(WaterQuality quality) {
    switch (quality) {
      case WaterQuality.excellent:
        return Colors.green;
      case WaterQuality.good:
        return Colors.blue;
      case WaterQuality.fair:
        return Colors.orange;
      case WaterQuality.poor:
        return Colors.red;
    }
  }

  String _getQualityLabel(WaterQuality quality) {
    switch (quality) {
      case WaterQuality.excellent:
        return 'Excellent';
      case WaterQuality.good:
        return 'Good';
      case WaterQuality.fair:
        return 'Fair';
      case WaterQuality.poor:
        return 'Poor';
    }
  }
}

/// Custom painter for tank shape and water level with waves
class _TankPainter extends CustomPainter {
  final double levelPercent;
  final Gradient waterGradient;
  final bool isDark;
  final double wavePhase;

  _TankPainter({
    required this.levelPercent,
    required this.waterGradient,
    required this.isDark,
    required this.wavePhase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw tank outline (trapezoid shape)
    final outlinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = isDark 
          ? Colors.white.withOpacity(0.3) 
          : const Color(0xFF1A1D1F).withOpacity(0.2);

    final path = Path()
      ..moveTo(size.width * 0.3, 0)
      ..lineTo(size.width * 0.7, 0)
      ..lineTo(size.width * 0.9, size.height)
      ..lineTo(size.width * 0.1, size.height)
      ..close();

    canvas.drawPath(path, outlinePaint);

    // Draw water fill with animated waves
    final waterLevel = size.height - (size.height * (levelPercent / 100));
    
    final waterPath = Path();
    
    // Create wave effect at water surface
    final waveHeight = 4.0;
    final waveCount = 2;
    final leftX = size.width * 0.1 + (size.width * 0.2 * (waterLevel / size.height));
    final rightX = size.width * 0.9 - (size.width * 0.2 * (waterLevel / size.height));
    
    waterPath.moveTo(leftX, waterLevel);
    
    // Draw waves
    for (double x = leftX; x <= rightX; x += 1) {
      final normalizedX = (x - leftX) / (rightX - leftX);
      final wave = math.sin((normalizedX * waveCount * 2 * math.pi) + wavePhase) * waveHeight;
      waterPath.lineTo(x, waterLevel + wave);
    }
    
    waterPath.lineTo(rightX, waterLevel);
    waterPath.lineTo(size.width * 0.9, size.height);
    waterPath.lineTo(size.width * 0.1, size.height);
    waterPath.close();

    final waterPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = waterGradient.createShader(
        Rect.fromLTWH(0, waterLevel, size.width, size.height - waterLevel),
      );

    canvas.drawPath(waterPath, waterPaint);
    
    // Add shimmer effect on water surface with wave
    final shimmerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = Colors.white.withOpacity(0.6);
    
    final shimmerPath = Path();
    shimmerPath.moveTo(leftX, waterLevel);
    
    for (double x = leftX; x <= rightX; x += 2) {
      final normalizedX = (x - leftX) / (rightX - leftX);
      final wave = math.sin((normalizedX * waveCount * 2 * math.pi) + wavePhase) * waveHeight;
      shimmerPath.lineTo(x, waterLevel + wave);
    }
    
    canvas.drawPath(shimmerPath, shimmerPaint);
    
    // Add bubbles effect for deeper water
    if (levelPercent > 30) {
      final bubblePaint = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.fill;
      
      // Draw some animated bubbles
      for (int i = 0; i < 5; i++) {
        final bubbleY = waterLevel + ((size.height - waterLevel) * 0.3) + 
                        (math.sin(wavePhase + i) * 20);
        final bubbleX = leftX + ((rightX - leftX) * (i / 5));
        final bubbleSize = 3.0 + (math.sin(wavePhase * 2 + i) * 2);
        
        canvas.drawCircle(
          Offset(bubbleX, bubbleY),
          bubbleSize,
          bubblePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_TankPainter oldDelegate) {
    return oldDelegate.levelPercent != levelPercent ||
        oldDelegate.waterGradient != waterGradient ||
        oldDelegate.isDark != isDark ||
        oldDelegate.wavePhase != wavePhase;
  }
}
