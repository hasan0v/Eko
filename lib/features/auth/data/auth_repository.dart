import 'dart:io';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;
import '../../../models/user.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/supabase_service.dart';

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
      // Sign in with Supabase
      final response = await SupabaseService.instance.signInWithEmail(
        email: email,
        password: password,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('İnternet bağlantınızı yoxlayın. Supabase serverə çatmaq mümkün olmadı.');
        },
      );

      if (response.user == null) {
        throw Exception('E-poçt və ya şifrə yanlışdır');
      }

      // Get user profile from Supabase
      final profile = await SupabaseService.instance.getProfile();
      
      final user = User(
        id: response.user!.id,
        name: profile?['name'] ?? 'User',
        email: response.user!.email ?? email,
        phone: profile?['phone'],
        photoUrl: profile?['photo_url'],
        createdAt: DateTime.parse(response.user!.createdAt),
        lastLogin: DateTime.now(),
      );

      // Save user and token to storage
      await _storage.saveUser(user.toJson());
      await _storage.saveAuthToken(response.session?.accessToken ?? '');
      
      // Set token in API client
      if (response.session?.accessToken != null) {
        _apiClient.setAuthToken(response.session!.accessToken);
      }

      return user;
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
      // Sign up with Supabase
      final response = await SupabaseService.instance.signUpWithEmail(
        email: email,
        password: password,
        name: name,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('İnternet bağlantınızı yoxlayın. Supabase serverə çatmaq mümkün olmadı.');
        },
      );

      if (response.user == null) {
        throw Exception('Qeydiyyat uğursuz oldu');
      }

      String? uploadedPhotoUrl = photoUrl;

      // Upload profile photo to Supabase Storage if provided
      if (photoUrl != null && photoUrl.startsWith('/')) {
        try {
          // Read image file
          final imageFile = File(photoUrl);
          if (await imageFile.exists()) {
            final imageBytes = await imageFile.readAsBytes();
            final fileName = photoUrl.split('/').last;
            
            // Upload to Supabase Storage
            uploadedPhotoUrl = await SupabaseService.instance.uploadProfilePhoto(
              imageBytes: imageBytes,
              fileName: fileName,
            );
          }
        } catch (e) {
          print('Failed to upload profile photo: $e');
          // Continue with registration even if photo upload fails
          uploadedPhotoUrl = null;
        }
      }

      // Create/update profile with additional info
      if (phone != null || uploadedPhotoUrl != null) {
        await SupabaseService.instance.updateProfile(
          name: name,
          phone: phone,
          photoUrl: uploadedPhotoUrl,
        );
      }

      final user = User(
        id: response.user!.id,
        name: name,
        email: email,
        phone: phone,
        photoUrl: uploadedPhotoUrl,
        createdAt: DateTime.parse(response.user!.createdAt),
      );

      // Save user and token to storage
      await _storage.saveUser(user.toJson());
      await _storage.saveAuthToken(response.session?.accessToken ?? '');
      
      // Set token in API client
      if (response.session?.accessToken != null) {
        _apiClient.setAuthToken(response.session!.accessToken);
      }

      return user;
    } on TimeoutException {
      throw Exception('Qoşulma vaxtı bitdi. İnternet bağlantınızı yoxlayın.');
    } on AuthException catch (e) {
      // Handle Supabase auth-specific errors
      if (e.message.contains('User already registered')) {
        throw Exception('Bu e-poçt artıq qeydiyyatdan keçib. Giriş edin.');
      } else if (e.message.contains('Email rate limit exceeded')) {
        throw Exception('Çox cəhd. Bir az gözləyin və yenidən cəhd edin.');
      } else if (e.message.contains('Invalid email')) {
        throw Exception('E-poçt düzgün deyil.');
      } else if (e.message.contains('Password')) {
        throw Exception('Şifrə ən azı 6 simvol olmalıdır.');
      }
      throw Exception('Qeydiyyat xətası: ${e.message}');
    } catch (e) {
      // Check for specific network errors
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('sockexception') || 
          errorMessage.contains('failed host lookup') ||
          errorMessage.contains('no address associated')) {
        throw Exception('İnternet bağlantınız yoxdur. WiFi və ya mobil datanı yoxlayın.');
      } else if (errorMessage.contains('user not authenticated')) {
        throw Exception('Bu e-poçt artıq istifadə olunur. Giriş edin.');
      }
      throw Exception('Qeydiyyat xətası: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      // Sign out from Supabase
      await SupabaseService.instance.signOut();

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
    return _storage.isLoggedIn() && SupabaseService.instance.isAuthenticated;
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

      String? uploadedPhotoUrl = photoUrl;

      // Upload profile photo to Supabase Storage if it's a local file path
      if (photoUrl != null && photoUrl.startsWith('/')) {
        try {
          // Read image file
          final imageFile = File(photoUrl);
          if (await imageFile.exists()) {
            final imageBytes = await imageFile.readAsBytes();
            final fileName = photoUrl.split('/').last;
            
            // Upload to Supabase Storage
            uploadedPhotoUrl = await SupabaseService.instance.uploadProfilePhoto(
              imageBytes: imageBytes,
              fileName: fileName,
            );
            
            // Delete old photo if exists
            if (currentUser.photoUrl != null && currentUser.photoUrl!.contains('profile-photos/')) {
              try {
                final oldPath = Uri.parse(currentUser.photoUrl!).path.split('/storage/v1/object/public/avatars/').last;
                await SupabaseService.instance.deleteFile(
                  bucketName: 'avatars',
                  filePath: oldPath,
                );
              } catch (e) {
                print('Failed to delete old photo: $e');
              }
            }
          }
        } catch (e) {
          print('Failed to upload profile photo: $e');
          // Use existing photo URL if upload fails
          uploadedPhotoUrl = currentUser.photoUrl;
        }
      }

      // Update profile in Supabase
      await SupabaseService.instance.updateProfile(
        name: name,
        phone: phone,
        photoUrl: uploadedPhotoUrl,
      );

      final updatedUser = currentUser.copyWith(
        name: name,
        phone: phone,
        photoUrl: uploadedPhotoUrl,
      );

      await _storage.saveUser(updatedUser.toJson());
      return updatedUser;
    } catch (e) {
      throw Exception('Profile update failed: $e');
    }
  }
}
