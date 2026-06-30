import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../auth/auth_provider.dart';
import '../auth/login_screen.dart';

class MobileOwnerDashboard extends ConsumerWidget {
  const MobileOwnerDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.bone,
      appBar: AppBar(
        title: Text('OWNER MONITOR', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.visibility_outlined, size: 80, color: AppTheme.emerald.withValues(alpha: 0.1)),
            const SizedBox(height: 24),
            Text(
              'REMOTE MONITORING ACTIVE',
              style: GoogleFonts.spaceGrotesk(
                letterSpacing: 2,
                fontWeight: FontWeight.w900,
                color: AppTheme.emerald.withValues(alpha: 0.2),
              ),
            ),
            const SizedBox(height: 8),
            const Text('Real-time order feed coming soon...', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
