import 'package:flutter/material.dart';

class PerfilNavigation extends StatelessWidget {
  const PerfilNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: const Color(0xFF303F9F),
      ),
      body: const Center(
        child: Text(
          'Pantalla de Perfil',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
