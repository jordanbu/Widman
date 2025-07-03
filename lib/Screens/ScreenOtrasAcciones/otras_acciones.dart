import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear fechas
import '../../api/api_Service.dart';

// --- Modelo para las Opciones de Reporte ---
enum ReportActionType {
  generic, // PDF genérico (si aún lo tienes como una descarga directa)
  quotationById,
  saleById,
  customWithParams,
  byDateRange, // Reporte por rango de fechas
}

class ReportOption {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final ReportActionType actionType;

  ReportOption({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.actionType,
  });
}

// --- Widget Principal ---
class OtrasAccionesScreen extends StatefulWidget {
  const OtrasAccionesScreen({super.key});

  @override
  State<OtrasAccionesScreen> createState() => _OtrasAccionesScreenState();
}

class _OtrasAccionesScreenState extends State<OtrasAccionesScreen> {
  bool _isLoading = false; // Estado global de carga para descargas
  String _loadingMessage = 'Descargando...';

  // Controllers para los diálogos (reutilizables)
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _empresaController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _cotizacionIdPersonalizadoController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  late final List<ReportOption> _reportOptions;

  @override
  void initState() {
    super.initState();
    _reportOptions = [
      ReportOption(
        title: 'Reporte General PDF',
        description: 'Descarga un informe general del sistema.',
        icon: Icons.picture_as_pdf,
        color: const Color(0xFF2A4D69),
        actionType: ReportActionType.generic,
      ),
      ReportOption(
        title: 'Reporte de Cotización por ID',
        description: 'Ingresa el ID de la cotización para generar el reporte.',
        icon: Icons.request_quote,
        color: const Color(0xFF3C5A74),
        actionType: ReportActionType.quotationById,
      ),
      ReportOption(
        title: 'Reporte de Venta por ID',
        description: 'Ingresa el ID de la venta para generar el reporte.',
        icon: Icons.shopping_cart,
        color: const Color(0xFF455A64),
        actionType: ReportActionType.saleById,
      ),
      ReportOption(
        title: 'Reporte Personalizado',
        description: 'Genera un reporte con parámetros específicos.',
        icon: Icons.settings_applications,
        color: const Color(0xFF546E7A),
        actionType: ReportActionType.customWithParams,
      ),
      ReportOption(
        title: 'Reporte por Rango de Fechas',
        description: 'Selecciona un inicio y fin para generar el reporte.',
        icon: Icons.date_range,
        color: const Color(0xFF607D8B),
        actionType: ReportActionType.byDateRange,
      ),
      // Añade más opciones aquí
    ];
  }

  @override
  void dispose() {
    _idController.dispose();
    _empresaController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    _cotizacionIdPersonalizadoController.dispose();
    super.dispose();
  }

  void _setLoading(bool loading, [String message = 'Descargando...']) {
    if (!mounted) return;
    setState(() {
      _isLoading = loading;
      _loadingMessage = message;
    });
  }

  Future<void> _handleReportSelection(ReportOption option) async {
    switch (option.actionType) {
      case ReportActionType.generic:
        _downloadGenericReport();
        break;
      case ReportActionType.quotationById:
        _showIdDialog(
          title: 'Reporte de Cotización',
          hint: 'ID de Cotización',
          onConfirm: (id) => _downloadQuotationReport(id),
        );
        break;
      case ReportActionType.saleById:
        _showIdDialog(
          title: 'Reporte de Venta',
          hint: 'ID de Venta',
          onConfirm: (id) => _downloadSaleReport(id),
        );
        break;
      case ReportActionType.customWithParams:
        _showCustomParamsDialog();
        break;
      case ReportActionType.byDateRange:
        _showDateRangeDialog();
        break;
    }
  }

