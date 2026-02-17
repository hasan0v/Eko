import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../models/chat_message.dart';

/// Chat history service using Supabase
class ChatHistoryService {
  final _supabase = SupabaseService.instance.client;

  /// Save a chat message
  Future<void> saveMessage(ChatMessage message) async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) {
      print('Warning: No authenticated user, skipping chat save');
      return;
    }

    await _supabase.from('chat_messages').insert({
      'user_id': userId,
      'content': message.content,
      'role': message.role.toString().split('.').last,
      'is_error': message.isError,
      'created_at': message.timestamp.toIso8601String(),
    });
  }

  /// Get all messages for current user
  Future<List<ChatMessage>> getAllMessages() async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return [];

    final response = await _supabase
        .from('chat_messages')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: true);

    return (response as List)
        .map((json) => _chatMessageFromJson(json))
        .toList();
  }

  /// Get recent messages (last N messages)
  Future<List<ChatMessage>> getRecentMessages({int limit = 50}) async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return [];

    final response = await _supabase
        .from('chat_messages')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);

    final messages = (response as List)
        .map((json) => _chatMessageFromJson(json))
        .toList();

    return messages.reversed.toList(); // Reverse to get chronological order
  }

  /// Clear all chat history for current user
  Future<void> clearHistory() async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return;

    await _supabase.from('chat_messages').delete().eq('user_id', userId);
  }

  /// Delete a specific message
  Future<void> deleteMessage(String messageId) async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return;

    await _supabase
        .from('chat_messages')
        .delete()
        .eq('id', messageId)
        .eq('user_id', userId);
  }

  /// Stream of chat messages (real-time updates)
  Stream<List<ChatMessage>> watchMessages() {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return Stream.value([]);

    return _supabase
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at')
        .map((data) => data.map((json) => _chatMessageFromJson(json)).toList());
  }

  /// Convert JSON to ChatMessage
  ChatMessage _chatMessageFromJson(Map<String, dynamic> json) {
    final roleString = json['role'] as String;
    final role = MessageRole.values.firstWhere(
      (e) => e.toString().split('.').last == roleString,
      orElse: () => MessageRole.assistant,
    );

    return ChatMessage(
      id: json['id'] as String,
      content: json['content'] as String,
      role: role,
      timestamp: DateTime.parse(json['created_at'] as String),
      isError: json['is_error'] as bool? ?? false,
    );
  }
}
