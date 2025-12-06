import 'package:flutter/material.dart';
import '../../models/compost_batch.dart';
import '../constants/app_colors.dart';

/// Status badge for compost batches
class BatchStatusBadge extends StatelessWidget {
  final CompostStatus status;
  final bool showIcon;

  const BatchStatusBadge({
    super.key,
    required this.status,
    this.showIcon = true,
  });

  Color get _color {
    switch (status) {
      case CompostStatus.active:
        return AppColors.warning;
      case CompostStatus.curing:
        return AppColors.info;
      case CompostStatus.ready:
        return AppColors.primary;
      case CompostStatus.harvested:
        return AppColors.textSecondaryLight;
    }
  }

  IconData get _icon {
    switch (status) {
      case CompostStatus.active:
        return Icons.trending_up;
      case CompostStatus.curing:
        return Icons.hourglass_bottom;
      case CompostStatus.ready:
        return Icons.check_circle;
      case CompostStatus.harvested:
        return Icons.inventory_2;
    }
  }

  String get _label {
    switch (status) {
      case CompostStatus.active:
        return 'Active';
      case CompostStatus.curing:
        return 'Curing';
      case CompostStatus.ready:
        return 'Ready';
      case CompostStatus.harvested:
        return 'Harvested';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(_icon, size: 16, color: _color),
            const SizedBox(width: 4),
          ],
          Text(
            _label,
            style: TextStyle(
              color: _color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
