import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:widmancrm/Screens/ScreenOtrasAcciones/otras_acciones.dart';
import 'package:widmancrm/navigation/agenda.dart';
import 'package:widmancrm/navigation/cotizacion_navigation.dart';
import 'package:widmancrm/navigation/create_prospet.dart';
import 'package:widmancrm/navigation/cuentas_p_vencer.dart';
import 'package:widmancrm/navigation/pizarra_virtual.dart';
import 'package:widmancrm/navigation/report_list_vencidas.dart';
import 'package:widmancrm/navigation/stock_navigation.dart';
import 'package:widmancrm/navigation/vent_navigation.dart';
import 'package:widmancrm/view/login_view.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  File? _image; // Store the selected image
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _image = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

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
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage, // Call the image picker function
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300], // Lighter grey for better contrast
                          border: Border.all(color: Colors.white, width: 7, ),

                          image: _image != null
                              ? DecorationImage(
                            image: FileImage(_image!),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: _image == null
                            ? const Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.white,
                        )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  const Text(
                    'Perfil',

                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
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
              title: 'Cotización',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CotizacionNavigation()),
                );
              },
            ),
            _buildListTile(
              context,
              icon: Icons.attach_money,
              title: 'Ventas',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VentNavigation()),
                );
              },
            ),
            _buildListTile(
              context,
              icon: Icons.bar_chart,
              title: 'Stock',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StockNavigation()),
                );
              },
            ),
            _buildListTile(
              context,
              icon: Icons.supervised_user_circle,
              title: 'Prospecto',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateProspect()),
                );
              },
            ),
            _buildListTile(
              context,
              icon: Icons.video_label,
              title: 'Pizarra Virtual',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PizarraVirtual()),
                );
              },
            ),
            _buildListTile(
              context,
              icon: Icons.analytics,
              title: 'Reporte Listas Vencidas',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportListVencidas()),
                );
              },
            ),
            _buildListTile(
              context,
              icon: Icons.schedule,
              title: 'Cuentas por Vencer',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CuentasPVencer()),
                );
              },
            ),
            _buildListTile(
              context,
              icon: Icons.calendar_month,
              title: 'Agenda',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Agenda()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Otras Acciones',
                style: TextStyle(color: Colors.black87),
              ),
              onTap: () {
                // Placeholder for extra actions
                Navigator.push(context, MaterialPageRoute(builder: (context)=> OtrasAcciones()));
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
                  MaterialPageRoute(builder: (_) => LoginView()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF2A4D69)),
      title: Text(title, style: const TextStyle(color: Colors.black87)),
      onTap: onTap,
    );
  }
}
