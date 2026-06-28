import 'package:flutter/material.dart';
import '../products/product_management_screen.dart';
import '../products/category_management_screen.dart';
import '../products/addon_management_screen.dart';
import '../inventory/inventory_screen.dart';
import '../reports/reports_screen.dart';
import '../reports/z_reading_screen.dart';
import '../settings/developer_settings_screen.dart';

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Management'),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(24),
        crossAxisCount: 4,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: [
          _MenuCard(
            title: 'Products',
            icon: Icons.coffee,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductManagementScreen()),
            ),
          ),
          _MenuCard(
            title: 'Categories',
            icon: Icons.category_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CategoryManagementScreen()),
            ),
          ),
          _MenuCard(
            title: 'Add-ons',
            icon: Icons.add_circle_outline,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddonManagementScreen()),
            ),
          ),
          _MenuCard(
            title: 'Inventory',
            icon: Icons.inventory_2_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InventoryScreen()),
            ),
          ),
          _MenuCard(
            title: 'Detailed Reports',
            icon: Icons.summarize_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReportsScreen()),
            ),
          ),
          _MenuCard(
            title: 'End of Day',
            icon: Icons.lock_clock_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ZReadingScreen()),
            ),
          ),
          _MenuCard(
            title: 'Developer Tools',
            icon: Icons.bug_report_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DeveloperSettingsScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.brown),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
