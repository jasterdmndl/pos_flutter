import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import 'dashboard_provider.dart';
import 'dashboard_summary.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.bone,
      appBar: AppBar(
        title: Text('ANALYTICS ENGINE', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 16)),
        centerTitle: true,
      ),
      body: dashboard.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (DashboardSummary data) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(dashboardProvider);
              await ref.refresh(dashboardProvider.future);
            },
            child: ListView(
              padding: const EdgeInsets.all(40),
              children: [
                // HEADER
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Business Summary", style: theme.textTheme.headlineLarge),
                        Text("Real-time performance metrics for Mire Sunset", style: TextStyle(color: AppTheme.ink.withOpacity(0.5))),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.ink.withOpacity(0.1)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16),
                          const SizedBox(width: 12),
                          Text(DateFormat('MMMM dd, yyyy').format(DateTime.now()), style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ).animate().fadeIn().slideY(begin: -0.2),

                const SizedBox(height: 48),

                // METRICS ROW
                Row(
                  children: [
                    _BoutiqueMetric(
                      label: 'TODAY SALES',
                      value: '₱${data.todaySales.toStringAsFixed(0)}',
                      icon: Icons.payments_outlined,
                      index: 0,
                    ),
                    const SizedBox(width: 24),
                    _BoutiqueMetric(
                      label: 'TOTAL ORDERS',
                      value: '${data.todayOrders}',
                      icon: Icons.shopping_bag_outlined,
                      index: 1,
                    ),
                    const SizedBox(width: 24),
                    _BoutiqueMetric(
                      label: 'AVG. ORDER',
                      value: '₱${data.averageOrder.toStringAsFixed(0)}',
                      icon: Icons.analytics_outlined,
                      index: 2,
                    ),
                    const SizedBox(width: 24),
                    _BoutiqueMetric(
                      label: 'TOP SELLER',
                      value: data.bestSeller.toUpperCase(),
                      icon: Icons.star_outline_rounded,
                      index: 3,
                    ),
                  ],
                ),
                
                const SizedBox(height: 48),

                // TREND CHART
                _DashboardSection(
                  title: 'SALES TRAJECTORY',
                  subtitle: '7-day revenue performance',
                  child: SalesTrendChart(trends: data.salesTrends),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),

                const SizedBox(height: 48),

                // BOTTOM GRID
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _DashboardSection(
                        title: 'TOP PRODUCTS',
                        subtitle: 'Volume sold per item',
                        child: TopProductsChart(products: data.topProducts),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 2,
                      child: _DashboardSection(
                        title: 'PAYMENT METHODS',
                        subtitle: 'Distribution of tender',
                        child: PaymentBreakdownChart(breakdowns: data.paymentBreakdowns),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),
                
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BoutiqueMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final int index;

  const _BoutiqueMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.ink.withOpacity(0.08), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: AppTheme.emerald),
                const SizedBox(width: 12),
                Text(label, style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1, color: AppTheme.ink.withOpacity(0.4))),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              value,
              style: GoogleFonts.spaceGrotesk(fontSize: 32, fontWeight: FontWeight.w900),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.1),
    );
  }
}

class _DashboardSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  const _DashboardSection({required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.ink.withOpacity(0.08), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, letterSpacing: 2)),
          Text(subtitle, style: TextStyle(color: AppTheme.ink.withOpacity(0.4), fontSize: 13)),
          const SizedBox(height: 48),
          SizedBox(height: 300, child: child),
        ],
      ),
    );
  }
}

// ======================
// RE-STYLED CHARTS (SOLID COLORS)
// ======================

class SalesTrendChart extends StatelessWidget {
  final List<SalesTrend> trends;
  const SalesTrendChart({super.key, required this.trends});

  @override
  Widget build(BuildContext context) {
    if (trends.isEmpty) return const Center(child: Text('NO DATA'));
    
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true, 
          drawVerticalLine: false,
          getDrawingHorizontalLine: (val) => FlLine(color: AppTheme.ink.withOpacity(0.05), strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= trends.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(DateFormat('E').format(trends[index].date).toUpperCase(), style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.bold)),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 60)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: trends.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.amount)).toList(),
            isCurved: false, // Straight lines for a more technical "boutique" feel
            color: AppTheme.emerald,
            barWidth: 6,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}

class TopProductsChart extends StatelessWidget {
  final List<TopProduct> products;
  const TopProductsChart({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const Center(child: Text('NO DATA'));

    return BarChart(
      BarChartData(
        barGroups: products.asMap().entries.map((e) => BarChartGroupData(
          x: e.key,
          barRods: [
            BarChartRodData(
              toY: e.value.quantity.toDouble(),
              color: AppTheme.emerald,
              width: 40,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        )).toList(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= products.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(products[index].name.toUpperCase(), style: GoogleFonts.spaceGrotesk(fontSize: 9, fontWeight: FontWeight.bold)),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}

class PaymentBreakdownChart extends StatelessWidget {
  final List<PaymentBreakdown> breakdowns;
  const PaymentBreakdownChart({super.key, required this.breakdowns});

  @override
  Widget build(BuildContext context) {
    if (breakdowns.isEmpty) return const Center(child: Text('NO DATA'));
    
    return PieChart(
      PieChartData(
        sections: breakdowns.asMap().entries.map((e) {
          final colors = [AppTheme.emerald, AppTheme.emeraldDeep, AppTheme.ink, const Color(0xFF4A4A4A)];
          return PieChartSectionData(
            value: e.value.amount,
            title: '${e.value.method.toUpperCase()}\n₱${e.value.amount.toStringAsFixed(0)}',
            color: colors[e.key % colors.length],
            radius: 100,
            titleStyle: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white),
          );
        }).toList(),
        sectionsSpace: 4,
        centerSpaceRadius: 0, // Solid pie for boutique feel
      ),
    );
  }
}
