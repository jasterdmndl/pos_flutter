import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> init() async {
    // These should ideally be in a .env file or secure storage
    // For now, providing placeholders as per standard Flutter Supabase setup
    const String supabaseUrl = 'YOUR_SUPABASE_URL';
    const String supabaseKey = 'YOUR_SUPABASE_ANON_KEY';

    if (supabaseUrl == 'YOUR_SUPABASE_URL') return;

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
