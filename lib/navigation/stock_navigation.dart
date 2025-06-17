import 'package:flutter/material.dart';

class StockNavigation extends StatelessWidget {
  const StockNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock'),
        backgroundColor: const Color(0xFF455A64),
      ),
      body: const Center(
        child: Text(
          'Pantalla Stock',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}