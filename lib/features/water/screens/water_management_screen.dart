import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_animations.dart';
import '../../../core/widgets/eco_card.dart';
import '../../../core/widgets/water_tank_widget.dart';
import '../../../core/widgets/water_quality_grid.dart';
import '../../../core/widgets/modern_widgets.dart';
import '../logic/water_bloc.dart';
import '../logic/water_event.dart';
import '../logic/water_state.dart';

/// Water management screen
class WaterManagementScreen extends StatefulWidget {
  const WaterManagementScreen({super.key});

  @override
  State<WaterManagementScreen> createState() => _WaterManagementScreenState();
}

class _WaterManagementScreenState extends State<WaterManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WaterBloc>().add(const WaterLoadTank());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text(AppStrings.waterManagement),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // TODO: Navigate to irrigation history
            },
          ),
          IconButton(
            icon: const Icon(Icons.schedule),
            onPressed: () {
              // TODO: Navigate to irrigation schedule
            },
          ),
        ],
      ),
      body: BlocBuilder<WaterBloc, WaterState>(
        builder: (context, state) {
          if (state is WaterLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WaterError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.failedToLoadWaterData,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<WaterBloc>().add(const WaterRefresh());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text(AppStrings.retry),
                  ),
                ],
              ),
            );
          }

          if (state is WaterTankLoaded) {
            return Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.backgroundGradient,
              ),
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<WaterBloc>().add(const WaterRefresh());
                },
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = MediaQuery.of(context).size.width;
                    final horizontalPadding = screenWidth < 360 ? 12.0 : 20.0;
                    
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 16,
                      ),
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      // Tank display
                      AnimatedCard(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            // Responsive tank size
                            final maxWidth = constraints.maxWidth;
                            final tankSize = maxWidth < 300 ? 160.0 : (maxWidth < 400 ? 180.0 : 200.0);
                            
                            return Center(
                              child: WaterTankWidget(
                                tank: state.tank,
                                size: tankSize,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Auto-irrigation toggle
                      StaggeredListItem(
                        index: 0,
                        child: ModernCard(
                          child: SwitchListTile(
                            title: Text(
                              AppStrings.autoIrrigation,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1D1F),
                              ),
                            ),
                            subtitle: Text(
                              AppStrings.autoWaterBasedOnSchedule,
                              style: const TextStyle(
                                color: Color(0xFF6C7278),
                              ),
                            ),
                            value: state.autoIrrigationEnabled,
                            onChanged: (value) {
                              context.read<WaterBloc>().add(WaterToggleAuto(value));
                            },
                            activeColor: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Manual irrigation button
                      StaggeredListItem(
                        index: 1,
                        child: ModernCard(
                          onTap: () => _showManualIrrigationDialog(),
                          child: Row(
                            children: [
                              const GradientIcon(
                                icon: Icons.play_circle_outline,
                                gradient: AppGradients.infoGradient,
                                size: 28,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      AppStrings.startManualIrrigation,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Color(0xFF1A1D1F),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      AppStrings.waterImmediately,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: Color(0xFF6C7278)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Water quality section
                      StaggeredListItem(
                        index: 2,
                        child: const SectionHeader(
                          title: AppStrings.waterQuality,
                        ),
                      ),
                      const SizedBox(height: 16),
                    WaterQualityGrid(
                      ph: state.tank.ph,
                      dissolvedOxygen: state.tank.dissolvedOxygen,
                      nitrate: state.tank.nitrate,
                      electricalConductivity: state.tank.electricalConductivity,
                      temperature: state.tank.temperature,
                      turbidity: state.tank.turbidity,
                    ),
                    const SizedBox(height: 24),

                    // Quick stats
                    Text(
                      AppStrings.quickStats,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: EcoCard(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.water_drop,
                                    color: Colors.blue,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    AppStrings.today,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: isDark
                                              ? AppColors.textSecondaryDark
                                              : AppColors.textSecondaryLight,
                                        ),
                                  ),
                                  Text(
                                    '45.2L',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: EcoCard(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.eco,
                                    color: Colors.green,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    AppStrings.saved,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: isDark
                                              ? AppColors.textSecondaryDark
                                              : AppColors.textSecondaryLight,
                                        ),
                                  ),
                                  Text(
                                    '13.5L',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Show manual irrigation dialog
  void _showManualIrrigationDialog() {
    final durationController = TextEditingController(text: '15');
    final zoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.startManualIrrigation),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: AppStrings.durationMinutes,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: zoneController,
              decoration: const InputDecoration(
                labelText: AppStrings.zoneOptional,
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final duration = int.tryParse(durationController.text);
              if (duration != null && duration > 0) {
                context.read<WaterBloc>().add(
                      WaterStartManualIrrigation(
                        duration: duration,
                        zone: zoneController.text.isEmpty
                            ? null
                            : zoneController.text,
                      ),
                    );
                Navigator.pop(dialogContext);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Irrigation started for $duration minutes'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text(AppStrings.start),
          ),
        ],
      ),
    );
  }
}
