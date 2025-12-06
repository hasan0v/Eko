import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';

class EducationCenterScreen extends StatelessWidget {
  const EducationCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.educationCenter),
      ),
      body: const Center(
        child: Text('Education Center - Coming Soon'),
      ),
    );
  }
}
