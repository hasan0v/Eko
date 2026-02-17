import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../../../models/soil_analysis.dart';

/// Soil analysis service using Supabase
class SoilAnalysisService {
  final _supabase = SupabaseService.instance.client;

  /// Get all soil analyses for current user
  Future<List<SoilAnalysis>> getAllAnalyses({int limit = 50}) async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return [];

    final response = await _supabase
        .from('soil_analyses')
        .select()
        .eq('user_id', userId)
        .order('timestamp', ascending: false)
        .limit(limit);

    return (response as List).map((json) => _analysisFromJson(json)).toList();
  }

  /// Get latest soil analysis
  Future<SoilAnalysis?> getLatestAnalysis() async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return null;

    final response = await _supabase
        .from('soil_analyses')
        .select()
        .eq('user_id', userId)
        .order('timestamp', ascending: false)
        .limit(1)
        .maybeSingle();

    return response != null ? _analysisFromJson(response) : null;
  }

  /// Get a specific soil analysis
  Future<SoilAnalysis?> getAnalysis(String analysisId) async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return null;

    final response = await _supabase
        .from('soil_analyses')
        .select()
        .eq('id', analysisId)
        .eq('user_id', userId)
        .maybeSingle();

    return response != null ? _analysisFromJson(response) : null;
  }

  /// Create a new soil analysis
  Future<SoilAnalysis> createAnalysis(SoilAnalysis analysis) async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('soil_analyses')
        .insert({
          'user_id': userId,
          'timestamp': analysis.timestamp.toIso8601String(),
          'health_score': analysis.healthScore,
          'nitrogen': analysis.nitrogen,
          'phosphorus': analysis.phosphorus,
          'potassium': analysis.potassium,
          'ph': analysis.ph,
          'moisture': analysis.moisture,
          'organic_matter': analysis.organicMatter,
          'temperature': analysis.temperature,
          'recommendations': analysis.recommendations,
          'health': analysis.health.toString().split('.').last,
        })
        .select()
        .single();

    return _analysisFromJson(response);
  }

  /// Delete a soil analysis
  Future<void> deleteAnalysis(String analysisId) async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return;

    await _supabase
        .from('soil_analyses')
        .delete()
        .eq('id', analysisId)
        .eq('user_id', userId);
  }

  /// Get soil analyses within a date range
  Future<List<SoilAnalysis>> getAnalysesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return [];

    final response = await _supabase
        .from('soil_analyses')
        .select()
        .eq('user_id', userId)
        .gte('timestamp', startDate.toIso8601String())
        .lte('timestamp', endDate.toIso8601String())
        .order('timestamp', ascending: false);

    return (response as List).map((json) => _analysisFromJson(json)).toList();
  }

  /// Stream soil analyses (real-time updates)
  Stream<List<SoilAnalysis>> watchAnalyses() {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return Stream.value([]);

    return _supabase
        .from('soil_analyses')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('timestamp', ascending: false)
        .map((data) => data.map((json) => _analysisFromJson(json)).toList());
  }

  // ==================== HELPER METHODS ====================

  SoilAnalysis _analysisFromJson(Map<String, dynamic> json) {
    return SoilAnalysis(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      healthScore: (json['health_score'] as num).toDouble(),
      nitrogen: (json['nitrogen'] as num).toDouble(),
      phosphorus: (json['phosphorus'] as num).toDouble(),
      potassium: (json['potassium'] as num).toDouble(),
      ph: (json['ph'] as num).toDouble(),
      moisture: (json['moisture'] as num).toDouble(),
      organicMatter: (json['organic_matter'] as num?)?.toDouble(),
      temperature: (json['temperature'] as num?)?.toDouble(),
      recommendations: (json['recommendations'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      health: SoilHealth.values.firstWhere(
        (e) => e.toString().split('.').last == json['health'],
      ),
    );
  }
}
