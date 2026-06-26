import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import 'order_details_screen.dart';
import 'sales_provider.dart';

class SalesHistoryScreen extends ConsumerWidget {
  const SalesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(salesHistoryProvider);

    return Scaffold(
      backgroundColor: AppTheme.bone,
      appBar: AppBar(
        title: Text('SALES LEDGER', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 16)),
      ),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) return _NoSalesState();

          final activeOrders = orders.where((o) => !o.isVoided).toList();
          final totalRevenue = activeOrders.fold<double>(0, (sum, order) => sum + order.total);

          return Column(
            children: [
              // SUMMARY HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1.5)),
                ),
                child: Row(
                  children: [
                    _SummaryStat(label: 'TOTAL ORDERS', value: '${orders.length}'),
                    const SizedBox(width: 48),
                    _SummaryStat(label: 'VOIDED', value: '${orders.length - activeOrders.length}', color: AppTheme.error),
                    const Spacer(),
                    _SummaryStat(label: 'NET REVENUE', value: '₱${totalRevenue.toStringAsFixed(2)}', isPrimary: true),
                  ],
                ),
              ),

              // LIST
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _OrderHistoryTile(order: order);
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool isPrimary;

  const _SummaryStat({required this.label, required this.value, this.color, this.isPrimary = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.spaceGrotesk(fontSize: 10, color: AppTheme.ink.withOpacity(0.4), fontWeight: FontWeight.w900, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: isPrimary ? 28 : 20,
            fontWeight: FontWeight.w900,
            color: color ?? (isPrimary ? AppTheme.emerald : AppTheme.ink),
          ),
        ),
      ],
    );
  }
}

class _OrderHistoryTile extends StatelessWidget {
  final dynamic order;
  const _OrderHistoryTile({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.ink.withOpacity(0.08), width: 1.5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        title: Row(
          children: [
            Text(order.receiptNumber, style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, letterSpacing: 0.5)),
            if (order.isVoided) ...[
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppTheme.error.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                child: Text('VOIDED', style: GoogleFonts.spaceGrotesk(color: AppTheme.error, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1)),
              ),
            ],
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(order.createdAt.toString().split('.')[0], style: TextStyle(color: AppTheme.ink.withOpacity(0.4), fontSize: 13)),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₱${order.total.toStringAsFixed(2)}',
              style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                decoration: order.isVoided ? TextDecoration.lineThrough : null,
                color: order.isVoided ? AppTheme.ink.withOpacity(0.2) : AppTheme.ink,
              ),
            ),
            Text(order.paymentMethod.toUpperCase(), style: GoogleFonts.spaceGrotesk(fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1, color: AppTheme.ink.withOpacity(0.3))),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => OrderDetailsScreen(order: order)),
          );
        },
      ),
    );
  }
}

class _NoSalesState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_outlined, size: 80, color: AppTheme.emerald.withOpacity(0.1)),
          const SizedBox(height: 24),
          Text(
            'NO TRANSACTIONS RECORDED',
            style: GoogleFonts.spaceGrotesk(
              letterSpacing: 2,
              fontWeight: FontWeight.w900,
              color: AppTheme.emerald.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}
