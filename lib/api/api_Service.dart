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
  //URL PROBAR

  //GET
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
  //GET
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
  //Metodos get
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
  //GET
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
  //GET
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
//GET
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
  //GET
  // Reemplaza este método en tu ApiService
  Future<int> registrarCotizacion(Map<String, dynamic> cotizacionData) async {
    final url = Uri.parse('$baseUrl/RegistraCotizacion');

    try {
      print('URL: $url'); // Debug
      print('Datos a enviar: $cotizacionData'); // Debug

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(cotizacionData), // Un solo encode, no doble
      );

      print('Status Code: ${response.statusCode}'); // Debug
      print('Response Body: ${response.body}'); // Debug

      if (response.statusCode == 200) {
        // Verifica si la respuesta es un número o contiene un número
        final responseBody = response.body.trim();
        if (responseBody.isEmpty) {
          throw Exception('Respuesta vacía del servidor');
        }

        // Intenta parsear como int directamente
        try {
          return int.parse(responseBody);
        } catch (e) {
          // Si falla, intenta parsear como JSON y extraer el ID
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
      print('Error detallado: $e'); // Debug
      throw Exception('Error de conexión al registrar cotización: $e');
    }
  }
  //Metodo Post
  Future<int> registrarProspecto(Map<String, dynamic> prospectoData) async {
    final url = Uri.parse('$baseUrl/RegistraClienteProspecto');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(jsonEncode(prospectoData)), // Doble encode
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
  Future<List<StockItem>> fetchStockItems() async {
    final response = await http.get(Uri.parse('$baseUrl/Stock')); // Ajusta tu ruta
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => StockItem.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener productos');
    }
//Peticiones get
  }
/*
  Future<List<RegistrarVenta>> fetchRegistrarVenta()async {
    final response = await http.get(Uri.parse('$baseUrl/RegistrarVenta'));
    if (response.statusCode == 200){
      final List<dynamic>data = jsonDecode(response.body);
      return data.map((item)=> RegistrarVenta.fromJson(item).toList());
    } else {
      throw Exception('Error al registrarVenta')
    }
  }*/

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


  //---------------   PRUEBAS  ---------------

  // ===== MÉTODOS PARA REPORTES PDF =====

  /// Descargar reporte de cotización y abrirlo automáticamente
  Future<bool> descargarReporteCotizacionPdf(int cotizacionId) async {
    try {
      final url = Uri.parse('http://app.singleton.com.bo/WIDMANCRM/ReporteCotizacionPdf?cotizacionId=$cotizacionId');

      print('Descargando PDF desde: $url'); // Debug

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

      // Ajusta la URL según tu endpoint específico
      final url = Uri.parse('$baseUrl/GenerarReporteCotizacion');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode(parametros),
      );

      if (response.statusCode == 200) {
        // Si la respuesta es un PDF directo
        if (response.headers['content-type']?.contains('application/pdf') == true) {
          return await _guardarYAbrirPDF(
              response.bodyBytes,
              'reporte_${DateTime.now().millisecondsSinceEpoch}'
          );
        }
        // Si la respuesta es Base64
        else {
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

  /// Descargar reporte sin abrir (solo guardar)
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

  /// Compartir PDF (para usar con share_plus)
  Future<String?> obtenerRutaPDFParaCompartir(int cotizacionId) async {
    try {
      final url = Uri.parse('http://app.singleton.com.bo/WIDMANCRM/ReporteCotizacionPdf?cotizacionId=$cotizacionId');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );

      if (response.statusCode == 200) {
        // Usar directorio temporal para compartir
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

  /// Método privado para guardar y abrir PDF
  Future<bool> _guardarYAbrirPDF(Uint8List pdfBytes, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName.pdf');

      await file.writeAsBytes(pdfBytes);

      // Abrir el archivo
      final result = await OpenFile.open(file.path);

      print('Archivo guardado en: ${file.path}');
      print('Resultado de apertura: ${result.message}');

      return result.type == ResultType.done;
    } catch (e) {
      print('Error al guardar/abrir PDF: $e');
      return false;
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

//pruebas//
}
