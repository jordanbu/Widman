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

  static const _primaryColor = Color(0xFF2A4D69);
  static const _accentColor = Color(0xFFE8ECEF);
  static const _errorColor = Colors.redAccent;

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
      _showSnackBar('Completa todos los campos requeridos', isError: true);
      return;
    }

    if (_productosSeleccionados.isEmpty) {
      _showSnackBar('Debe seleccionar al menos un producto', isError: true);
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
      _showSnackBar('Error al registrar: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: const TextStyle(color: Colors.white)),
          backgroundColor: isError ? _errorColor : _primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  void _agregarProducto() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          'No se han agregado productos aún.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
      );
    }
    return Column(
      children: _productosSeleccionados.map((producto) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              producto.nombre,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            subtitle: Text(
              'Código: ${producto.codAlterno}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: _errorColor),
              onPressed: () {
                setState(() => _productosSeleccionados.remove(producto));
              },
            ),
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: _accentColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Cliente>>(
            future: _futureClientes,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: _primaryColor));
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error al cargar clientes: ${snapshot.error}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: _errorColor),
                  ),
                );
              }

              final clientes = snapshot.data ?? [];

              return Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nombreController,
                              decoration: InputDecoration(
                                labelText: 'Nombre de Cotización',
                                hintText: 'Ingresa el nombre de la cotización',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: const TextStyle(color: _primaryColor),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: _primaryColor, width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) => (value == null || value.trim().isEmpty)
                                  ? 'El nombre es obligatorio'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _observacionController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: 'Observación',
                                hintText: 'Ingresa una observación (opcional)',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: const TextStyle(color: _primaryColor),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: _primaryColor, width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            /// ✅ Dropdown Cliente con desborde arreglado
                            DropdownButtonFormField<Cliente>(
                              value: _selectedCliente,
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                              isExpanded: true, // ✅ Esto previene el desborde
                              decoration: InputDecoration(
                                labelText: 'Seleccionar Cliente',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: const TextStyle(color: _primaryColor),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: _primaryColor, width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              ),
                              items: clientes.map((cliente) {
                                return DropdownMenuItem(
                                  value: cliente,
                                  child: SizedBox(
                                    width: double.infinity, // ✅ Ocupa todo el ancho disponible
                                    child: Text(
                                      cliente.nombre,
                                      overflow: TextOverflow.ellipsis, // ✅ Corta el texto si es muy largo
                                      maxLines: 1, // ✅ Solo una línea
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (cliente) => setState(() => _selectedCliente = cliente),
                              validator: (value) =>
                              value == null ? 'Selecciona un cliente' : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Productos seleccionados',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildProductosSeleccionados(),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity, // ✅ Botón ocupa todo el ancho
                      child: TextButton.icon(
                        onPressed: _agregarProducto,
                        icon: const Icon(Icons.add, color: _primaryColor),
                        label: const Text(
                          'Agregar producto',
                          style: TextStyle(color: _primaryColor, fontWeight: FontWeight.w600),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: _primaryColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity, // ✅ Botón ocupa todo el ancho
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _guardarCotizacion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 3,//jordan solo puedo escribir, no puedo hacer click en nada
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                          'Guardar Cotización',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
