import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OtrasAcciones extends StatefulWidget {
  const OtrasAcciones({super.key});

  @override
  State<OtrasAcciones> createState() => _OtrasAccionesState();
}

class _OtrasAccionesState extends State<OtrasAcciones> {
  final TextEditingController observacionController = TextEditingController();
  final TextEditingController empresaController = TextEditingController();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codigo1Controller = TextEditingController();
  final TextEditingController monto1Controller = TextEditingController();
  final TextEditingController codigo2Controller = TextEditingController();
  final TextEditingController monto2Controller = TextEditingController();

  List<dynamic>? cotizacionResult;
  bool isLoading = false;
  String? error;

  Future<void> fetchCotizacion(String datos) async {
    setState(() {
      isLoading = true;
      error = null;
      cotizacionResult = null;
    });

    final url = Uri.parse(
        'http://192.168.0.9/WIDMANCRM/Comunicacion.svc/RegistrarCotizacion?Datos=$datos');
    
    print('peticion enviada a: $url');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        setState(() {
          cotizacionResult = data['RegistrarCotizacionResult'];
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Error en la respuesta: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error al hacer la petición: $e';
        isLoading = false;
      });
    }
  }

  void enviar() {
    final observacion = observacionController.text.trim();
    final empresa = empresaController.text.trim();
    final usuario = usuarioController.text.trim();
    final email = emailController.text.trim();
    final codigo1 = codigo1Controller.text.trim();
    final monto1 = monto1Controller.text.trim();
    final codigo2 = codigo2Controller.text.trim();
    final monto2 = monto2Controller.text.trim();

    if (observacion.isEmpty ||
        empresa.isEmpty ||
        usuario.isEmpty ||
        email.isEmpty ||
        codigo1.isEmpty ||
        monto1.isEmpty ||
        codigo2.isEmpty ||
        monto2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    // Armamos el string Datos (según el patrón que diste, ejemplo):
    // "0Observacion|18|0Empresa|17266120|0drada|0jclavijo@singleton.com.bo|6611|222.0|12|20.0|7|7"
    //
    // Aquí pongo el ejemplo con las variables que pusiste (ajusta si quieres):
    final datos = "0$observacion|18|0$empresa|17266120|0$usuario|0$email|$codigo1|$monto1|12|$monto2|7|7";

    fetchCotizacion(datos);
  }

  @override
  void dispose() {
    observacionController.dispose();
    empresaController.dispose();
    usuarioController.dispose();
    emailController.dispose();
    codigo1Controller.dispose();
    monto1Controller.dispose();
    codigo2Controller.dispose();
    monto2Controller.dispose();
    super.dispose();
  }

  Widget campoTexto(
      {required String label,
        required TextEditingController controller,
        TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Otras Acciones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            campoTexto(label: 'Observacion', controller: observacionController),
            campoTexto(label: 'Empresa', controller: empresaController),
            campoTexto(label: 'Usuario', controller: usuarioController),
            campoTexto(label: 'Email', controller: emailController, keyboardType: TextInputType.emailAddress),
            campoTexto(label: 'Código 1', controller: codigo1Controller, keyboardType: TextInputType.number),
            campoTexto(label: 'Monto 1', controller: monto1Controller, keyboardType: TextInputType.number),
            campoTexto(label: 'Código 2', controller: codigo2Controller, keyboardType: TextInputType.number),
            campoTexto(label: 'Monto 2', controller: monto2Controller, keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: enviar,
              child: const Text('Enviar Cotización'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : error != null
                    ? Text(
                  error!,
                  style: const TextStyle(color: Colors.red),
                )
                    : cotizacionResult != null
                    ? ListView.builder(
                  itemCount: cotizacionResult!.length,
                  itemBuilder: (context, index) {
                    final item = cotizacionResult![index];
                    return ListTile(
                      leading:
                      CircleAvatar(child: Text('${index + 1}')),
                      title: Text(item.toString()),
                    );
                  },
                )
                    : const Text('No hay datos para mostrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
