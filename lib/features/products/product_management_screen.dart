import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/database/collections/product_entity.dart';
import '../../core/database/collections/category_entity.dart';
import '../../core/theme/app_theme.dart';
import 'product_provider.dart';

class ProductManagementScreen extends ConsumerWidget {
  const ProductManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: AppTheme.bone,
      appBar: AppBar(
        title: Text('MANAGE PRODUCTS', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 16)),
        actions: [
          _ManagementActionBtn(
            icon: Icons.add_rounded,
            label: "ADD PRODUCT",
            onTap: () => _showProductDialog(context, ref, null, categoriesAsync.value ?? []),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) return const _EmptyState(label: "NO PRODUCTS FOUND");
          
          return ListView.builder(
            padding: const EdgeInsets.all(40),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.ink.withValues(alpha: 0.08), width: 1.5),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  title: Text(
                    product.name.toUpperCase(),
                    style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, letterSpacing: 0.5),
                  ),
                  subtitle: Text(
                    '₱${product.price.toStringAsFixed(2)}',
                    style: GoogleFonts.spaceGrotesk(color: AppTheme.emerald, fontWeight: FontWeight.bold),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit_outlined, size: 20, color: AppTheme.ink.withValues(alpha: 0.4)),
                        onPressed: () => _showProductDialog(context, ref, product, categoriesAsync.value ?? []),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.delete_outline_rounded, size: 20, color: Colors.red[300]),
                        onPressed: () => _deleteProduct(context, ref, product.id),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: (index * 30).ms).slideX(begin: 0.05);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Future<void> _showProductDialog(BuildContext context, WidgetRef ref, dynamic product, List<CategoryEntity> categories) async {
    final nameController = TextEditingController(text: product?.name ?? '');
    final priceController = TextEditingController(text: product?.price?.toString() ?? '');
    int? selectedCategoryId = product?.categoryId ?? (categories.isNotEmpty ? categories.first.id : null);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          product == null ? 'CREATE PRODUCT' : 'EDIT PRODUCT',
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DialogField(label: "PRODUCT NAME", controller: nameController),
              const SizedBox(height: 24),
              _DialogField(label: "PRICE (PHP)", controller: priceController, isNumeric: true),
              const SizedBox(height: 24),
              _DialogDropdown(
                label: "CATEGORY", 
                value: selectedCategoryId, 
                items: categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name.toUpperCase()))).toList(),
                onChanged: (val) => selectedCategoryId = val,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: ElevatedButton(
              onPressed: () async {
                final repo = ref.read(productRepositoryProvider);
                final entity = ProductEntity()
                  ..id = product?.id ?? 0
                  ..name = nameController.text
                  ..price = double.tryParse(priceController.text) ?? 0
                  ..categoryId = selectedCategoryId ?? 0
                  ..isActive = true;
                
                await repo.saveProduct(entity);
                ref.invalidate(productProvider);
                if (context.mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.emerald),
              child: const Text('SAVE CHANGES'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProduct(BuildContext context, WidgetRef ref, int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('DELETE PRODUCT?'),
        content: const Text('This action is permanent and will remove the item from your menu.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('DELETE PERMANENTLY'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(productRepositoryProvider).deleteProduct(id);
      ref.invalidate(productProvider);
    }
  }
}

class _ManagementActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ManagementActionBtn({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20, color: AppTheme.emerald),
      label: Text(label, style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, color: AppTheme.emerald, fontSize: 11, letterSpacing: 1)),
    );
  }
}

class _DialogField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isNumeric;
  const _DialogField({required this.label, required this.controller, this.isNumeric = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.ink.withValues(alpha: 0.4), letterSpacing: 1.5)),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
          decoration: const InputDecoration(contentPadding: EdgeInsets.all(20)),
        ),
      ],
    );
  }
}

class _DialogDropdown extends StatelessWidget {
  final String label;
  final int? value;
  final List<DropdownMenuItem<int>> items;
  final Function(int?) onChanged;
  const _DialogDropdown({required this.label, this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.ink.withValues(alpha: 0.4), letterSpacing: 1.5)),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          value: value,
          items: items,
          onChanged: onChanged,
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, color: AppTheme.ink),
          decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16)),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String label;
  const _EmptyState({required this.label});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(label, style: GoogleFonts.spaceGrotesk(color: AppTheme.ink.withValues(alpha: 0.2), fontWeight: FontWeight.w900, letterSpacing: 2)),
    );
  }
}
