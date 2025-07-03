import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:widmancrm/models/lista_producto_venta_model.dart';

import '../models/cliente_model.dart';
import '../models/cotizacion_model.dart';
import '../models/prospecto_model.dart';
import '../models/reporte_lista_vencidos_model.dart' hide Cliente, Vendedor;
import '../models/stock_item_models.dart';
import '../models/venta_model.dart';
import '../models/vendedor_model.dart';

class ApiService {
  static const String baseUrl = 'http://app.singleton.com.bo/WIDMANCRM/Comunicacion.svc';

  // ===== MÉTODOS GET =====  

  /// Obtener lista de stock de productos
  Future<List<StockItem>> fetchStock() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Stock'),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => StockItem.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar stock: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }

  /// Obtener lista de prospectos
  Future<List<Prospecto>> fetchProspectos() async {
    final response = await http.get(
      Uri.parse('$baseUrl/ListaProspectos'),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Prospecto.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar prospectos: ${response.statusCode}');
    }
  }

  /// Obtener lista de clientes
  Future<List<Cliente>> fetchClientes() async {
    final response = await http.get(
      Uri.parse('$baseUrl/ListaCliente'),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Cliente.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar clientes: ${response.statusCode}');
    }
  }

  /// Obtener lista de cotizaciones
  Future<List<Cotizacion>> fetchCotizaciones() async {
    final response = await http.get(
      Uri.parse('$baseUrl/ListaCotizacion'),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Cotizacion.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar cotizaciones: ${response.statusCode}');
    }
  }

  /// Obtener lista de ventas
  Future<List<Venta>> fetchVentas() async {
    final response = await http.get(
      Uri.parse('$baseUrl/ListaVenta'),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Venta.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar ventas: ${response.statusCode}');
    }
  }

  /// Obtener lista de productos de venta
  Future<List<ProductoVenta>> fetchListaProductoVenta() async {
    final response = await http.get(
      Uri.parse('$baseUrl/ListaProductoVenta'),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ProductoVenta.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar productos de venta: ${response.statusCode}');
    }
  }

  /// Obtener lista de vendedores
  Future<List<Vendedor>> fetchListaVendedores() async {
    final response = await http.get(
      Uri.parse('$baseUrl/ListaVendedores'),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Vendedor.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar vendedores: ${response.statusCode}');
    }
  }

  /// Obtener items de stock (método alternativo)
  Future<List<StockItem>> fetchStockItems() async {
    final response = await http.get(
      Uri.parse('$baseUrl/Stock'),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => StockItem.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener productos: ${response.statusCode}');
    }
  }

  // ===== MÉTODOS POST =====














  /// Registrar nueva cotización
  Future<int> registrarCotizacion(Map<String, dynamic> cotizacionData) async {
    final url = Uri.parse('$baseUrl/RegistraCotizacion');

    try {
      print('URL: $url');
      print('Datos a enviar: $cotizacionData');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(cotizacionData),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = response.body.trim();
        if (responseBody.isEmpty) {
          throw Exception('Respuesta vacía del servidor');
        }

        try {
          return int.parse(responseBody);
        } catch (e) {
          final jsonResponse = jsonDecode(responseBody);
          if (jsonResponse is int) {
            return jsonResponse;
          } else if (jsonResponse is Map && jsonResponse.containsKey('id')) {
            return int.parse(jsonResponse['id'].toString());
          } else {
            throw Exception('Formato de respuesta no esperado: $jsonResponse');
          }
        }
      } else {
        throw Exception('Error HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error detallado: $e');
      throw Exception('Error de conexión al registrar cotización: $e');
    }
  }

  /// Registrar nuevo prospecto
  Future<int> registrarProspecto(Map<String, dynamic> prospectoData) async {
    final url = Uri.parse('$baseUrl/RegistraClienteProspecto');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(jsonEncode(prospectoData)), // Doble encode según el código original
      );

