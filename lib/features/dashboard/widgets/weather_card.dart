import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum WeatherCondition { sunny, cloudy, rainy, snowy, partlyCloudy }

class WeatherCard extends StatefulWidget {
  final double temperature;
  final WeatherCondition condition;

  const WeatherCard({
    super.key,
    this.temperature = 24,
    this.condition = WeatherCondition.sunny,
  });

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard>
    with TickerProviderStateMixin {
  late AnimationController _primaryController;
  late AnimationController _secondaryController;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _primaryController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
    _secondaryController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _secondaryController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  LinearGradient get _gradient {
    switch (widget.condition) {
      case WeatherCondition.sunny:
        return const LinearGradient(
          colors: [Color(0xFFFF9500), Color(0xFFFFB347), Color(0xFFFFCC33)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case WeatherCondition.cloudy:
        return const LinearGradient(
          colors: [Color(0xFF8E9EAB), Color(0xFFB8C6D0), Color(0xFF95A5B1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case WeatherCondition.rainy:
        return const LinearGradient(
          colors: [Color(0xFF4B6CB7), Color(0xFF6190E8), Color(0xFF5A7FBF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case WeatherCondition.snowy:
        return const LinearGradient(
          colors: [Color(0xFF83A4D4), Color(0xFFB6FBFF), Color(0xFF9DC4E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case WeatherCondition.partlyCloudy:
        return const LinearGradient(
          colors: [Color(0xFFE8A838), Color(0xFFC4B59D), Color(0xFF9EB8C4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  String get _conditionText {
    switch (widget.condition) {
      case WeatherCondition.sunny:
        return 'Günəşli';
      case WeatherCondition.cloudy:
        return 'Buludlu';
      case WeatherCondition.rainy:
        return 'Yağışlı';
      case WeatherCondition.snowy:
        return 'Qarlı';
      case WeatherCondition.partlyCloudy:
        return 'Hissəvi buludlu';
    }
  }

  IconData get _conditionIcon {
    switch (widget.condition) {
      case WeatherCondition.sunny:
        return Icons.wb_sunny_rounded;
      case WeatherCondition.cloudy:
        return Icons.cloud_rounded;
      case WeatherCondition.rainy:
        return Icons.grain_rounded;
      case WeatherCondition.snowy:
        return Icons.ac_unit_rounded;
      case WeatherCondition.partlyCloudy:
        return Icons.cloud_queue_rounded;
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    const months = [
      'Yanvar',
      'Fevral',
      'Mart',
      'Aprel',
      'May',
      'İyun',
      'İyul',
      'Avqust',
      'Sentyabr',
      'Oktyabr',
      'Noyabr',
      'Dekabr',
    ];
    const weekdays = [
      'Bazar ertəsi',
      'Çərşənbə axşamı',
      'Çərşənbə',
      'Cümə axşamı',
      'Cümə',
      'Şənbə',
      'Bazar',
    ];
    return '${now.day} ${months[now.month - 1]}, ${weekdays[now.weekday - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: _gradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: _gradient.colors.first.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: _gradient.colors.last.withOpacity(0.2),
            blurRadius: 40,
            offset: const Offset(0, 16),
            spreadRadius: -4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Animated background particles
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _primaryController,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _WeatherParticlePainter(
                      condition: widget.condition,
                      progress: _primaryController.value,
                      secondaryProgress: _secondaryController.value,
                    ),
                  );
                },
              ),
            ),
            // Decorative circles
            Positioned(
              top: -30,
              right: -20,
              child: AnimatedBuilder(
                animation: _secondaryController,
                builder: (context, _) {
                  return Transform.scale(
                    scale: 1.0 + _secondaryController.value * 0.08,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: -40,
              left: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  // Animated weather icon
                  _buildAnimatedIcon(),
                  const SizedBox(width: 20),
                  // Temperature & Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Temperature row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.temperature.round()}',
                              style: const TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.0,
                                letterSpacing: -2,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                '°C',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white70,
                                  height: 1.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Condition text
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _conditionText,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Date row
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                _getFormattedDate(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withOpacity(0.85),
                                  letterSpacing: 0.2,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return SizedBox(
      width: 90,
      height: 90,
      child: AnimatedBuilder(
        animation: _primaryController,
        builder: (context, child) {
          return CustomPaint(
            painter: _WeatherIconPainter(
              condition: widget.condition,
              progress: _primaryController.value,
              pulseProgress: _secondaryController.value,
            ),
            child: Center(
              child: Transform.scale(
                scale: 1.0 + sin(_secondaryController.value * pi) * 0.05,
                child: Icon(_conditionIcon, size: 44, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Animated background particles
class _WeatherParticlePainter extends CustomPainter {
  final WeatherCondition condition;
  final double progress;
  final double secondaryProgress;

  _WeatherParticlePainter({
    required this.condition,
    required this.progress,
    required this.secondaryProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    switch (condition) {
      case WeatherCondition.sunny:
        _drawSunParticles(canvas, size);
        break;
      case WeatherCondition.rainy:
        _drawRainDrops(canvas, size);
        break;
      case WeatherCondition.snowy:
        _drawSnowflakes(canvas, size);
        break;
      case WeatherCondition.cloudy:
      case WeatherCondition.partlyCloudy:
        _drawCloudParticles(canvas, size);
        break;
    }
  }

  void _drawSunParticles(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.06)
          ..style = PaintingStyle.fill;

    final rng = Random(42);
    for (int i = 0; i < 6; i++) {
      final baseX = rng.nextDouble() * size.width;
      final baseY = rng.nextDouble() * size.height;
      final radius = 2.0 + rng.nextDouble() * 4;
      final offset = sin((progress + i * 0.15) * 2 * pi) * 12;
      canvas.drawCircle(
        Offset(baseX + offset, baseY),
        radius + secondaryProgress * 2,
        paint,
      );
    }
  }

  void _drawRainDrops(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.15)
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round;

    final rng = Random(42);
    for (int i = 0; i < 12; i++) {
      final x = rng.nextDouble() * size.width;
      final speed = 0.6 + rng.nextDouble() * 0.4;
      final y = ((progress * speed + i * 0.08) % 1.0) * (size.height + 20) - 10;
      final length = 8.0 + rng.nextDouble() * 12;
      canvas.drawLine(Offset(x, y), Offset(x - 2, y + length), paint);
    }
  }

  void _drawSnowflakes(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.2)
          ..style = PaintingStyle.fill;

    final rng = Random(42);
    for (int i = 0; i < 10; i++) {
      final baseX = rng.nextDouble() * size.width;
      final speed = 0.4 + rng.nextDouble() * 0.3;
      final y = ((progress * speed + i * 0.1) % 1.0) * (size.height + 20) - 10;
      final wobble = sin((progress + i * 0.2) * 2 * pi) * 15;
      final radius = 1.5 + rng.nextDouble() * 2.5;
      canvas.drawCircle(Offset(baseX + wobble, y), radius, paint);
    }
  }

  void _drawCloudParticles(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.05)
          ..style = PaintingStyle.fill;

    for (int i = 0; i < 3; i++) {
      final xOffset = sin((progress + i * 0.33) * 2 * pi) * 20;
      final y = size.height * (0.2 + i * 0.3);
      final rx = 40.0 + i * 10;
      final ry = 16.0 + i * 4;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(size.width * (0.3 + i * 0.25) + xOffset, y),
          width: rx,
          height: ry,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WeatherParticlePainter oldDelegate) =>
      progress != oldDelegate.progress ||
      secondaryProgress != oldDelegate.secondaryProgress;
}

// Animated glow/ring around the weather icon
class _WeatherIconPainter extends CustomPainter {
  final WeatherCondition condition;
  final double progress;
  final double pulseProgress;

  _WeatherIconPainter({
    required this.condition,
    required this.progress,
    required this.pulseProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Pulsing glow
    final glowPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.08 + pulseProgress * 0.06)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, glowPaint);

    // Inner ring
    final innerGlow =
        Paint()
          ..color = Colors.white.withOpacity(0.12 + pulseProgress * 0.05)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.72, innerGlow);

    if (condition == WeatherCondition.sunny ||
        condition == WeatherCondition.partlyCloudy) {
      _drawSunRays(canvas, center, radius);
    }
  }

  void _drawSunRays(Canvas canvas, Offset center, double radius) {
    final rayPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.12)
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * pi + progress * 2 * pi;
      final innerR = radius * 0.55;
      final outerR = radius * 0.88;
      canvas.drawLine(
        Offset(
          center.dx + cos(angle) * innerR,
          center.dy + sin(angle) * innerR,
        ),
        Offset(
          center.dx + cos(angle) * outerR,
          center.dy + sin(angle) * outerR,
        ),
        rayPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WeatherIconPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      pulseProgress != oldDelegate.pulseProgress;
}
