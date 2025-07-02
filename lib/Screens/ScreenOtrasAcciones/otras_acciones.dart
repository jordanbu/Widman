import 'package:flutter/material.dart';
import 'package:widmancrm/Screens/ScreenAgenda/wave_clipper.dart';
import 'package:widmancrm/api/api_service.dart';

class OtrasAcciones extends StatefulWidget {
  const OtrasAcciones({super.key});

  @override
  State<OtrasAcciones> createState() => _OtrasAccionesState();
}

class _OtrasAccionesState extends State<OtrasAcciones> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con gradiente y forma de onda
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
                // Header con botón de regreso
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Otras Acciones',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Contenido principal
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.white,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Título de la sección
                          const Text(
                            'Acciones disponibles',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF455A64),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Botón para descargar reporte PDF
                          ElevatedButton.icon(
                            onPressed: _isLoading ? null : _descargarReportePDF,
                            icon: _isLoading
                                ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                                : const Icon(Icons.picture_as_pdf),
                            label: Text(_isLoading ? 'Descargando...' : 'Ver Reporte PDF'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2A4D69),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              elevation: 2,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Botón para descargar reportes de cotizaciones
                          ElevatedButton.icon(
                            onPressed: () => _mostrarDialogoCotizacion(),
                            icon: const Icon(Icons.request_quote),
                            label: const Text('Reporte de Cotización'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3C5A74),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              elevation: 2,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Botón para descargar reportes de ventas
                          ElevatedButton.icon(
                            onPressed: () => _mostrarDialogoVenta(),
                            icon: const Icon(Icons.shopping_cart),
                            label: const Text('Reporte de Venta'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF455A64),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              elevation: 2,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Botón para generar reporte personalizado
                          ElevatedButton.icon(
                            onPressed: () => _mostrarDialogoReportePersonalizado(),
                            icon: const Icon(Icons.settings),
                            label: const Text('Reporte Personalizado'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF546E7A),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              elevation: 2,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Texto informativo
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Desde aquí puedes acceder a diferentes tipos de reportes y acciones adicionales del sistema. Los reportes se descargarán automáticamente y se abrirán en tu aplicación de PDF predeterminada.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
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

  /// Descargar reporte PDF genérico
  Future<void> _descargarReportePDF() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await ApiService().descargarYAbrirReportePDF();

      if (!mounted) return;

      _mostrarMensaje(
        success
            ? 'PDF descargado y abierto correctamente.'
            : 'No se pudo abrir el PDF.',
        success ? Icons.check_circle : Icons.error,
        success ? Colors.green : Colors.red,
      );
    } catch (e) {
      if (!mounted) return;
      _mostrarMensaje(
        'Error al descargar el PDF: $e',
        Icons.error,
        Colors.red,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Mostrar diálogo para ingresar ID de cotización
  void _mostrarDialogoCotizacion() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reporte de Cotización'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'ID de Cotización',
            hintText: 'Ingrese el ID de la cotización',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final id = int.tryParse(controller.text);
              if (id != null) {
                Navigator.pop(context);
                _descargarReporteCotizacion(id);
              }
            },
            child: const Text('Descargar'),
          ),
        ],
      ),
    );
  }

  /// Mostrar diálogo para ingresar ID de venta
  void _mostrarDialogoVenta() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reporte de Venta'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'ID de Venta',
            hintText: 'Ingrese el ID de la venta',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final id = int.tryParse(controller.text);
              if (id != null) {
                Navigator.pop(context);
                _descargarReporteVenta(id);
              }
            },
            child: const Text('Descargar'),
          ),
        ],
      ),
    );
  }

  /// Mostrar diálogo para reporte personalizado
  void _mostrarDialogoReportePersonalizado() {
    final TextEditingController empresaController = TextEditingController();
    final TextEditingController direccionController = TextEditingController();
    final TextEditingController telefonoController = TextEditingController();
    final TextEditingController cotizacionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reporte Personalizado'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: empresaController,
                decoration: const InputDecoration(
                  labelText: 'Empresa',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: direccionController,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: telefonoController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cotizacionController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ID Cotización (opcional)',
                  border: OutlineInputBorder(),
                ),
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
              if (empresaController.text.isNotEmpty &&
                  direccionController.text.isNotEmpty &&
                  telefonoController.text.isNotEmpty) {
                Navigator.pop(context);
                _generarReportePersonalizado(
                  empresaController.text,
                  direccionController.text,
                  telefonoController.text,
                  int.tryParse(cotizacionController.text),
                );
              }
            },
            child: const Text('Generar'),
          ),
        ],
      ),
    );
  }

  /// Descargar reporte de cotización específica
  Future<void> _descargarReporteCotizacion(int cotizacionId) async {
    try {
      final success = await ApiService().descargarReporteCotizacionPdf(cotizacionId);

      if (!mounted) return;

      _mostrarMensaje(
        success
            ? 'Reporte de cotización descargado correctamente.'
            : 'No se pudo descargar el reporte de cotización.',
        success ? Icons.check_circle : Icons.error,
        success ? Colors.green : Colors.red,
      );
    } catch (e) {
      if (!mounted) return;
      _mostrarMensaje(
        'Error al descargar reporte de cotización: $e',
        Icons.error,
        Colors.red,
      );
    }
  }

  /// Descargar reporte de venta específica
  Future<void> _descargarReporteVenta(int ventaId) async {
    try {
      final success = await ApiService().descargarReporteVentaPdf(ventaId);

      if (!mounted) return;

      _mostrarMensaje(
        success
            ? 'Reporte de venta descargado correctamente.'
            : 'No se pudo descargar el reporte de venta.',
        success ? Icons.check_circle : Icons.error,
        success ? Colors.green : Colors.red,
      );
    } catch (e) {
      if (!mounted) return;
      _mostrarMensaje(
        'Error al descargar reporte de venta: $e',
        Icons.error,
        Colors.red,
      );
    }
  }

  /// Generar reporte personalizado
  Future<void> _generarReportePersonalizado(
      String empresa,
      String direccion,
      String telefono,
      int? cotizacionId,
      ) async {
    try {
      final success = await ApiService().generarReporteConParametros(
        empresa: empresa,
        direccion: direccion,
        telefono: telefono,
        cotizacionId: cotizacionId,
      );

      if (!mounted) return;

      _mostrarMensaje(
        success
            ? 'Reporte personalizado generado correctamente.'
            : 'No se pudo generar el reporte personalizado.',
        success ? Icons.check_circle : Icons.error,
        success ? Colors.green : Colors.red,
      );
    } catch (e) {
      if (!mounted) return;
      _mostrarMensaje(
        'Error al generar reporte personalizado: $e',
        Icons.error,
        Colors.red,
      );
    }
  }

  /// Mostrar mensaje de resultado
  void _mostrarMensaje(String mensaje, IconData icono, Color color) {
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
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
