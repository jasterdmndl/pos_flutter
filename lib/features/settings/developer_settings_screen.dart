import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/database/isar_service.dart';
import '../../core/database/collections/order_entity.dart';
import '../../core/database/collections/order_item_entity.dart';
import '../../core/database/collections/order_addon_entity.dart';
import '../../core/database/collections/z_reading_entity.dart';
import '../../core/theme/app_theme.dart';
import '../dashboard/dashboard_provider.dart';
import '../sales/sales_provider.dart';

class DeveloperSettingsScreen extends ConsumerWidget {
  const DeveloperSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.bone,
      appBar: AppBar(
        title: Text('DEVELOPER TOOLS (TESTING ONLY)', 
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, color: Colors.red[900])),
      ),
      body: ListView(
        padding: const EdgeInsets.all(40),
        children: [
          _WarningCard(),
          const SizedBox(height: 32),
          _ResetActionTile(
            title: 'Delete Local Z-Readings',
            subtitle: 'Removes all Z-Reading logs from this device.',
            onTap: () => _resetTable(context, ref, 'zReadings'),
          ),
          _ResetActionTile(
            title: 'Delete All Local Invoices',
            subtitle: 'Wipes all local sales history. (Supabase data remains)',
            onTap: () => _resetTable(context, ref, 'orders'),
          ),
          const SizedBox(height: 48),
          Text("CLOUD RESET INSTRUCTIONS", style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.ink.withValues(alpha: 0.1)),
            ),
            child: Text(
              "To reset your Supabase cloud data, run this in your SQL Editor:\n\n"
              "TRUNCATE z_readings, orders, order_items, order_item_addons CASCADE;\n"
              "UPDATE running_totals SET lifetime_grand_total = 0, reset_counter = 0 WHERE id = 1;",
              style: GoogleFonts.sourceCodePro(fontSize: 13, color: Colors.blue[900]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _resetTable(BuildContext context, WidgetRef ref, String tableName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('CONFIRM DATA WIPE'),
        content: Text('Are you sure you want to delete all $tableName? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('DELETE ALL'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await IsarService.isar.writeTxn(() async {
        if (tableName == 'zReadings') {
          await IsarService.isar.zReadingEntitys.clear();
        } else if (tableName == 'orders') {
          await IsarService.isar.orderEntitys.clear();
          await IsarService.isar.orderItemEntitys.clear();
          await IsarService.isar.orderAddonEntitys.clear();
        }
      });
      
      ref.invalidate(salesHistoryProvider);
      ref.invalidate(dashboardProvider);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Local $tableName wiped.')));
      }
    }
  }
}

class _ResetActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ResetActionTile({required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(24),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.delete_forever, color: Colors.red),
        onTap: onTap,
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 32),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("TEST MODE ONLY", style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, color: Colors.red[900])),
                const Text("Deleting Z-readings or sales records is illegal for a BIR-registered business. Remove these tools before final inspection."),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
