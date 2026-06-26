import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/collections/ingredient_entity.dart';
import '../checkout/checkout_controller.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(inventoryRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
      ),
      body: FutureBuilder<List<IngredientEntity>>(
        future: repo.getAllIngredients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final ingredients = snapshot.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              final ingredient = ingredients[index];
              return Card(
                child: ListTile(
                  title: Text(ingredient.name),
                  subtitle: Text('Stock: ${ingredient.stockQuantity} ${ingredient.unit}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_box_outlined),
                    onPressed: () => _showRestockDialog(context, ref, ingredient),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showRestockDialog(BuildContext context, WidgetRef ref, IngredientEntity ingredient) async {
    final amountController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Restock ${ingredient.name}'),
        content: TextField(
          controller: amountController,
          decoration: InputDecoration(labelText: 'Amount (${ingredient.unit})'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text) ?? 0;
              final newStock = ingredient.stockQuantity + amount;
              await ref.read(inventoryRepositoryProvider).updateStock(ingredient.id, newStock);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Restock'),
          ),
        ],
      ),
    );
  }
}
