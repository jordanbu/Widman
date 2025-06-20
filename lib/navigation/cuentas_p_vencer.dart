import 'package:flutter/material.dart';

class CuentasPVencer extends StatelessWidget {
  const CuentasPVencer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with wave curve
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF2A4D69), Color(0xFF3C5A74)],
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.6,
            ),
          ),
          // Main content
          SafeArea(
            child: Column(
              children: [
                // AppBar personalizado
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 35),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Cuentas por Vencer',
                        style: TextStyle(color: Colors.white, fontSize: 20,

                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.white,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          const Text(
                            'Cuentas',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF455A64),
                            ),
                          ),
                          const SizedBox(height: 16),





                        ],
                      ),
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
}

// Custom clipper for the wave effect
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.8);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height * 0.8);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width * 3 / 4, size.height * 0.6);
    var secondEndPoint = Offset(size.width, size.height * 0.8);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
