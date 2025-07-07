import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
import '../routes/app_routes.dart';
import '../view/Login/wave_clipper.dart';

class LoginView extends StatelessWidget {
  final controller = LoginController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Fondo curvo
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    height: size.height * 0.6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2A4D69),
                    ),
                  ),
                ),

                // Contenido con scroll adaptable
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
                              height: 160,
                              width: 160,
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            '¡Bienvenido!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2A4D69),
                            ),
                          ),
                          const SizedBox(height: 70),

                          // Campo usuario
                          TextField(
                            controller: controller.userController,
                            decoration: _buildInputDecoration('Usuario'),
                          ),
                          const SizedBox(height: 20),

                          // Campo contraseña
                          TextField(
                            controller: controller.passwordController,
                            obscureText: true,
                            decoration: _buildInputDecoration('Contraseña'),
                          ),
                          const SizedBox(height: 30),

                          // Botón ingresar
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                backgroundColor: const Color(0xFF3C5A74),
                                elevation: 4,
                              ),
                              onPressed: () async {
                                final result = await controller.login();

                                if (result != null) {
                                  // Éxito: Ir a home
                                  Navigator.pushReplacementNamed(context, AppRoutes.home);

                                  // Puedes guardar datos aquí si quieres (ID, nombre)
                                  print("ID Usuario: ${result[0]}");
                                  print("Nombre: ${result[1]}");
                                } else {
                                  // Error
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Credenciales inválidas")),
                                  );
                                }
                              },
                              child: const Text(
                                "INGRESAR",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  color: Colors.white,
                                ),
                              ),
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

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white.withOpacity(0.95),
      labelStyle: const TextStyle(color: Colors.black45),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black12, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black87, width: 2),
      ),
    );
  }
}
