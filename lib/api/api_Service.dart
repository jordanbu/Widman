// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:widmancrm/models/almacen_model.dart';

import '../models/cliente_model.dart';
import '../models/cotizacion_model.dart';
import '../models/prospecto_model.dart';
import '../models/stock_item_models.dart';
import '../models/venta_model.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.9/WIDMANCRM/Comunicacion.svc';

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
}
