import 'package:flutter/material.dart';

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
    );
  }
}