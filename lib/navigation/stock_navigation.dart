import 'package:flutter/material.dart';
import 'package:widmancrm/Screens/ScreenStock/wave_clipper.dart';

class StockNavigation extends StatelessWidget {
  const StockNavigation({super.key});

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
                        'Stock de Productos',
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
                          const Text(
                            'Lista de Productos',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF455A64),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Search bar and filter
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Buscar...',
                                    prefixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF455A64),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
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
                              ),
                              const SizedBox(width: 8),
                              DropdownButton<String>(
                                value: 'Nombre',
                                items: <String>['Nombre', 'Código'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  // Implement filter type change logic here
                                },
                                style: const TextStyle(
                                  color: Color(0xFF455A64),
                                  fontSize: 16,
                                ),
                                dropdownColor: Colors.white,
                                icon: const Icon(Icons.filter_list, color: Color(0xFF2A4D69)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Add your product list items here
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
