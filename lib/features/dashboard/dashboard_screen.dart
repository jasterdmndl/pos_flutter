import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../auth/auth_provider.dart';
import '../auth/login_screen.dart';
import '../pos/pos_screen.dart';
import '../pos/management_screen.dart';
import '../sales/sales_history_screen.dart';
import '../../core/theme/app_theme.dart';
import 'dashboard_provider.dart';
import 'dashboard_summary.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    // GUARD: Only admin/owner can see dashboards — cashier is POS-only
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (user.role != 'admin' && user.role != 'owner') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const PosScreen()),
          );
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final dashboard = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: AppTheme.bone,
      appBar: AppBar(
        title: Text('ANALYTICS ENGINE', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined, size: 20),
            tooltip: 'HISTORY',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SalesHistoryScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 20),
            tooltip: 'MANAGE',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ManagementScreen()),
            ),
          ),
          const VerticalDivider(width: 24, indent: 16, endIndent: 16),
          IconButton(
            icon: const Icon(Icons.logout_rounded, size: 20),
            tooltip: 'LOGOUT',
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
      body: dashboard.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (DashboardSummary data) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(dashboardProvider.future),
            child: ListView(
              padding: const EdgeInsets.all(32),
              children: [
                // HEADER
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Business Summary", style: GoogleFonts.fraunces(fontWeight: FontWeight.bold, fontSize: 30)),
                        const SizedBox(height: 4),
                        Text("Real-time performance metrics for Mire Sunset", style: TextStyle(color: AppTheme.ink.withOpacity(0.5))),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(color: AppTheme.ink.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8)),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 16, color: AppTheme.emerald),
                          const SizedBox(width: 12),
                          Text(DateFormat('MMMM dd, yyyy').format(DateTime.now()), style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ).animate().fadeIn().slideY(begin: -0.1),

                const SizedBox(height: 32),

                // KPI ROW
                LayoutBuilder(builder: (context, constraints) {
                  final cols = constraints.maxWidth > 1080 ? 4 : 2;
                  const gap = 20.0;
                  final cardWidth = (constraints.maxWidth - gap * (cols - 1)) / cols;

                  final sevenDayAvg = data.salesTrends.isEmpty
                      ? 0.0
                      : data.salesTrends.map((t) => t.amount).reduce((a, b) => a + b) / data.salesTrends.length;

                  final metrics = [
                    _KpiStat(
                      label: 'TODAY SALES',
                      value: '₱${NumberFormat('#,##0').format(data.todaySales)}',
                      caption: '7-day avg ₱${NumberFormat('#,##0').format(sevenDayAvg)} / day',
                      icon: Icons.payments_rounded,
                      index: 0,
                    ),
                    _KpiStat(
                      label: 'TOTAL ORDERS',
                      value: '${data.todayOrders}',
                      caption: 'transactions completed today',
                      icon: Icons.shopping_bag_rounded,
                      index: 1,
                    ),
                    _KpiStat(
                      label: 'AVG. ORDER',
                      value: '₱${NumberFormat('#,##0').format(data.averageOrder)}',
                      caption: 'revenue per transaction',
                      icon: Icons.analytics_rounded,
                      index: 2,
                    ),
                    _KpiStat(
                      label: 'TOP SELLER',
                      value: data.bestSeller.toUpperCase(),
                      caption: 'best performing product',
                      icon: Icons.star_rounded,
                      index: 3,
                      compactValue: true,
                    ),
                  ];

                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: metrics.map((m) => SizedBox(width: cardWidth, child: m)).toList(),
                  );
                }),

                const SizedBox(height: 24),

                // CHARTS ROW: SALES TRAJECTORY + PAYMENT DONUT
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _DashboardCard(
                        title: 'Sales Trajectory',
                        subtitle: 'Daily revenue over the last 7 days',
                        trailing: _PeriodChip(label: 'LAST 7 DAYS'),
                        contentHeight: 300,
                        child: _SalesTrajectoryChart(trends: data.salesTrends),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: _DashboardCard(
                        title: 'Payment Methods',
                        subtitle: 'Distribution of tender today',
                        contentHeight: 300,
                        child: _PaymentDonut(breakdowns: data.paymentBreakdowns),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.08),

                const SizedBox(height: 24),

                // BOTTOM ROW: TOP PRODUCTS + CASHIER PERFORMANCE
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _DashboardCard(
                        title: 'Top Products',
                        subtitle: 'Volume sold per item',
                        contentHeight: 300,
                        child: _TopProductsPanel(products: data.topProducts),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: _DashboardCard(
                        title: 'Cashier Performance',
                        subtitle: 'Daily sales volume per staff member',
                        contentHeight: 300,
                        child: _CashierTable(breakdowns: data.cashierBreakdowns),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.08),

                const SizedBox(height: 60),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ======================
// SHARED CARD & CHIPS
// ======================

class _DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;
  final Widget child;
  final double? contentHeight;

  const _DashboardCard({
    required this.title,
    required this.subtitle,
    required this.child,
    this.trailing,
    this.contentHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppTheme.ink.withOpacity(0.04), blurRadius: 24, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w800, fontSize: 17)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(color: AppTheme.ink.withOpacity(0.4), fontSize: 12.5)),
                  ],
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 12), trailing!],
            ],
          ),
          const SizedBox(height: 24),
          if (contentHeight != null)
            SizedBox(height: contentHeight, child: child)
          else
            child,
        ],
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  const _PeriodChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.mintSoft,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1, color: AppTheme.emeraldDeep),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppTheme.emeraldDeep),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: AppTheme.ink.withOpacity(0.15)),
          const SizedBox(height: 12),
          Text(
            message,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              color: AppTheme.ink.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================
// KPI STAT CARD
// ======================

class _KpiStat extends StatelessWidget {
  final String label;
  final String value;
  final String caption;
  final IconData icon;
  final int index;
  final bool compactValue;

  const _KpiStat({
    required this.label,
    required this.value,
    required this.caption,
    required this.icon,
    required this.index,
    this.compactValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppTheme.ink.withOpacity(0.04), blurRadius: 24, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.mintSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 24, color: AppTheme.emerald),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: AppTheme.ink.withOpacity(0.4)),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.spaceGrotesk(
              fontSize: compactValue ? 22 : 30,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: AppTheme.ink.withOpacity(0.35)),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 80).ms).slideY(begin: 0.1);
  }
}

