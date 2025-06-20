import 'package:flutter/material.dart';
import 'package:widmancrm/Screens/ScreenProspecto/wave_clipper.dart';

class NewClient extends StatelessWidget {
  const NewClient({super.key});

  @override
  Widget build(BuildContext context) {
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 35),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Nuevo Prospecto',
                        style: TextStyle(color: Colors.white, fontSize: 20),
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
                          const SizedBox(height: 20),
                          // Circular image placeholder
                          Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Form fields
                          const Text('Nombre:', style: TextStyle(fontSize: 16)),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Nombre del Cliente',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text('Razón Social:', style: TextStyle(fontSize: 16)),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Razón Social',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text('Teléfono:', style: TextStyle(fontSize: 16)),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Teléfono',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text('Segmento:', style: TextStyle(fontSize: 16)),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Segmento',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Guardar button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2A4D69),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'Guardar',

                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
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
