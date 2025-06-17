import 'package:flutter/material.dart';

class CotizacionScreen extends StatefulWidget {
  const CotizacionScreen({super.key});

  @override
  State<CotizacionScreen> createState() => _CotizacionScreenState();
}

class _CotizacionScreenState extends State<CotizacionScreen> {
  String? _deliveryMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Titulo',
        style: TextStyle(
          color: Colors.white
        ),),
        backgroundColor: const Color(0xFF455A64),
        actions: [
          TextButton(
            onPressed: () {
              // Acción de guardar
            },
            child: const Text(
              'GUARDAR',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(  // Para evitar overflow si el teclado aparece
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
                  labelText: 'Razón Social',
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
                children: [
                  Radio<String>(
                    value: 'Correo',
                    groupValue: _deliveryMethod,
                    onChanged: (value) {
                      setState(() {
                        _deliveryMethod = value;
                      });
                    },
                  ),
                  const Text('Correo'),
                  Radio<String>(
                    value: 'Descarga',
                    groupValue: _deliveryMethod,
                    onChanged: (value) {
                      setState(() {
                        _deliveryMethod = value;
                      });
                    },
                  ),
                  const Text('Descarga'),
                ],
              ),
              const SizedBox(height: 24),

            ],
          ),
        ),
      ),
    );
  }
}
