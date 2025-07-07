import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OtrasAcciones extends StatefulWidget {
  const OtrasAcciones({super.key});

  @override
  State<OtrasAcciones> createState() => _OtrasAccionesState();
}

class _OtrasAccionesState extends State<OtrasAcciones> {
  final _formKey = GlobalKey<FormState>();

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
        'http://app.singleton.com.bo/WIDMANCRM/Comunicacion.svc/RegistrarCotizacion?Datos=$datos');

    print('Enviando petición a: $url');

    try {
      final response = await http.post(url);
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
    FocusScope.of(context).unfocus(); // Oculta el teclado

    if (!_formKey.currentState!.validate()) return;

    final observacion = observacionController.text.trim();
    final empresa = empresaController.text.trim();
    final usuario = usuarioController.text.trim();
    final email = emailController.text.trim();
    final codigo1 = codigo1Controller.text.trim();
    final monto1 = monto1Controller.text.trim();
    final codigo2 = codigo2Controller.text.trim();
    final monto2 = monto2Controller.text.trim();

    final datos =
        "0$observacion|18|0$empresa|17266120|0$usuario|0$email|$codigo1|$monto1|$codigo2|$monto2|7|7";

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

  Widget campoTexto({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Otras Acciones'),
        backgroundColor: const Color(0xFF2A4D69),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      campoTexto(
                        label: 'Obs',
                        controller: observacionController,
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Campo requerido' : null,
                      ),
                      campoTexto(
                        label: 'Empresa',
                        controller: empresaController,
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Campo requerido' : null,
                      ),
                      campoTexto(
                        label: 'Usuario',
                        controller: usuarioController,
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Campo requerido' : null,
                      ),
                      campoTexto(
                        label: 'Email',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Campo requerido';
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Correo inválido';
                          }
                          return null;
                        },
                      ),
                      campoTexto(
                        label: 'Código 1',
                        controller: codigo1Controller,
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Campo requerido' : null,
                      ),
                      campoTexto(
                        label: 'Monto 1',
                        controller: monto1Controller,
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Campo requerido' : null,
                      ),
                      campoTexto(
                        label: 'Código 2',
                        controller: codigo2Controller,
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Campo requerido' : null,
                      ),
                      campoTexto(
                        label: 'Monto 2',
                        controller: monto2Controller,
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: enviar,
                        icon: const Icon(Icons.send),
                        label: const Text('Enviar Cotización'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2A4D69),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        height: 300,
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
                                leading: CircleAvatar(
                                  backgroundColor:
                                  const Color(0xFF2A4D69),
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                        color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  item.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              );
                            },
                          )
                              : const Text('No hay datos para mostrar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
