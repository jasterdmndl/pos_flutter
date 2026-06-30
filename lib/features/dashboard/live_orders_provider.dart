import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/supabase_service.dart';

/// A provider that streams the most recent orders from Supabase in real-time.
final liveOrdersProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  if (!SupabaseService.isInitialized) {
    return Stream.value([]);
  }

  final client = SupabaseService.client;
  
  // Realtime Stream: Listen to all changes in the 'orders' table
  // We use the 'stream' method which provides near-instant updates for INSERTS and UPDATES
  return client
      .from('orders')
      .stream(primaryKey: ['id'])
      .order('created_at', ascending: false) // Newest first
      .limit(20)
      .map((data) => List<Map<String, dynamic>>.from(data));
});
