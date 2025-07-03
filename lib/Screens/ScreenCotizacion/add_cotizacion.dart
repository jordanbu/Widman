import 'package:flutter/material.dart';
import 'package:widmancrm/api/api_Service.dart';
import 'package:widmancrm/models/cliente_model.dart';

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

  static const _primaryColor = Color(0xFF2A4D69);
  static const _accentColor = Color(0xFFE8ECEF);
  static const _errorColor = Colors.redAccent;

  // Usuario por defecto requerido por la API
  final String usuarioSistema = 'jclavijo@singleton.com.bo';

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

    setState(() => _isLoading = true);

    try {
      final datosCotizacion = [
        '0${_observacionController.text.trim()}', // Observación
        '118', // Estado u otro código fijo
        '0Empresa S.A.', // Razón social fija
        '${_selectedCliente!.idPersona}', // ID cliente seleccionado
        '0$usuarioSistema', // Usuario vendedor (prefijo 0)
        '0cliente@correo.com', // Correo del cliente
        '612', '222.0', // Producto 1
        '16611', '220.0', // Producto 2
        '7', // Producto 3 sin precio
      ];

      final datosParam = datosCotizacion.join('|');

      final resultId = await _apiService.enviarCotizacionComoCadena(datosParam);
      _showSnackBar('✅ Cotización registrada correctamente: ID $resultId');
      _limpiarFormulario();
    } catch (e) {
      _showSnackBar('❌ Error al registrar cotización: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _limpiarFormulario() {
    _nombreController.clear();
    _observacionController.clear();
    setState(() {
      _selectedCliente = null;
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? _errorColor : _primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
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
                return const Center(
                  child: CircularProgressIndicator(color: _primaryColor),
                );
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
                                hintText: 'Ej: Cotización Equipos Oficina',
                                prefixIcon: Icon(Icons.assignment, color: _primaryColor),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: const TextStyle(color: _primaryColor),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: _primaryColor, width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) =>
                              (value == null || value.trim().isEmpty) ? 'El nombre es obligatorio' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _observacionController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: 'Observación',
                                hintText: 'Descripción adicional (opcional)',
                                prefixIcon: Icon(Icons.note, color: _primaryColor),
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
                            DropdownButtonFormField<Cliente>(
                              value: _selectedCliente,
                              icon: const Icon(Icons.arrow_drop_down, color: _primaryColor),
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'Seleccionar Cliente',
                                prefixIcon: Icon(Icons.person, color: _primaryColor),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: const TextStyle(color: _primaryColor),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: _primaryColor, width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              items: clientes.map((cliente) {
                                return DropdownMenuItem(
                                  value: cliente,
                                  child: Text(cliente.nombre, overflow: TextOverflow.ellipsis),
                                );
                              }).toList(),
                              onChanged: (cliente) => setState(() => _selectedCliente = cliente),
                              validator: (value) => value == null ? 'Selecciona un cliente' : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _guardarCotizacion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 3,
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
