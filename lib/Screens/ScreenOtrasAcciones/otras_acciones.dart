import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrarCotizacionPage extends StatefulWidget {
  @override
  _RegistrarCotizacionPageState createState() => _RegistrarCotizacionPageState();
}

class _RegistrarCotizacionPageState extends State<RegistrarCotizacionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _monto1Controller = TextEditingController();
  final TextEditingController _codigo2Controller = TextEditingController();
  final TextEditingController _monto2Controller = TextEditingController();

  bool _isLoading = false;
  String _ultimaRespuesta = '';

  @override
  void initState() {
    super.initState();
    _resetFormularioConValoresPorDefecto();
  }

  void _resetFormularioConValoresPorDefecto() {
    _codigoController.text = '6611';
    _monto1Controller.text = '222.0';
    _codigo2Controller.text = '12';
    _monto2Controller.text = '20.0';
  }

  String construirDatos() {
    return "0Observacion|18|0Empresa|17266120|0drada|0jclavijo@singleton.com.bo|${_codigoController.text}|${_monto1Controller.text}|${_codigo2Controller.text}|${_monto2Controller.text}|7|7";
  }

  Future<void> registrarCotizacion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String datos = construirDatos();
    debugPrint('📤 Enviando datos: $datos');

    final url = Uri.parse(
      'http://app.singleton.com.bo/WIDMANCRM/Comunicacion.svc/RegistrarCotizacion?Datos=${Uri.encodeComponent(datos)}',
    );

    debugPrint('🌐 URL completa: $url');

    try {
      // Agregar headers para mejor compatibilidad
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(Duration(seconds: 30));

      debugPrint('📥 Status Code: ${response.statusCode}');
      debugPrint('📥 Headers: ${response.headers}');
      debugPrint('📥 Body completo: ${response.body}');
      debugPrint('📥 Body length: ${response.body.length}');

      setState(() {
        _ultimaRespuesta = response.body;
      });

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          _mostrarError('⚠️ El servidor devolvió una respuesta vacía');
        } else {
          _procesarRespuesta(response.body);
        }
      } else {
        _mostrarError('❌ Error HTTP ${response.statusCode}:\n${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Error completo: $e');
      _mostrarError('❌ Error de conexión: $e');
    }

    setState(() => _isLoading = false);
  }

  void _procesarRespuesta(String responseBody) {
    try {
      debugPrint('🔍 Procesando respuesta: $responseBody');

      // Verificar si la respuesta está vacía o es solo espacios
      if (responseBody.trim().isEmpty) {
        _mostrarError('⚠️ Respuesta vacía del servidor');
        return;
      }

      // Verificar errores específicos del servidor
      if (responseBody.contains('índice estaba fuera del intervalo') ||
          responseBody.contains('index')) {
        _mostrarError('❌ Error de Validación del Servidor\n\n'
            'El servidor rechazó los datos enviados. Esto puede ocurrir por:\n'
            '• Códigos no válidos en el sistema\n'
            '• Montos fuera del rango permitido\n'
            '• Valores no registrados en la base de datos\n\n'
            'Intenta con los valores por defecto que funcionan:\n'
            '• Código 1: 6611\n'
            '• Monto 1: 222.0\n'
            '• Código 2: 12\n'
            '• Monto 2: 20.0\n\n'
            'Error completo:\n$responseBody');
        return;
      }

      if (responseBody.contains('Error') || responseBody.contains('Exception')) {
        _mostrarError('❌ Error del servidor:\n$responseBody');
        return;
      }

      // Intentar parsear como JSON
      try {
        final jsonResponse = jsonDecode(responseBody);
        debugPrint('✅ JSON parseado exitosamente: $jsonResponse');

        if (jsonResponse['RegistrarCotizacionResult'] != null) {
          var resultado = jsonResponse['RegistrarCotizacionResult'];
          debugPrint('🎯 Resultado extraído: $resultado');
          debugPrint('🎯 Tipo de resultado: ${resultado.runtimeType}');

          if (resultado is List && resultado.isNotEmpty) {
            List<String> resultadoList = resultado.map((e) => e.toString()).toList();
            debugPrint('✅ Llamando _mostrarResultadoExitoso con: $resultadoList');
            _mostrarResultadoExitoso(resultadoList);
          } else if (resultado is String) {
            if (resultado.trim().isEmpty) {
              _mostrarError('⚠️ El servidor devolvió un resultado vacío');
            } else {
              _mostrarError('📝 Respuesta del servidor: $resultado');
            }
          } else {
            debugPrint('❌ Resultado no es List ni String: ${resultado.runtimeType}');
            _mostrarError('❓ Formato de respuesta inesperado: $resultado');
          }
        } else {
          _mostrarError('❓ No se encontró RegistrarCotizacionResult en la respuesta:\n$responseBody');
        }
      } catch (jsonError) {
        debugPrint('❌ Error parseando JSON: $jsonError');
        // La respuesta no es JSON válido
        _mostrarError('❌ Respuesta no es JSON válido.\n\nRespuesta completa:\n$responseBody');
      }
    } catch (e) {
      debugPrint('❌ Error general procesando respuesta: $e');
      _mostrarError('❌ Error procesando la respuesta: $e\n\nRespuesta completa:\n$responseBody');
    }
  }

  void _mostrarResultadoExitoso(List<String> resultado) {
    debugPrint('🎉 _mostrarResultadoExitoso llamado con: $resultado');
    showDialog(
      context: context,
      barrierDismissible: false, // Evita que se cierre accidentalmente
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Cotización Registrada'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('✅ Registro exitoso', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            SizedBox(height: 12),
            if (resultado.length > 0)
              _buildInfoRow('Empresa:', resultado[0]),
            if (resultado.length > 1)
              _buildInfoRow('Dirección:', resultado[1]),
            if (resultado.length > 2)
              _buildInfoRow('Teléfono:', resultado[2]),
            if (resultado.length > 3)
              _buildInfoRow('Email:', resultado[3]),
            if (resultado.length > 4)
              _buildInfoRow('Usuario:', resultado[4]),
            if (resultado.length > 5)
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: _buildInfoRow('ID Cotización:', resultado[5]),
              ),
            if (resultado.length <= 1)
              Text('Cotización registrada exitosamente', style: TextStyle(color: Colors.green)),
          ],
        ),
        actions: [
          TextButton(
            child: Text('OK', style: TextStyle(fontSize: 16)),
            onPressed: () {
              debugPrint('👍 Usuario cerró diálogo exitoso');
              Navigator.of(context).pop();
              _resetFormularioConValoresPorDefecto();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _mostrarError(String mensaje) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('❌ Error'),
        content: SingleChildScrollView(
          child: Text(mensaje),
        ),
        actions: [
          TextButton(
            child: Text('Cerrar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _mostrarUltimaRespuesta() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('📋 Última Respuesta del Servidor'),
        content: SingleChildScrollView(
          child: Text(_ultimaRespuesta.isEmpty ? 'No hay respuesta disponible' : _ultimaRespuesta),
        ),
        actions: [
          TextButton(
            child: Text('Cerrar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _limpiarFormulario() {
    _codigoController.clear();
    _monto1Controller.clear();
    _codigo2Controller.clear();
    _monto2Controller.clear();
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _monto1Controller.dispose();
    _codigo2Controller.dispose();
    _monto2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Cotización'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _mostrarUltimaRespuesta,
            tooltip: 'Ver última respuesta',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Mostrar los datos que se van a enviar
              Card(
                color: Colors.grey[100],
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Datos que se enviarán:', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(construirDatos(), style: TextStyle(fontSize: 12, fontFamily: 'monospace')),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _codigoController,
                decoration: InputDecoration(
                  labelText: 'Código 1',
                  border: OutlineInputBorder(),
                  helperText: 'Códigos válidos conocidos: 6611',
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Ingrese Código 1' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _monto1Controller,
                decoration: InputDecoration(
                  labelText: 'Monto 1',
                  border: OutlineInputBorder(),
                  helperText: 'Rango sugerido: 100.0 - 500.0',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return 'Monto inválido';
                  }
                  double monto = double.parse(value);
                  if (monto < 0) {
                    return 'El monto debe ser positivo';
                  }
                  if (monto > 10000) {
                    return 'Monto muy alto, verificar';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _codigo2Controller,
                decoration: InputDecoration(
                  labelText: 'Código 2',
                  border: OutlineInputBorder(),
                  helperText: 'Códigos válidos conocidos: 12',
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Ingrese Código 2' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _monto2Controller,
                decoration: InputDecoration(
                  labelText: 'Monto 2',
                  border: OutlineInputBorder(),
                  helperText: 'Rango sugerido: 1.0 - 50.0',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return 'Monto inválido';
                  }
                  double monto = double.parse(value);
                  if (monto < 0) {
                    return 'El monto debe ser positivo';
                  }
                  if (monto > 1000) {
                    return 'Monto muy alto, verificar';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton.icon(
                  icon: _isLoading
                      ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                      : Icon(Icons.send),
                  label: Text(_isLoading ? 'Enviando...' : 'Enviar Cotización'),
                  onPressed: _isLoading ? null : registrarCotizacion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.refresh),
                  label: Text('Nueva Cotización'),
                  onPressed: _resetFormularioConValoresPorDefecto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.visibility),
                  label: Text('Ver Última Respuesta'),
                  onPressed: _mostrarUltimaRespuesta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  title: 'Registrar Cotización',
  theme: ThemeData(
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  ),
  home: RegistrarCotizacionPage(),
  debugShowCheckedModeBanner: false,
));
