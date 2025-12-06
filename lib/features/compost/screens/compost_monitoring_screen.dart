import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/eco_card.dart';
import '../../../core/widgets/circular_progress.dart';
import '../../../core/widgets/sensor_grid.dart';
import '../../../core/widgets/batch_status_badge.dart';
import '../logic/compost_bloc.dart';
import '../logic/compost_event.dart';
import '../logic/compost_state.dart';
import '../../../models/compost_batch.dart';

class CompostMonitoringScreen extends StatefulWidget {
  const CompostMonitoringScreen({super.key});

  @override
  State<CompostMonitoringScreen> createState() => _CompostMonitoringScreenState();
}

class _CompostMonitoringScreenState extends State<CompostMonitoringScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CompostBloc>().add(const CompostLoadBatches());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compost Monitoring'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateBatchDialog,
          ),
        ],
      ),
      body: BlocBuilder<CompostBloc, CompostState>(
        builder: (context, state) {
          if (state is CompostLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CompostError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<CompostBloc>().add(const CompostRefresh());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is CompostLoaded) {
            if (state.batches.isEmpty) {
              return _buildEmptyState();
            }

            final activeBatch = state.selectedBatch ?? 
                state.batches.firstWhere(
                  (b) => b.status == CompostStatus.active,
                  orElse: () => state.batches.first,
                );

            return RefreshIndicator(
              onRefresh: () async {
                context.read<CompostBloc>().add(const CompostRefresh());
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircularProgress(
                        progress: activeBatch.progress / 100,
                        label: activeBatch.batchNumber,
                        subtitle: '${activeBatch.durationDays} days',
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildBatchInfo(activeBatch),
                    const SizedBox(height: 24),
                    Text(
                      'Real-time Sensors',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    SensorGrid(sensorData: activeBatch.latestReading),
                  ],
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildBatchInfo(CompostBatch batch) {
    return EcoCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Status'),
              BatchStatusBadge(status: batch.status),
            ],
          ),
          const Divider(height: 24),
          _buildInfoRow('Initial Weight', '${batch.initialWeight.toStringAsFixed(1)} kg'),
          const SizedBox(height: 12),
          _buildInfoRow('Current Weight', '${(batch.currentWeight ?? batch.initialWeight).toStringAsFixed(1)} kg'),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Reduction',
            '${(batch.weightReduction ?? 0.0).toStringAsFixed(1)}%',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.compost, size: 80, color: AppColors.textSecondaryLight),
          const SizedBox(height: 16),
          const Text('No Compost Batches'),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showCreateBatchDialog,
            icon: const Icon(Icons.add),
            label: const Text('Create Batch'),
          ),
        ],
      ),
    );
  }

  void _showCreateBatchDialog() {
    final nameController = TextEditingController();
    final weightController = TextEditingController();
    final locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Create New Batch'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Batch Name',
                hintText: 'BATCH-2025-001',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Initial Weight (kg)',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  weightController.text.isNotEmpty) {
                context.read<CompostBloc>().add(
                      CompostCreateBatch(
                        name: nameController.text,
                        initialWeight: double.parse(weightController.text),
                        location: locationController.text,
                      ),
                    );
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
