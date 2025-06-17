import 'package:flutter/material.dart';

class VentNavigation extends StatelessWidget {
  const VentNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Venta'),
        backgroundColor: const Color(0xFF455A64),
      ),
      body: const Center(
        child: Text(
          'Pantalla de Venta',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}