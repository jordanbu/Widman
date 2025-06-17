import 'package:flutter/material.dart';

class CotizacionScreen extends StatelessWidget {
  const CotizacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Titulo'),
        backgroundColor: const Color(0xFF455A64),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('GUARDAR', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
<<<<<<< HEAD
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                icon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                icon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Zón Social',
                icon: Icon(Icons.people),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Observación',
                icon: Icon(Icons.visibility),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Entregar por:'),
            Row(
              children: const [
                Radio(value: 'Correo', groupValue: 'delivery', onChanged: null),
                Text('Correo'),
                Radio(value: 'Descarga', groupValue: 'delivery', onChanged: null),
                Text('Descarga'),
              ],
            ),
          ],
=======
      body: const Center(
        child: Text(
          'Pantalla Cotizacion prueba',
          style: TextStyle(fontSize: 24),
>>>>>>> c9cadc093bfe3f093a785ec354d74d5bb0c2e382
        ),
      ),
    );
  }
}
