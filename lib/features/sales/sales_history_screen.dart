import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'order_details_screen.dart';
import 'sales_provider.dart';

class SalesHistoryScreen extends ConsumerWidget {
  const SalesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync =
    ref.watch(salesHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales History'),
      ),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(
              child: Text('No sales yet'),
            );
          }

          final activeOrders = orders.where((o) => !o.isVoided).toList();
          final totalRevenue = activeOrders.fold<double>(
            0,
                (sum, order) => sum + order.total,
          );

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.brown.shade50,
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Valid Orders: ${activeOrders.length} / Total: ${orders.length}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Net Revenue: ₱${totalRevenue.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];

                    return Card(
                      margin:
                      const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      color: order.isVoided ? Colors.red[50] : null,
                      child: ListTile(
                        title: Row(
                          children: [
                            Text(
                              order.receiptNumber,
                            ),
                            if (order.isVoided) ...[
                              const SizedBox(width: 8),
                              const Text(
                                '[VOIDED]',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                        subtitle: Text(
                          order.createdAt
                              .toString(),
                        ),
                        trailing: Text(
                          '₱${order.total.toStringAsFixed(2)}',
                          style:
                          const TextStyle(
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderDetailsScreen(
                                order: order,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },

        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (error, stack) =>
            Center(
              child: Text(
                error.toString(),
              ),
            ),
      ),
    );
  }
}