import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_animations.dart';
import '../../../core/widgets/modern_widgets.dart';
import '../../../core/services/storage_service.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/logic/auth_bloc.dart';
import '../../auth/logic/auth_event.dart';
import '../../auth/screens/login_screen.dart';
import '../../../models/user.dart';

class ProfileScreen extends StatefulWidget {
  final AuthRepository authRepository;

  const ProfileScreen({
    super.key,
    required this.authRepository,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  User? _currentUser;
  File? _imageFile;
  bool _isLoading = false;
  bool _isEditingProfile = false;
  bool _isChangingPassword = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    _currentUser = widget.authRepository.getCurrentUser();
    if (_currentUser != null) {
      _nameController.text = _currentUser!.name;
      _emailController.text = _currentUser!.email;
      _phoneController.text = _currentUser!.phone ?? '';
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _saveProfile();
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.authRepository.updateProfile(
        name: _nameController.text,
        phone: _phoneController.text.isEmpty ? null : _phoneController.text,
        photoUrl: _imageFile?.path,
      );

      // Reload user data to get the uploaded photo URL
      _currentUser = widget.authRepository.getCurrentUser();
      
      setState(() {
        _isEditingProfile = false;
        _isLoading = false;
        _imageFile = null; // Clear local file after upload
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil uğurla yeniləndi'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Xəta: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Şifrələr uyğun gəlmir'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_newPasswordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Şifrə ən azı 6 simvol olmalıdır'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate password change (implement actual API call)
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _isChangingPassword = false;
    });

    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Şifrə uğurla dəyişdirildi'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 360 ? 12.0 : 20.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE8ECF0),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: const Color(0xFF1A1D1F),
            iconSize: 20,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text(
          'Profil',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1D1F),
          ),
        ),
        actions: [
          if (_isEditingProfile)
            IconButton(
              icon: const Icon(Icons.check, color: Color(0xFF1A1D1F)),
              onPressed: _isLoading ? null : _saveProfile,
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.backgroundGradient,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Profile Picture Section
                AnimatedCard(
                  child: ModernCard(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppGradients.primaryGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF19E624).withOpacity(0.3),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: _buildProfileImage(),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: AppGradients.infoGradient,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  boxShadow: AppShadows.cardShadow,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _currentUser?.name ?? 'İstifadəçi',
                        style: const TextStyle(
                          color: Color(0xFF1A1D1F),
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _currentUser?.email ?? '',
                        style: const TextStyle(
                          color: Color(0xFF6C7278),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
                const SizedBox(height: 24),

                // Profile Info Section
                StaggeredListItem(
                  index: 0,
                  child: const SectionHeader(
                    title: 'Şəxsi Məlumatlar',
                    subtitle: 'Profilinizi redaktə edin',
                  ),
                ),
                const SizedBox(height: 16),
                
                StaggeredListItem(
                  index: 1,
                  child: ModernCard(
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          label: 'Ad Soyad',
                          icon: Icons.person,
                          enabled: _isEditingProfile,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ad daxil edin';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.email,
                          enabled: false, // Email typically shouldn't change
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Telefon',
                          icon: Icons.phone,
                          enabled: _isEditingProfile,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: GradientButton(
                            text: _isEditingProfile ? 'Yadda Saxla' : 'Redaktə Et',
                            icon: _isEditingProfile ? Icons.save : Icons.edit,
                            gradient: _isEditingProfile
                                ? AppGradients.successGradient
                                : AppGradients.infoGradient,
                            isLoading: _isLoading,
                            onPressed: () {
                              if (_isEditingProfile) {
                                _saveProfile();
                              } else {
                                setState(() {
                                  _isEditingProfile = true;
                                });
                              }
                            },
                          ),
                        ),
                        if (_isEditingProfile) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _isEditingProfile = false;
                                  _loadUserData();
                                });
                              },
                              child: const Text(
                                'Ləğv et',
                                style: TextStyle(color: Color(0xFF6C7278)),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Password Change Section
                StaggeredListItem(
                  index: 2,
                  child: const SectionHeader(
                    title: 'Təhlükəsizlik',
                    subtitle: 'Şifrənizi dəyişin',
                  ),
                ),
                const SizedBox(height: 16),
                
                if (!_isChangingPassword)
                  StaggeredListItem(
                    index: 3,
                    child: ModernCard(
                      onTap: () {
                        setState(() {
                          _isChangingPassword = true;
                        });
                      },
                      child: Row(
                        children: [
                          const GradientIcon(
                            icon: Icons.lock_outline,
                            gradient: AppGradients.warningGradient,
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Şifrəni Dəyişdir',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xFF1A1D1F),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Hesabınızı qorumaq üçün şifrənizi yeniləyin',
                                  style: TextStyle(
                                    color: Color(0xFF6C7278),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Color(0xFF6C7278)),
                        ],
                      ),
                    ),
                  )
                else
                  StaggeredListItem(
                    index: 3,
                    child: ModernCard(
                      child: Column(
                        children: [
                          _buildPasswordField(
                            controller: _currentPasswordController,
                            label: 'Cari Şifrə',
                            icon: Icons.lock,
                          ),
                          const SizedBox(height: 16),
                          _buildPasswordField(
                            controller: _newPasswordController,
                            label: 'Yeni Şifrə',
                            icon: Icons.lock_open,
                          ),
                          const SizedBox(height: 16),
                          _buildPasswordField(
                            controller: _confirmPasswordController,
                            label: 'Yeni Şifrəni Təsdiqlə',
                            icon: Icons.lock_outline,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: GradientButton(
                              text: 'Şifrəni Yenilə',
                              icon: Icons.check,
                              gradient: AppGradients.successGradient,
                              isLoading: _isLoading,
                              onPressed: _changePassword,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _isChangingPassword = false;
                                  _currentPasswordController.clear();
                                  _newPasswordController.clear();
                                  _confirmPasswordController.clear();
                                });
                              },
                              child: const Text(
                                'Ləğv et',
                                style: TextStyle(color: Color(0xFF6C7278)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 32),

                // Account Info
                StaggeredListItem(
                  index: 4,
                  child: const SectionHeader(
                    title: 'Hesab Məlumatı',
                  ),
                ),
                const SizedBox(height: 16),
                
                StaggeredListItem(
                  index: 5,
                  child: ModernCard(
                    child: Column(
                      children: [
                        _buildInfoRow(
                          'Üzv Olma Tarixi',
                          _formatDate(_currentUser?.createdAt),
                          Icons.calendar_today,
                        ),
                        if (_currentUser?.lastLogin != null) ...[
                          const Divider(height: 24),
                          _buildInfoRow(
                            'Son Giriş',
                            _formatDate(_currentUser?.lastLogin),
                            Icons.access_time,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Logout Button
                StaggeredListItem(
                  index: 6,
                  child: SizedBox(
                    width: double.infinity,
                    child: GradientButton(
                      text: 'Çıxış',
                      icon: Icons.logout,
                      gradient: AppGradients.errorGradient,
                      onPressed: () {
                        _showLogoutDialog();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Center(
      child: Text(
        _currentUser?.name[0].toUpperCase() ?? 'U',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    // If user just picked an image from device, show that
    if (_imageFile != null) {
      return Image.file(
        _imageFile!,
        fit: BoxFit.cover,
      );
    }

    // If user has a photo URL from database
    if (_currentUser?.photoUrl != null && _currentUser!.photoUrl!.isNotEmpty) {
      final photoUrl = _currentUser!.photoUrl!;
      
      // Check if it's a network URL (from Supabase Storage)
      if (photoUrl.startsWith('http://') || photoUrl.startsWith('https://')) {
        return Image.network(
          photoUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: Colors.white,
              ),
            );
          },
          errorBuilder: (context, error, stack) {
            return _buildDefaultAvatar();
          },
        );
      }
      
      // If it's a local file path (legacy support)
      if (photoUrl.startsWith('/')) {
        return Image.file(
          File(photoUrl),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) {
            return _buildDefaultAvatar();
          },
        );
      }
    }

    // Default avatar with user's initial
    return _buildDefaultAvatar();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Color(0xFF1A1D1F)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: enabled ? const Color(0xFF6C7278) : const Color(0xFF9CA3AF),
        ),
        prefixIcon: Icon(
          icon,
          color: enabled ? const Color(0xFF2E7D32) : const Color(0xFF9CA3AF),
        ),
        filled: true,
        fillColor: enabled
            ? const Color(0xFFF0F4F8)
            : const Color(0xFFF8FAFB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFE8ECF0),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFE8ECF0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF2E7D32),
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFE8ECF0),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      style: const TextStyle(color: Color(0xFF1A1D1F)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF6C7278)),
        prefixIcon: Icon(icon, color: const Color(0xFF2E7D32)),
        filled: true,
        fillColor: const Color(0xFFF0F4F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFE8ECF0),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFE8ECF0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF2E7D32),
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF2E7D32).withOpacity(0.15),
                const Color(0xFF2E7D32).withOpacity(0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF2E7D32),
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF6C7278),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF1A1D1F),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}.${date.month}.${date.year}';
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.logout, color: Color(0xFF1A1D1F)),
            SizedBox(width: 12),
            Text(
              'Çıxış',
              style: TextStyle(
                color: Color(0xFF1A1D1F),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: const Text(
          'Hesabdan çıxmaq istədiyinizdən əminsiniz?',
          style: TextStyle(color: Color(0xFF6C7278), fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Ləğv et',
              style: TextStyle(color: Color(0xFF6C7278)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              // Use AuthBloc to logout
              context.read<AuthBloc>().add(const AuthLogoutRequested());
              
              if (mounted) {
                // Navigate to login screen
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Çıxış'),
          ),
        ],
      ),
    );
  }
}
