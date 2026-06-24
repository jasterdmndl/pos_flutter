import 'package:flutter/material.dart';
import '../../core/database/collections/order_entity.dart';
import '../../core/database/collections/order_item_entity.dart';
import '../../core/database/collections/order_addon_entity.dart';
import '../receipts/pdf_receipt_service.dart';
import '../receipts/receipt_repository.dart';
import '../receipts/receipt_data.dart';


import 'sales_repository.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderEntity order;

  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  State<OrderDetailsScreen> createState() =>
      _OrderDetailsScreenState();
}

class _OrderDetailsScreenState
    extends State<OrderDetailsScreen> {
  final repository = SalesRepository();

  late Future<List<OrderItemEntity>> itemsFuture;

  @override
  void initState() {
    super.initState();

    itemsFuture = repository.getOrderItems(
      widget.order.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order #${order.id}',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            tooltip: 'Print Receipt',
            onPressed: () async {
              try {
                final receipt =
                await ReceiptRepository()
                    .getReceipt(order.id);

                if (receipt == null) {
                  return;
                }

                await PdfReceiptService()
                    .printReceipt(receipt);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error: $e',
                      ),
                    ),
                  );
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Save PDF',
            onPressed: () async {
              try {
                final receipt =
                await ReceiptRepository()
                    .getReceipt(order.id);

                if (receipt == null) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Receipt not found',
                        ),
                      ),
                    );
                  }
                  return;
                }

                final file =
                await PdfReceiptService()
                    .saveReceiptPdf(receipt);

                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        'PDF saved:\n${file.path}',
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error: $e',
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<OrderItemEntity>>(
        future: itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            );
          }

          final items = snapshot.data ?? [];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ORDER SUMMARY

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.id}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'Date: ${order.createdAt}',
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Payment: ${order.paymentMethod}',
                      ),

                      const Divider(),

                      Text(
                        'Subtotal: ₱${order.subtotal.toStringAsFixed(2)}',
                      ),

                      Text(
                        'Discount: ₱${order.discountAmount.toStringAsFixed(2)}',
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Total: ₱${order.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Items',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // ORDER ITEMS

              ...items.map(
                    (item) => OrderItemCard(
                  item: item,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class OrderItemCard extends StatelessWidget {
  final OrderItemEntity item;

  const OrderItemCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final repository = SalesRepository();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: FutureBuilder<List<OrderAddonEntity>>(
          future: repository.getAddons(item.id),
          builder: (context, snapshot) {
            final addons = snapshot.data ?? [];

            return Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${item.productName} x${item.quantity}',
                        style: const TextStyle(
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    Text(
                      '₱${item.subtotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                if (addons.isEmpty)
                  const Text(
                    'No Add-ons',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                ...addons.map(
                      (addon) => Padding(
                    padding:
                    const EdgeInsets.only(
                        left: 12,
                        bottom: 4),
                    child: Text(
                      '+ ${addon.addonName} x${addon.quantity}',
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}