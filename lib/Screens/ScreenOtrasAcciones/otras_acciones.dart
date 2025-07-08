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

    try {
      final response = await http.post(url);

      debugPrint('📥 Status: ${response.statusCode}');
      debugPrint('📥 Body: ${response.body}');

      if (response.statusCode == 200) {
        _procesarRespuesta(response.body);
      } else {
        _mostrarError('Error ${response.statusCode}:\n${response.body}');
      }
    } catch (e) {
      _mostrarError('❌ Error de red: $e');
    }

    setState(() => _isLoading = false);
  }

  void _procesarRespuesta(String responseBody) {
    try {
      debugPrint('🔍 Procesando respuesta: $responseBody');

      // Verificar si la respuesta contiene un error conocido
      if (responseBody.contains('índice estaba fuera del intervalo') ||
          responseBody.contains('index') ||
          responseBody.contains('Error')) {
        _mostrarError('Error del servidor:\n$responseBody');
        return;
      }

      final jsonResponse = jsonDecode(responseBody);

      if (jsonResponse['RegistrarCotizacionResult'] != null) {
        var resultado = jsonResponse['RegistrarCotizacionResult'];

        // Verificar si el resultado es una lista
        if (resultado is List && resultado.isNotEmpty) {
          List<String> resultadoList = resultado.map((e) => e.toString()).toList();
          _mostrarResultadoExitoso(resultadoList);
        } else if (resultado is String) {
          // Si es un string, podría ser un mensaje de error
          _mostrarError('Respuesta del servidor: $resultado');
        } else {
          _mostrarError('Formato de respuesta inesperado: $resultado');
        }
      } else {
        _mostrarError('Respuesta inesperada del servidor:\n$responseBody');
      }
    } catch (e) {
      debugPrint('❌ Error parseando JSON: $e');
      _mostrarError('Error al procesar la respuesta del servidor.\n\nRespuesta completa:\n$responseBody');
    }
  }

  void _mostrarResultadoExitoso(List<String> resultado) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('✅ Cotización Registrada'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (resultado.length > 0) Text('Empresa: ${resultado[0]}'),
            if (resultado.length > 1) Text('Dirección: ${resultado[1]}'),
            if (resultado.length > 2) Text('Teléfono: ${resultado[2]}'),
            if (resultado.length > 3) Text('Email: ${resultado[3]}'),
            if (resultado.length > 4) Text('Usuario: ${resultado[4]}'),
            if (resultado.length > 5) Text('ID Cotización: ${resultado[5]}'),
            if (resultado.length <= 1) Text('Cotización registrada exitosamente'),
          ],
        ),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              _resetFormularioConValoresPorDefecto();
            },
          ),
        ],
      ),
    );
  }

  void _mostrarError(String mensaje) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('❌ Error'),
        content: Text(mensaje),
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _codigoController,
                decoration: InputDecoration(
                  labelText: 'Código 1',
                  border: OutlineInputBorder(),
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
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value == null || double.tryParse(value) == null
                    ? 'Monto inválido'
                    : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _codigo2Controller,
                decoration: InputDecoration(
                  labelText: 'Código 2',
                  border: OutlineInputBorder(),
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
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value == null || double.tryParse(value) == null
                    ? 'Monto inválido'
                    : null,
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
));



