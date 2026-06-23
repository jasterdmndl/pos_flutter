import 'package:flutter/material.dart';

import 'product_model.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      const Product(
        id: 1,
        name: 'Latte',
        price: 120,
        isActive: true,
      ),
      const Product(
        id: 2,
        name: 'Mocha',
        price: 140,
        isActive: true,
      ),
      const Product(
        id: 3,
        name: 'Americano',
        price: 100,
        isActive: true,
      ),
      const Product(
        id: 4,
        name: 'Cappuccino',
        price: 130,
        isActive: true,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cafe POS'),
      ),
      body: GridView.builder(
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
            child: InkWell(
              onTap: () {
                debugPrint('${product.name} tapped');
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₱${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}