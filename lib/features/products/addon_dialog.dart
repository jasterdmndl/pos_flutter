import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'addon_provider.dart';

class AddonDialog extends ConsumerStatefulWidget {
  const AddonDialog({super.key});

  @override
  ConsumerState<AddonDialog> createState() => _AddonDialogState();
}

class _AddonDialogState extends ConsumerState<AddonDialog> {
  final Map<int, int> selectedAddons = {};

  @override
  Widget build(BuildContext context) {
    final addonsAsync = ref.watch(addonProvider);

    return AlertDialog(
      title: const Text('Customize Drink'),
      content: SizedBox(
        width: 400,
        child: addonsAsync.when(
          data: (addons) => ListView.builder(
            shrinkWrap: true,
            itemCount: addons.length,
            itemBuilder: (context, index) {
              final addon = addons[index];
              final quantity = selectedAddons[addon.id] ?? 0;

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              addon.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '₱${addon.price.toStringAsFixed(0)}',
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (quantity == 0) return;
                          setState(() {
                            selectedAddons[addon.id] = quantity - 1;
                            if (selectedAddons[addon.id] == 0) {
                              selectedAddons.remove(addon.id);
                            }
                          });
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Text(quantity.toString()),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            selectedAddons[addon.id] = quantity + 1;
                          });
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(
              context,
              selectedAddons,
            );
          },
          child: const Text('Add To Cart'),
        ),
      ],
    );
  }
}
