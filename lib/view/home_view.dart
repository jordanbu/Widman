import 'package:flutter/material.dart';
import 'package:widmancrm/navigation/cotizacion_navigation.dart';
import 'package:widmancrm/navigation/create_prospet.dart';
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
      // Fondo con degradado moderno
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF455A64), Color(0xFFECEFF1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
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
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                    const Text(
                      "Inicio",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      tooltip: 'Cerrar sesión',
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginView()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Mensaje de bienvenida centrado
              const Center(
                child: Column(
                  children: [
                    Icon(Icons.business_center, size: 80, color: Colors.white),
                    SizedBox(height: 20),
                    Text(
                      'Bienvenido a Widman CRM',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
      // Definición del Drawer
      drawer: Drawer(
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
                    height: 88,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'WidmanCRM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2, // Corregido: "latterSpacing" -> "letterSpacing"
                    ),
                  ),
                ],
              ),
            ),


            ListTile(
              leading: const Icon(Icons.co_present),
              title: const Text('Cotizacion'),
              onTap: () {
                Navigator.pop(context); // Cierra el drawer
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> CotizacionNavigation()));
                // Agrega navegación o acción aquí
              },
            ),
            ListTile(
              leading: const Icon(Icons.vertical_split),
              title: const Text('Ventas'),
              onTap: () {
                Navigator.pop(context); // Cierra el drawer
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> VentNavigation()));
                // Agrega navegación o acción aquí
              },
            ),
            ListTile(
              leading: const Icon(Icons.vertical_distribute),
              title: const Text('Stock'),
              onTap: () {
                Navigator.push;
                Navigator.push(context,MaterialPageRoute(builder: (context)=> StockNavigation()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.padding_rounded),
              title: const Text('Crear Prospecto'),
              onTap: () {
                Navigator.push;
                Navigator.push(context,MaterialPageRoute(builder: (context)=> CreateProspect()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_label),
              title: const Text('Pizarra Virtual'),
              onTap: () {
                Navigator.push;
                Navigator.push(context,
                    MaterialPageRoute(builder:
                        (context)=> PizarraVirtual()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Reporte Listas Vencidas'),
              onTap: () {
                Navigator.pop(context); // Cierra el drawer
                Navigator.push(context,
                MaterialPageRoute(builder: (context)=> ReportListVencidas()));
                // Agrega navegación o acción aquí
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Cuentas por Vencer'),
              onTap: () {
                Navigator.pop(context); // Cierra el drawer
                // Agrega navegación o acción aquí
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Agenda'),
              onTap: () {
                Navigator.pop(context); // Cierra el drawer
                // Agrega navegación o acción aquí
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_as),
              title: const Text('Venta'),
              onTap: () {
                Navigator.push;

              },
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                Navigator.pop(context); // Cierra el drawer
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
