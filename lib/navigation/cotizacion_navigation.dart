import 'package:flutter/material.dart';
import 'package:widmancrm/ScreenCotizacion/add_cotizacion.dart';

class CotizacionNavigation extends StatelessWidget {
  const CotizacionNavigation({super.key});

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
                        'Cotización',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                // Filter bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filtrar',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 60,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'ID',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 100,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Fecha',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 60,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Nombre',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // List container
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
                            'Lista de Cotizaciones',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF455A64),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Text('PS0004'),
                            title: const Text('Prueba'),
                            trailing: const Text('18-06-2025'),
                            onTap: () {},
                          ),
                          const Divider(),

                          const Divider(),
                          ListTile(
                            leading: const Text('PS0004'),
                            title: const Text('Prueba'),
                            trailing: const Text('18-06-2025'),
                            onTap: () {},
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Text('PS0004'),
                            title: const Text('Prueba'),
                            trailing: const Text('18-06-2025'),
                            onTap: () {},
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Text('PS232'),
                            title: const Text('Prueba'),
                            trailing: const Text('15-56-2025'),
                            onTap: (){},
                          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder:
                  (context)=> AddCotizacion()
          ));
        },
        backgroundColor: const Color(0xFF455A64),
        child: const Icon(Icons.add, color: Colors.white),
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
