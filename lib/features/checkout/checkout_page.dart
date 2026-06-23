import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../checkout/checkout_model.dart';
import '../checkout/checkout_controller.dart';
import '../discounts/discount_model.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  PaymentMethod selectedMethod = PaymentMethod.cash;

  DiscountType selectedDiscount = DiscountType.none;

  @override
  Widget build(BuildContext context) {
    final order = ref.watch(checkoutProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Payment Method",
              style: TextStyle(fontSize: 18),
            ),

            RadioListTile(
              title: const Text("Cash"),
              value: PaymentMethod.cash,
              groupValue: selectedMethod,
              onChanged: (value) {
                setState(() {
                  selectedMethod = value!;
                });
              },
            ),

            RadioListTile(
              title: const Text("GCash"),
              value: PaymentMethod.gcash,
              groupValue: selectedMethod,
              onChanged: (value) {
                setState(() {
                  selectedMethod = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              "Discount",
              style: TextStyle(fontSize: 18),
            ),

            DropdownButton<DiscountType>(
              value: selectedDiscount,
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

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref
                      .read(checkoutProvider.notifier)
                      .checkout(
                    paymentMethod: selectedMethod,
                    discountType: selectedDiscount,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Order Completed!"),
                    ),
                  );
                },
                child: const Text("Complete Payment"),
              ),
            ),

            if (order != null) ...[
              const SizedBox(height: 20),
              Text("Total: ₱${order.total.toStringAsFixed(0)}"),
            ],
          ],
        ),
      ),
    );
  }
}