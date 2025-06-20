import 'package:flutter/material.dart';
import 'package:widmancrm/Screens/ScreenCotizacion/wave_clipper.dart';

class AddCotizacion extends StatelessWidget {
  const AddCotizacion({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background with wave curve
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF2A4D69), Color(0xFF3C5A74)],
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.6,
            ),
          ),
          // Main content
          SafeArea(
            child: Column(
              children: [
                // AppBar personalizado
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white, size: 35),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Nueva Cotizacion',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Search bar
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Nombre del Cliente',
                          hintStyle: const TextStyle(color: Color(0xFF2A4D69)),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF2A4D69),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Color(0xFF2A4D69)),
                      ),
                      const SizedBox(height: 12),
                      // Row for Todos, Nombre, Razon Social
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(

                            'Todos',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),

                          const Expanded(child: SizedBox()),
                          const Text(
                            'Nombre',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          const Text(
                            'Razón Social',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.white,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          const Text(
                            'Lista de Clientes',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF455A64),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
