import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';
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
  final _refController = TextEditingController();
  double _changeDue = 0;

  @override
  void dispose() {
    _refController.dispose();
    super.dispose();
  }

  void _onNumpadPressed(String value, double total) {
    setState(() {
      if (value == "clear") {
        receivedAmount = "";
      } else if (value == "delete") {
        if (receivedAmount.isNotEmpty) {
          receivedAmount = receivedAmount.substring(0, receivedAmount.length - 1);
        }
      } else {
        if (value == "." && receivedAmount.contains(".")) return;
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

  void _generateGcashRef() {
    // Generate a unique 13-digit-like code for GCash
    // Format: 9001 + 9 random alphanumeric (all caps)
    const uuid = Uuid();
    final randomPart = uuid.v4().substring(0, 9).toUpperCase();
    _refController.text = "9001$randomPart";
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final theme = Theme.of(context);

    final subtotal = cart.fold<double>(0, (sum, item) => sum + item.subtotal);
    final discountAmount = subtotal * selectedDiscount.rate;
    final total = subtotal - discountAmount;

    final received = double.tryParse(receivedAmount) ?? 0;
    final bool isInsufficient = selectedMethod == PaymentMethod.cash && received < total;

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
                    Container(width: 40, height: 4, color: Colors.white.withValues(alpha: 0.3)),
                    const SizedBox(height: 48),
                    Expanded(
                      child: ListView.separated(
                        itemCount: cart.length,
                        separatorBuilder: (_, __) => Divider(color: Colors.white.withValues(alpha: 0.1), height: 32),
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
                    
                    if (selectedMethod == PaymentMethod.cash) ...[
                      const SizedBox(height: 12),
                      if (isInsufficient && received > 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "INSUFFICIENT", 
                              style: GoogleFonts.spaceGrotesk(color: Colors.red[200], fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
                            ),
                            Text(
                              "-₱${(total - received).toStringAsFixed(2)}",
                              style: GoogleFonts.spaceGrotesk(color: Colors.red[200], fontWeight: FontWeight.bold),
                            ),
                          ],
                        ).animate().fadeIn()
                      else if (_changeDue > 0)
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

            // RIGHT: ACTIONS & NUMPAD/QR
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CONTROLS
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
                                onTap: () {
                                  setState(() => selectedMethod = PaymentMethod.gcash);
                                  if (_refController.text.isEmpty) {
                                    _generateGcashRef();
                                  }
                                },
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
                            onPressed: isInsufficient ? null : () async {
                              await ref.read(checkoutProvider.notifier).checkout(
                                paymentMethod: selectedMethod,
                                discountType: selectedDiscount,
                                amountReceived: received,
                                changeDue: _changeDue,
                                referenceNumber: _refController.text.isNotEmpty ? _refController.text : null,
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
                              backgroundColor: isInsufficient ? Colors.grey[300] : AppTheme.emerald,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Text(
                              isInsufficient ? 'WAITING FOR FULL PAYMENT' : 'COMPLETE SETTLEMENT',
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
                    // DYNAMIC RIGHT PANEL (NUMPAD OR GCASH QR)
                    Expanded(
                      flex: 5,
                      child: selectedMethod == PaymentMethod.cash 
                        ? _CashNumpad(
                            amount: receivedAmount, 
                            onPressed: (v) => _onNumpadPressed(v, total),
                          )
                        : _GcashPanel(
                            total: total, 
                            refController: _refController,
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

class _CashNumpad extends StatelessWidget {
  final String amount;
  final Function(String) onPressed;
  const _CashNumpad({required this.amount, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("AMOUNT RECEIVED", style: Theme.of(context).textTheme.labelLarge),
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
                  amount.isEmpty ? "0.00" : amount,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 32, 
                    fontWeight: FontWeight.w900,
                    color: amount.isEmpty ? AppTheme.ink.withValues(alpha: 0.2) : AppTheme.ink,
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
                _NumpadButton(label: "$i", onTap: () => onPressed("$i")),
              _NumpadButton(label: ".", onTap: () => onPressed(".")),
              _NumpadButton(label: "0", onTap: () => onPressed("0")),
              _NumpadButton(
                label: "⌫", 
                onTap: () => onPressed("delete"),
                color: Colors.red[50],
                textColor: Colors.red,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => onPressed("clear"),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20),
            side: BorderSide(color: AppTheme.ink.withValues(alpha: 0.1)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text("CLEAR AMOUNT", style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, letterSpacing: 1)),
        ),
      ],
    ).animate().fadeIn().slideX(begin: 0.1);
  }
}

class _GcashPanel extends StatelessWidget {
  final double total;
  final TextEditingController refController;
  const _GcashPanel({required this.total, required this.refController});

  @override
  Widget build(BuildContext context) {
    // Fetch custom GCash details from .env
    final String gcashNumber = dotenv.get('GCASH_NUMBER', fallback: '');
    final String gcashName = dotenv.get('GCASH_NAME', fallback: 'MIRE SUNSET');

    // If a number is provided, we generate a specific GCash payment URI.
    // If not, we just show a generic amount QR.
    final String qrData = gcashNumber.isNotEmpty 
        ? "gcash://pay?number=$gcashNumber&amount=${total.toStringAsFixed(2)}"
        : "GCash-Payment-PHP-${total.toStringAsFixed(2)}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("SCAN TO PAY", style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.2), width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 200.0,
                    eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "PHP ${total.toStringAsFixed(2)}",
                  style: GoogleFonts.spaceGrotesk(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.blue[900]),
                ),
                Text(
                  "Receiver: $gcashName",
                  style: GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue[800]),
                ),
                const SizedBox(height: 4),
                Text(
                  "Scan with GCash App",
                  style: GoogleFonts.spaceGrotesk(fontSize: 11, color: Colors.blue[700], letterSpacing: 1),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text("REFERENCE NUMBER", style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 12),
        TextField(
          controller: refController,
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: "Enter 13-digit code",
            prefixIcon: const Icon(Icons.receipt_long_rounded, color: Colors.blue),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.blue.withValues(alpha: 0.1), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
          ),
        ),
      ],
    ).animate().fadeIn().slideX(begin: 0.1);
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
            color: isSelected ? (label == 'GCASH' ? Colors.blue : AppTheme.emerald) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? (label == 'GCASH' ? Colors.blue : AppTheme.emerald) : AppTheme.ink.withValues(alpha: 0.1),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : (label == 'GCASH' ? Colors.blue : AppTheme.emerald), size: 28),
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
