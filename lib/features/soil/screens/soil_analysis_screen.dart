import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_animations.dart';
import '../../../core/widgets/modern_widgets.dart';
import '../../../models/soil_analysis.dart';
import 'dart:math' as math;

class SoilAnalysisScreen extends StatefulWidget {
  const SoilAnalysisScreen({super.key});

  @override
  State<SoilAnalysisScreen> createState() => _SoilAnalysisScreenState();
}

class _SoilAnalysisScreenState extends State<SoilAnalysisScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  // Mock data - Replace with BLoC/API data later
  final SoilAnalysis _currentAnalysis = SoilAnalysis(
    id: '1',
    timestamp: DateTime.now(),
    healthScore: 78.5,
    nitrogen: 4.8,
    phosphorus: 9.2,
    potassium: 11.5,
    ph: 6.5,
    moisture: 52.3,
    organicMatter: 3.8,
    temperature: 22.5,
    health: SoilHealth.healthy,
    recommendations: [
      'Torpaq sağlamlığı yaxşıdır',
      'Azot səviyyəsi optimal diapazondan azacıq aşağıdır',
      'Nəmlik səviyyəsi ideal intervalda qalır',
      'Orqanik maddə əlavə etməyə davam edin',
    ],
  );

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 360 ? 12.0 : 20.0;

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text(AppStrings.soilAnalysis),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // TODO: Navigate to soil history
            },
          ),
          IconButton(
            icon: const Icon(Icons.science_outlined),
            onPressed: () {
              // TODO: Navigate to new analysis
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.backgroundGradient,
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            // TODO: Refresh data
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Health Score Card
                AnimatedCard(child: _buildHealthScoreCard()),
                const SizedBox(height: 32),

                // NPK Section
                StaggeredListItem(
                  index: 0,
                  child: const SectionHeader(
                    title: 'NPK Tərkibi',
                    subtitle: 'Əsas qida maddələri',
                  ),
                ),
                const SizedBox(height: 16),
                StaggeredListItem(index: 1, child: _buildNPKSection()),
                const SizedBox(height: 32),

                // Environmental Factors
                StaggeredListItem(
                  index: 2,
                  child: const SectionHeader(
                    title: 'Ətraf Mühit',
                    subtitle: 'pH, nəmlik və temperatur',
                  ),
                ),
                const SizedBox(height: 16),
                StaggeredListItem(
                  index: 3,
                  child: _buildEnvironmentalFactors(),
                ),
                const SizedBox(height: 32),

                // Organic Matter
                StaggeredListItem(index: 4, child: _buildOrganicMatterCard()),
                const SizedBox(height: 32),

                // Recommendations
                StaggeredListItem(
                  index: 5,
                  child: const SectionHeader(
                    title: 'Tövsiyələr',
                    subtitle: 'Torpaq sağlamlığını yaxşılaşdırın',
                  ),
                ),
                const SizedBox(height: 16),
                ..._buildRecommendations(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHealthScoreCard() {
    final healthColor = _getHealthColor(_currentAnalysis.health);
    final healthGradient = _getHealthGradient(_currentAnalysis.health);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: healthGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: healthColor.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Torpaq Sağlamlığı',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Text(
                  _getHealthLabel(_currentAnalysis.health),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.05),
                child: child,
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glow effect
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
                // Progress circle
                SizedBox(
                  width: 140,
                  height: 140,
                  child: CustomPaint(
                    painter: _CircularProgressPainter(
                      progress: _currentAnalysis.healthScore / 100,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Score text
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _currentAnalysis.healthScore.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'XAL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Son Yoxlama: ${_formatTimestamp(_currentAnalysis.timestamp)}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNPKSection() {
    return Row(
      children: [
        Expanded(
          child: _buildNutrientCard(
            'N',
            'Azot',
            _currentAnalysis.nitrogen,
            Icons.science,
            const Color(0xFF42A5F5),
            AppGradients.infoGradient,
            'Optimal: 4.0-6.0%',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildNutrientCard(
            'P',
            'Fosfor',
            _currentAnalysis.phosphorus,
            Icons.water_drop,
            const Color(0xFFAB47BC),
            const LinearGradient(
              colors: [Color(0xFFAB47BC), Color(0xFFBA68C8)],
            ),
            'Optimal: 8.0-10.0%',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildNutrientCard(
            'K',
            'Kalium',
            _currentAnalysis.potassium,
            Icons.bolt,
            const Color(0xFFFFA726),
            AppGradients.warningGradient,
            'Optimal: 10.0-12.0%',
          ),
        ),
      ],
    );
  }

  Widget _buildNutrientCard(
    String symbol,
    String name,
    double value,
    IconData icon,
    Color color,
    Gradient gradient,
    String optimalRange,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            symbol,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(
              color: Color(0xFF6C7278),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${value.toStringAsFixed(1)}%',
            style: const TextStyle(
              color: Color(0xFF1A1D1F),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            optimalRange,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color.withOpacity(0.7),
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentalFactors() {
    return Column(
      children: [
        ModernCard(
          child: Column(
            children: [
              _buildEnvironmentalRow(
                'pH Səviyyəsi',
                _currentAnalysis.ph.toStringAsFixed(1),
                Icons.water_damage,
                _currentAnalysis.isPhOptimal
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFFFFA726),
                _currentAnalysis.ph / 14,
                'Optimal: 6.0-7.0',
              ),
              const Divider(height: 24),
              _buildEnvironmentalRow(
                'Nəmlik',
                '${_currentAnalysis.moisture.toStringAsFixed(1)}%',
                Icons.opacity,
                _currentAnalysis.isMoistureOptimal
                    ? const Color(0xFF42A5F5)
                    : const Color(0xFFFFA726),
                _currentAnalysis.moisture / 100,
                'Optimal: 40-60%',
              ),
              if (_currentAnalysis.temperature != null) ...[
                const Divider(height: 24),
                _buildEnvironmentalRow(
                  'Temperatur',
                  '${_currentAnalysis.temperature!.toStringAsFixed(1)}C',
                  Icons.thermostat,
                  const Color(0xFFEF5350),
                  _currentAnalysis.temperature! / 40,
                  'Optimal: 18-25C',
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnvironmentalRow(
    String label,
    String value,
    IconData icon,
    Color color,
    double progress,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF6C7278),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Color(0xFF1A1D1F),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          hint,
          style: TextStyle(
            color: color.withOpacity(0.7),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildOrganicMatterCard() {
    final organicMatter = _currentAnalysis.organicMatter ?? 0;
    final color =
        organicMatter >= 3.5
            ? const Color(0xFF4CAF50)
            : organicMatter >= 2.0
            ? const Color(0xFFFFA726)
            : const Color(0xFFEF5350);

    return ModernCard(
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.eco, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Orqanik Maddə',
                  style: TextStyle(
                    color: Color(0xFF6C7278),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      organicMatter.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Color(0xFF1A1D1F),
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 4, left: 4),
                      child: Text(
                        '%',
                        style: TextStyle(
                          color: Color(0xFF6C7278),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Optimal: ≥ 3.5%',
                  style: TextStyle(
                    color: color.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRecommendations() {
    return _currentAnalysis.recommendations.asMap().entries.map((entry) {
      final index = entry.key;
      final recommendation = entry.value;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: StaggeredListItem(
          index: 6 + index,
          child: ModernCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: AppGradients.successGradient,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4CAF50).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(Icons.check, color: Colors.white, size: 18),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    recommendation,
                    style: const TextStyle(
                      color: Color(0xFF1A1D1F),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Color _getHealthColor(SoilHealth health) {
    switch (health) {
      case SoilHealth.healthy:
        return const Color(0xFF4CAF50);
      case SoilHealth.moderate:
        return const Color(0xFFFFA726);
      case SoilHealth.unhealthy:
        return const Color(0xFFEF5350);
    }
  }

  Gradient _getHealthGradient(SoilHealth health) {
    switch (health) {
      case SoilHealth.healthy:
        return AppGradients.successGradient;
      case SoilHealth.moderate:
        return AppGradients.warningGradient;
      case SoilHealth.unhealthy:
        return AppGradients.errorGradient;
    }
  }

  String _getHealthLabel(SoilHealth health) {
    switch (health) {
      case SoilHealth.healthy:
        return 'Sağlam';
      case SoilHealth.moderate:
        return 'Orta';
      case SoilHealth.unhealthy:
        return 'Zəif';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} dəqiqə əvvəl';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} saat əvvəl';
    } else {
      return '${difference.inDays} gün əvvəl';
    }
  }
}

/// Custom painter for circular progress indicator
class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CircularProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle
    final bgPaint =
        Paint()
          ..color = color.withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - 5, bgPaint);

    // Progress arc
    final progressPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 5),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
