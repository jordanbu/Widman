import 'package:flutter/material.dart';
import '../view/Inicio/wave_clipper.dart';
import 'login_view.dart';

class InicioView extends StatelessWidget {
  const InicioView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Fondo curvo
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    height: size.height * 0.65,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2A4D69),
                    ),
                  ),
                ),

                // Contenido central
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          Center(
                            child: Image.asset(
                              'assets/logo_singleton.png',
                              width: 160,
                              height: 240,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            '¡Bienvenido!',
                            style: TextStyle(
                              fontSize: 24,
                              color: Color(0xFF2A4D69),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Botón crear cuenta
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => LoginView()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2A4D69),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Crear una cuenta'),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Botón registrarse
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF2A4D69),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: const BorderSide(color: Color(0xFF2A4D69), width: 1.5),
                              ),
                              child: const Text('Regístrate'),
                            ),
                          ),

                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
