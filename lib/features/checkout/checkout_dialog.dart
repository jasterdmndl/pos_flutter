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
  String receivedAmount = "";
  double _changeDue = 0;

  void _onNumpadPressed(String value, double total) {
    setState(() {
      if (value == "clear") {
        receivedAmount = "";
      } else if (value == "delete") {
        if (receivedAmount.isNotEmpty) {
          receivedAmount = receivedAmount.substring(0, receivedAmount.length - 1);
        }
      } else {
        // Prevent multiple decimals
        if (value == "." && receivedAmount.contains(".")) return;
        // Limit length
        if (receivedAmount.length > 8) return;
        receivedAmount += value;
      }
      _calculateChange(total);
    });
  }

  void _calculateChange(double total) {
    final received = double.tryParse(receivedAmount) ?? 0;
    setState(() {
      _changeDue = received > total ? received - total : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final theme = Theme.of(context);

    final subtotal = cart.fold<double>(0, (sum, item) => sum + item.subtotal);
    final discountAmount = subtotal * selectedDiscount.rate;
    final total = subtotal - discountAmount;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
      child: Container(
        width: 1100,
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
                                    style: GoogleFonts.spaceGrotesk(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
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
                    if (selectedMethod == PaymentMethod.cash && _changeDue > 0) ...[
                      const SizedBox(height: 12),
                      _WhiteAmountRow(
                        label: "CHANGE DUE", 
                        amount: _changeDue, 
                        color: Colors.white,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // RIGHT: ACTIONS & NUMPAD
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CONTROLS (Payment & Privilege)
                    Expanded(
                      flex: 4,
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
                                onTap: () {
                                  setState(() => selectedMethod = PaymentMethod.cash);
                                  _calculateChange(total);
                                },
                              ),
                              const SizedBox(width: 12),
                              _BoutiquePaymentOption(
                                label: 'GCASH',
                                icon: Icons.qr_code_scanner,
                                isSelected: selectedMethod == PaymentMethod.gcash,
                                onTap: () => setState(() => selectedMethod = PaymentMethod.gcash),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Text("APPLY PRIVILEGE", style: theme.textTheme.labelLarge),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<DiscountType>(
                            value: selectedDiscount,
                            style: GoogleFonts.spaceGrotesk(color: AppTheme.ink, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: AppTheme.ink.withValues(alpha: 0.1), width: 2),
                              ),
                            ),
                            items: DiscountType.values.map((type) {
                              return DropdownMenuItem(value: type, child: Text(type.label.toUpperCase()));
                            }).toList(),
                            onChanged: (value) {
                              setState(() => selectedDiscount = value!);
                              _calculateChange(subtotal - (subtotal * value!.rate));
                            },
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () async {
                              final received = double.tryParse(receivedAmount) ?? 0;
                              if (selectedMethod == PaymentMethod.cash && received < total) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Insufficient amount received"), backgroundColor: Colors.red),
                                );
                                return;
                              }

                              await ref.read(checkoutProvider.notifier).checkout(
                                paymentMethod: selectedMethod,
                                discountType: selectedDiscount,
                                amountReceived: received,
                                changeDue: _changeDue,
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
                          const SizedBox(height: 12),
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
                    const SizedBox(width: 48),
                    // NUMPAD (Visible only for Cash)
                    if (selectedMethod == PaymentMethod.cash)
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("AMOUNT RECEIVED", style: theme.textTheme.labelLarge),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                              decoration: BoxDecoration(
                                color: AppTheme.bone,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppTheme.ink.withValues(alpha: 0.08), width: 2),
                              ),
                              child: Row(
                                children: [
                                  Text("₱", style: GoogleFonts.spaceGrotesk(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.emerald)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      receivedAmount.isEmpty ? "0.00" : receivedAmount,
                                      style: GoogleFonts.spaceGrotesk(
                                        fontSize: 32, 
                                        fontWeight: FontWeight.w900,
                                        color: receivedAmount.isEmpty ? AppTheme.ink.withValues(alpha: 0.2) : AppTheme.ink,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Expanded(
                              child: GridView.count(
                                crossAxisCount: 3,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 1.3,
                                children: [
                                  for (var i = 1; i <= 9; i++)
                                    _NumpadButton(label: "$i", onTap: () => _onNumpadPressed("$i", total)),
                                  _NumpadButton(label: ".", onTap: () => _onNumpadPressed(".", total)),
                                  _NumpadButton(label: "0", onTap: () => _onNumpadPressed("0", total)),
                                  _NumpadButton(
                                    label: "⌫", 
                                    onTap: () => _onNumpadPressed("delete", total),
                                    color: Colors.red[50],
                                    textColor: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton(
                              onPressed: () => _onNumpadPressed("clear", total),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                side: BorderSide(color: AppTheme.ink.withValues(alpha: 0.1)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text("CLEAR AMOUNT", style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, letterSpacing: 1)),
                            ),
                          ],
                        ).animate().fadeIn().slideX(begin: 0.1),
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

class _NumpadButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;

  const _NumpadButton({
    required this.label,
    required this.onTap,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.ink.withValues(alpha: 0.08), width: 1.5),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 24, 
                fontWeight: FontWeight.bold,
                color: textColor ?? AppTheme.ink,
              ),
            ),
          ),
        ),
      ),
    );
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
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.emerald : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppTheme.emerald : AppTheme.ink.withValues(alpha: 0.1),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : AppTheme.emerald, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.spaceGrotesk(
                  color: isSelected ? Colors.white : AppTheme.ink,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  fontSize: 12,
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
  final Color? color;

  const _WhiteAmountRow({
    required this.label,
    required this.amount,
    this.isNegative = false,
    this.isBold = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            color: (color ?? Colors.white).withValues(alpha: isBold ? 1 : 0.5),
            fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
            fontSize: isBold ? 24 : 14,
          ),
        ),
        Text(
          "${isNegative ? '-' : ''}₱${amount.toStringAsFixed(2)}",
          style: GoogleFonts.spaceGrotesk(
            color: color ?? Colors.white,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
            fontSize: isBold ? 28 : 16,
          ),
        ),
      ],
    );
  }
}
