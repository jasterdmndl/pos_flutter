import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/database/collections/order_entity.dart';
import '../../core/database/collections/order_item_entity.dart';
import '../../core/database/collections/order_addon_entity.dart';
import '../../core/theme/app_theme.dart';
import '../receipts/pdf_receipt_service.dart';
import '../receipts/receipt_repository.dart';
import '../orders/order_provider.dart';
import '../dashboard/dashboard_provider.dart';
import 'sales_provider.dart';
import 'sales_repository.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  final OrderEntity order;

  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  ConsumerState<OrderDetailsScreen> createState() =>
      _OrderDetailsScreenState();
}

class _OrderDetailsScreenState
    extends ConsumerState<OrderDetailsScreen> {
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
      backgroundColor: AppTheme.bone,
      appBar: AppBar(
        title: Text(order.receiptNumber, style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, letterSpacing: 1)),
        actions: [
          _ActionBtn(
            icon: Icons.print_outlined,
            onTap: () async => _printReceipt(context, order),
          ),
          _ActionBtn(
            icon: Icons.picture_as_pdf_outlined,
            onTap: () async => _savePdf(context, order),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: FutureBuilder<List<OrderItemEntity>>(
        future: itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data ?? [];

          return ListView(
            padding: const EdgeInsets.all(40),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LEFT: DETAILS CARD
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("TRANSACTION DETAILS", style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, letterSpacing: 2, color: AppTheme.ink.withOpacity(0.4))),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppTheme.ink.withOpacity(0.08), width: 1.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _DetailRow(label: "DATE", value: order.createdAt.toString().split('.')[0]),
                              _DetailRow(label: "PAYMENT", value: order.paymentMethod.toUpperCase()),
                              _DetailRow(label: "STATUS", value: order.isVoided ? "VOIDED" : "COMPLETED", color: order.isVoided ? AppTheme.error : AppTheme.emerald),
                              if (order.isVoided) _DetailRow(label: "VOID REASON", value: order.voidReason ?? "N/A"),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Divider(),
                              ),
                              _DetailRow(label: "SUBTOTAL", value: "₱${order.subtotal.toStringAsFixed(2)}"),
                              _DetailRow(label: "DISCOUNT", value: "₱${order.discountAmount.toStringAsFixed(2)}"),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("TOTAL", style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, fontSize: 24)),
                                  Text("₱${order.total.toStringAsFixed(2)}", style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, fontSize: 32, color: AppTheme.emerald)),
                                ],
                              ),
                            ],
                          ),
                        ).animate().fadeIn().slideX(begin: -0.05),
                        
                        if (!order.isVoided) ...[
                          const SizedBox(height: 48),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => _showVoidDialog(context),
                              icon: const Icon(Icons.cancel_outlined, size: 18),
                              label: const Text("VOID TRANSACTION"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red[400],
                                side: BorderSide(color: Colors.red.withOpacity(0.2), width: 2),
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ).animate().fadeIn(delay: 400.ms),
                        ],
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 48),

                  // RIGHT: ITEMS
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ORDER ITEMS", style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, letterSpacing: 2, color: AppTheme.ink.withOpacity(0.4))),
                        const SizedBox(height: 24),
                        ...items.map((item) => _OrderItemBoutiqueCard(item: item).animate().fadeIn().slideX(begin: 0.05)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _printReceipt(BuildContext context, OrderEntity order) async {
    try {
      final receipt = await ReceiptRepository().getReceipt(order.id);
      if (receipt != null) await PdfReceiptService().printReceipt(receipt);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _savePdf(BuildContext context, OrderEntity order) async {
    try {
      final receipt = await ReceiptRepository().getReceipt(order.id);
      if (receipt != null) {
        final file = await PdfReceiptService().saveReceiptPdf(receipt);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF saved: ${file.path}')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _showVoidDialog(BuildContext context) async {
    final reasonController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('VOID TRANSACTION', style: GoogleFonts.fraunces(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(labelText: 'Reason for voiding', hintText: 'e.g., Input error'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('CONFIRM VOID'),
          ),
        ],
      ),
    );

    if (result == true && reasonController.text.isNotEmpty) {
      await ref.read(orderRepositoryProvider).voidOrder(widget.order.id, reasonController.text);
      ref.invalidate(salesHistoryProvider);
      ref.invalidate(dashboardProvider);
      if (mounted) Navigator.pop(context);
    }
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: IconButton(
        icon: Icon(icon, color: AppTheme.ink.withOpacity(0.6)),
        onPressed: onTap,
        style: IconButton.styleFrom(
          hoverColor: AppTheme.emerald.withOpacity(0.05),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const _DetailRow({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.spaceGrotesk(fontSize: 11, fontWeight: FontWeight.w900, color: AppTheme.ink.withOpacity(0.3), letterSpacing: 1)),
          Text(value, style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, color: color ?? AppTheme.ink)),
        ],
      ),
    );
  }
}

class _OrderItemBoutiqueCard extends StatelessWidget {
  final OrderItemEntity item;
  const _OrderItemBoutiqueCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.ink.withOpacity(0.08), width: 1.5),
      ),
      child: FutureBuilder<List<OrderAddonEntity>>(
        future: SalesRepository().getAddons(item.id),
        builder: (context, snapshot) {
          final addons = snapshot.data ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${item.productName.toUpperCase()}  × ${item.quantity}",
                    style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                  Text(
                    "₱${item.subtotal.toStringAsFixed(2)}",
                    style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                ],
              ),
              if (addons.isNotEmpty) ...[
                const SizedBox(height: 12),
                ...addons.map((a) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text("+ ${a.addonName} (x${a.quantity})", style: TextStyle(fontSize: 12, color: AppTheme.ink.withOpacity(0.4))),
                )),
              ],
            ],
          );
        },
      ),
    );
  }
}
