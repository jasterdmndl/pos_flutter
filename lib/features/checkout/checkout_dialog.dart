import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../receipts/receipt_dialog.dart';
import '../cart/cart_provider.dart';
import '../discounts/discount_model.dart';
import 'checkout_controller.dart';
import 'checkout_model.dart';

class CheckoutDialog extends ConsumerStatefulWidget {
  const CheckoutDialog({super.key});

  @override
  ConsumerState<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends ConsumerState<CheckoutDialog> {
  PaymentMethod selectedMethod = PaymentMethod.cash;
  DiscountType selectedDiscount = DiscountType.none;

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final theme = Theme.of(context);

    final subtotal = cart.fold<double>(0, (sum, item) => sum + item.subtotal);
    final discountAmount = subtotal * selectedDiscount.rate;
    final total = subtotal - discountAmount;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 100, vertical: 40),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            // LEFT: SUMMARY (DARK EMERALD)
            Expanded(
              flex: 4,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppTheme.emerald,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.all(48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "REVIEW\nORDER",
                      style: GoogleFonts.fraunces(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 0.9,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(width: 40, height: 4, color: Colors.white.withOpacity(0.3)),
                    const SizedBox(height: 48),
                    Expanded(
                      child: ListView.separated(
                        itemCount: cart.length,
                        separatorBuilder: (_, __) => Divider(color: Colors.white.withOpacity(0.1), height: 32),
                        itemBuilder: (context, index) {
                          final item = cart[index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name.toUpperCase(),
                                    style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "QTY: ${item.quantity}",
                                    style: GoogleFonts.spaceGrotesk(color: Colors.white.withOpacity(0.5), fontSize: 12),
                                  ),
                                ],
                              ),
                              Text(
                                "₱${item.subtotal.toStringAsFixed(2)}",
                                style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    _WhiteAmountRow(label: "SUBTOTAL", amount: subtotal),
                    _WhiteAmountRow(label: "DISCOUNT", amount: discountAmount, isNegative: true),
                    const Divider(color: Colors.white24, height: 48),
                    _WhiteAmountRow(label: "TOTAL", amount: total, isBold: true),
                  ],
                ),
              ),
            ),

            // RIGHT: ACTIONS
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("SET PAYMENT", style: theme.textTheme.labelLarge),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _BoutiquePaymentOption(
                          label: 'CASH',
                          icon: Icons.payments_outlined,
                          isSelected: selectedMethod == PaymentMethod.cash,
                          onTap: () => setState(() => selectedMethod = PaymentMethod.cash),
                        ),
                        const SizedBox(width: 16),
                        _BoutiquePaymentOption(
                          label: 'GCASH',
                          icon: Icons.qr_code_scanner,
                          isSelected: selectedMethod == PaymentMethod.gcash,
                          onTap: () => setState(() => selectedMethod = PaymentMethod.gcash),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    Text("APPLY PRIVILEGE", style: theme.textTheme.labelLarge),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<DiscountType>(
                      value: selectedDiscount,
                      style: GoogleFonts.spaceGrotesk(color: AppTheme.ink, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppTheme.ink.withOpacity(0.1), width: 2),
                        ),
                      ),
                      items: DiscountType.values.map((type) {
                        return DropdownMenuItem(value: type, child: Text(type.label.toUpperCase()));
                      }).toList(),
                      onChanged: (value) => setState(() => selectedDiscount = value!),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        await ref.read(checkoutProvider.notifier).checkout(
                          paymentMethod: selectedMethod,
                          discountType: selectedDiscount,
                        );

                        final order = ref.read(checkoutProvider);

                        if (order != null && context.mounted) {
                          await showDialog(
                            context: context,
                            builder: (_) => ReceiptDialog(order: order),
                          );
                        }

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(72),
                        backgroundColor: AppTheme.emerald,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        'COMPLETE SETTLEMENT',
                        style: GoogleFonts.spaceGrotesk(letterSpacing: 2, fontWeight: FontWeight.w900),
                      ),
                    ).animate(onPlay: (c) => c.repeat())
                     .shimmer(delay: 2.seconds, duration: 1.5.seconds),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("CANCEL TRANSACTION", style: GoogleFonts.spaceGrotesk(
                          color: Colors.red[300],
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          fontSize: 12,
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack);
  }
}

class _BoutiquePaymentOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _BoutiquePaymentOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: 200.ms,
          padding: const EdgeInsets.symmetric(vertical: 32),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.emerald : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppTheme.emerald : AppTheme.ink.withOpacity(0.1),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : AppTheme.emerald, size: 32),
              const SizedBox(height: 12),
              Text(
                label,
                style: GoogleFonts.spaceGrotesk(
                  color: isSelected ? Colors.white : AppTheme.ink,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WhiteAmountRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isNegative;
  final bool isBold;

  const _WhiteAmountRow({
    required this.label,
    required this.amount,
    this.isNegative = false,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white.withOpacity(isBold ? 1 : 0.5),
            fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
            fontSize: isBold ? 24 : 14,
          ),
        ),
        Text(
          "${isNegative ? '-' : ''}₱${amount.toStringAsFixed(2)}",
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
            fontSize: isBold ? 28 : 16,
          ),
        ),
      ],
    );
  }
}