// ======================
// SALES TRAJECTORY (GRADIENT BARS + GHOST AVG)
// ======================

class _SalesTrajectoryChart extends StatelessWidget {
  final List<SalesTrend> trends;
  const _SalesTrajectoryChart({required this.trends});

  @override
  Widget build(BuildContext context) {
    if (trends.isEmpty) return const _EmptyState(icon: Icons.bar_chart_rounded, message: 'NO SALES DATA YET');

    final maxAmount = trends.map((t) => t.amount).reduce((a, b) => a > b ? a : b);
    final avg = trends.map((t) => t.amount).reduce((a, b) => a + b) / trends.length;
    final maxY = (maxAmount > avg ? maxAmount : avg) * 1.2;

    return Column(
      children: [
        Expanded(
          child: BarChart(
            BarChartData(
              maxY: maxY,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (val) => FlLine(color: AppTheme.ink.withOpacity(0.05), strokeWidth: 1),
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= trends.length) return const SizedBox();
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          DateFormat('E').format(trends[index].date).toUpperCase(),
                          style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.ink.withOpacity(0.4)),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 48,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const SizedBox();
                      return Text(
                        NumberFormat.compact().format(value),
                        style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.ink.withOpacity(0.35)),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => AppTheme.ink,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    if (rod.toY == 0) return null;
                    final date = trends[group.x.toInt()].date;
                    return BarTooltipItem(
                      '${DateFormat('MMM d').format(date)}\n₱${NumberFormat('#,##0.00').format(rod.toY)}',
                      GoogleFonts.spaceGrotesk(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                    );
                  },
                ),
              ),
              barGroups: trends.asMap().entries.map((e) {
                return BarChartGroupData(
                  x: e.key,
                  barsSpace: 6,
                  barRods: [
                    BarChartRodData(
                      toY: avg,
                      color: AppTheme.mintSoft,
                      width: 14,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                    ),
                    BarChartRodData(
                      toY: e.value.amount,
                      width: 14,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [AppTheme.emeraldDeep, AppTheme.emerald],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ChartLegendDot(color: AppTheme.mintSoft, label: '7-DAY AVG'),
            const SizedBox(width: 20),
            _ChartLegendDot(color: AppTheme.emerald, label: 'DAILY SALES'),
          ],
        ),
      ],
    );
  }
}

class _ChartLegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _ChartLegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1, color: AppTheme.ink.withOpacity(0.45)),
        ),
      ],
    );
  }
}

// ======================
// PAYMENT METHODS DONUT
// ======================

