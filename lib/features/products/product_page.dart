import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_theme.dart';
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
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CATEGORIES BAR
        Container(
          height: 80,
          color: Colors.white,
          child: categoriesAsync.when(
            data: (categories) => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              itemCount: categories.length + 1,
              itemBuilder: (context, index) {
                final isAll = index == 0;
                final category = isAll ? null : categories[index - 1];
                final isSelected = isAll 
                  ? selectedCategory == null 
                  : selectedCategory == category?.id;

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: () => ref.read(selectedCategoryProvider.notifier).state = category?.id,
                    child: AnimatedContainer(
                      duration: 200.ms,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.emerald : Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: isSelected ? AppTheme.emerald : AppTheme.ink.withOpacity(0.1),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          isAll ? 'ALL ITEMS' : category!.name.toUpperCase(),
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                            color: isSelected ? Colors.white : AppTheme.ink.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                  ),
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
              padding: const EdgeInsets.all(24),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final product = products[index];

                return _ProductCard(product: product, index: index);
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ),
      ],
    );
  }
}

class _ProductCard extends ConsumerWidget {
  final dynamic product;
  final int index;
  const _ProductCard({required this.product, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        side: BorderSide(color: AppTheme.ink.withOpacity(0.08), width: 1.5),
      ),
      child: InkWell(
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
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                color: AppTheme.bone,
                child: Center(
                  child: Text(
                    product.name[0],
                    style: GoogleFonts.fraunces(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.emerald.withOpacity(0.2),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 1.5,
              color: AppTheme.ink.withOpacity(0.08),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.name.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₱${product.price.toStringAsFixed(2)}',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16,
                        color: AppTheme.emerald,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1, curve: Curves.easeOut),
    );
  }
}
