import 'package:flutter/material.dart';
import 'package:widmancrm/Screens/ScreenCotizacion/wave_clipper.dart';
import 'package:widmancrm/api/api_Service.dart';
import '../../models/lista_producto_venta_model.dart';

// Modelo para producto con cantidad
class ProductoCotizado {
  final ProductoVenta producto;
  int cantidad;

  ProductoCotizado({required this.producto, this.cantidad = 1});
}

class AddCotizacion extends StatefulWidget {
  const AddCotizacion({super.key});

  @override
  State<AddCotizacion> createState() => _AddCotizacionState();
}

class _AddCotizacionState extends State<AddCotizacion> {
  final ApiService _apiService = ApiService();
  late Future<List<ProductoVenta>> _futureProductos;
  final TextEditingController _searchController = TextEditingController();

  List<ProductoVenta> _productosTotales = [];
  List<ProductoVenta> _productosFiltrados = [];
  List<ProductoCotizado> _productosAgregados = [];

  bool _isGuardando = false;

  @override
  void initState() {
    super.initState();
    _futureProductos = _apiService.fetchListaProductoVenta();
    _futureProductos.then((productos) {
      setState(() {
        _productosTotales = productos;
        _productosFiltrados = productos;
      });
    });

    _searchController.addListener(_filtrarProductos);
  }

  void _filtrarProductos() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _productosFiltrados = _productosTotales.where((p) {
        return p.nombre.toLowerCase().contains(query) ||
            p.numSec.toString().contains(query);
      }).toList();
    });
  }

  void _eliminarProducto(int index) {
    setState(() {
      _productosAgregados.removeAt(index);
    });
  }

  Future<void> _agregarProductoConCantidad(ProductoVenta producto) async {
    final cantidad = await _mostrarDialogoCantidad();
    if (cantidad != null && cantidad > 0) {
      final yaExiste = _productosAgregados
          .any((p) => p.producto.numSec == producto.numSec);

      setState(() {
        if (yaExiste) {
          final existente = _productosAgregados
              .firstWhere((p) => p.producto.numSec == producto.numSec);
          existente.cantidad += cantidad;
        } else {
          _productosAgregados.add(
            ProductoCotizado(producto: producto, cantidad: cantidad),
          );
        }
        _searchController.clear();
        _productosFiltrados = _productosTotales;
      });
    }
  }

  Future<int?> _mostrarDialogoCantidad() async {
    final controller = TextEditingController();

    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cantidad'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Ingrese la cantidad'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final value = int.tryParse(controller.text);
                Navigator.pop(context, value);
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _guardarCotizacion() async {
    if (_productosAgregados.isEmpty) return;

    setState(() {
      _isGuardando = true;
    });

    try {
      final productos = _productosAgregados.map((p) => {
        "id": p.producto.numSec,
        "cantidad": p.cantidad.toDouble(),
      }).toList();

      // Datos estáticos para pruebas, modifica según tu necesidad
      final observacion = "Cotización desde app Flutter";
      final empresa = "Empresa XYZ";
      final idEmpresa = 118;
      final idCliente = 17266120;
      final usuario = "drada";
      final emailCliente = "jclavijo@singleton.com.bo";

      final respuesta = await _apiService.registrarCotizacionDesdePantalla(
        observacion: observacion,
        empresa: empresa,
        idEmpresa: idEmpresa,
        idCliente: idCliente,
        usuario: usuario,
        emailCliente: emailCliente,
        productos: productos,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cotización guardada. Respuesta: $respuesta')),
        );
        setState(() {
          _productosAgregados.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar cotización: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGuardando = false;
        });
      }
    }
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
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // Fondo con wave
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: size.height * 0.35,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2A4D69), Color(0xFF4B749F)],
                ),
              ),
            ),
          ),

          // Contenido principal
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Nueva Cotización',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Card principal
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Buscar Producto',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2A4D69),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Nombre o ID del producto',
                                filled: true,
                                fillColor: Colors.grey[300],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: const Icon(Icons.search,
                                    color: Color(0xFF2A4D69)),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    _filtrarProductos();
                                  },
                                )
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Lista de productos
                            SizedBox(
                              height: 220,
                              child: FutureBuilder<List<ProductoVenta>>(
                                future: _futureProductos,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return const Center(
                                        child: Text('Error al cargar productos'));
                                  } else if (_productosFiltrados.isEmpty) {
                                    return const Center(
                                        child: Text('No se encontraron productos'));
                                  }

                                  return ListView.builder(
                                    itemCount: _productosFiltrados.length,
                                    itemBuilder: (context, index) {
                                      final producto = _productosFiltrados[index];
                                      return ListTile(
                                        title: Text(producto.nombre),
                                        subtitle: Text('ID: ${producto.numSec}'),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.add_circle,
                                              color: Color(0xFF2A4D69)),
                                          onPressed: () =>
                                              _agregarProductoConCantidad(producto),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            const Divider(height: 32),

                            // Productos agregados
                            const Text(
                              'Productos Agregados',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _productosAgregados.isEmpty
                                ? const Text('No hay productos agregados.')
                                : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _productosAgregados.length,
                              itemBuilder: (context, index) {
                                final p = _productosAgregados[index];
                                return Card(
                                  margin:
                                  const EdgeInsets.symmetric(vertical: 6),
                                  child: ListTile(
                                    title: Text(p.producto.nombre),
                                    subtitle: Text('ID: ${p.producto.numSec}'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('x${p.cantidad}'),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.redAccent),
                                          onPressed: () => _eliminarProducto(index),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Guardar cotización
                    ElevatedButton(
                      onPressed: _isGuardando ? null : _guardarCotizacion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A4D69),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isGuardando
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text(
                        'Guardar Cotización',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
