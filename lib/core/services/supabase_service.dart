import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/logger.dart';

class SupabaseService {
  static bool _initialized = false;
  static String? _error;

  static Future<void> init() async {
    try {
      final String supabaseUrl = dotenv.get('SUPABASE_URL', fallback: '');
      final String supabaseKey = dotenv.get('SUPABASE_ANON_KEY', fallback: '');

      if (supabaseUrl.isEmpty || supabaseKey.isEmpty) {
        _error = 'SUPABASE_URL or SUPABASE_ANON_KEY is missing in .env file.';
        AppLogger.e(_error);
        return;
      }

      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseKey,
      );
      _initialized = true;
      AppLogger.i('Supabase initialized successfully.');
    } catch (e) {
      _error = 'Failed to initialize Supabase: $e';
      AppLogger.e(_error);
    }
  }

  static bool get isInitialized => _initialized;
  static String? get initializationError => _error;
  static SupabaseClient get client => Supabase.instance.client;
}
