import 'package:flutter/material.dart';

class ReportListVencidas extends StatelessWidget {
  const ReportListVencidas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte Listas Vencidas'),
        backgroundColor: const Color(0xFF303F9F),
      ),
      body: const Center(
        child: Text(
          'Pantalla de Reporte Listas',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
