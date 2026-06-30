import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/services/supabase_service.dart';

/// A provider that streams the most recent orders from Supabase in real-time.
final liveOrdersProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  if (!SupabaseService.isInitialized) {
    return Stream.value([]);
  }

  final client = SupabaseService.client;
  
  // Create a stream that listens to the 'orders' table
  // We sort by created_at descending to show newest first
  return client
      .from('orders')
      .stream(primaryKey: ['id'])
      .order('created_at')
      .limit(20)
      .map((data) => List<Map<String, dynamic>>.from(data));
});
