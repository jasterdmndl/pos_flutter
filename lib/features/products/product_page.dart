import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'addon_dialog.dart';
import '../cart/cart_provider.dart';
import 'product_provider.dart';
import '../cart/cart_addon_model.dart';
import 'addon_provider.dart';

class ProductPage extends ConsumerWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productProvider);
    final cartItems = ref.watch(cartProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADER (POS STYLE)
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            'Cafe POS (${cartItems.length})',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // PRODUCT GRID
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
            ),
            itemBuilder: (context, index) {
              final product = products[index];

              return Card(
                elevation: 2,
                child: InkWell(
                  onTap: () async {
                    // 1. Open addon dialog
                    final selectedAddons =
                    await showDialog<Map<int, int>>(
                      context: context,
                      builder: (_) => const AddonDialog(),
                    );

                    if (selectedAddons == null) {
                      return;
                    }

                    // 2. Convert selected addons → CartAddon list
                    final addons = ref
                        .read(addonProvider)
                        .where(
                          (addon) =>
                          selectedAddons.containsKey(addon.id),
                    )
                        .map(
                          (addon) => CartAddon(
                        name: addon.name,
                        price: addon.price,
                        quantity:
                        selectedAddons[addon.id] ?? 0,
                      ),
                    )
                        .where((addon) => addon.quantity > 0)
                        .toList();

                    // 3. Add to cart (SMART MERGING ALREADY HANDLED)
                    ref
                        .read(cartProvider.notifier)
                        .addProduct(product, addons);

                    // 4. Quick feedback
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "${product.name} added",
                        ),
                        duration:
                        const Duration(milliseconds: 600),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Text(
                        product.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '₱${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}