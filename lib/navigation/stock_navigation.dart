import 'package:flutter/material.dart';
import 'package:widmancrm/api/api_service.dart';
import 'package:widmancrm/models/lista_producto_venta_model.dart';
import '../Screens/ScreenStock/wave_clipper.dart';

class StockNavigation extends StatefulWidget {
  const StockNavigation({super.key});

  @override
  State<StockNavigation> createState() => _StockNavigationState();
}

class _StockNavigationState extends State<StockNavigation> {
  final ApiService _apiService = ApiService();
  late Future<List<ProductoVenta>> _futureProductos;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _searchError;

  @override
  void initState() {
    super.initState();
    _futureProductos = _apiService.fetchListaProductoVenta();
    _searchController.addListener(_validateAndFilter);
  }

  void _validateAndFilter() {
    final query = _searchController.text.trim();
    setState(() {
      if (query.isEmpty) {
        _searchError = null;
        _searchQuery = '';
      } else if (query.length < 2) {
        _searchError = 'Ingrese al menos 2 caracteres';
        _searchQuery = '';
      } else if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(query)) {
        _searchError = 'Solo letras y números son permitidos';
        _searchQuery = '';
      } else {
        _searchError = null;
        _searchQuery = query.toLowerCase();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
              height: size.height * 0.6,
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
                        icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Stock de productos',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar por nombre o ID...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      errorText: _searchError,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: FutureBuilder<List<ProductoVenta>>(
                          future: _futureProductos,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text('No hay productos disponibles.'));
                            } else {
                              final productos = snapshot.data!;
                              final filteredProductos = _searchQuery.isEmpty
                                  ? productos
                                  : productos.where((producto) {
                                final nombreLower = producto.nombre.toLowerCase();
                                final idString = producto.numSec.toString();
                                return nombreLower.contains(_searchQuery) ||
                                    idString.contains(_searchQuery);
                              }).toList();

                              if (filteredProductos.isEmpty && _searchQuery.isNotEmpty) {
                                return const Center(child: Text('No se encontraron productos.'));
                              }

                              return ListView.builder(
                                itemCount: filteredProductos.length,
                                itemBuilder: (context, index) {
                                  final producto = filteredProductos[index];
                                  return ListTile(
                                    leading: const Icon(Icons.shopping_bag),
                                    title: Text(producto.nombre),
                                    subtitle: Text('Código: ${producto.codAlterno}'),
                                    trailing: Text('ID: ${producto.numSec}'),
                                  );
                                },
                              );
                            }
                          },
                        ),
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
