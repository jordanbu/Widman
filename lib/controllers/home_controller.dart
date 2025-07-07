// controllers/home_controller.dart
import 'package:flutter/material.dart';
import 'package:widmancrm/api/api_Service.dart';
import 'package:widmancrm/models/cliente_model.dart';



class HomeController {
  // Controladores de texto
  final TextEditingController searchController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController nitController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Estados
  late Future<List<Cliente>> futureClientes;
  String searchQuery = '';
  String selectedFilter = 'Nombre';

  // Inicialización
  void initState() {
    futureClientes = ApiService().fetchClientes();
  }

  // Limpieza de recursos
  void dispose() {
    searchController.dispose();
    nombreController.dispose();
    nitController.dispose();
    emailController.dispose();
  }

  // Método para refrescar la lista de clientes
  void refreshClientes() {
    futureClientes = ApiService().fetchClientes();
  }

  // Método para actualizar la búsqueda
  void updateSearchQuery(String query) {
    searchQuery = query;
  }

  // Método para actualizar el filtro seleccionado
  void updateSelectedFilter(String filter) {
    selectedFilter = filter;
  }

  // Método para agregar un cliente
  Future<bool> agregarCliente(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      final clienteData = {
        'IDPersona': 0,
        'NombreCliente': nombreController.text,
        'Nit': nitController.text,
        'conCredito': 0,
        'descuento': 0.0,
        'limiteCredito': 0.0,
        'Email': emailController.text,
      };

      try {
        final apiService = ApiService();
        final result = await apiService.registrarProspecto(clienteData);

        if (result > 0) {
          _showSnackBar(context, 'Cliente registrado exitosamente');
          _clearControllers();
          return true;
        } else {
          _showSnackBar(context, 'Error al registrar cliente');
          return false;
        }
      } catch (e) {
        _showSnackBar(context, 'Error: $e');
        return false;
      }
    }
    return false;
  }

  // Método para filtrar clientes
  List<Cliente> filterClientes(List<Cliente> clientes) {
    final q = searchQuery.toLowerCase();

    return clientes.where((c) {
      if (selectedFilter == 'Nombre') {
        return c.nombre.toLowerCase().contains(q);
      } else if (selectedFilter == 'ID') {
        return c.idPersona.toString().contains(q);
      } else if (selectedFilter == 'Fecha') {
        return '2024-06-20'.contains(q);
      }
      return true;
    }).toList();
  }

  // Métodos privados
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _clearControllers() {
    nombreController.clear();
    nitController.clear();
    emailController.clear();
  }
}
