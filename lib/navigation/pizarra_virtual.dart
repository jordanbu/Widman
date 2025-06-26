import 'package:flutter/material.dart';
import 'package:widmancrm/Screens/ScreenPizarraVirtual/wave_clipper.dart';

class PizarraVirtual extends StatefulWidget {
  const PizarraVirtual({super.key});

  @override
  _PizarraVirtualState createState() => _PizarraVirtualState();
}

class _PizarraVirtualState extends State<PizarraVirtual> {
  List<Offset?> puntos = [];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo con curva
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: screenHeight * 0.6,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF2A4D69), Color(0xFF3C5A74)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
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
                      const SizedBox(width: 16),
                      const Text(
                        'Pizarra Virtual',
                        style: TextStyle(color: Colors.white, fontSize: 20),
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
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              'Zona de Dibujo',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF455A64),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Zona de dibujo
                            Expanded(
                              child: GestureDetector(
                                onPanUpdate: (details) {
                                  RenderBox box = context.findRenderObject() as RenderBox;
                                  Offset point = box.globalToLocal(details.globalPosition);
                                  setState(() {
                                    puntos.add(point);
                                  });
                                },
                                onPanEnd: (_) {
                                  setState(() {
                                    puntos.add(null);
                                  });
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CustomPaint(
                                    painter: PizarraPainter(puntos),
                                    child: Container(
                                      color: Colors.grey[200],
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Botón limpiar
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  puntos.clear();
                                });
                              },
                              icon: const Icon(Icons.delete),
                              label: const Text('Limpiar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
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

class PizarraPainter extends CustomPainter {
  final List<Offset?> puntos;
  PizarraPainter(this.puntos);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < puntos.length - 1; i++) {
      if (puntos[i] != null && puntos[i + 1] != null) {
        canvas.drawLine(puntos[i]!, puntos[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(PizarraPainter oldDelegate) => true;
}
