import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/database/isar_service.dart';
import 'core/services/supabase_service.dart';
import 'features/auth/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await IsarService.init();
  await SupabaseService.init();

  runApp(
    const ProviderScope(
      child: PosFlutterApp(),
    ),
  );
}

class PosFlutterApp extends StatelessWidget {
  const PosFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mire Sunset POS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          primary: Colors.brown,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