      if (response.statusCode == 200) {
        return int.parse(response.body);
      } else {
        throw Exception('Error al registrar prospecto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión al registrar prospecto: $e');
    }
  }

  // ===== MÉTODOS PARA REPORTES PDF =====

  /// Descargar reporte de cotización y abrirlo automáticamente
  Future<bool> descargarReporteCotizacionPdf(int cotizacionId) async {
    try {
      final url = Uri.parse('http://app.singleton.com.bo/WIDMANCRM/ReporteCotizacionPdf?cotizacionId=$cotizacionId');

      print('Descargando PDF desde: $url');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );

      if (response.statusCode == 200) {
        return await _guardarYAbrirPDF(
            response.bodyBytes,
            'cotizacion_$cotizacionId'
        );
      } else {
        throw Exception('Error al descargar PDF: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al descargar PDF: $e');
      throw Exception('Error al descargar el PDF: $e');
    }
  }

  /// Descargar reporte de venta
  Future<bool> descargarReporteVentaPdf(int ventaId) async {
    try {
      final url = Uri.parse('http://app.singleton.com.bo/WIDMANCRM/ReporteVentaPdf?ventaId=$ventaId');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );

      if (response.statusCode == 200) {
        return await _guardarYAbrirPDF(
            response.bodyBytes,
            'venta_$ventaId'
        );
      } else {
        throw Exception('Error al descargar reporte de venta: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al descargar reporte de venta: $e');
      throw Exception('Error al descargar reporte de venta: $e');
    }
  }

  /// Generar reporte con parámetros personalizados
  Future<bool> generarReporteConParametros({
    required String empresa,
    required String direccion,
    required String telefono,
    int? cotizacionId,
  }) async {
    try {
      final Map<String, dynamic> parametros = {
        'empresa': empresa,
        'direccion': direccion,
        'telefono': telefono,
        if (cotizacionId != null) 'cotizacionId': cotizacionId,
      };

      final url = Uri.parse('$baseUrl/GenerarReporteCotizacion');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode(parametros),
      );

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.contains('application/pdf') == true) {
          return await _guardarYAbrirPDF(
              response.bodyBytes,
              'reporte_${DateTime.now().millisecondsSinceEpoch}'
          );
        } else {
          final pdfBase64 = response.body;
          final pdfBytes = base64Decode(pdfBase64);
          return await _guardarYAbrirPDF(
              pdfBytes,
              'reporte_${DateTime.now().millisecondsSinceEpoch}'
          );
        }
      } else {
        throw Exception('Error al generar reporte: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al generar reporte: $e');
      throw Exception('Error al generar reporte: $e');
    }
  }

  /// Descargar PDF sin abrir (solo guardar)
  Future<String?> descargarPDFSinAbrir(int cotizacionId) async {
    try {
      final url = Uri.parse('http://app.singleton.com.bo/WIDMANCRM/ReporteCotizacionPdf?cotizacionId=$cotizacionId');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final fileName = 'cotizacion_${cotizacionId}_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final file = File('${directory.path}/$fileName');

        await file.writeAsBytes(response.bodyBytes);
        return file.path;
      } else {
        throw Exception('Error al descargar PDF: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al descargar PDF: $e');
      return null;
    }
  }

  /// Obtener ruta de PDF para compartir
  Future<String?> obtenerRutaPDFParaCompartir(int cotizacionId) async {
    try {
      final url = Uri.parse('http://app.singleton.com.bo/WIDMANCRM/ReporteCotizacionPdf?cotizacionId=$cotizacionId');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );

      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final fileName = 'cotizacion_$cotizacionId.pdf';
        final file = File('${directory.path}/$fileName');

        await file.writeAsBytes(response.bodyBytes);
        return file.path;
      } else {
        throw Exception('Error al obtener PDF: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener PDF: $e');
      return null;
    }
  }

  /// Verificar si existe un reporte para una cotización
  Future<bool> existeReporteCotizacion(int cotizacionId) async {
    try {
      final url = Uri.parse('http://app.singleton.com.bo/WIDMANCRM/VerificarReporte?cotizacionId=$cotizacionId');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['existe'] == true;
      }
      return false;
    } catch (e) {
      print('Error al verificar reporte: $e');
      return false;
    }
  }

  /// Descargar y abrir reporte PDF genérico
  Future<bool> descargarYAbrirReportePDF() async {
    try {
      final url = Uri.parse('$baseUrl/DescargarPDF');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = json.decode(response.body);
        final List<dynamic> bytesList = jsonBody['DescargarpdfResult'];
        final Uint8List pdfBytes = Uint8List.fromList(bytesList.cast<int>());

        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/reporte_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final file = File(filePath);
        await file.writeAsBytes(pdfBytes);

        final result = await OpenFile.open(file.path);
        return result.type == ResultType.done;
      } else {
        throw Exception('Error al descargar PDF: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al descargar o abrir el PDF: $e');
      return false;
    }
  }

  // ===== MÉTODOS PRIVADOS =====

  /// Guardar PDF en el dispositivo y abrirlo automáticamente
  Future<bool> _guardarYAbrirPDF(Uint8List pdfBytes, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName.pdf');

      await file.writeAsBytes(pdfBytes);

      final result = await OpenFile.open(file.path);

      print('Archivo guardado en: ${file.path}');
      print('Resultado de apertura: ${result.message}');

      return result.type == ResultType.done;
    } catch (e) {
      print('Error al guardar/abrir PDF: $e');
      return false;
    }
  }
  Future<int> registrarCotizacionPostConDatosString({
    required String observacion,
    required String empresa,
    required int idCliente,
    required String emailUsuario,
    required String emailCliente,
    required List<Map<String, dynamic>> productos, // [{id: int, cantidad: double}]
  }) async {
    try {
      // Construir string Datos en el formato que quieres
      List<String> productosPartes = [];
      for (var producto in productos) {
        productosPartes.add(producto['id'].toString());
        productosPartes.add(producto['cantidad'].toString());
      }

      final datosString =
          '{0$observacion|118|0$empresa|$idCliente|0$emailUsuario|0$emailCliente|${productosPartes.join('|')}}';

      final url = Uri.parse('$baseUrl/RegistrarCotizacion');

      final body = jsonEncode({"Datos": datosString});

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: body,
      );

      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final bodyResponse = response.body.trim();

        if (bodyResponse.isEmpty) {
          throw Exception('Respuesta vacía del servidor');
        }

        try {
          return int.parse(bodyResponse);
        } catch (e) {
          final jsonResponse = jsonDecode(bodyResponse);
          if (jsonResponse is int) {
            return jsonResponse;
          } else if (jsonResponse is Map && jsonResponse.containsKey('id')) {
            return int.parse(jsonResponse['id'].toString());
          } else {
            throw Exception('Formato de respuesta no esperado: $jsonResponse');
          }
        }
      } else {
        throw Exception('Error HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error en registrarCotizacionPostConDatosString: $e');
      throw Exception('Error al registrar cotización: $e');
    }
  }
  Future<String> enviarCotizacionComoCadena(String datos) async {
    final url = Uri.parse('http://app.singleton.com.bo/WIDMANCRM/Comunicacion.svc/RegistrarCotizacion?Datos={$datos}');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error al registrar cotización: ${response.statusCode}');
    }
  }
}
