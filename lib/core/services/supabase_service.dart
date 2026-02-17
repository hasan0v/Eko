import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

/// Supabase service for database operations
class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseClient? _client;

  SupabaseService._();

  /// Get singleton instance
  static SupabaseService get instance {
    _instance ??= SupabaseService._();
    return _instance!;
  }

  /// Get Supabase client
  SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase not initialized. Call initialize() first.');
    }
    return _client!;
  }

  /// Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
    _client = Supabase.instance.client;
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _client?.auth.currentUser != null;

  /// Get current user ID
  String? get currentUserId => _client?.auth.currentUser?.id;

  /// Get current user
  User? get currentUser => _client?.auth.currentUser;

  /// Sign in anonymously (for testing/demo)
  Future<AuthResponse> signInAnonymously() async {
    return await client.auth.signInAnonymously();
  }

  /// Sign in with email and password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign up with email and password
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: {'name': name ?? 'User'},
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  /// Update user profile
  Future<void> updateProfile({
    String? name,
    String? phone,
    String? photoUrl,
  }) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };
    if (name != null) updates['name'] = name;
    if (phone != null) updates['phone'] = phone;
    if (photoUrl != null) updates['photo_url'] = photoUrl;

    await client.from('profiles').update(updates).eq('id', userId);
  }

  /// Get user profile
  Future<Map<String, dynamic>?> getProfile() async {
    final userId = currentUserId;
    if (userId == null) return null;

    final response = await client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    return response;
  }

  /// Upload file to storage
  Future<String> uploadFile({
    required String bucketName,
    required String filePath,
    required List<int> fileBytes,
    String? contentType,
  }) async {
    try {
      // Convert List<int> to Uint8List
      final bytes = Uint8List.fromList(fileBytes);
      
      // Upload file to storage
      await client.storage.from(bucketName).uploadBinary(
        filePath,
        bytes,
        fileOptions: FileOptions(
          contentType: contentType,
          upsert: true,
        ),
      );

      // Get public URL
      final publicUrl = client.storage.from(bucketName).getPublicUrl(filePath);
      return publicUrl;
    } catch (e) {
      throw Exception('File upload failed: $e');
    }
  }

  /// Upload profile photo
  Future<String> uploadProfilePhoto({
    required List<int> imageBytes,
    required String fileName,
  }) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filePath = 'profile-photos/$userId/$timestamp-$fileName';

    return await uploadFile(
      bucketName: 'avatars',
      filePath: filePath,
      fileBytes: imageBytes,
      contentType: 'image/jpeg',
    );
  }

  /// Delete file from storage
  Future<void> deleteFile({
    required String bucketName,
    required String filePath,
  }) async {
    try {
      await client.storage.from(bucketName).remove([filePath]);
    } catch (e) {
      throw Exception('File deletion failed: $e');
    }
  }
}
