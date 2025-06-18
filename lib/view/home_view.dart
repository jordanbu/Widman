import 'package:flutter/material.dart';
import 'package:widmancrm/navigation/agenda.dart';
import 'package:widmancrm/navigation/cotizacion_navigation.dart';
import 'package:widmancrm/navigation/create_prospet.dart';
import 'package:widmancrm/navigation/cuentas_p_vencer.dart';
import 'package:widmancrm/navigation/pizarra_virtual.dart';
import 'package:widmancrm/navigation/report_list_vencidas.dart';
import 'package:widmancrm/navigation/stock_navigation.dart';
import 'package:widmancrm/navigation/vent_navigation.dart';
import 'login_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fondo con degradado moderno usando ClipPath
      body: Stack(
        children: [
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

          SafeArea(
            child: Column(
              children: [
                // AppBar personalizado con ícono de logout y botón de menú
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Botón para abrir el drawer
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white, size: 36),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Mensaje de bienvenida centrado
                const Center(
                  child: Column(
                    children: [
                        SizedBox(height: 20),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
      // Definición del Drawer
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.7,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF455A64),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo_wid.png',
                    height: 90,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'WidmanCRM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.app_registration),
              title: const Text('Cotizacion'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CotizacionNavigation()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Ventas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VentNavigation()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Stock'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StockNavigation()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.supervised_user_circle),
              title: const Text('Prospecto'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateProspect()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_label),
              title: const Text('Pizarra Virtual'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PizarraVirtual()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Reporte Listas Vencidas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportListVencidas()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Cuentas por Vencer'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CuentasPVencer()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Agenda'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Agenda()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Otras Acciones'),
              onTap: () {
                Navigator.push;
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                );
              },
            ),
          ],
        ),
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