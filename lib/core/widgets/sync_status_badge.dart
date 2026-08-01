import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../features/orders/order_provider.dart';
import '../services/connectivity_service.dart';
import '../theme/app_theme.dart';

class SyncStatusBadge extends ConsumerWidget {
  const SyncStatusBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingCount = ref.watch(pendingSyncCountProvider).value ?? 0;
    final connectivity = ref.watch(connectivityProvider).value ?? [ConnectivityResult.none];
    final isOffline = connectivity.contains(ConnectivityResult.none) || connectivity.isEmpty;

    if (pendingCount == 0 && !isOffline) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.emerald.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_done_rounded, size: 14, color: AppTheme.emerald),
            const SizedBox(width: 8),
            Text(
              "ALL SYNCED",
              style: GoogleFonts.spaceGrotesk(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
                color: AppTheme.emerald,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOffline ? Colors.red.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOffline ? Icons.cloud_off_rounded : Icons.sync_rounded,
            size: 14,
            color: isOffline ? Colors.red : Colors.orange[800],
          ),
          const SizedBox(width: 8),
          Text(
            isOffline 
              ? "OFFLINE" 
              : "$pendingCount PENDING SYNC",
            style: GoogleFonts.spaceGrotesk(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
              color: isOffline ? Colors.red : Colors.orange[800],
            ),
          ),
        ],
      ),
    );
  }
}
