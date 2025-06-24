import 'package:flutter/material.dart';
import 'package:widmancrm/Screens/ScreenPizarraVirtual/wave_clipper.dart';

class PizarraVirtual extends StatefulWidget {
  const PizarraVirtual({super.key});

  @override
  _PizarraVirtualState createState() => _PizarraVirtualState();
}

class _PizarraVirtualState extends State<PizarraVirtual> {
  String _searchQuery = '';
  String _selectedFilter = 'All'; // Track selected filter

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
                        'Pizarra Virtual',
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
                            'Pizarra',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF455A64),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Search bar
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Buscar...',
                              prefixIcon: const Icon(Icons.search, color: Color(0xFF455A64)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF455A64)),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          // Filter buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedFilter = 'Client';
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _selectedFilter == 'Client'
                                      ? const Color(0xFF2A4D69)
                                      : Colors.grey[300],
                                  foregroundColor: _selectedFilter == 'Client'
                                      ? Colors.white
                                      : const Color(0xFF455A64),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                ),
                                child: const Text('Cliente'),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedFilter = 'Prospect';
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _selectedFilter == 'Prospect'
                                      ? const Color(0xFF2A4D69)
                                      : Colors.grey[300],
                                  foregroundColor: _selectedFilter == 'Prospect'
                                      ? Colors.white
                                      : const Color(0xFF455A64),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                ),
                                child: const Text('Prospecto'),
                              ),
                            ],
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
