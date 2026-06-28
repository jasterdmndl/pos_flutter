import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      title: Text('SALES INVOICE', style: GoogleFonts.fraunces(fontWeight: FontWeight.bold)),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'MIRE SUNSET',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const Center(child: Text('123 Cafe Street, Manila', style: TextStyle(fontSize: 12))),
              const Center(child: Text('TIN: 000-000-000-000', style: TextStyle(fontSize: 12))),

              const Divider(height: 32),

              Center(
                child: Text(
                  'INV-${order.createdAt.year}-${order.id.padLeft(6, '0')}',
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
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Divider(),

              _SummaryRow(label: 'Subtotal', value: order.subtotal),
              _SummaryRow(label: 'Discount', value: order.discountAmount),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('₱${order.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),

              const Divider(height: 32),
              const Text('TAX BREAKDOWN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 4),
              _TaxRow(label: 'VATable Sales', value: order.total / 1.12),
              _TaxRow(label: 'VAT Amount (12%)', value: order.total - (order.total / 1.12)),

              const SizedBox(height: 24),

              Text(
                'Payment: ${order.paymentMethod.name.toUpperCase()}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              Text(
                order.createdAt.toString().split('.')[0],
                style: const TextStyle(color: Colors.grey, fontSize: 12),
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
                receiptNumber: 'INV-${order.createdAt.year}-${order.id.padLeft(6, '0')}',
                subtotal: order.subtotal,
                discountAmount: order.discountAmount,
                total: order.total,
                vatableSales: order.total / 1.12,
                vatAmount: order.total - (order.total / 1.12),
                exemptSales: 0,
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

              await PdfReceiptService().printReceipt(receipt);

            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Printing Error: $e')));
              }
            }
          },
          child: const Text('Print Invoice'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text('₱${value.toStringAsFixed(2)}'),
      ],
    );
  }
}

class _TaxRow extends StatelessWidget {
  final String label;
  final double value;
  const _TaxRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Text('₱${value.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
