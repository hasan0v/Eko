import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../core/config/gemini_config.dart';
import '../models/chat_message.dart';

/// Service for interacting with Gemini AI
class GeminiService {
  late final GenerativeModel _model;
  late ChatSession _chat;
  
  GeminiService() {
    _model = GeminiConfig.getModel();
    _chat = _model.startChat();
  }

  /// Initialize chat with history
  void initializeWithHistory(List<ChatMessage> messages) {
    if (messages.isEmpty) {
      _chat = _model.startChat();
      return;
    }

    // Convert chat messages to Gemini Content format
    final history = <Content>[];
    for (final message in messages) {
      // Skip error messages and system messages
      if (message.isError || message.role == MessageRole.system) continue;
      
      // Convert to Gemini format
      if (message.role == MessageRole.user) {
        history.add(Content.text(message.content));
      } else if (message.role == MessageRole.assistant) {
        history.add(Content.model([TextPart(message.content)]));
      }
    }

    // Start new chat with history
    _chat = _model.startChat(history: history);
  }

  /// Send message and get response
  Future<ChatMessage> sendMessage(String userMessage) async {
    try {
      final content = Content.text(userMessage);
      final response = await _chat.sendMessage(content);
      
      if (response.text == null || response.text!.isEmpty) {
        return ChatMessage.error(
          'Üzr istəyirik, cavab ala bilmədik. Zəhmət olmasa yenidən cəhd edin.',
        );
      }
      
      return ChatMessage.assistant(response.text!);
    } catch (e) {
      return ChatMessage.error(
        'Xəta baş verdi: ${e.toString()}\n\nZəhmət olmasa internet bağlantınızı yoxlayın və yenidən cəhd edin.',
      );
    }
  }

  /// Send message with context from app data
  Future<ChatMessage> sendMessageWithContext({
    required String userMessage,
    Map<String, dynamic>? soilData,
    Map<String, dynamic>? waterData,
    Map<String, dynamic>? compostData,
  }) async {
    try {
      // Build context-aware message
      final contextMessage = _buildContextMessage(
        userMessage,
        soilData: soilData,
        waterData: waterData,
        compostData: compostData,
      );
      
      final content = Content.text(contextMessage);
      final response = await _chat.sendMessage(content);
      
      if (response.text == null || response.text!.isEmpty) {
        return ChatMessage.error(
          'Üzr istəyirik, cavab ala bilmədik. Zəhmət olmasa yenidən cəhd edin.',
        );
      }
      
      return ChatMessage.assistant(response.text!);
    } catch (e) {
      return ChatMessage.error(
        'Xəta baş verdi: ${e.toString()}\n\nZəhmət olmasa internet bağlantınızı yoxlayın və yenidən cəhd edin.',
      );
    }
  }

  /// Build message with context
  String _buildContextMessage(
    String userMessage, {
    Map<String, dynamic>? soilData,
    Map<String, dynamic>? waterData,
    Map<String, dynamic>? compostData,
  }) {
    final buffer = StringBuffer();
    
    // Add sensor data context if available
    if (soilData != null) {
      buffer.writeln('📊 Cari Torpaq Məlumatları:');
      buffer.writeln('- Azot (N): ${soilData['nitrogen']}%');
      buffer.writeln('- Fosfor (P): ${soilData['phosphorus']}%');
      buffer.writeln('- Kalium (K): ${soilData['potassium']}%');
      buffer.writeln('- pH: ${soilData['ph']}');
      buffer.writeln('- Nəmlik: ${soilData['moisture']}%');
      if (soilData['temperature'] != null) {
        buffer.writeln('- Temperatur: ${soilData['temperature']}C');
      }
      buffer.writeln('');
    }
    
    if (waterData != null) {
      buffer.writeln('💧 Cari Su Məlumatları:');
      buffer.writeln('- Su səviyyəsi: ${waterData['level']}L / ${waterData['capacity']}L');
      buffer.writeln('- pH: ${waterData['ph']}');
      if (waterData['temperature'] != null) {
        buffer.writeln('- Temperatur: ${waterData['temperature']}C');
      }
      buffer.writeln('');
    }
    
    if (compostData != null) {
      buffer.writeln('♻️ Cari Kompost Məlumatları:');
      buffer.writeln('- Temperatur: ${compostData['temperature']}C');
      buffer.writeln('- Nəmlik: ${compostData['humidity']}%');
      buffer.writeln('- Tamamlanma: ${compostData['progress']}%');
      buffer.writeln('');
    }
    
    buffer.writeln('🌾 İstifadəçi Sualı:');
    buffer.writeln(userMessage);
    
    return buffer.toString();
  }

  /// Clear chat history
  void clearHistory() {
    _chat = _model.startChat();
  }

  /// Get a quick response for common questions
  Future<ChatMessage> getQuickResponse(String question) async {
    return sendMessage(question);
  }
}
