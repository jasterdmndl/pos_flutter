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
import 'dashboard_summary.dart';

class MobileOwnerDashboard extends ConsumerWidget {
  const MobileOwnerDashboard({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveOrders = ref.watch(liveOrdersProvider);
    final summaryAsync = ref.watch(remoteDashboardProvider);
    final user = ref.watch(authProvider);

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
              'REMOTE MONITOR',
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
            // 1. WELCOME HEADER
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${_getGreeting()}, ${user?.name.split(' ')[0] ?? 'Owner'}",
                      style: GoogleFonts.fraunces(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.ink,
                      ),
                    ).animate().fadeIn().slideX(begin: -0.1),
                    const SizedBox(height: 4),
                    Text(
                      "Here is what's happening at your terminal today.",
                      style: TextStyle(color: AppTheme.ink.withValues(alpha: 0.5), fontSize: 13),
                    ).animate().fadeIn(delay: 200.ms),
                  ],
                ),
              ),
            ),

            // 2. PRIMARY STATS
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
                        index: 0,
                      ),
                      const SizedBox(width: 16),
                      _CompactMetric(
                        label: "TOTAL ORDERS",
                        value: "${data.todayOrders}",
                        icon: Icons.shopping_bag_outlined,
                        index: 1,
                      ),
                    ],
                  ),
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: LinearProgressIndicator(),
                ),
                error: (_, __) => const SizedBox(),
              ),
            ),

            // 3. ANALYTICS QUICK VIEW (Step 3 Addition)
            SliverToBoxAdapter(
              child: summaryAsync.when(
                data: (data) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _AnalyticsStrip(data: data),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),
            ),

            // 4. LIVE FEED HEADER
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

            // 5. LIVE FEED LIST
            liveOrders.when(
              data: (orders) {
                if (orders.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox_outlined, size: 48, color: AppTheme.ink.withValues(alpha: 0.1)),
                          const SizedBox(height: 16),
                          const Text("No orders found today.", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final order = orders[index];
                        final isVoided = order['is_voided'] == true;
                        final timestamp = DateTime.parse(order['created_at']);
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
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
                                      style: TextStyle(fontSize: 11, color: AppTheme.ink.withValues(alpha: 0.4), fontWeight: FontWeight.bold),
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "₱${(order['total'] as num).toStringAsFixed(2)}",
                                    style: GoogleFonts.spaceGrotesk(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                      color: isVoided ? AppTheme.ink.withValues(alpha: 0.3) : AppTheme.emerald,
                                      decoration: isVoided ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                  Text(
                                    (order['payment_method'] as String).toUpperCase(),
                                    style: GoogleFonts.spaceGrotesk(fontSize: 8, fontWeight: FontWeight.w900, color: AppTheme.ink.withValues(alpha: 0.3)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.05);
                      },
                      childCount: orders.length,
                    ),
                  ),
                );
              },
              loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
              error: (err, _) => SliverFillRemaining(child: Center(child: Text("Stream Error: $err"))),
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
  final int index;

  const _CompactMetric({required this.label, required this.value, required this.icon, required this.index});

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
              style: GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.1),
    );
  }
}

class _AnalyticsStrip extends StatelessWidget {
  final DashboardSummary data;
  const _AnalyticsStrip({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.emerald,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.emerald.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "TOP PRODUCT",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.bestSeller.toUpperCase(),
                  style: GoogleFonts.fraunces(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            width: 1.5,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "AVG TICKET",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "₱${data.averageOrder.toStringAsFixed(0)}",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1);
  }
}
