import 'package:flutter/material.dart';
import 'features/products/product_page.dart';

void main() {
  runApp(const PosFlutterApp());
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
      home: const ProductPage(),
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