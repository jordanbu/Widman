import 'package:flutter/material.dart';
import 'package:widmancrm/api/api_service.dart';
import 'package:widmancrm/models/cliente_model.dart';
import 'package:widmancrm/models/lista_producto_venta_model.dart';

import '../../navigation/stock_navigation.dart';

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
  List<ProductoVenta> _selectedProductos = [];
  bool _isLoading = false;
  late Future<List<Cliente>> _futureClientes;

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

  Future<void> _selectProductos() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StockNavigation()),
    );

    if (result != null && result is List<ProductoVenta>) {
      setState(() {
        _selectedProductos = result;
      });
    }
  }

  Future<void> _guardarCotizacion() async {
    if (!_formKey.currentState!.validate() || _selectedCliente == null) {
      _showSnackBar('Completa todos los campos requeridos');
      return;
    }

    if (_selectedProductos.isEmpty) {
      _showSnackBar('Selecciona al menos un producto');
      return;
    }

    setState(() => _isLoading = true);

    final nuevaCotizacion = {
      "nombre": _nombreController.text.trim(),
      "observacion": _observacionController.text.trim(),
      "idcliente": _selectedCliente!.idPersona,
      "cod_estado": "ACT",
      "tipo": 1,
      "productos": _selectedProductos.map((producto) => producto.toJson()).toList(),
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

  Widget _buildNombreField() {
    return TextFormField(
      controller: _nombreController,
      decoration: const InputDecoration(
        labelText: 'Nombre de Cotización',
        hintText: 'Ingresa el nombre de la cotización',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'El nombre es obligatorio';
        }
        return null;
      },
    );
  }

  Widget _buildObservacionField() {
    return TextFormField(
      controller: _observacionController,
      decoration: const InputDecoration(
        labelText: 'Observación',
        hintText: 'Ingresa una observación (opcional)',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
    );
  }

  Widget _buildClienteDropdown(List<Cliente> clientes) {
    return DropdownButtonFormField<Cliente>(
      value: _selectedCliente,
      decoration: const InputDecoration(
        labelText: 'Seleccionar Cliente',
        hintText: 'Elige un cliente',
        border: OutlineInputBorder(),
      ),
      items: clientes.map((cliente) {
        return DropdownMenuItem<Cliente>(
          value: cliente,
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 80),
            child: Text(
              cliente.nombre,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        );
      }).toList(),
      onChanged: (cliente) => setState(() => _selectedCliente = cliente),
      validator: (value) => value == null ? 'Selecciona un cliente' : null,
      isExpanded: true,
    );
  }
  Widget _buildProductosField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Productos Seleccionados',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _selectProductos,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2A4D69),
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text(
            'Seleccionar Productos',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        _selectedProductos.isEmpty
            ? const Text('No hay productos seleccionados.')
            : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _selectedProductos.length,
          itemBuilder: (context, index) {
            final producto = _selectedProductos[index];
            return ListTile(
              title: Text(producto.nombre),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Código: ${producto.codAlterno}'),
                  Text('Stock: ${producto.nsUnidad}'),
                  Text('Tipo: ${producto.tipo}'),
                  Text('ID: ${producto.numSec}'),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _selectedProductos.removeAt(index);
                  });
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGuardarButton() {
    return ElevatedButton(
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
                  _buildNombreField(),
                  const SizedBox(height: 12),
                  _buildObservacionField(),
                  const SizedBox(height: 12),
                  _buildClienteDropdown(clientes),
                  const SizedBox(height: 12),
                  _buildProductosField(),
                  const SizedBox(height: 20),
                  _buildGuardarButton(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
