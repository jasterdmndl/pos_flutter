import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/supabase_service.dart';
import 'auth_provider.dart';
import '../pos/pos_screen.dart';
import '../dashboard/mobile_owner_dashboard.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError("Please enter both email and password");
      return;
    }

    setState(() => _isLoading = true);
    final success = await ref.read(authProvider.notifier).login(email, password);
    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        final user = ref.read(authProvider);
        if (user?.role == 'owner') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MobileOwnerDashboard()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const PosScreen()),
          );
        }
      }
    } else {
      if (mounted) {
        final error = ref.read(authErrorProvider);
        _showError(error ?? "Login Unsuccessful. Check credentials.");
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.spaceGrotesk(fontSize: 12)),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;
    final isPhone = size.width < 500;
    
    final isSupabaseReady = SupabaseService.isInitialized;
    final supabaseError = SupabaseService.initializationError;

    return Scaffold(
      backgroundColor: AppTheme.bone,
      body: Row(
        children: [
          // LEFT SIDE - BRANDING (Only on Desktop/Tablet)
          if (!isMobile)
            Expanded(
              flex: 6,
              child: Container(
                color: AppTheme.emerald,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 60,
                      left: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "MIRE\nSUNSET",
                            style: GoogleFonts.fraunces(
                              fontSize: 100,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 0.9,
                            ),
                          ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.2),
                          const SizedBox(height: 20),
                          Container(width: 80, height: 6, color: Colors.white),
                          const SizedBox(height: 20),
                          Text(
                            "POS System",
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 16,
                              letterSpacing: 4,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // RIGHT SIDE - LOGIN FORM (Optimized for Mobile/Phone)
          Expanded(
            flex: 5,
            child: Container(
              color: AppTheme.bone,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isPhone ? 24 : (isMobile ? 48 : 80),
                      vertical: 40,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 80,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Mobile/Phone Logo
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppTheme.emerald.withValues(alpha: 0.05),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.coffee_rounded, size: 48, color: AppTheme.emerald),
                            ).animate().scale(delay: 200.ms),
                            
                            const SizedBox(height: 32),
                            
                            Text(
                              "MIRE SUNSET",
                              style: GoogleFonts.fraunces(
                                fontSize: isPhone ? 32 : 48,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.ink,
                                letterSpacing: 1,
                              ),
                            ).animate().fadeIn(delay: 400.ms),
                            
                            Text(
                              "MANAGEMENT TERMINAL",
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                color: AppTheme.emerald,
                              ),
                            ).animate().fadeIn(delay: 600.ms),

                            const SizedBox(height: 48),

                            if (!isSupabaseReady) 
                              _ConfigErrorBox(error: supabaseError),

                            _LoginField(
                              label: "ACCOUNT EMAIL",
                              controller: _emailController,
                              icon: Icons.alternate_email_rounded,
                              hint: "email@gmail.com",
                              enabled: isSupabaseReady,
                            ).animate().fadeIn(delay: 800.ms),
                            
                            const SizedBox(height: 24),
                            
                            _LoginField(
                              label: "PASSWORD",
                              controller: _passwordController,
                              icon: Icons.lock_outline_rounded,
                              isPassword: true,
                              enabled: isSupabaseReady,
                            ).animate().fadeIn(delay: 1000.ms),
                            
                            const SizedBox(height: 48),
                            
                            SizedBox(
                              width: double.infinity,
                              height: 64,
                              child: ElevatedButton(
                                onPressed: (_isLoading || !isSupabaseReady) ? null : _handleLogin,
                                child: _isLoading
                                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                    : const Text("SIGN IN"),
                              ),
                            ).animate().fadeIn(delay: 1.2.seconds),
                            
                            const Spacer(),
                            const SizedBox(height: 48),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isSupabaseReady ? Icons.verified_user_outlined : Icons.cloud_off_outlined, 
                                  size: 16, 
                                  color: isSupabaseReady ? AppTheme.emerald : Colors.red,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  isSupabaseReady ? "ENCRYPTED SESSION" : "OFFLINE TERMINAL",
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 10,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.w900,
                                    color: isSupabaseReady ? AppTheme.ink.withValues(alpha: 0.3) : Colors.red,
                                  ),
                                ),
                              ],
                            ).animate().fadeIn(delay: 1.5.seconds),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final IconData icon;
  final bool isPassword;
  final bool enabled;

  const _LoginField({
    required this.label,
    required this.controller,
    required this.icon,
    this.hint,
    this.isPassword = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: GoogleFonts.spaceGrotesk(
            fontSize: 10, 
            fontWeight: FontWeight.w900, 
            letterSpacing: 1.5,
            color: AppTheme.ink.withValues(alpha: 0.4),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          obscureText: isPassword,
          enabled: enabled,
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
            contentPadding: const EdgeInsets.all(20),
          ),
        ),
      ],
    );
  }
}

class _ConfigErrorBox extends StatelessWidget {
  final String? error;
  const _ConfigErrorBox({this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.2), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.cloud_off_rounded, color: Colors.red, size: 20),
              const SizedBox(width: 12),
              Text(
                "CONFIG ERROR",
                style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, letterSpacing: 1, color: Colors.red[900]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            error ?? "App credentials missing.",
            style: GoogleFonts.spaceGrotesk(fontSize: 11, height: 1.5, color: Colors.red[700]),
          ),
        ],
      ),
    ).animate().shake();
  }
}
