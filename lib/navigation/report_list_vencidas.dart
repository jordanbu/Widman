import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:widmancrm/Screens/ScreenReporteListasVencidas/wave_clipper.dart';
import '../api/api_Service.dart';
import '../../models/vendedor_model.dart';

class ReportListVencidas extends StatefulWidget {
  const ReportListVencidas({super.key});

  @override
  State<ReportListVencidas> createState() => _ReportListVencidasState();
}

class _ReportListVencidasState extends State<ReportListVencidas> {
  late Future<List<Vendedor>> _vendedores;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  final TextEditingController _correoController = TextEditingController();
  List<Vendedor> _vendedoresSeleccionados = [];
  List<Vendedor> _todosVendedores = [];

  @override
  void initState() {
    super.initState();
    _vendedores = ApiService().fetchListaVendedores();
    _cargarVendedores();
  }

  Future<void> _cargarVendedores() async {
    try {
      final vendedores = await ApiService().fetchListaVendedores();
      setState(() {
        _todosVendedores = vendedores;
      });
    } catch (e) {
      print('Error cargando vendedores: $e');
    }
  }

  Future<void> _selectFechaInicio(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaInicio ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _fechaInicio = picked;
      });
    }
  }

  Future<void> _selectFechaFin(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaFin ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _fechaFin = picked;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void _mostrarModalSeleccionVendedores() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Handle del modal
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Título
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Seleccionar Vendedores',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF455A64),
                      ),
                    ),
                  ),
                  const Divider(),
                  // Lista de vendedores
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: _todosVendedores.length,
                      itemBuilder: (context, index) {
                        final vendedor = _todosVendedores[index];
                        final isSelected = _vendedoresSeleccionados
                            .any((v) => v.numSec == vendedor.numSec);

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isSelected
                                ? const Color(0xFF2A4D69)
                                : Colors.grey[300],
                            child: Icon(
                              Icons.person,
                              color: isSelected ? Colors.white : Colors.grey[600],
                            ),
                          ),
                          title: Text(
                            vendedor.nombre,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text('Código: ${vendedor.numSec}'),
                          trailing: isSelected
                              ? const Icon(
                            Icons.check_circle,
                            color: Color(0xFF2A4D69),
                          )
                              : const Icon(
                            Icons.radio_button_unchecked,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _vendedoresSeleccionados.removeWhere(
                                        (v) => v.numSec == vendedor.numSec);
                              } else {
                                _vendedoresSeleccionados.add(vendedor);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  // Botones de acción
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _vendedoresSeleccionados.clear();
                              });
                            },
                            child: const Text('Limpiar'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2A4D69),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                                'Confirmar (${_vendedoresSeleccionados.length})'
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _generarReporte() {
    if (_vendedoresSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona al menos un vendedor'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_fechaInicio == null || _fechaFin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona las fechas de inicio y fin'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Aquí puedes agregar la lógica para generar el reporte
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Generando reporte para ${_vendedoresSeleccionados.length} vendedor(es)'
        ),
        backgroundColor: Colors.green,
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
                // Encabezado
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 35),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Reporte Listas Vencidos',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título
                            const Center(
                              child: Text(
                                'Configuración de Reporte',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF455A64),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Campo de correo
                            TextField(
                              controller: _correoController,
                              decoration: const InputDecoration(
                                labelText: 'Correo electrónico',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.email),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),

                            const SizedBox(height: 16),

                            // Fechas
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () => _selectFechaInicio(context),
                                    child: InputDecorator(
                                      decoration: const InputDecoration(
                                        labelText: 'Fecha',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.date_range),
                                      ),
                                      child: Text(
                                        _fechaInicio != null
                                            ? _formatDate(_fechaInicio)
                                            : 'Inicio',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => _selectFechaFin(context),
                                    child: InputDecorator(
                                      decoration: const InputDecoration(
                                        labelText: 'Fecha',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.date_range),
                                      ),
                                      child: Text(
                                        _fechaFin != null
                                            ? _formatDate(_fechaFin)
                                            : 'Fin',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Selección de vendedores
                            const Text(
                              'Vendedores',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF455A64),
                              ),
                            ),
                            const SizedBox(height: 8),

                            InkWell(
                              onTap: _mostrarModalSeleccionVendedores,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[400]!),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.people, color: Colors.grey),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _vendedoresSeleccionados.isEmpty
                                            ? 'Seleccionar vendedores'
                                            : '${_vendedoresSeleccionados.length} vendedor(es) seleccionado(s)',
                                        style: TextStyle(
                                          color: _vendedoresSeleccionados.isEmpty
                                              ? Colors.grey[600]
                                              : Colors.black87,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                                  ],
                                ),
                              ),
                            ),

                            // Lista de vendedores seleccionados
                            if (_vendedoresSeleccionados.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _vendedoresSeleccionados.length,
                                  itemBuilder: (context, index) {
                                    final vendedor = _vendedoresSeleccionados[index];
                                    return Card(
                                      elevation: 1,
                                      margin: const EdgeInsets.symmetric(vertical: 2),
                                      child: ListTile(
                                        dense: true,
                                        leading: const CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Color(0xFF2A4D69),
                                          child: Icon(
                                            Icons.person,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        title: Text(
                                          vendedor.nombre,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        subtitle: Text(
                                          'Código: ${vendedor.numSec}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.close, size: 18),
                                          onPressed: () {
                                            setState(() {
                                              _vendedoresSeleccionados.removeAt(index);
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ] else ...[
                              const SizedBox(height: 20),
                              const Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.people_outline,
                                        size: 64,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'No hay vendedores seleccionados',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Toca arriba para seleccionar vendedores',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],

                            const SizedBox(height: 16),

                            // Botón de generar reporte
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2A4D69),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: _generarReporte,
                                child: const Text(
                                  'Generar Reporte',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
