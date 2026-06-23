import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cart_provider.dart';
import '../checkout/checkout_dialog.dart';
import 'addon_edit_dialog.dart';

class CartPanel extends ConsumerWidget {
  const CartPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartController = ref.read(cartProvider.notifier);

    return Container(
      width: 320,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          const Text(
            "Cart",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // CART ITEMS
          Expanded(
            child: cartItems.isEmpty
                ? const Center(
              child: Text("Cart is empty"),
            )
                : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        // PRODUCT NAME + ACTIONS
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.product.name,
                                style: const TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),

                            // EDIT ADDONS BUTTON
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                final updatedAddons =
                                await showDialog(
                                  context: context,
                                  builder: (_) =>
                                      AddonEditDialog(
                                        currentAddons:
                                        item.addons,
                                      ),
                                );

                                if (updatedAddons == null) return;

                                cartController
                                    .updateItemAddons(
                                  item,
                                  updatedAddons,
                                );
                              },
                            ),

                            // DELETE BUTTON
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                cartController
                                    .removeItem(item);
                              },
                            ),
                          ],
                        ),

                        // ADD-ONS LIST
                        if (item.addons.isNotEmpty)
                          ...item.addons.map(
                                (addon) => Padding(
                              padding:
                              const EdgeInsets.only(
                                  left: 8),
                              child: Text(
                                "• ${addon.name} x${addon.quantity}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),

                        const SizedBox(height: 8),

                        // QUANTITY + PRICE
                        Row(
                          children: [
                            IconButton(
                              icon:
                              const Icon(Icons.remove),
                              onPressed: () {
                                cartController
                                    .decreaseItem(item);
                              },
                            ),

                            Text(
                              "${item.quantity}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                cartController
                                    .increaseItem(item);
                              },
                            ),

                            const Spacer(),

                            Text(
                              "₱${item.subtotal.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(),

          // TOTAL
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "₱${cartController.total.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // CHECKOUT BUTTON (DIALOG)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: cartItems.isEmpty
                  ? null
                  : () {
                showDialog(
                  context: context,
                  builder: (_) =>
                  const CheckoutDialog(),
                );
              },
              child: const Text("Checkout"),
            ),
          ),
        ],
      ),
    );
  }
}