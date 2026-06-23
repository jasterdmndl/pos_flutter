import 'package:flutter/material.dart';
import '../cart/cart_addon_model.dart';

class AddonEditDialog extends StatefulWidget {
  final List<CartAddon> currentAddons;

  const AddonEditDialog({
    super.key,
    required this.currentAddons,
  });

  @override
  State<AddonEditDialog> createState() =>
      _AddonEditDialogState();
}

class _AddonEditDialogState
    extends State<AddonEditDialog> {
  late List<CartAddon> addons;

  @override
  void initState() {
    super.initState();
    addons = List.from(widget.currentAddons);
  }

  void updateQuantity(int index, int value) {
    setState(() {
      if (value <= 0) {
        addons.removeAt(index);
      } else {
        addons[index] = CartAddon(
          name: addons[index].name,
          price: addons[index].price,
          quantity: value,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Add-ons"),
      content: SizedBox(
        width: 400,
        child: addons.isEmpty
            ? const Text("No add-ons")
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(addons.length, (i) {
            final addon = addons[i];

            return Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text(addon.name),

                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () =>
                          updateQuantity(i, addon.quantity - 1),
                    ),
                    Text("${addon.quantity}"),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () =>
                          updateQuantity(i, addon.quantity + 1),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, addons);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}