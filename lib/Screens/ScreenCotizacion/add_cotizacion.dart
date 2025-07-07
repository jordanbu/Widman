import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'serializacion_utils.dart';

class AddCotizacion extends StatefulWidget {
  const AddCotizacion({super.key});

  @override
  State<AddCotizacion> createState() => _AddCotizacionState();
}



class _AddCotizacionState extends State<AddCotizacion> {
  bool enviando = false;

  Future<void> registrarCotizacion() async {
    setState(() => enviando = true);

    List<List<Object>> detalles = [
      [7, 20.0, 12, 0.0], // [cantidad, precio, ns_producto, descuento]
    ];

    List<Object?> datos = [
      "Observacion",                   // 0: observacion (string)
      18,                              // 1: ns_cliente (int)
      "Empresa",                       // 2: razonSocial (string)
      "17266120",                      // 3: telefono (string)
      "drada",                         // 4: usuario (string)
      "jclavijo@singleton.com.bo",     // 5: correo (string)
      detalles,                        // 6: detalles (List<List<Object>>)
    ];

    String cadena = SerializacionUtils.generarCadenaEnvioAlServidor(datos);
    debugPrint("🔗 Cadena enviada: $cadena");
//*


    final url = Uri.parse(
      'http://192.168.0.9/WIDMANCRM/Comunicacion.svc/RegistrarCotizacion?Datos=$cadena',
    );

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Cotización registrada correctamente')),
        );
        debugPrint("✅ Respuesta del servidor: ${response.body}");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error ${response.statusCode}: Verifica los datos enviados: ${response.body}')),
        );
        debugPrint("❌ Respuesta del servidor: ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error de red: $e')),
      );
      debugPrint("❌ Error de red: $e");
    } finally {
      setState(() => enviando = false);
    }
  }

  @override
  void initState() {
    super.initState();
    registrarCotizacion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Cotización'),
        backgroundColor: const Color(0xFF2A4D69),
      ),
      body: Center(
        child: enviando
            ? const CircularProgressIndicator()
            : const Text(
          'Cotización enviada.',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      ),
    );
  }
}
