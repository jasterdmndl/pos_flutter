import 'package:flutter/material.dart';

import '../checkout/checkout_model.dart';
import 'receipt_data.dart';
import 'pdf_receipt_service.dart';

class ReceiptDialog extends StatelessWidget {
  final Order order;

  const ReceiptDialog({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Receipt'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'CAFE POS',
                  style: TextStyle(
                    fontWeight:
                    FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),

              const Divider(),

              Center(
                child: Text(
                  'OR-${order.createdAt.year}-${order.id.padLeft(6, '0')}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              ...order.items.map(
                    (item) => Padding(
                  padding:
                  const EdgeInsets.only(
                      bottom: 12),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${item.product.name} x${item.quantity}',
                            ),
                          ),
                          Text(
                            '₱${item.subtotal.toStringAsFixed(2)}',
                          ),
                        ],
                      ),

                      ...item.addons.map(
                            (addon) => Padding(
                          padding:
                          const EdgeInsets.only(
                              left: 16),
                          child: Text(
                            '+ ${addon.name} x${addon.quantity}',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                  fontWeight:
                  FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Payment: ${order.paymentMethod.name.toUpperCase()}',
              ),

              Text(
                order.createdAt.toString(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            try {
              final receipt = ReceiptData(
                orderId: int.tryParse(order.id) ?? 0,

                receiptNumber:
                'OR-${order.createdAt.year}-${order.id.padLeft(6, '0')}',

                subtotal: order.subtotal,
                discountAmount: order.discountAmount,
                total: order.total,
                paymentMethod: order.paymentMethod.name,
                createdAt: order.createdAt,
                items: order.items.map((item) {
                  return ReceiptItem(
                    productName: item.product.name,
                    quantity: item.quantity,
                    subtotal: item.subtotal,
                    addons: item.addons.map((addon) {
                      return ReceiptAddon(
                        name: addon.name,
                        quantity: addon.quantity,
                        subtotal: addon.subtotal,
                      );
                    }).toList(),
                  );
                }).toList(),
              );

              await PdfReceiptService()
                  .printReceipt(receipt);

            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content: Text(
                      'Printing Error: $e',
                    ),
                  ),
                );
              }
            }
          },
          child: const Text(
            'Print Receipt',
          ),
        ),

        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Close',
          ),
        ),
      ],
    );
  }
}