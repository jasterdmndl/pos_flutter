import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../products/product_management_screen.dart';
import '../products/category_management_screen.dart';
import '../products/addon_management_screen.dart';
import '../inventory/inventory_screen.dart';
import '../reports/reports_screen.dart';
import '../reports/z_reading_screen.dart';
import '../settings/developer_settings_screen.dart';
import '../../core/theme/app_theme.dart';

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bone,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'STORE MANAGEMENT',
              style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: 2,
              ),
            ),
            Text(
              'CONFIGURE PRODUCTS, INVENTORY, AND REPORTS',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: AppTheme.ink.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Administrative Hub",
              style: GoogleFonts.fraunces(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppTheme.ink,
              ),
            ).animate().fadeIn().slideX(begin: -0.1),
            const SizedBox(height: 48),
            
            // GRID SECTION
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              childAspectRatio: 1.1,
              children: [
                _BoutiqueMenuCard(
                  title: 'PRODUCTS',
                  subtitle: 'Manage menu items & prices',
                  icon: Icons.coffee_rounded,
                  index: 0,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductManagementScreen())),
                ),
                _BoutiqueMenuCard(
                  title: 'CATEGORIES',
                  subtitle: 'Organize your store menu',
                  icon: Icons.category_rounded,
                  index: 1,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryManagementScreen())),
                ),
                _BoutiqueMenuCard(
                  title: 'ADD-ONS',
                  subtitle: 'Drink customizations & shots',
                  icon: Icons.add_circle_outline_rounded,
                  index: 2,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddonManagementScreen())),
                ),
                _BoutiqueMenuCard(
                  title: 'INVENTORY',
                  subtitle: 'Track beans, milk & stock',
                  icon: Icons.inventory_2_outlined,
                  index: 3,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InventoryScreen())),
                ),
                _BoutiqueMenuCard(
                  title: 'DETAILED REPORTS',
                  subtitle: 'Review deep sales analytics',
                  icon: Icons.summarize_outlined,
                  index: 4,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsScreen())),
                ),
                _BoutiqueMenuCard(
                  title: 'END OF DAY',
                  subtitle: 'Mandatory Z-Reading & Reset',
                  icon: Icons.lock_clock_outlined,
                  index: 5,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ZReadingScreen())),
                ),
                _BoutiqueMenuCard(
                  title: 'DEVELOPER TOOLS',
                  subtitle: 'Testing & database reset',
                  icon: Icons.bug_report_outlined,
                  index: 6,
                  isDestructive: true,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DeveloperSettingsScreen())),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BoutiqueMenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final int index;
  final bool isDestructive;

  const _BoutiqueMenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    required this.index,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppTheme.ink.withValues(alpha: 0.08), width: 1.5),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDestructive 
                    ? Colors.red.withValues(alpha: 0.05) 
                    : AppTheme.emerald.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon, 
                  size: 28, 
                  color: isDestructive ? Colors.red[400] : AppTheme.emerald
                ),
              ),
              const Spacer(),
              Text(
                title,
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.ink.withValues(alpha: 0.4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1, curve: Curves.easeOut);
  }
}
