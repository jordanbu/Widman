import 'package:flutter/material.dart';
import 'package:widmancrm/navigation/perfil_navigation.dart';
import 'package:widmancrm/navigation/report_list_vencidas.dart';
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
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFCFD8DC),
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),

              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context); // Cierra el drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context); // Cierra el drawer
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>const PerfilNavigation())
                );
                // Agrega navegación o acción aquí
              },
            ),
            ListTile(
              leading: const Icon(Icons.co_present),
              title: const Text('Cotizacion'),
              onTap: () {
                Navigator.pop(context); // Cierra el drawer
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> ReportListVencidas()));
                // Agrega navegación o acción aquí
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
              leading: const Icon(Icons.vertical_distribute),
              title: const Text('Stock'),
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
