// screens/add_cotizacion.dart
import 'package:flutter/material.dart';
import 'package:widmancrm/api/api_service.dart';
import 'package:widmancrm/models/cliente_model.dart';
import 'package:widmancrm/models/lista_producto_venta_model.dart';
import '../../widgets/producto_selector.dart';

class AddCotizacion extends StatefulWidget {
  const AddCotizacion({super.key});

  @override
  State<AddCotizacion> createState() => _AddCotizacionState();
}

class _AddCotizacionState extends State<AddCotizacion> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  final _nombreController = TextEditingController();
  final _observacionController = TextEditingController();
  Cliente? _selectedCliente;
  bool _isLoading = false;
  late Future<List<Cliente>> _futureClientes;

  List<ProductoVenta> _productosSeleccionados = [];

  @override
  void initState() {
    super.initState();
    _futureClientes = _apiService.fetchClientes();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _observacionController.dispose();
    super.dispose();
  }

  Future<void> _guardarCotizacion() async {
    if (!_formKey.currentState!.validate() || _selectedCliente == null) {
      _showSnackBar('Completa todos los campos requeridos');
      return;
    }

    if (_productosSeleccionados.isEmpty) {
      _showSnackBar('Debe seleccionar al menos un producto');
      return;
    }

    setState(() => _isLoading = true);

    final nuevaCotizacion = {
      "nombre": _nombreController.text.trim(),
      "observacion": _observacionController.text.trim(),
      "idcliente": _selectedCliente!.idPersona,
      "cod_estado": "ACT",
      "tipo": 1,
      "productos": _productosSeleccionados.map((p) => p.numSec).toList(),
    };

    try {
      final resultId = await _apiService.registrarCotizacion(nuevaCotizacion);
      _showSnackBar('Cotización registrada con ID $resultId');
      if (context.mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showSnackBar('Error al registrar: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void _agregarProducto() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ProductoSelector(
        onProductoSelected: (producto) {
          setState(() {
            if (!_productosSeleccionados.any((p) => p.numSec == producto.numSec)) {
              _productosSeleccionados.add(producto);
            }
          });
        },
      ),
    );
  }

  Widget _buildProductosSeleccionados() {
    if (_productosSeleccionados.isEmpty) {
      return const Text('No se han agregado productos aún.');
    }
    return Column(
      children: _productosSeleccionados.map((producto) {
        return ListTile(
          title: Text(producto.nombre),
          subtitle: Text('Código: ${producto.codAlterno}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() => _productosSeleccionados.remove(producto));
            },
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nueva Cotización',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2A4D69),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Cliente>>(
          future: _futureClientes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error al cargar clientes: ${snapshot.error}'));
            }
            final clientes = snapshot.data ?? [];
            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre de Cotización',
                      hintText: 'Ingresa el nombre de la cotización',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                    (value == null || value.trim().isEmpty) ? 'El nombre es obligatorio' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _observacionController,
                    decoration: const InputDecoration(
                      labelText: 'Observación',
                      hintText: 'Ingresa una observación (opcional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<Cliente>(
                    value: _selectedCliente,
                    decoration: const InputDecoration(
                      labelText: 'Seleccionar Cliente',
                      border: OutlineInputBorder(),
                    ),
                    items: clientes.map((cliente) {
                      return DropdownMenuItem(
                        value: cliente,
                        child: Text(cliente.nombre),
                      );
                    }).toList(),
                    onChanged: (cliente) => setState(() => _selectedCliente = cliente),
                    validator: (value) => value == null ? 'Selecciona un cliente' : null,
                  ),
                  const SizedBox(height: 20),
                  const Text('Productos seleccionados', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildProductosSeleccionados(),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: _agregarProducto,
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar producto'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _guardarCotizacion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A4D69),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'Guardar Cotización',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
