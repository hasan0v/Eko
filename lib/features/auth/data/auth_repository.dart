import '../../../models/user.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/storage_service.dart';

/// Authentication repository
class AuthRepository {
  final ApiClient _apiClient;
  final StorageService _storage;

  AuthRepository({
    required ApiClient apiClient,
    required StorageService storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  /// Login with email and password
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      // TODO: Replace with actual API call
      // final response = await _apiClient.post('/auth/login', data: {
      //   'email': email,
      //   'password': password,
      // });
      
      // Mock response for now
      await Future.delayed(const Duration(seconds: 2));
      
      final mockUser = User(
        id: '1',
        name: 'Demo User',
        email: email,
        phone: '+1234567890',
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );

      // Save user and token to storage
      await _storage.saveUser(mockUser.toJson());
      await _storage.saveAuthToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');
      
      // Set token in API client
      _apiClient.setAuthToken(_storage.getAuthToken()!);

      return mockUser;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  /// Register new user
  Future<User> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? photoUrl,
  }) async {
    try {
      // TODO: Replace with actual API call
      // final response = await _apiClient.post('/auth/register', data: {
      //   'name': name,
      //   'email': email,
      //   'password': password,
      //   'phone': phone,
      // });

      // Mock response for now
      await Future.delayed(const Duration(seconds: 2));

      final mockUser = User(
        id: '${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        phone: phone,
        photoUrl: photoUrl,
        createdAt: DateTime.now(),
      );

      // Save user and token to storage
      await _storage.saveUser(mockUser.toJson());
      await _storage.saveAuthToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');
      
      // Set token in API client
      _apiClient.setAuthToken(_storage.getAuthToken()!);

      return mockUser;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      // TODO: Call API to invalidate token
      // await _apiClient.post('/auth/logout');

      // Clear local storage
      await _storage.clearUser();
      await _storage.clearAuthToken();
      
      // Clear token from API client
      _apiClient.clearAuthToken();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  /// Get current user from storage
  User? getCurrentUser() {
    final userData = _storage.getUser();
    if (userData == null) return null;
    return User.fromJson(userData);
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return _storage.isLoggedIn();
  }

  /// Request password reset
  Future<void> requestPasswordReset(String email) async {
    try {
      // TODO: Call API
      // await _apiClient.post('/auth/forgot-password', data: {'email': email});
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      throw Exception('Password reset request failed: $e');
    }
  }

  /// Reset password with code
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      // TODO: Call API
      // await _apiClient.post('/auth/reset-password', data: {
      //   'email': email,
      //   'code': code,
      //   'newPassword': newPassword,
      // });
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  /// Update user profile
  Future<User> updateProfile({
    String? name,
    String? phone,
    String? photoUrl,
  }) async {
    try {
      final currentUser = getCurrentUser();
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      // TODO: Call API
      // final response = await _apiClient.put('/user/profile', data: {
      //   'name': name,
      //   'phone': phone,
      //   'photoUrl': photoUrl,
      // });

      await Future.delayed(const Duration(seconds: 1));

      final updatedUser = currentUser.copyWith(
        name: name,
        phone: phone,
        photoUrl: photoUrl,
      );

      await _storage.saveUser(updatedUser.toJson());
      return updatedUser;
    } catch (e) {
      throw Exception('Profile update failed: $e');
    }
  }
}
