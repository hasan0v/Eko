import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';

class WaterManagementScreen extends StatelessWidget {
  const WaterManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.waterManagement),
      ),
      body: const Center(
        child: Text('Water Management - Coming Soon'),
      ),
    );
  }
}
