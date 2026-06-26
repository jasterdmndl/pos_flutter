import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/supabase_service.dart';
import 'auth_provider.dart';
import '../pos/pos_screen.dart';

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PosScreen()),
        );
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
        content: Text(message, style: GoogleFonts.spaceGrotesk()),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;
    
    final isSupabaseReady = SupabaseService.isInitialized;
    final supabaseError = SupabaseService.initializationError;

    return Scaffold(
      body: Row(
        children: [
          // LEFT SIDE - BRANDING (BOUTIQUE SPLIT) - Hides on small mobile
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
                          Container(
                            width: 80,
                            height: 6,
                            color: Colors.white,
                          ).animate().scaleX(begin: 0, alignment: Alignment.centerLeft, delay: 500.ms),
                          const SizedBox(height: 20),
                          Text(
                            "POS System",
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 16,
                              letterSpacing: 4,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ).animate().fadeIn(delay: 800.ms),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // RIGHT SIDE - LOGIN FORM
          Expanded(
            flex: 5,
            child: Container(
              color: AppTheme.bone,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 40 : 80,
                      vertical: 40,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 80,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isSupabaseReady)
                              Container(
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
                                        const Icon(Icons.cloud_off_rounded, color: Colors.red),
                                        const SizedBox(width: 12),
                                        Text(
                                          "CONFIGURATION ERROR",
                                          style: GoogleFonts.spaceGrotesk(
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1,
                                            color: Colors.red[900],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      supabaseError ?? "The app could not find your .env file or the keys inside it are empty.",
                                      style: GoogleFonts.spaceGrotesk(
                                        fontSize: 12,
                                        height: 1.5,
                                        color: Colors.red[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ).animate().shake(),
                            if (isMobile) ...[
                              Text(
                                "MIRE SUNSET",
                                style: GoogleFonts.fraunces(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.emerald,
                                ),
                              ).animate().fadeIn(),
                              const SizedBox(height: 32),
                            ],
                            Text(
                              "Welcome Back",
                              style: theme.textTheme.headlineLarge,
                            ).animate().fadeIn().slideY(begin: 0.2),
                            const SizedBox(height: 8),
                            Text(
                              "Sign in to access your store terminal",
                              style: theme.textTheme.bodyMedium?.copyWith(color: AppTheme.ink.withValues(alpha: 0.5)),
                            ).animate().fadeIn(delay: 200.ms),
                            
                            const SizedBox(height: 48),
                            
                            Text("ACCOUNT EMAIL", style: theme.textTheme.labelLarge),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _emailController,
                              enabled: isSupabaseReady,
                              decoration: const InputDecoration(
                                hintText: "email@gmail.com",
                                prefixIcon: Icon(Icons.alternate_email_rounded, size: 20),
                              ),
                            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                            
                            const SizedBox(height: 24),
                            
                            Text("PASSWORD", style: theme.textTheme.labelLarge),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              enabled: isSupabaseReady,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.lock_outline_rounded, size: 20),
                              ),
                            ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),
                            
                            const SizedBox(height: 48),
                            
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: (_isLoading || !isSupabaseReady) ? null : _handleLogin,
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 24, 
                                        width: 24, 
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                      )
                                    : const Text("SIGN IN"),
                              ),
                            ).animate().fadeIn(delay: 800.ms).scaleXY(begin: 0.95),
                            
                            const Spacer(),
                            const SizedBox(height: 32),
                            const Divider(),
                            const SizedBox(height: 32),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isSupabaseReady ? Icons.verified_user_outlined : Icons.cloud_off_outlined, 
                                  size: 16, 
                                  color: isSupabaseReady ? AppTheme.emerald : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isSupabaseReady ? "SECURED BY SUPABASE CLOUD" : "OFFLINE / CONFIG MISSING",
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 10,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold,
                                    color: isSupabaseReady ? AppTheme.emerald : Colors.red,
                                  ),
                                ),
                              ],
                            ).animate().fadeIn(delay: 1.seconds),
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
