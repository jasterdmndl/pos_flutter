import 'package:flutter/material.dart';
import 'features/pos/pos_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/isar_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await IsarService.init();

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
      title: 'POS Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
        ),
      ),
      home: const PosScreen(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cafe POS'),
      ),
      body: const Center(
        child: Text(
          'Cafe POS System',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}