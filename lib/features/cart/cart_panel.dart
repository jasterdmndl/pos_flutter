import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import 'cart_provider.dart';
import 'cart_item_model.dart';
import 'addon_edit_dialog.dart';
import '../checkout/checkout_dialog.dart';

class CartPanel extends ConsumerWidget {
  const CartPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return Container(
      width: 450,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // HEADER
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'CURRENT ORDER',
                      style: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        letterSpacing: 2,
                      ),
                    ),
                    const Spacer(),
                    if (cart.isNotEmpty)
                      IconButton(
                        onPressed: () => ref.read(cartProvider.notifier).clearCart(),
                        icon: const Icon(Icons.delete_outline, size: 20),
                        color: Colors.red[300],
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${cart.length} ITEMS IN BASKET',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    color: AppTheme.ink.withValues(alpha: 0.4),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // CART ITEMS
          Expanded(
            child: cart.isEmpty
                ? _EmptyCart()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return _CartItem(item: item)
                          .animate()
                          .fadeIn(delay: (index * 100).ms)
                          .slideX(begin: 0.1);
                    },
                  ),
          ),

          // FOOTER
          if (cart.isNotEmpty) _CartFooter(cart: cart),
        ],
      ),
    );
  }
}

class _CartItem extends ConsumerWidget {
  final CartItem item;
  const _CartItem({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.bone,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${item.quantity}',
                    style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name.toUpperCase(),
                      style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, fontSize: 15),
                    ),
                    if (item.addons.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          item.addons.map((a) => '${a.name} (x${a.quantity})').join(', '),
                          style: TextStyle(fontSize: 12, color: AppTheme.ink.withValues(alpha: 0.5)),
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                '₱${item.subtotal.toStringAsFixed(2)}',
                style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const SizedBox(width: 56),
              _SmallAction(
                icon: Icons.edit_outlined,
                onTap: () async {
                  final updated = await showDialog<List>(
                    context: context,
                    builder: (_) => AddonEditDialog(currentAddons: item.addons),
                  );
                  if (updated != null) {
                    ref.read(cartProvider.notifier).updateItemAddons(item, updated.cast());
                  }
                },
              ),
              const SizedBox(width: 8),
              _SmallAction(
                icon: Icons.remove,
                onTap: () => ref.read(cartProvider.notifier).decreaseItem(item),
              ),
              const SizedBox(width: 8),
              _SmallAction(
                icon: Icons.add,
                onTap: () => ref.read(cartProvider.notifier).increaseItem(item),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
        ],
      ),
    );
  }
}

class _SmallAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SmallAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.ink.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 14),
      ),
    );
  }
}

class _CartFooter extends StatelessWidget {
  final List<CartItem> cart;
  const _CartFooter({required this.cart});

  @override
  Widget build(BuildContext context) {
    final subtotal = cart.fold<double>(0, (sum, item) => sum + item.subtotal);

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1.5)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('SUBTOTAL', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, color: AppTheme.ink.withValues(alpha: 0.5))),
              Text('₱${subtotal.toStringAsFixed(2)}', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => showDialog(context: context, builder: (_) => const CheckoutDialog()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.emerald,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMd)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'CHECKOUT',
                  style: GoogleFonts.spaceGrotesk(letterSpacing: 2, fontWeight: FontWeight.w900),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.arrow_forward_rounded, size: 18),
              ],
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .shimmer(delay: 2.seconds, duration: 1.5.seconds, color: Colors.white.withValues(alpha: 0.2)),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_outlined, size: 80, color: AppTheme.emerald.withValues(alpha: 0.1)),
          const SizedBox(height: 24),
          Text(
            'EMPTY BASKET',
            style: GoogleFonts.spaceGrotesk(
              letterSpacing: 2,
              fontWeight: FontWeight.w900,
              color: AppTheme.emerald.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }
}