class _PaymentDonut extends StatelessWidget {
  final List<PaymentBreakdown> breakdowns;
  const _PaymentDonut({required this.breakdowns});

  static const _palette = [
    AppTheme.emerald,
    Color(0xFF4C9F70),
    AppTheme.emeraldDeep,
    Color(0xFF9DCBAC),
    Color(0xFF8A9188),
  ];

  @override
  Widget build(BuildContext context) {
    if (breakdowns.isEmpty) return const _EmptyState(icon: Icons.pie_chart_rounded, message: 'NO PAYMENTS YET');

    final total = breakdowns.map((e) => e.amount).reduce((a, b) => a + b);

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 52,
                  sections: breakdowns.asMap().entries.map((e) {
                    final fraction = total == 0 ? 0.0 : e.value.amount / total;
                    return PieChartSectionData(
                      value: e.value.amount,
                      color: _palette[e.key % _palette.length],
                      radius: 42,
                      showTitle: fraction >= 0.08,
                      title: '${(fraction * 100).toStringAsFixed(0)}%',
                      titleStyle: GoogleFonts.spaceGrotesk(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.white),
                    );
                  }).toList(),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'TODAY',
                      style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: AppTheme.ink.withOpacity(0.35)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₱${NumberFormat.compact().format(total)}',
                      style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: breakdowns.asMap().entries.map((e) {
            final fraction = total == 0 ? 0.0 : e.value.amount / total;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _palette[e.key % _palette.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      e.value.method.toUpperCase(),
                      style: GoogleFonts.spaceGrotesk(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5, color: AppTheme.ink.withOpacity(0.55)),
                    ),
                  ),
                  Text(
                    '₱${NumberFormat('#,##0.00').format(e.value.amount)}',
                    style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 38,
                    child: Text(
                      '${(fraction * 100).toStringAsFixed(0)}%',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.spaceGrotesk(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.ink.withOpacity(0.35)),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ======================
// TOP PRODUCTS (VOLUME BARS)
// ======================

class _TopProductsPanel extends StatelessWidget {
  final List<TopProduct> products;
  const _TopProductsPanel({required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const _EmptyState(icon: Icons.inventory_2_rounded, message: 'NO PRODUCTS SOLD YET');

    final maxQty = products.map((p) => p.quantity).reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: products.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final p = products[index];
              final fraction = maxQty == 0 ? 0.0 : p.quantity / maxQty;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          p.name.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'x${p.quantity}',
                        style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.ink.withOpacity(0.4)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LayoutBuilder(builder: (context, constraints) {
                    return Stack(
                      children: [
                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppTheme.ink.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        Container(
                          height: 10,
                          width: constraints.maxWidth * fraction,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: const LinearGradient(
                              colors: [AppTheme.emeraldDeep, AppTheme.emerald],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

// ======================
// CASHIER PERFORMANCE TABLE
// ======================

class _CashierTable extends StatelessWidget {
  final List<CashierBreakdown> breakdowns;
  const _CashierTable({required this.breakdowns});

  @override
  Widget build(BuildContext context) {
    if (breakdowns.isEmpty) return const _EmptyState(icon: Icons.people_alt_rounded, message: 'NO CASHIER ACTIVITY YET');

    return Column(
      children: [
        // TABLE HEADER
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              const SizedBox(width: 46),
              Expanded(
                child: Text(
                  'CASHIER',
                  style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: AppTheme.ink.withOpacity(0.35)),
                ),
              ),
              SizedBox(
                width: 60,
                child: Text(
                  'ORDERS',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: AppTheme.ink.withOpacity(0.35)),
                ),
              ),
              SizedBox(
                width: 110,
                child: Text(
                  'SALES',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: AppTheme.ink.withOpacity(0.35)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: breakdowns.length,
            separatorBuilder: (context, index) => Divider(color: AppTheme.ink.withOpacity(0.06), height: 1),
            itemBuilder: (context, index) {
              final b = breakdowns[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppTheme.mintSoft,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          b.name.isNotEmpty ? b.name[0].toUpperCase() : '?',
                          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, fontSize: 14, color: AppTheme.emerald),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        b.name.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w800, fontSize: 13),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        '${b.orders}',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.spaceGrotesk(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.ink.withOpacity(0.5)),
                      ),
                    ),
                    SizedBox(
                      width: 110,
                      child: Text(
                        '₱${NumberFormat('#,##0.00').format(b.sales)}',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, fontSize: 14, color: AppTheme.emerald),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
