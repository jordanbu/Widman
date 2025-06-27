import 'package:flutter/material.dart';
import 'package:widmancrm/Screens/ScreenCotizacion/wave_clipper.dart';
import '../Screens/ScreenCotizacion/add_cotizacion.dart';
import 'package:widmancrm/api/api_Service.dart';
import 'package:widmancrm/models/cotizacion_model.dart';
import 'package:widmancrm/models/cliente_model.dart';

class CotizacionNavigation extends StatefulWidget {
  const CotizacionNavigation({super.key});

  @override
  State<CotizacionNavigation> createState() => _CotizacionNavigationState();
}

class _CotizacionNavigationState extends State<CotizacionNavigation> {
  final ApiService _apiService = ApiService();
  late Future<List<Cotizacion>> _futureCotizaciones;
  List<Cliente> _clientes = [];
  bool _clientesLoaded = false;

  String _searchQuery = '';
  String _selectedFilter = 'ID';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    print('API mostrando datos'); // Added console message
    _loadCotizaciones();
    _loadClientes();
  }

  void _loadCotizaciones() {
    setState(() {
      _futureCotizaciones = _apiService.fetchCotizaciones();
    });
  }

  void _loadClientes() async {
    try {
      final clientes = await _apiService.fetchClientes();
      setState(() {
        _clientes = clientes;
        _clientesLoaded = true;
      });
    } catch (e) {
      print('Error cargando clientes: $e');
      setState(() {
        _clientesLoaded = true;
      });
    }
  }

  String _getClienteName(int idCliente) {
    if (!_clientesLoaded) return 'Cargando...';
    try {
      final cliente = _clientes.firstWhere((c) => c.idPersona == idCliente);
      return cliente.nombre;
    } catch (e) {
      return 'Cliente no encontrado';
    }
  }

  String _getEstadoText(String codEstado) {
    switch (codEstado.toUpperCase()) {
      case 'ACT':
        return 'Activa';
      case 'PEN':
        return 'Pendiente';
      case 'APR':
        return 'Aprobada';
      case 'REC':
        return 'Rechazada';
      case 'CAN':
        return 'Cancelada';
      default:
        return codEstado;
    }
  }

  Color _getEstadoColor(String codEstado) {
    switch (codEstado.toUpperCase()) {
      case 'ACT':
        return Colors.green;
      case 'PEN':
        return Colors.orange;
      case 'APR':
        return Colors.blue;
      case 'REC':
        return Colors.red;
      case 'CAN':
        return Colors.grey;
      default:
        return Colors.black54;
    }
  }

  void _showCotizacionDetails(Cotizacion cotizacion) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.description, color: Color(0xFF2A4D69)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Detalles de Cotización',
                  style: TextStyle(
                    color: Color(0xFF2A4D69),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailCard('ID', cotizacion.numSec.toString(), Icons.tag),
                _buildDetailCard('Nombre', cotizacion.nombre, Icons.title),
                _buildDetailCard('Cliente', _getClienteName(cotizacion.idCliente), Icons.person),
                _buildDetailCard('Fecha', cotizacion.fecha, Icons.calendar_today),
                _buildDetailCard('Estado', _getEstadoText(cotizacion.codEstado), Icons.info,
                    color: _getEstadoColor(cotizacion.codEstado)),
                _buildDetailCard('Tipo', cotizacion.tipo.toString(), Icons.category),
                if (cotizacion.observacion.isNotEmpty)
                  _buildDetailCard('Observación', cotizacion.observacion, Icons.note, isLongText: true),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF2A4D69),
              ),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailCard(String label, String value, IconData icon, {Color? color, bool isLongText = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: isLongText ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color ?? Colors.grey[600]),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color ?? Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCotizacionCard(Cotizacion cotizacion) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showCotizacionDetails(cotizacion),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con ID y Estado
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFF2A4D69).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'ID: ${cotizacion.numSec}',
                        style: TextStyle(
                          color: Color(0xFF2A4D69),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getEstadoColor(cotizacion.codEstado).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getEstadoColor(cotizacion.codEstado),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _getEstadoText(cotizacion.codEstado),
                        style: TextStyle(
                          color: _getEstadoColor(cotizacion.codEstado),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Nombre de la cotización
                Text(
                  cotizacion.nombre,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),

                // Cliente y Fecha
                Row(
                  children: [
                    Icon(Icons.person, size: 14, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        _getClienteName(cotizacion.idCliente),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(
                      cotizacion.fecha,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),

                // Observación si existe
                if (cotizacion.observacion.isNotEmpty) ...[
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.note, size: 14, color: Colors.grey[600]),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            cotizacion.observacion,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              height: MediaQuery.of(context).size.height * 0.6,
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
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Cotizaciones',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white, size: 26),
                        onPressed: _loadData,
                        tooltip: 'Actualizar',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar cotizaciones...',
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF2A4D69)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: ['ID', 'Nombre', 'Fecha'].map((filtro) {
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedFilter = filtro;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _selectedFilter == filtro
                                      ? const Color(0xFF2A4D69)
                                      : Colors.white,
                                  foregroundColor: _selectedFilter == filtro
                                      ? Colors.white
                                      : const Color(0xFF2A4D69),
                                  elevation: _selectedFilter == filtro ? 4 : 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                ),
                                child: Text(
                                  filtro,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: FutureBuilder<List<Cotizacion>>(
                        future: _futureCotizaciones,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Color(0xFF2A4D69),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Cargando cotizaciones...',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 64,
                                    color: Colors.red[300],
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Error al cargar cotizaciones',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red[700],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '${snapshot.error}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _loadData,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF2A4D69),
                                    ),
                                    child: Text(
                                      'Reintentar',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.description_outlined,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No hay cotizaciones',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Las cotizaciones que crees aparecerán aquí',
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                ],
                              ),
                            );
                          }

                          final cotizaciones = snapshot.data!;
                          final q = _searchQuery.toLowerCase();

                          final filtradas = cotizaciones.where((c) {
                            if (_selectedFilter == 'ID') {
                              return c.numSec.toString().contains(q);
                            } else if (_selectedFilter == 'Nombre') {
                              return c.nombre.toLowerCase().contains(q);
                            } else if (_selectedFilter == 'Fecha') {
                              return c.fecha.contains(q);
                            }
                            return true;
                          }).toList();

                          // Ordenar por ID descendente (más recientes primero)
                          filtradas.sort((a, b) => b.numSec.compareTo(a.numSec));

                          if (filtradas.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No se encontraron resultados',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Prueba con otros términos de búsqueda',
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                ],
                              ),
                            );
                          }

                          return RefreshIndicator(
                            onRefresh: () async => _loadData(),
                            color: Color(0xFF2A4D69),
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              itemCount: filtradas.length,
                              itemBuilder: (context, index) {
                                return _buildCotizacionCard(filtradas[index]);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddCotizacion()),
          );

          if (result == true) {
            _loadData();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Cotización creada exitosamente'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        backgroundColor: const Color(0xFF2A4D69),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nueva Cotización',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
