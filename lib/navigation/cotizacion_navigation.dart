import 'package:flutter/material.dart';

class CotizacionNavigation extends StatelessWidget {
  const CotizacionNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
            color: Colors.white,
            size: 35,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Cotizacion',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF455A64),
      ),
      backgroundColor: const Color(0xFF455A64), // Asegura el fondo oscuro
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Pantalla Cotizacion',
              style: TextStyle(
                fontSize: 23,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
