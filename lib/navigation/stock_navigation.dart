import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:widmancrm/api/api_Service.dart';
import 'package:widmancrm/models/lista_producto_venta_model.dart';
import '../Screens/ScreenStock/wave_clipper.dart';

class PrecioProducto {
  final int nsProducto;
  final double precio;
  final double descuento;
  final String codigoMoneda;

  PrecioProducto({
    required this.nsProducto,
    required this.precio,
    required this.descuento,
    required this.codigoMoneda,
  });

  factory PrecioProducto.fromJson(Map<String, dynamic> json) {
    return PrecioProducto(
      nsProducto: json['ns_Producto'],
      precio: (json['precio'] as num).toDouble(),
      descuento: (json['precio_por_descuento'] as num).toDouble(),
      codigoMoneda: json['codigo_moneda'] ?? 'Bs',
    );
  }
}

class StockNavigation extends StatefulWidget {
  final int? idCliente;

  const StockNavigation({super.key, this.idCliente});

  @override
  State<StockNavigation> createState() => _StockNavigationState();
}

class _StockNavigationState extends State<StockNavigation> {
  final ApiService _apiService = ApiService();
  late Future<List<ProductoVenta>> _futureProductos;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _searchError;
  Map<int, PrecioProducto> mapaPrecios = {};
  bool _loadingPrecios = false;

  @override
  void initState() {
    super.initState();
    _futureProductos = _apiService.fetchListaProductoVenta();
    _searchController.addListener(_validateAndFilter);
    _cargarPrecios();
  }

  Future<void> _cargarPrecios() async {
    setState(() {
      _loadingPrecios = true;
    });

    try {
      final idCliente = widget.idCliente ?? 1;
      final precios = await _fetchListaPreciosPorCliente(idCliente);

      setState(() {
        mapaPrecios = { for (var p in precios) p.nsProducto : p };
        _loadingPrecios = false;
      });
    } catch (e) {
      setState(() {
        _loadingPrecios = false;
      });
      print('Error al cargar precios: $e');
    }
  }

  Future<List<PrecioProducto>> _fetchListaPreciosPorCliente(int idCliente) async {
    final String url = 'http://192.168.0.9/WIDMANCRM/Comunicacion.svc/listaprecios?idCliente=$idCliente';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => PrecioProducto.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener precios: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
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
      } else if (!RegExp(r'^[a-zA-Z0-9\s]+\$').hasMatch(query)) {
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
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Stock de productos',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      if (_loadingPrecios)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
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
                                  final precioInfo = mapaPrecios[producto.numSec];

                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    child: ListTile(
                                      leading: const Icon(Icons.shopping_bag, color: Color(0xFF2A4D69)),
                                      title: Text(
                                        producto.nombre,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Código: ${producto.codAlterno}'),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.attach_money, size: 16, color: Colors.green),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  _buildPrecioText(precioInfo),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: precioInfo != null
                                                        ? Colors.green[700]
                                                        : Colors.grey[600],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (precioInfo != null && precioInfo.descuento > 0)
                                            Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.local_offer, size: 16, color: Colors.orange),
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      'Descuento: ${precioInfo.codigoMoneda} ${precioInfo.descuento.toStringAsFixed(2)}',
                                                      style: TextStyle(
                                                        color: Colors.orange[700],
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                      trailing: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[100],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'ID: ${producto.numSec}',
                                          style: TextStyle(
                                            color: Colors.blue[800],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
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

  String _buildPrecioText(PrecioProducto? precioInfo) {
    if (precioInfo == null) {
      return 'Precio: No disponible';
    }
    return 'Precio: ${precioInfo.codigoMoneda} ${precioInfo.precio.toStringAsFixed(2)}';
  }
}
