import 'package:flutter/material.dart';

/// Video lesson model
class LessonModel {
  final String title;
  final String videoUrl;
  final String thumbnailUrl;
  final LessonLevel level;
  final IconData icon;

  const LessonModel({
    required this.title,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.level,
    required this.icon,
  });

  /// Extract YouTube video ID from URL
  String get videoId {
    final uri = Uri.parse(videoUrl);
    return uri.queryParameters['v'] ?? '';
  }

  /// Generate thumbnail URL from YouTube video ID
  String get thumbnail => 'https://img.youtube.com/vi/$videoId/mqdefault.jpg';
}

/// Lesson difficulty levels
enum LessonLevel {
  beginner,
  basic,
  intermediate,
  advanced,
  expert;

  String get title {
    switch (this) {
      case LessonLevel.beginner:
        return 'Səviyyə 1: Tam Başlanğıc';
      case LessonLevel.basic:
        return 'Səviyyə 2: Başlanğıc';
      case LessonLevel.intermediate:
        return 'Səviyyə 3: Orta';
      case LessonLevel.advanced:
        return 'Səviyyə 4: Qabaqcıl';
      case LessonLevel.expert:
        return 'Səviyyə 5: Ekspert';
    }
  }

  String get subtitle {
    switch (this) {
      case LessonLevel.beginner:
        return 'Əsasları Başa Düşmək';
      case LessonLevel.basic:
        return 'Əsas Suvarma və Torpaq Sağlamlığı';
      case LessonLevel.intermediate:
        return 'Praktik Quraşdırma və İdarəetmə';
      case LessonLevel.advanced:
        return 'Texnologiya və Dəqiq Kənd Təsərrüfatı';
      case LessonLevel.expert:
        return 'Qabaqcıl Sistemlər və Üsullar';
    }
  }

  Color get color {
    switch (this) {
      case LessonLevel.beginner:
        return const Color(0xFF4CAF50); // Green
      case LessonLevel.basic:
        return const Color(0xFF2196F3); // Blue
      case LessonLevel.intermediate:
        return const Color(0xFFFF9800); // Orange
      case LessonLevel.advanced:
        return const Color(0xFF9C27B0); // Purple
      case LessonLevel.expert:
        return const Color(0xFFE91E63); // Pink
    }
  }

  IconData get icon {
    switch (this) {
      case LessonLevel.beginner:
        return Icons.play_circle_outline;
      case LessonLevel.basic:
        return Icons.water_drop_outlined;
      case LessonLevel.intermediate:
        return Icons.build_outlined;
      case LessonLevel.advanced:
        return Icons.precision_manufacturing_outlined;
      case LessonLevel.expert:
        return Icons.psychology_outlined;
    }
  }
}
