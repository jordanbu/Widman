import 'package:flutter/material.dart';
import 'package:widmancrm/Screens/ScreenCotizacion/wave_clipper.dart';
import '../Screens/ScreenCotizacion/add_cotizacion.dart';
import 'package:widmancrm/api/api_Service.dart';
import 'package:widmancrm/models/cotizacion_model.dart';

class CotizacionNavigation extends StatefulWidget {
  const CotizacionNavigation({super.key});

  @override
  State<CotizacionNavigation> createState() => _CotizacionNavigationState();
}

class _CotizacionNavigationState extends State<CotizacionNavigation> {
  final ApiService _apiService = ApiService();
  late Future<List<Cotizacion>> _futureCotizaciones;

  String _searchQuery = '';
  String _selectedFilter = 'ID';

  @override
  void initState() {
    super.initState();
    _futureCotizaciones = _apiService.fetchCotizaciones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 16),
                      const Text('Cotización',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar por ID, Nombre o Fecha',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: ['ID', 'Nombre', 'Fecha'].map((filtro) {
                          return ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedFilter = filtro;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedFilter == filtro
                                  ? const Color(0xFF2A4D69)
                                  : Colors.grey[300],
                              foregroundColor: _selectedFilter == filtro
                                  ? Colors.white
                                  : const Color(0xFF455A64),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(filtro),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: FutureBuilder<List<Cotizacion>>(
                        future: _futureCotizaciones,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('No hay cotizaciones disponibles.'));
                          }

                          final cotizaciones = snapshot.data!;
                          final q = _searchQuery.toLowerCase();

                          final filtradas = cotizaciones.where((c) {
                            if (_selectedFilter == 'ID') {
                              return c.numSec.toString().contains(q);
                            } else if (_selectedFilter == 'Nombre') {
                              return c.nombre.toLowerCase().contains(q);
                            } else if (_selectedFilter == 'Fecha') {
                              return c.fecha.contains(q);
                            }
                            return true;
                          }).toList();

                          return ListView.builder(
                            itemCount: filtradas.length,
                            itemBuilder: (context, i) {
                              final c = filtradas[i];
                              return ListTile(
                                leading: Text(c.numSec.toString()),
                                title: Text(c.nombre),
                                subtitle: Text(c.fecha),
                                trailing: Text(c.observacion),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddCotizacion()),
          );
        },
        backgroundColor: const Color(0xFF2A4D69),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
