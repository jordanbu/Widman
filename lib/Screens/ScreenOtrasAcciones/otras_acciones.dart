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
    _codigoController.text = '6611';
    _monto1Controller.text = '222.0';
    _codigo2Controller.text = '12';
    _monto2Controller.text = '20.0';
  }

  String construirDatos() {
    return "0no|18|0Empresa|17266120|0drada|0jclavijo@singleton.com.bo|${_codigoController.text}|${_monto1Controller.text}|${_codigo2Controller.text}|${_monto2Controller.text}|7|7";
  }

  Future<void> registrarCotizacion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String datos = construirDatos();
    debugPrint('📤 Enviando datos (POST URL): $datos');

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
      final jsonResponse = jsonDecode(responseBody);

      if (jsonResponse['RegistrarCotizacionResult'] != null) {
        // ✅ Corrige el error de tipo con .toString()
        List<String> resultado = (jsonResponse['RegistrarCotizacionResult'] as List)
            .map((e) => e.toString())
            .toList();
        _mostrarResultadoExitoso(resultado);
      } else {
        _mostrarError('Respuesta inesperada del servidor.');
      }
    } catch (e) {
      _mostrarError('Error al procesar la respuesta: $e\n\n$responseBody');
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
            Text('Empresa: ${resultado[0]}'),
            Text('Dirección: ${resultado[1]}'),
            Text('Teléfono: ${resultado[2]}'),
            Text('Email: ${resultado[3]}'),
            Text('Usuario: ${resultado[4]}'),
            Text('ID Cotización: ${resultado[5]}'),
          ],
        ),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              _limpiarFormulario();
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
      body: Container(
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
                validator: (value) => value == null || value.isEmpty ? 'Ingrese Código 1' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _monto1Controller,
                decoration: InputDecoration(
                  labelText: 'Monto 1',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value == null || double.tryParse(value) == null ? 'Monto inválido' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _codigo2Controller,
                decoration: InputDecoration(
                  labelText: 'Código 2',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Ingrese Código 2' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _monto2Controller,
                decoration: InputDecoration(
                  labelText: 'Monto 2',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value == null || double.tryParse(value) == null ? 'Monto inválido' : null,
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
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                      : Icon(Icons.send),
                  label: Text(_isLoading ? 'Enviando...' : 'Enviar Cotización'),
                  onPressed: _isLoading ? null : registrarCotizacion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

void main() => runApp(MaterialApp(home: RegistrarCotizacionPage()));
