import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../auth/auth_provider.dart';
import '../auth/login_screen.dart';
import 'live_orders_provider.dart';
import 'dashboard_provider.dart';

class MobileOwnerDashboard extends ConsumerWidget {
  const MobileOwnerDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveOrders = ref.watch(liveOrdersProvider);
    final summaryAsync = ref.watch(dashboardProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.bone,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MIRE SUNSET',
              style: GoogleFonts.fraunces(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: AppTheme.emerald,
              ),
            ),
            Text(
              'OWNER MONITORING',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: AppTheme.ink.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, size: 20),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dashboardProvider);
          return ref.refresh(dashboardProvider.future);
        },
        child: CustomScrollView(
          slivers: [
            // 1. STATS SECTION
            SliverToBoxAdapter(
              child: summaryAsync.when(
                data: (data) => Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      _CompactMetric(
                        label: "TODAY SALES",
                        value: "₱${data.todaySales.toStringAsFixed(0)}",
                        icon: Icons.payments_outlined,
                      ),
                      const SizedBox(width: 16),
                      _CompactMetric(
                        label: "ORDERS",
                        value: "${data.todayOrders}",
                        icon: Icons.shopping_bag_outlined,
                      ),
                    ],
                  ),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const SizedBox(),
              ),
            ),

            // 2. LIVE FEED HEADER
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ).animate(onPlay: (c) => c.repeat()).fade(duration: 1.seconds),
                    const SizedBox(width: 12),
                    Text(
                      "LIVE TRANSACTION FEED",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        color: AppTheme.ink.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. LIVE FEED LIST
            liveOrders.when(
              data: (orders) {
                if (orders.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text("Waiting for new orders...")),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final order = orders[index];
                        final isVoided = order['is_voided'] == true;
                        final timestamp = DateTime.parse(order['created_at']);
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isVoided ? Colors.red.withValues(alpha: 0.1) : AppTheme.ink.withValues(alpha: 0.05),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "INV-${timestamp.year}-${order['id'].toString().padLeft(6, '0')}",
                                      style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat('hh:mm a').format(timestamp),
                                      style: TextStyle(fontSize: 12, color: AppTheme.ink.withValues(alpha: 0.4)),
                                    ),
                                  ],
                                ),
                              ),
                              if (isVoided)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "VOID",
                                    style: GoogleFonts.spaceGrotesk(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.red),
                                  ),
                                ),
                              Text(
                                "₱${(order['total'] as num).toStringAsFixed(2)}",
                                style: GoogleFonts.spaceGrotesk(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                  color: isVoided ? AppTheme.ink.withValues(alpha: 0.3) : AppTheme.emerald,
                                  decoration: isVoided ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn().slideY(begin: 0.1);
                      },
                      childCount: orders.length,
                    ),
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, _) => SliverFillRemaining(
                child: Center(child: Text("Stream Error: $err")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _CompactMetric({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.ink.withValues(alpha: 0.05), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: AppTheme.emerald),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
                color: AppTheme.ink.withValues(alpha: 0.4),
              ),
            ),
            Text(
              value,
              style: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}
