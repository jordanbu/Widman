import 'package:flutter/material.dart';
import 'package:widmancrm/navigation/agenda.dart';
import 'package:widmancrm/navigation/cotizacion_navigation.dart';
import 'package:widmancrm/navigation/create_prospet.dart';
import 'package:widmancrm/navigation/cuentas_p_vencer.dart';
import 'package:widmancrm/navigation/pizarra_virtual.dart';
import 'package:widmancrm/navigation/report_list_vencidas.dart';
import 'package:widmancrm/navigation/stock_navigation.dart';
import 'package:widmancrm/navigation/vent_navigation.dart';
import 'package:widmancrm/view/login_view.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo_wid.png', height: 90),
                  const SizedBox(height: 8),
                  const Text(
                    'Perfil',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            _buildListTile(
              context,
              icon: Icons.app_registration,
              title: 'Cotizacion',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CotizacionNavigation()));
              },
            ),
            _buildListTile(
              context,
              icon: Icons.attach_money,
              title: 'Ventas',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const VentNavigation()));
              },
            ),
            _buildListTile(
              context,
              icon: Icons.bar_chart,
              title: 'Stock',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const StockNavigation()));
              },
            ),
            _buildListTile(
              context,
              icon: Icons.supervised_user_circle,
              title: 'Prospecto',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CreateProspect()));
              },
            ),
            _buildListTile(
              context,
              icon: Icons.video_label,
              title: 'Pizarra Virtual',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const PizarraVirtual()));
              },
            ),
            _buildListTile(
              context,
              icon: Icons.analytics,
              title: 'Reporte Listas Vencidas',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ReportListVencidas()));
              },
            ),
            _buildListTile(
              context,
              icon: Icons.schedule,
              title: 'Cuentas por Vencer',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CuentasPVencer()));
              },
            ),
            _buildListTile(
              context,
              icon: Icons.calendar_month,
              title: 'Agenda',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const Agenda()));
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Otras Acciones', style: TextStyle(color: Colors.black87)),
              onTap: () {
                // Acción extra
              },
            ),
            _buildListTile(
              context,
              icon: Icons.logout,
              title: 'Cerrar Sesión',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginView()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF2A4D69)),
      title: Text(title, style: const TextStyle(color: Colors.black87)),
      onTap: onTap,
    );
  }
}
