import 'package:flutter/material.dart';
import 'package:widmancrm/Screens/ScreenVentas/new_sale_screen.dart';
import '../Screens/ScreenVentas/wave_clipper.dart';
import '../api/api_Service.dart';
import '../models/venta_model.dart';

class VentNavigation extends StatefulWidget {
  const VentNavigation({super.key});

  @override
  _VentNavigationState createState() => _VentNavigationState();
}

class _VentNavigationState extends State<VentNavigation> {
  final ApiService _apiService = ApiService();
  String _searchQuery = '';
  String _filterType = 'Nombre';

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
                        'Ventas',
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
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Venta de Productos',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF455A64),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
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
                                      setState(() {
                                        _searchQuery = value.toLowerCase();
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                DropdownButton<String>(
                                  value: _filterType,
                                  items: <String>['Nombre', 'Código'].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _filterType = newValue!;
                                    });
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
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: FutureBuilder<List<Venta>>(
                              future: _apiService.fetchVentas(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return const Center(child: Text('No hay ventas disponibles'));
                                }

                                final ventas = snapshot.data!;
                                final filteredVentas = ventas.where((venta) {
                                  if (_filterType == 'Nombre') {
                                    return venta.nombre.toLowerCase().contains(_searchQuery);
                                  } else {
                                    return venta.numSec.toString().contains(_searchQuery);
                                  }
                                }).toList();

                                return ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: filteredVentas.length,
                                  itemBuilder: (context, index) {
                                    final venta = filteredVentas[index];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(vertical: 8),
                                      child: ListTile(
                                        title: Text(
                                          venta.nombre,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2A4D69),
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Código: ${venta.numSec}'),
                                            Text('Fecha: ${venta.fecha}'),
                                            Text('Estado: ${venta.codEstado}'),
                                            Text('Observación: ${venta.observacion}'),
                                            Text('Tipo: ${venta.tipo}'),
                                            Text('ID Cliente: ${venta.idCliente}'),
                                          ],
                                        ),
                                        onTap: () {
                                          // Implement navigation or details view here
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> NewSaleScreen()));
        },
        backgroundColor: const Color(0xFF2A4D69),
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Registrar Nueva Venta',
      ),
    );
  }
}
