import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginController {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<List<dynamic>?> login() async {
    final user = userController.text.trim();
    final pass = passwordController.text.trim();

    final url = Uri.parse(
      'http://app.singleton.com.bo/WIDMANCRM/Comunicacion.svc/InicioCorrecto?Usr=$user&Pwd=$pass',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        final result = decoded['InicioCorrectoResult'];

        // Si result es una lista y contiene al menos un valor, es válido
        if (result is List && result.isNotEmpty) {
          return result;
        }
      }
    } catch (e) {
      print("Error al iniciar sesión: $e");
    }

    return null; // Falló el login
  }
}
