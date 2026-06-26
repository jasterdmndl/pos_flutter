import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../sales/sales_history_screen.dart';
import '../products/product_page.dart';
import '../cart/cart_panel.dart';
import '../dashboard/dashboard_screen.dart';
import '../auth/auth_provider.dart';
import 'management_screen.dart';

class PosScreen extends ConsumerWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

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
        title: const Text('Mire Sunset'),
        actions: [
          if (user?.role == 'admin') ...[
            IconButton(
              icon: const Icon(Icons.dashboard_customize_outlined),
              tooltip: 'Business Dashboard',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DashboardScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: 'Sales History',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SalesHistoryScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: 'Management',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ManagementScreen(),
                  ),
                );
              },
            ),
          ],
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }
}
