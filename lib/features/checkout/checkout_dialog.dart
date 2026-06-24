import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../cart/cart_provider.dart';
import '../discounts/discount_model.dart';
import 'checkout_controller.dart';
import 'checkout_model.dart';

class CheckoutDialog extends ConsumerStatefulWidget {
  const CheckoutDialog({super.key});

  @override
  ConsumerState<CheckoutDialog> createState() =>
      _CheckoutDialogState();
}

class _CheckoutDialogState
    extends ConsumerState<CheckoutDialog> {
  PaymentMethod selectedMethod = PaymentMethod.cash;
  DiscountType selectedDiscount = DiscountType.none;

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);

    final subtotal = cart.fold<double>(
      0,
          (sum, item) => sum + item.subtotal,
    );

    final discountAmount =
        subtotal * selectedDiscount.rate;

    final total = subtotal - discountAmount;

    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Confirm Order",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // ORDER SUMMARY
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final item = cart[index];

                  return ListTile(
                    title: Text(item.product.name),
                    subtitle: item.addons.isEmpty
                        ? null
                        : Text(
                      item.addons
                          .map((a) =>
                      "${a.name} x${a.quantity}")
                          .join(", "),
                    ),
                    trailing: Text(
                      "₱${item.subtotal.toStringAsFixed(0)}",
                    ),
                  );
                },
              ),
            ),

            const Divider(),

            // PAYMENT
            const Text("Payment Method"),
            Row(
              children: [
                Radio(
                  value: PaymentMethod.cash,
                  groupValue: selectedMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedMethod = value!;
                    });
                  },
                ),
                const Text("Cash"),

                Radio(
                  value: PaymentMethod.gcash,
                  groupValue: selectedMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedMethod = value!;
                    });
                  },
                ),
                const Text("GCash"),
              ],
            ),

            // DISCOUNT
            const SizedBox(height: 10),
            DropdownButton<DiscountType>(
              value: selectedDiscount,
              isExpanded: true,
              items: DiscountType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.label),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDiscount = value!;
                });
              },
            ),

            const SizedBox(height: 10),

            // TOTAL
            Text(
              "Subtotal: ₱${subtotal.toStringAsFixed(0)}",
            ),
            Text(
              "Discount: ₱${discountAmount.toStringAsFixed(0)}",
            ),
            Text(
              "TOTAL: ₱${total.toStringAsFixed(0)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // ACTION BUTTONS
            Row(
              mainAxisAlignment:
              MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),

                const SizedBox(width: 10),

                ElevatedButton(
                  onPressed: () async {
                    await ref
                        .read(checkoutProvider.notifier)
                        .checkout(
                      paymentMethod: selectedMethod,
                      discountType: selectedDiscount,
                    );

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text("Order Completed"),
                      ),
                    );
                  },
                  child: const Text("Confirm Payment"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}