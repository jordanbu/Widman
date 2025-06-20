import 'package:flutter/material.dart';

class AddCotizacion extends StatelessWidget {
  const AddCotizacion({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo degradado con curva
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: size.height * 0.6,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF2A4D69), Color(0xFF3C5A74)],
                ),
              ),
            ),
          ),

          // Contenido principal
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar personalizado
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Agregar Cotización',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Formulario
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildTextField('Nombre del cliente'),
                        const SizedBox(height: 16),
                        _buildTextField('Producto'),
                        const SizedBox(height: 16),
                        _buildTextField('Cantidad', keyboardType: TextInputType.number),
                        const SizedBox(height: 16),
                        _buildTextField('Precio', keyboardType: TextInputType.number),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Aquí guardarías la cotización
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Cotización guardada")),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: const Color(0xFF2A4D69),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Guardar',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// Fondo con curva personalizada
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height * 0.8);

    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstEndPoint = Offset(size.width / 2, size.height * 0.8);
    path.quadraticBezierTo(
      firstControlPoint.dx, firstControlPoint.dy,
      firstEndPoint.dx, firstEndPoint.dy,
    );

    final secondControlPoint = Offset(size.width * 3 / 4, size.height * 0.6);
    final secondEndPoint = Offset(size.width, size.height * 0.8);
    path.quadraticBezierTo(
      secondControlPoint.dx, secondControlPoint.dy,
      secondEndPoint.dx, secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