  // --- Métodos de Descarga ---
  Future<void> _downloadGenericReport() async {
    _setLoading(true, 'Descargando Reporte General...');
    try {
      final success = await ApiService().descargarYAbrirReportePDF(); // Asumiendo que tienes esta función
      if (!mounted) return;
      _mostrarMensaje(
        success ? 'Reporte general descargado y abierto.' : 'No se pudo abrir el reporte general.',
        success ? Icons.check_circle : Icons.error,
        success ? Colors.green : Colors.red,
      );
    } catch (e) {
      if (!mounted) return;
      _mostrarMensaje('Error al descargar reporte: ${e.toString()}', Icons.error, Colors.red);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _downloadQuotationReport(int cotizacionId) async {
    _setLoading(true, 'Descargando Reporte de Cotización...');
    try {
      final success = await ApiService().descargarReporteCotizacionPdf(cotizacionId);
      if (!mounted) return;
      _mostrarMensaje(
        success ? 'Reporte de cotización descargado.' : 'No se pudo abrir el reporte.',
        success ? Icons.check_circle : Icons.error,
        success ? Colors.green : Colors.red,
      );
    } catch (e) {
      if (!mounted) return;
      _mostrarMensaje('Error: ${e.toString()}', Icons.error, Colors.red);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _downloadSaleReport(int ventaId) async {
    _setLoading(true, 'Descargando Reporte de Venta...');
    try {
      final success = await ApiService().descargarReporteVentaPdf(ventaId);
      if (!mounted) return;
      _mostrarMensaje(
        success ? 'Reporte de venta descargado.' : 'No se pudo abrir el reporte.',
        success ? Icons.check_circle : Icons.error,
        success ? Colors.green : Colors.red,
      );
    } catch (e) {
      if (!mounted) return;
      _mostrarMensaje('Error: ${e.toString()}', Icons.error, Colors.red);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _downloadCustomReport(
      String empresa, String direccion, String telefono, int? cotizacionId) async {
    _setLoading(true, 'Generando Reporte Personalizado...');
    try {
      // Asegúrate que tu ApiService tiene un método como este
      final success = await ApiService().generarReporteConParametros(
        empresa: empresa,
        direccion: direccion,
        telefono: telefono,
        cotizacionId: cotizacionId, // Podría ser opcional en tu API
      );
      if (!mounted) return;
      _mostrarMensaje(
        success ? 'Reporte personalizado generado.' : 'No se pudo generar el reporte.',
        success ? Icons.check_circle : Icons.error,
        success ? Colors.green : Colors.red,
      );
    } catch (e) {
      if (!mounted) return;
      _mostrarMensaje('Error: ${e.toString()}', Icons.error, Colors.red);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _downloadReportByDateRange(DateTime start, DateTime end) async {
    _setLoading(true, 'Descargando Reporte por Fechas...');
    try {
      // Necesitarás un método en ApiService para esto, ej:
      // final success = await ApiService().descargarReportePorFechas(start, end);
      // Por ahora, simularemos éxito:
      await Future.delayed(const Duration(seconds: 2)); // Simula llamada a API
      const success = true; // Simulación

      if (!mounted) return;
      _mostrarMensaje(
        success
            ? 'Reporte por fechas (${DateFormat('dd/MM/yy').format(start)} - ${DateFormat('dd/MM/yy').format(end)}) descargado.'
            : 'No se pudo generar el reporte por fechas.',
        success ? Icons.check_circle : Icons.error,
        success ? Colors.green : Colors.red,
      );
    } catch (e) {
      if (!mounted) return;
      _mostrarMensaje('Error: ${e.toString()}', Icons.error, Colors.red);
    } finally {
      _setLoading(false);
    }
  }

  // --- Diálogos ---
  void _showIdDialog({
    required String title,
    required String hint,
    required Function(int) onConfirm,
  }) {
    _idController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: _idController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: hint,
            hintText: 'Ingrese el ID',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final id = int.tryParse(_idController.text);
              if (id != null) {
                Navigator.pop(context);
                onConfirm(id);
              } else {
                _mostrarMensaje('Por favor, ingrese un ID válido.', Icons.warning, Colors.orange);
              }
            },
            child: const Text('Descargar'),
          ),
        ],
      ),
    );
  }

  void _showCustomParamsDialog() {
    _empresaController.clear();
    _direccionController.clear();
    _telefonoController.clear();
    _cotizacionIdPersonalizadoController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reporte Personalizado'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: _empresaController,
                  decoration: const InputDecoration(labelText: 'Empresa', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(
                  controller: _direccionController,
                  decoration: const InputDecoration(labelText: 'Dirección', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(
                  controller: _telefonoController,
                  decoration: const InputDecoration(labelText: 'Teléfono', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(
                controller: _cotizacionIdPersonalizadoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'ID Cotización (Opcional)', border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_empresaController.text.isNotEmpty &&
                  _direccionController.text.isNotEmpty &&
                  _telefonoController.text.isNotEmpty) {
                Navigator.pop(context);
                _downloadCustomReport(
                  _empresaController.text,
                  _direccionController.text,
                  _telefonoController.text,
                  int.tryParse(_cotizacionIdPersonalizadoController.text),
                );
              } else {
                _mostrarMensaje('Por favor, complete los campos requeridos.', Icons.warning, Colors.orange);
              }
            },
            child: const Text('Generar'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isStartDate ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _showDateRangeDialog() {
    // Resetear fechas al abrir el diálogo por si se había usado antes
    _startDate = null;
    _endDate = null;

    showDialog(
      context: context,
      // Usamos un StatefulWidgetBuilder para que el contenido del diálogo pueda actualizarse
      // al seleccionar fechas sin cerrar y reabrir el diálogo.
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Reporte por Rango de Fechas'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text(_startDate == null
                        ? 'Seleccionar fecha de inicio'
                        : 'Inicio: ${DateFormat('dd/MM/yyyy').format(_startDate!)}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: dialogContext, // Usar el context del diálogo
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        setDialogState(() { // Actualizar el estado del diálogo
                          _startDate = picked;
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: Text(_endDate == null
                        ? 'Seleccionar fecha de fin'
                        : 'Fin: ${DateFormat('dd/MM/yyyy').format(_endDate!)}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: dialogContext, // Usar el context del diálogo
                        initialDate: _endDate ?? _startDate ?? DateTime.now(),
                        firstDate: _startDate ?? DateTime(2000), // No antes que la fecha de inicio
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        setDialogState(() { // Actualizar el estado del diálogo
                          _endDate = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Descargar'),
                  onPressed: (_startDate != null && _endDate != null && !_startDate!.isAfter(_endDate!))
                      ? () {
                    Navigator.of(dialogContext).pop();
                    _downloadReportByDateRange(_startDate!, _endDate!);
                  }
                      : null, // Deshabilitar si las fechas no son válidas
                ),
              ],
            );
          },
        );
      },
    );
  }


  void _mostrarMensaje(String mensaje, IconData icono, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icono, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(mensaje)),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // --- UI Build Method ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Reportes'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: [
          ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: _reportOptions.length,
            itemBuilder: (context, index) {
              final option = _reportOptions[index];
              return Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: Icon(option.icon, color: option.color, size: 36),
                  title: Text(option.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(option.description),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
                  onTap: _isLoading ? null : () => _handleReportSelection(option),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Card(
                  elevation: 8.0,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(_loadingMessage, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
