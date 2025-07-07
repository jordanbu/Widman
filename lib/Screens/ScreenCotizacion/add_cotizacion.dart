import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'serializacion_utils.dart';
import 'package:widmancrm/api/api_service.dart';
import 'package:widmancrm/models/lista_producto_venta_model.dart';

class AddCotizacion extends StatefulWidget {
  const AddCotizacion({super.key});

  @override
  State<AddCotizacion> createState() => _AddCotizacionState();
}

class _AddCotizacionState extends State<AddCotizacion> {
  final ApiService _apiService = ApiService();
  late Future<List<ProductoVenta>> _futureProductos;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _searchError;
  bool enviando = false;

  List<List<Object>> productosSeleccionados = [];
  List<Map<String, dynamic>> productosParaMostrar = [];

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

  Future<void> registrarCotizacion() async {
    if (productosSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Debes seleccionar al menos un producto")),
      );
      return;
    }

    setState(() => enviando = true);

    final prefs = await SharedPreferences.getInstance();
    final usuario = prefs.getString('usuario') ?? 'jordan';

    double total = 0;
    for (var producto in productosSeleccionados) {
      double precio = producto[1] as double;
      int cantidad = producto[2] as int;
      total += precio * cantidad;
    }

    List<Object?> datos = [
      "", // observación
      11028,
      "",
      11,
      usuario,
      "",
      6611,
      total,
      productosSeleccionados,
      7
    ];

    String cadena = SerializacionUtils.generarCadenaEnvioAlServidor(datos);
    debugPrint("🔗 Cadena enviada: $cadena");

    final url = Uri.parse(
      'http://app.singleton.com.bo/WIDMANCRM/Comunicacion.svc/RegistrarCotizacion?Datos=$cadena',
    );

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Cotización registrada correctamente')),
        );
        setState(() {
          productosSeleccionados.clear();
          productosParaMostrar.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Error 400: Verifica los datos enviados')),
        );
        debugPrint("❌ Respuesta: ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error de red: $e')),
      );
    } finally {
      setState(() => enviando = false);
    }
  }

  void _mostrarDialogoProducto(ProductoVenta producto) {
    final precioController = TextEditingController(text: '0.0');
    final cantidadController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Agregar: ${producto.nombre}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: precioController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Precio'),
            ),
            TextField(
              controller: cantidadController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cantidad'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final precio = double.tryParse(precioController.text) ?? 0.0;
              final cantidad = int.tryParse(cantidadController.text) ?? 1;
              if (precio <= 0 || cantidad <= 0) return;

              setState(() {
                productosSeleccionados.add([
                  producto.numSec,
                  precio,
                  cantidad,
                  611,
                ]);

                productosParaMostrar.add({
                  'nombre': producto.nombre,
                  'precio': precio,
                  'cantidad': cantidad,
                  'subtotal': precio * cantidad,
                });
              });
              Navigator.pop(context);
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  void _eliminarProducto(int index) {
    setState(() {
      productosSeleccionados.removeAt(index);
      productosParaMostrar.removeAt(index);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Cotización'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: enviando ? null : registrarCotizacion,
          )
        ],
      ),
      body: Column(
        children: [
          if (productosParaMostrar.isNotEmpty) ...[
            Container(
              height: 200,
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🛒 Productos seleccionados: ${productosParaMostrar.length}'),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: productosParaMostrar.length,
                      itemBuilder: (context, index) {
                        final producto = productosParaMostrar[index];
                        return Card(
                          child: ListTile(
                            title: Text(producto['nombre']),
                            subtitle: Text('Precio: \$${producto['precio']} | Cantidad: ${producto['cantidad']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('\$${producto['subtotal'].toStringAsFixed(2)}'),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _eliminarProducto(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
          ],

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
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
                  final filtered = _searchQuery.isEmpty
                      ? productos
                      : productos.where((p) =>
                  p.nombre.toLowerCase().contains(_searchQuery) ||
                      p.numSec.toString().contains(_searchQuery)).toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text('No se encontraron productos.'));
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final producto = filtered[index];
                      return ListTile(
                        leading: const Icon(Icons.shopping_cart),
                        title: Text(producto.nombre),
                        subtitle: Text('Código: ${producto.codAlterno}'),
                        trailing: Text('ID: ${producto.numSec}'),
                        onTap: () => _mostrarDialogoProducto(producto),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
