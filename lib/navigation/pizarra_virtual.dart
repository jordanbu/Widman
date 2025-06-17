import 'package:flutter/material.dart';

class PizarraVirtual extends StatelessWidget {
  const PizarraVirtual({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizarra Virtual'),
        backgroundColor: const Color(0xFF455A64),
      ),
      body: const Center(
        child: Text(
          'Pantalla Pizarra Virtual',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}