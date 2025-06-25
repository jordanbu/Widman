import 'package:flutter/material.dart';
import 'package:widmancrm/api/api_Service.dart';
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

  @override
  void initState() {
    super.initState();
    _futureProductos = _apiService.fetchListaProductoVenta();
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
                              return ListView.builder(
                                itemCount: productos.length,
                                itemBuilder: (context, index) {
                                  final producto = productos[index];
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
