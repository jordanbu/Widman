import 'package:flutter/material.dart';
import 'package:widmancrm/Screens/ScreenProspecto/new_client.dart';
import 'package:widmancrm/Screens/ScreenProspecto/wave_clipper.dart';

class CreateProspect extends StatelessWidget {
  const CreateProspect({super.key});

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
                        icon: const Icon(Icons.menu, color: Colors.white, size: 35),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Prospecto',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),

                TextField(
                  decoration: InputDecoration(
                    hintText: 'Nombre del cliente',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF455A64),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Color(0xFF2A4D69),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),

                  onChanged: (value) {
                    // Implement search logic here

                  },

                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Todos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                    ),
                    ),
                    const Expanded(child: SizedBox()),
                    const Text('Nombre',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                    ),
                    ),
                    const Expanded(child: SizedBox()),
                    const Text('Razon Social',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    ),

                  ],

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
                          const SizedBox(height: 16),
                          // Add your client list items here
                        ],
                      ),
                    ),

                  ),

                ),
              ],
            ),
          ),
          // Floating Action Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  // Navigate to add new client screen
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> NewClient()));
                },
                backgroundColor: const Color(0xFF2A4D69),
                child: const Icon(Icons.add, color: Colors.white),

              ),
            ),
          ),
        ],
      ),
    );
  }
}
