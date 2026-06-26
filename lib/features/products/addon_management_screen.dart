import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/collections/product_addon_entity.dart';
import 'addon_provider.dart';
import 'product_provider.dart';

class AddonManagementScreen extends ConsumerWidget {
  const AddonManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addonsAsync = ref.watch(addonProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Add-ons'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddonDialog(context, ref, null),
          ),
        ],
      ),
      body: addonsAsync.when(
        data: (addons) => ListView.builder(
          itemCount: addons.length,
          itemBuilder: (context, index) {
            final addon = addons[index];
            return ListTile(
              title: Text(addon.name),
              subtitle: Text('₱${addon.price.toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      // Need to find the entity for editing
                      final repo = ref.read(productRepositoryProvider);
                      final allEntities = await repo.getAddons();
                      final entity = allEntities.firstWhere((e) => e.id == addon.id);
                      if (context.mounted) _showAddonDialog(context, ref, entity);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteAddon(context, ref, addon.id),
                  ),
                ],
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Future<void> _showAddonDialog(BuildContext context, WidgetRef ref, ProductAddonEntity? addon) async {
    final nameController = TextEditingController(text: addon?.name ?? '');
    final priceController = TextEditingController(text: addon?.price.toString() ?? '');
    bool isPerUnit = addon?.isPerUnit ?? false;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(addon == null ? 'Add Add-on' : 'Edit Add-on'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              SwitchListTile(
                title: const Text('Price per unit/pump?'),
                value: isPerUnit,
                onChanged: (val) => setDialogState(() => isPerUnit = val),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final repo = ref.read(productRepositoryProvider);
                final entity = ProductAddonEntity()
                  ..id = addon?.id ?? 0
                  ..name = nameController.text
                  ..price = double.tryParse(priceController.text) ?? 0
                  ..isPerUnit = isPerUnit
                  ..isActive = true;
                
                await repo.saveAddon(entity);
                ref.invalidate(addonProvider);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteAddon(BuildContext context, WidgetRef ref, int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Add-on'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(productRepositoryProvider).deleteAddon(id);
      ref.invalidate(addonProvider);
    }
  }
}
