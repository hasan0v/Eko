import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';

class SoilAnalysisScreen extends StatelessWidget {
  const SoilAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.soilAnalysis),
      ),
      body: const Center(
        child: Text('Soil Analysis - Coming Soon'),
      ),
    );
  }
}
