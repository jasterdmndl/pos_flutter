import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static Future<void> init() async {
    final String supabaseUrl = dotenv.get('SUPABASE_URL', fallback: '');
    final String supabaseKey = dotenv.get('SUPABASE_ANON_KEY', fallback: '');

    if (supabaseUrl.isEmpty || supabaseKey.isEmpty) {
      print('Supabase credentials not found in .env file. Sync will be disabled.');
      return;
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
