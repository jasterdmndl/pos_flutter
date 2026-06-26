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
    final productsAsync = ref.watch(productProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final cartItems = ref.watch(cartProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADER
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cafe POS (${cartItems.length})',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Optional: Search bar could go here
            ],
          ),
        ),

        // CATEGORIES BAR
        SizedBox(
          height: 50,
          child: categoriesAsync.when(
            data: (categories) => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return CategoryChip(
                    label: 'All',
                    isSelected: selectedCategory == null,
                    onSelected: () => ref.read(selectedCategoryProvider.notifier).state = null,
                  );
                }
                final category = categories[index - 1];
                return CategoryChip(
                  label: category.name,
                  isSelected: selectedCategory == category.id,
                  onSelected: () => ref.read(selectedCategoryProvider.notifier).state = category.id,
                );
              },
            ),
            loading: () => const Center(child: LinearProgressIndicator()),
            error: (_, __) => const SizedBox(),
          ),
        ),

        // PRODUCT GRID
        Expanded(
          child: productsAsync.when(
            data: (products) => GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemBuilder: (context, index) {
                final product = products[index];

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      final selectedAddons = await showDialog<Map<int, int>>(
                        context: context,
                        builder: (_) => const AddonDialog(),
                      );

                      if (selectedAddons == null) return;

                      final addonsAsync = ref.read(addonProvider);
                      final allAddons = addonsAsync.value ?? [];

                      final addons = allAddons
                          .where((addon) => selectedAddons.containsKey(addon.id))
                          .map((addon) => CartAddon(
                                name: addon.name,
                                price: addon.price,
                                quantity: selectedAddons[addon.id] ?? 0,
                              ))
                          .where((addon) => addon.quantity > 0)
                          .toList();

                      ref.read(cartProvider.notifier).addProduct(product, addons);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${product.name} added"),
                            duration: const Duration(milliseconds: 600),
                          ),
                        );
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          product.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₱${product.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, __) => Center(child: Text('Error: $err')),
          ),
        ),
      ],
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onSelected(),
        selectedColor: Theme.of(context).primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
