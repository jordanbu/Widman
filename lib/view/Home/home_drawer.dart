import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadImagePath();
  }

  Future<void> _loadImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? path = prefs.getString('profile_image_path');
    if (path != null && File(path).existsSync()) {
      setState(() {
        _image = File(path);
      });
    }
  }

  Future<void> _saveImagePath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', path);
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _image = File(image.path);
        });
        await _saveImagePath(image.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imagen: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Drawer(
          child: SafeArea(
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
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[300],
                              border: Border.all(color: Colors.white, width: 7),
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
                    icon: Icons.app_registration,
                    title: 'Cotización',
                    onTap: () => _navigate(context, const CotizacionNavigation()),
                  ),
                  _buildListTile(
                    icon: Icons.attach_money,
                    title: 'Ventas',
                    onTap: () => _navigate(context, const VentNavigation()),
                  ),
                  _buildListTile(
                    icon: Icons.bar_chart,
                    title: 'Stock',
                    onTap: () => _navigate(context, const StockNavigation()),
                  ),
                  _buildListTile(
                    icon: Icons.supervised_user_circle,
                    title: 'Prospecto',
                    onTap: () => _navigate(context, const CreateProspect()),
                  ),
                  _buildListTile(
                    icon: Icons.video_label,
                    title: 'Pizarra Virtual',
                    onTap: () => _navigate(context, const PizarraVirtual()),
                  ),
                  _buildListTile(
                    icon: Icons.analytics,
                    title: 'Reporte Listas Vencidas',
                    onTap: () => _navigate(context, const ReportListVencidas()),
                  ),
                  _buildListTile(
                    icon: Icons.schedule,
                    title: 'Cuentas por Vencer',
                    onTap: () => _navigate(context, const CuentasPVencer()),
                  ),
                  _buildListTile(
                    icon: Icons.calendar_month,
                    title: 'Agenda',
                    onTap: () => _navigate(context, const Agenda()),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text(
                      'Otras Acciones',
                      style: TextStyle(color: Colors.black87),
                    ),
                    onTap: () => _navigate(context, OtrasAcciones()),
                  ),
                  _buildListTile(
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
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({
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

  void _navigate(BuildContext context, Widget destination) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
  }
}
