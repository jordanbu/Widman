// home_view.dart
import 'package:flutter/material.dart';
import 'package:widmancrm/view/Home/home_drawer.dart';
import 'package:widmancrm/view/Home/wave_clipper.dart';
import 'package:widmancrm/api/api_service.dart';
import 'package:widmancrm/models/cliente_model.dart';

// Widgets separados
import '../controllers/home_controller.dart';
import '../widgets/add_client_dialog.dart';
import '../widgets/client_search_section.dart';
import '../widgets/home_app_bart.dart';
import '../widgets/navigation_grid.dart';

// Controladores

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
    _controller.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            // Fondo con gradiente
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
                height: MediaQuery.of(context).size.height * 0.4,
              ),
            ),

            // Contenido principal
            Column(
              children: [
                // AppBar personalizado
                HomeAppBar(),

                const SizedBox(height: 20),

                // Contenido scrolleable
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 17),

                          // Grid de navegación
                          NavigationGrid(controller: _controller),

                          const SizedBox(height: 20),

                          // Sección de búsqueda de clientes
                          ClientSearchSection(controller: _controller),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // Botón flotante para agregar cliente
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2A4D69),
        child: const Icon(Icons.person_add, color: Colors.white),
        onPressed: () => _showAddClientDialog(context),
      ),
    );
  }

  void _showAddClientDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddClientDialog(
        controller: _controller,
        onClientAdded: () {
          _controller.refreshClientes();
        },
      ),
    );
  }
}
