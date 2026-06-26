import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../sales/sales_history_screen.dart';
import '../products/product_page.dart';
import '../cart/cart_panel.dart';
import '../dashboard/dashboard_screen.dart';
import '../auth/auth_provider.dart';
import '../auth/login_screen.dart';
import 'management_screen.dart';

class PosScreen extends ConsumerWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.bone,
      appBar: AppBar(
        toolbarHeight: 80,
        title: Row(
          children: [
            const SizedBox(width: 8),
            Text(
              'MIRE SUNSET',
              style: GoogleFonts.fraunces(
                fontWeight: FontWeight.w900,
                fontSize: 24,
                letterSpacing: 1,
                color: AppTheme.emerald,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.emerald.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
        actions: [
          if (user?.role == 'admin') ...[
            _NavIcon(
              icon: Icons.analytics_outlined,
              label: 'DASHBOARD',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
              ),
            ),
            _NavIcon(
              icon: Icons.receipt_long_outlined,
              label: 'HISTORY',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SalesHistoryScreen()),
              ),
            ),
            _NavIcon(
              icon: Icons.settings_outlined,
              label: 'MANAGE',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManagementScreen()),
              ),
            ),
          ],
          const VerticalDivider(width: 32, indent: 24, endIndent: 24),
          _NavIcon(
            icon: Icons.logout_rounded,
            label: 'LOGOUT',
            color: Colors.red[700],
            onTap: () {
              ref.read(authProvider.notifier).logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
          const SizedBox(width: 24),
        ],
      ),
      body: Row(
        children: [
          // LEFT SIDE - MENU
          const Expanded(
            flex: 3,
            child: ProductPage(),
          ),

          // RIGHT SIDE - CART
          const CartPanel().animate().fadeIn(duration: 400.ms).slideX(begin: 0.1),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _NavIcon({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color ?? AppTheme.ink.withOpacity(0.7)),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
                color: color ?? AppTheme.ink.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
