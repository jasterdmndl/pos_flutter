import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'dashboard_provider.dart';
import 'dashboard_summary.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final dashboard = ref.watch(dashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Business Dashboard',
        ),
        centerTitle: true,
      ),
      body: dashboard.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
          ),
        ),
        data: (DashboardSummary data) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(
                dashboardProvider,
              );

              await ref.refresh(
                dashboardProvider.future,
              );
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ======================
                // SALES SUMMARY CARDS
                // ======================
                Row(
                  children: [
                    Expanded(
                      child: DashboardCard(
                        title: 'Today Sales',
                        value: '₱${data.todaySales.toStringAsFixed(2)}',
                        icon: Icons.payments,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DashboardCard(
                        title: 'Orders Today',
                        value: '${data.todayOrders}',
                        icon: Icons.receipt_long,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DashboardCard(
                        title: 'Average Order',
                        value: '₱${data.averageOrder.toStringAsFixed(2)}',
                        icon: Icons.analytics,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DashboardCard(
                        title: 'Best Seller',
                        value: data.bestSeller,
                        icon: Icons.local_cafe,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ======================
                // SALES TRENDS CHART
                // ======================
                const SectionHeader(title: 'Sales Trends (Last 7 Days)'),
                const SizedBox(height: 12),
                SizedBox(
                  height: 300,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SalesTrendChart(trends: data.salesTrends),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ======================
                // TOP PRODUCTS & PAYMENT BREAKDOWN
                // ======================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionHeader(title: 'Top Products'),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 300,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TopProductsChart(products: data.topProducts),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionHeader(title: 'Payment Breakdown'),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 300,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: PaymentBreakdownChart(
                                    breakdowns: data.paymentBreakdowns),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 36),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesTrendChart extends StatelessWidget {
  final List<SalesTrend> trends;
  const SalesTrendChart({super.key, required this.trends});

  @override
  Widget build(BuildContext context) {
    if (trends.isEmpty) return const Center(child: Text('No data available'));

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= trends.length) return const Text('');
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    DateFormat('E').format(trends[index].date),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: trends
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.amount))
                .toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withValues(alpha: 0.3),
            ),
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
    if (products.isEmpty) return const Center(child: Text('No data available'));

    return BarChart(
      BarChartData(
        barGroups: products
            .asMap()
            .entries
            .map((e) => BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value.quantity.toDouble(),
                      color: Colors.orange,
                      width: 20,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ))
            .toList(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= products.length) return const Text('');
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    products[index].name,
                    style: const TextStyle(fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 30),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
      ),
    );
  }
}

class PaymentBreakdownChart extends StatelessWidget {
  final List<PaymentBreakdown> breakdowns;
  const PaymentBreakdownChart({super.key, required this.breakdowns});

  @override
  Widget build(BuildContext context) {
    if (breakdowns.isEmpty) return const Center(child: Text('No data available'));

    return PieChart(
      PieChartData(
        sections: breakdowns.asMap().entries.map((e) {
          final colors = [Colors.green, Colors.blue, Colors.purple, Colors.orange];
          return PieChartSectionData(
            value: e.value.amount,
            title: '${e.value.method}\n₱${e.value.amount.toStringAsFixed(0)}',
            color: colors[e.key % colors.length],
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }
}
