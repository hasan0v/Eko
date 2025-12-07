import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_animations.dart';
import '../logic/auth_bloc.dart';
import '../logic/auth_event.dart';
import '../logic/auth_state.dart';
import 'registration_screen.dart';
import '../../dashboard/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late AnimationController _scaleController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: AppAnimations.slow,
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );
    _scaleController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: AppGradients.backgroundGradient,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),

                      // Logo with animation and glow
                      AnimatedCard(
                        child: Center(
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: AppGradients.primaryGradient,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: AppShadows.primaryGlowShadow,
                            ),
                            child: const Icon(
                              Icons.eco,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Welcome Text with animation
                      StaggeredListItem(
                        index: 0,
                        child: Text(
                          AppStrings.welcome,
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 12),
                      StaggeredListItem(
                        index: 1,
                        child: Text(
                          AppStrings.continueToLogin,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Email Field with glass effect
                      StaggeredListItem(
                        index: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: AppShadows.cardShadow,
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            enabled: !isLoading,
                            decoration: InputDecoration(
                              labelText: AppStrings.email,
                              hintText: AppStrings.enterEmailHint,
                              prefixIcon: Container(
                                margin: const EdgeInsets.all(12),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: AppGradients.primaryGradient,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.email_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(20),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return AppStrings.enterEmail;
                              }
                              if (!value.contains('@') ||
                                  !value.contains('.')) {
                                return AppStrings.enterValidEmail;
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password Field with glass effect
                      StaggeredListItem(
                        index: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: AppShadows.cardShadow,
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            enabled: !isLoading,
                            decoration: InputDecoration(
                              labelText: AppStrings.password,
                              hintText: AppStrings.enterPasswordHint,
                              prefixIcon: Container(
                                margin: const EdgeInsets.all(12),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: AppGradients.primaryGradient,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.lock_outline,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(20),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppStrings.enterPassword;
                              }
                              if (value.length < 6) {
                                return AppStrings.passwordMinLength;
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Forgot Password
                      StaggeredListItem(
                        index: 4,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed:
                                isLoading
                                    ? null
                                    : () {
                                      // TODO: Navigate to forgot password screen
                                    },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: const Text(AppStrings.forgotPassword),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Login Button with gradient
                      StaggeredListItem(
                        index: 5,
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: AppGradients.primaryGradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: AppShadows.primaryShadow,
                          ),
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child:
                                isLoading
                                    ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                    : Text(
                                      AppStrings.login,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Divider
                      StaggeredListItem(
                        index: 6,
                        child: Row(
                          children: [
                            const Expanded(child: Divider(thickness: 1)),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                AppStrings.orContinueWith,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey.shade600),
                              ),
                            ),
                            const Expanded(child: Divider(thickness: 1)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Social Login Buttons with gradient borders
                      StaggeredListItem(
                        index: 7,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: AppShadows.cardShadow,
                                ),
                                child: OutlinedButton.icon(
                                  onPressed:
                                      isLoading
                                          ? null
                                          : () {
                                            // TODO: Google Sign In
                                          },
                                  icon: const Icon(
                                    Icons.g_mobiledata,
                                    size: 32,
                                    color: AppColors.primary,
                                  ),
                                  label: const Text(AppStrings.google),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    side: BorderSide.none,
                                    foregroundColor: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: AppShadows.cardShadow,
                                ),
                                child: OutlinedButton.icon(
                                  onPressed:
                                      isLoading
                                          ? null
                                          : () {
                                            // TODO: Facebook Sign In
                                          },
                                  icon: const Icon(
                                    Icons.facebook,
                                    size: 24,
                                    color: Color(0xFF1877F2),
                                  ),
                                  label: const Text(AppStrings.facebook),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    side: BorderSide.none,
                                    foregroundColor: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Sign Up Link
                      StaggeredListItem(
                        index: 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.noAccount,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 4),
                            TextButton(
                              onPressed:
                                  isLoading
                                      ? null
                                      : () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    const RegistrationScreen(),
                                          ),
                                        );
                                      },
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              child: const Text(AppStrings.signUp),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
