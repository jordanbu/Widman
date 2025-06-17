import 'package:flutter/material.dart';

class CreateProspet extends StatelessWidget {
  const CreateProspet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Prospecto'),
        backgroundColor: const Color(0xFF455A64),
      ),
      body: const Center(
        child: Text(
          'Pantalla Crear Prospecto',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
