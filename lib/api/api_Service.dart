import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import '../models/cliente_model.dart';
import '../models/cotizacion_model.dart';
import '../models/prospecto_model.dart';
import '../models/reporte_lista_vencidos_model.dart' hide Cliente, Vendedor;
import '../models/stock_item_models.dart';
import '../models/venta_model.dart';
import '../models/vendedor_model.dart';
import '../models/lista_producto_venta_model.dart';

class ApiService {
  static const String baseUrl = 'http://app.singleton.com.bo/WIDMANCRM/Comunicacion.svc';

  // ===================== MÉTODOS GET ======================

  Future<List<StockItem>> fetchStock() async {
    final response = await http.get(Uri.parse('$baseUrl/Stock'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<StockItem>.from(data.map((json) => StockItem.fromJson(json)));
    } else {
      throw Exception('Error al cargar stock');
    }
  }

  Future<List<Prospecto>> fetchProspectos() async {
    final response = await http.get(Uri.parse('$baseUrl/ListaProspectos'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Prospecto>.from(data.map((json) => Prospecto.fromJson(json)));
    } else {
      throw Exception('Error al cargar prospectos');
    }
  }

  Future<List<Cliente>> fetchClientes() async {
    final response = await http.get(Uri.parse('$baseUrl/ListaCliente'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Cliente>.from(data.map((json) => Cliente.fromJson(json)));
    } else {
      throw Exception('Error al cargar clientes');
    }
  }

  Future<List<Cotizacion>> fetchCotizaciones() async {
    final response = await http.get(Uri.parse('$baseUrl/ListaCotizacion'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Cotizacion>.from(data.map((json) => Cotizacion.fromJson(json)));
    } else {
      throw Exception('Error al cargar cotizaciones');
    }
  }


  final userController = TextEditingController();
  final passController= TextEditingController();

  bool loading = false;



  Future<List<Venta>> fetchVentas() async {
    final response = await http.get(Uri.parse('$baseUrl/ListaVenta'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Venta>.from(data.map((json) => Venta.fromJson(json)));
    } else {
      throw Exception('Error al cargar ventas');
    }
  }

  Future<List<ProductoVenta>> fetchListaProductoVenta() async {
    final response = await http.get(Uri.parse('$baseUrl/ListaProductoVenta'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<ProductoVenta>.from(data.map((json) => ProductoVenta.fromJson(json)));
    } else {
      throw Exception('Error al cargar productos de venta');
    }
  }

  Future<List<Vendedor>> fetchListaVendedores() async {
    final response = await http.get(Uri.parse('$baseUrl/ListaVendedores'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Vendedor>.from(data.map((json) => Vendedor.fromJson(json)));
    } else {
      throw Exception('Error al cargar vendedores');
    }
  }

  // ===================== MÉTODOS POST ======================

  /// POST alternativo que envía datos en formato JSON estándar
  Future<int> registrarCotizacion(Map<String, dynamic> cotizacionData) async {
    final url = Uri.parse('$baseUrl/RegistraCotizacion');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: jsonEncode(cotizacionData),
    );

    if (response.statusCode == 200) {
      final responseBody = response.body.trim();
      if (responseBody.isEmpty) throw Exception('Respuesta vacía');
      return int.tryParse(responseBody) ?? -1;
    } else {
      throw Exception('Error HTTP ${response.statusCode}');
    }
  }

  /// POST para registrar prospecto
  Future<int> registrarProspecto(Map<String, dynamic> prospectoData) async {
    final url = Uri.parse('$baseUrl/RegistraClienteProspecto');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: jsonEncode(jsonEncode(prospectoData)), // doble encode requerido
    );

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Error al registrar prospecto');
    }
  }

  // ================== MÉTODO DE COTIZACIÓN ESPECIAL ==================

  /// Registrar cotización enviando la cadena personalizada en la URL
  /// Ejemplo de datos: 0Observacion|18|0Empresa|17266120|0drada|0jclavijo@singleton.com.bo|6611|222.0|12|20.0|7|7

  Future<String> enviarCotizacionComoCadena(String datos) async {
    final url = Uri.parse('http://app.singleton.com.bo/WIDMANCRM/Comunicacion.svc/RegistrarCotizacion');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: jsonEncode({"Datos": datos}),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error al registrar cotización: ${response.statusCode}');
    }
  }
  Future<String> registrarCotizacionDesdePantalla({
    required String observacion,
    required String empresa,
    required int idEmpresa,
    required int idCliente,
    required String usuario,
    required String emailCliente,
    required List<Map<String, dynamic>> productos, // [{id: int, cantidad: double}]
  }) async {
    try {
      final buffer = StringBuffer();
      buffer.write('0$observacion|');
      buffer.write('1$idEmpresa|');
      buffer.write('0$empresa|');
      buffer.write('1$idCliente|');
      buffer.write('0$usuario|');
      buffer.write('0$emailCliente|');
      buffer.write('6|');

      for (var producto in productos) {
        buffer.write('1${producto['id']}|');
        buffer.write('2${producto['cantidad']}|');
      }

      buffer.write('7');

      final datosFinal = buffer.toString();

      final response = await http.post(
        Uri.parse('$baseUrl/RegistrarCotizacion'),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode({"Datos": datosFinal}),
      );

      print('Status: \${response.statusCode}');
      print('Body: \${response.body}');

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Error al registrar cotización: \${response.statusCode}');
      }
    } catch (e) {
      print('Error en registrarCotizacionDesdePantalla: \$e');
      throw Exception('Error de conexión: \$e');
    }
  }
}


  // ================== MÉTODOS PARA REPORTES ==================

  Future<bool> descargarReporteCotizacionPdf(int cotizacionId) async {
    final url = Uri.parse('http://app.singleton.com.bo/WIDMANCRM/ReporteCotizacionPdf?cotizacionId=$cotizacionId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return await _guardarYAbrirPDF(response.bodyBytes, 'cotizacion_$cotizacionId');
    } else {
      throw Exception('Error al descargar PDF');
    }
  }

  Future<String?> obtenerRutaPDFParaCompartir(int cotizacionId) async {
    final url = Uri.parse('http://app.singleton.com.bo/WIDMANCRM/ReporteCotizacionPdf?cotizacionId=$cotizacionId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/cotizacion_$cotizacionId.pdf';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } else {
      return null;
    }
  }

  Future<bool> _guardarYAbrirPDF(Uint8List bytes, String nombreArchivo) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/$nombreArchivo.pdf';
    final file = File(path);
    await file.writeAsBytes(bytes);
    final result = await OpenFile.open(file.path);
    return result.type == ResultType.done;
  }

