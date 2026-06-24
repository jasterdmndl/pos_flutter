import 'package:flutter/material.dart';
import '../sales/sales_history_screen.dart';
import '../products/product_page.dart';
import '../cart/cart_panel.dart';

class PosScreen extends StatelessWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // LEFT SIDE - PRODUCTS
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey[50],
              child: const ProductPage(),
            ),
          ),

          // RIGHT SIDE - CART
          const CartPanel(),
        ],
      ),

      appBar: AppBar(
        title: const Text('Cafe POS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const SalesHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}