import '../models/lesson_model.dart';
import 'package:flutter/material.dart';

/// Repository for education lessons
class LessonRepository {
  /// Get all lessons organized by level
  static Map<LessonLevel, List<LessonModel>> getAllLessons() {
    return {
      LessonLevel.beginner: _getBeginnerLessons(),
      LessonLevel.basic: _getBasicLessons(),
      LessonLevel.intermediate: _getIntermediateLessons(),
      LessonLevel.advanced: _getAdvancedLessons(),
      LessonLevel.expert: _getExpertLessons(),
    };
  }

  static List<LessonModel> _getBeginnerLessons() {
    return [
      const LessonModel(
        title: 'Kənd Təsərrüfatına Giriş - Əsas Konsepsiyalar',
        videoUrl: 'https://www.youtube.com/watch?v=ICv9o3dexrc',
        thumbnailUrl: '',
        level: LessonLevel.beginner,
        icon: Icons.agriculture,
      ),
      const LessonModel(
        title: 'Torpaq Əsasları: Torpaq Profilləri',
        videoUrl: 'https://www.youtube.com/watch?v=xoTd7ctj-e0',
        thumbnailUrl: '',
        level: LessonLevel.beginner,
        icon: Icons.layers,
      ),
      const LessonModel(
        title: 'Torpaq Sağlamlığını Anlamaq | Sağlam Torpaq - Sağlam Planet Hissə 1',
        videoUrl: 'https://www.youtube.com/watch?v=7slM-rdtSsQ',
        thumbnailUrl: '',
        level: LessonLevel.beginner,
        icon: Icons.eco,
      ),
    ];
  }

  static List<LessonModel> _getBasicLessons() {
    return [
      const LessonModel(
        title: 'Başlanğıc üçün Suvarma 101 Bələdçisi',
        videoUrl: 'https://www.youtube.com/watch?v=hwHPg_b8KQc',
        thumbnailUrl: '',
        level: LessonLevel.basic,
        icon: Icons.water,
      ),
      const LessonModel(
        title: 'Səpələyici Sistemin Anatomiyası',
        videoUrl: 'https://www.youtube.com/watch?v=lbaJRLGW-Xo',
        thumbnailUrl: '',
        level: LessonLevel.basic,
        icon: Icons.shower,
      ),
      const LessonModel(
        title: 'Suvarma Sistemi Necə İşləyir',
        videoUrl: 'https://www.youtube.com/watch?v=UADXcEJTcso',
        thumbnailUrl: '',
        level: LessonLevel.basic,
        icon: Icons.settings_input_component,
      ),
      const LessonModel(
        title: 'Torpaq Məktəbi: Sağlam torpağı nə yaradır?',
        videoUrl: 'https://www.youtube.com/watch?v=ofmWHWimdFM',
        thumbnailUrl: '',
        level: LessonLevel.basic,
        icon: Icons.school,
      ),
    ];
  }

  static List<LessonModel> _getIntermediateLessons() {
    return [
      const LessonModel(
        title: 'DIY Damcı Suvarma: Başlanğıc üçün Ən Asan Bələdçi',
        videoUrl: 'https://www.youtube.com/watch?v=SqPf4B9oD4U',
        thumbnailUrl: '',
        level: LessonLevel.intermediate,
        icon: Icons.build_circle,
      ),
      const LessonModel(
        title: 'Tərəvəz Bağında Damcı Suvarma Quraşdırılması',
        videoUrl: 'https://www.youtube.com/watch?v=MQNdGFI9wiQ',
        thumbnailUrl: '',
        level: LessonLevel.intermediate,
        icon: Icons.grass,
      ),
      const LessonModel(
        title: 'Əla Torpaq Necə Yaradılır - Dr. Elaine Ingham ilə Torpaq Elmi Masterclass',
        videoUrl: 'https://www.youtube.com/watch?v=ErMHR6Mc4Bk',
        thumbnailUrl: '',
        level: LessonLevel.intermediate,
        icon: Icons.science,
      ),
      const LessonModel(
        title: 'Torpaq Sağlamlığı üçün Örtük Bitkiləri | Şumsuz və Az Şumlu Strategiyalar',
        videoUrl: 'https://www.youtube.com/watch?v=XQMJK9UYOF4',
        thumbnailUrl: '',
        level: LessonLevel.intermediate,
        icon: Icons.nature,
      ),
    ];
  }

  static List<LessonModel> _getAdvancedLessons() {
    return [
      const LessonModel(
        title: 'Müasir Kənd Təsərrüfatı üçün 5 Ağıllı Suvarma Sistemi',
        videoUrl: 'https://www.youtube.com/watch?v=Ulf8E1XnhgI',
        thumbnailUrl: '',
        level: LessonLevel.advanced,
        icon: Icons.smart_toy,
      ),
      const LessonModel(
        title: 'Kənd Təsərrüfatını Dəyişdirən Top 5 Torpaq Nəmlik Sensoru',
        videoUrl: 'https://www.youtube.com/watch?v=ko0VDt41xCM',
        thumbnailUrl: '',
        level: LessonLevel.advanced,
        icon: Icons.sensors,
      ),
      const LessonModel(
        title: 'Dəqiq Kənd Təsərrüfatı Nədir? Dəqiq Əkinçiliyin Mənası Nədir?',
        videoUrl: 'https://www.youtube.com/watch?v=WhAfZhFxHTs',
        thumbnailUrl: '',
        level: LessonLevel.advanced,
        icon: Icons.gps_fixed,
      ),
      const LessonModel(
        title: 'Dəqiq Suvarma: Dəqiq Əkinçilik üçün Növbəti Böyük Çağırış',
        videoUrl: 'https://www.youtube.com/watch?v=wW9puUpLhGo',
        thumbnailUrl: '',
        level: LessonLevel.advanced,
        icon: Icons.precision_manufacturing,
      ),
    ];
  }

  static List<LessonModel> _getExpertLessons() {
    return [
      const LessonModel(
        title: 'AI Gücləndirməli Avtomatlaşdırılmış Suvarma Sistemləri | Ağıllı Əkinçilik Həlləri',
        videoUrl: 'https://www.youtube.com/watch?v=BwZMJmX3SDw',
        thumbnailUrl: '',
        level: LessonLevel.expert,
        icon: Icons.psychology,
      ),
      const LessonModel(
        title: 'Qabaqcıl Suvarma İdarəetmə Texnikaları (Müxtəlif Qabaqcıl Mövzular)',
        videoUrl: 'https://www.youtube.com/watch?v=FpXar_ZVDuw',
        thumbnailUrl: '',
        level: LessonLevel.expert,
        icon: Icons.workspace_premium,
      ),
    ];
  }
}
