import 'package:hive_flutter/hive_flutter.dart';
import '../models/chat_message.dart';

/// Service for managing chat history in local database
class ChatHistoryService {
  static const String _chatHistoryBox = 'chat_history';
  static const String _chatSessionsBox = 'chat_sessions';

  /// Initialize chat history database
  static Future<void> initialize() async {
    if (!Hive.isBoxOpen(_chatHistoryBox)) {
      await Hive.openBox(_chatHistoryBox);
    }
    if (!Hive.isBoxOpen(_chatSessionsBox)) {
      await Hive.openBox(_chatSessionsBox);
    }
  }

  /// Save a message to history
  Future<void> saveMessage(ChatMessage message) async {
    await initialize();
    final box = Hive.box(_chatHistoryBox);
    await box.put(message.id, {
      'id': message.id,
      'content': message.content,
      'role': message.role.toString(),
      'timestamp': message.timestamp.toIso8601String(),
      'isError': message.isError,
    });
  }

  /// Get all messages
  List<ChatMessage> getAllMessages() {
    if (!Hive.isBoxOpen(_chatHistoryBox)) {
      return [];
    }
    
    final box = Hive.box(_chatHistoryBox);
    final messages = <ChatMessage>[];

    for (var value in box.values) {
      if (value is Map) {
        messages.add(_messageFromMap(value.cast<String, dynamic>()));
      }
    }

    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return messages;
  }

  /// Get recent messages
  List<ChatMessage> getRecentMessages({int limit = 50}) {
    final allMessages = getAllMessages();
    if (allMessages.length <= limit) {
      return allMessages;
    }
    return allMessages.sublist(allMessages.length - limit);
  }

  /// Clear all chat history
  Future<void> clearHistory() async {
    await initialize();
    final box = Hive.box(_chatHistoryBox);
    await box.clear();
  }

  /// Delete a specific message
  Future<void> deleteMessage(String messageId) async {
    await initialize();
    final box = Hive.box(_chatHistoryBox);
    await box.delete(messageId);
  }

  /// Save current session metadata
  Future<void> saveSession({
    required String sessionId,
    required DateTime startTime,
    DateTime? endTime,
    int messageCount = 0,
  }) async {
    await initialize();
    final box = Hive.box(_chatSessionsBox);
    await box.put(sessionId, {
      'sessionId': sessionId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'messageCount': messageCount,
    });
  }

  /// Get message count
  int getMessageCount() {
    if (!Hive.isBoxOpen(_chatHistoryBox)) {
      return 0;
    }
    return Hive.box(_chatHistoryBox).length;
  }

  ChatMessage _messageFromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] as String,
      content: map['content'] as String,
      role: _roleFromString(map['role'] as String),
      timestamp: DateTime.parse(map['timestamp'] as String),
      isError: map['isError'] as bool? ?? false,
    );
  }

  MessageRole _roleFromString(String roleStr) {
    return MessageRole.values.firstWhere(
      (r) => r.toString() == roleStr,
      orElse: () => MessageRole.assistant,
    );
  }
}
