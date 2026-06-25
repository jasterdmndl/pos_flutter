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

          final totalRevenue = orders.fold<double>(
            0,
                (sum, order) => sum + order.total,
          );

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Orders: ${orders.length}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Revenue: ₱${totalRevenue.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
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
                      child: ListTile(
                        title: Text(
                          order.receiptNumber,
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