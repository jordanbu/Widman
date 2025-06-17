import 'package:flutter/material.dart';

class CotizacionNavigation extends StatelessWidget {
  const CotizacionNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cotizacion'),
        backgroundColor: const Color(0xFF455A64),
      ),
      body: const Center(
        child: Text(
          'Pantalla Cotizacion',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}