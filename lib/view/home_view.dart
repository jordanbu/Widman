import 'package:flutter/material.dart';
import 'package:widmancrm/view/Home/home_drawer.dart';
import 'package:widmancrm/view/Home/wave_clipper.dart';
import 'package:widmancrm/api/api_service.dart';
import 'package:widmancrm/models/cliente_model.dart';

// Importa todas las pantallas necesarias
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

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<List<Cliente>> _futureClientes;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _nitController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _searchQuery = '';
  String _selectedFilter = 'Nombre';

  @override
  void initState() {
    super.initState();
    _futureClientes = ApiService().fetchClientes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _nombreController.dispose();
    _nitController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Método para refrescar la lista de clientes
  void _refreshClientes() {
    setState(() {
      _futureClientes = ApiService().fetchClientes();
    });
  }

  // Método para agregar un cliente
  Future<void> _agregarCliente() async {
    if (_formKey.currentState!.validate()) {
      final clienteData = {
        'IDPersona': 0,
        'NombreCliente': _nombreController.text,
        'Nit': _nitController.text,
        'conCredito': 0,
        'descuento': 0.0,
        'limiteCredito': 0.0,
        'Email': _emailController.text,
      };

      try {
        final apiService = ApiService();
        final result = await apiService.registrarProspecto(clienteData);
        if (result > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cliente registrado exitosamente')),
          );
          _refreshClientes();
          Navigator.of(context).pop();
          _nombreController.clear();
          _nitController.clear();
          _emailController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al registrar cliente')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  // Método para navegar a otras pantallas
  void _navigate(Widget destination) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  // Método para cerrar sesión
  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginView()),
    );
  }

  // Widget para crear las cajas de navegación
  Widget _buildNavigationBox({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? backgroundColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: const Color(0xFF2A4D69),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2A4D69),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      body: SafeArea(
        child: Stack(
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
                height: MediaQuery.of(context).size.height * 0.4,
              ),
            ),
            Column(
              children: [
                // AppBar personalizado
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white, size: 36),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                      const Text(
                        'Panel Principal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.add_alert, color: Colors.white),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Grid de opciones principales
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const SizedBox(height: 17,),

                          // Grid de navegación
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.2,
                            children: [
                              _buildNavigationBox(
                                icon: Icons.app_registration,
                                title: 'Cotización',
                                onTap: () => _navigate(const CotizacionNavigation()),
                              ),
                              _buildNavigationBox(
                                icon: Icons.attach_money,
                                title: 'Ventas',
                                onTap: () => _navigate(const VentNavigation()),
                              ),
                              _buildNavigationBox(
                                icon: Icons.bar_chart,
                                title: 'Stock',
                                onTap: () => _navigate(const StockNavigation()),
                              ),
                              _buildNavigationBox(
                                icon: Icons.supervised_user_circle,
                                title: 'Prospecto',
                                onTap: () => _navigate(const CreateProspect()),
                              ),
                              _buildNavigationBox(
                                icon: Icons.video_label,
                                title: 'Pizarra Virtual',
                                onTap: () => _navigate(const PizarraVirtual()),
                              ),
                              _buildNavigationBox(
                                icon: Icons.analytics,
                                title: 'Reporte Listas Vencidas',
                                onTap: () => _navigate(const ReportListVencidas()),
                              ),
                              _buildNavigationBox(
                                icon: Icons.schedule,
                                title: 'Cuentas por Vencer',
                                onTap: () => _navigate(const CuentasPVencer()),
                              ),
                              _buildNavigationBox(
                                icon: Icons.calendar_month,
                                title: 'Agenda',
                                onTap: () => _navigate(const Agenda()),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Sección de acciones adicionales
                          Row(
                            children: [
                              Expanded(
                                child: _buildNavigationBox(
                                  icon: Icons.more_horiz,
                                  title: 'Otras Acciones',
                                  onTap: () => _navigate(OtrasAcciones()),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildNavigationBox(
                                  icon: Icons.logout,
                                  title: 'Cerrar Sesión',
                                  onTap: _logout,
                                  backgroundColor: Colors.red[50],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Sección de búsqueda de clientes (mantenemos la funcionalidad original)
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Buscar Clientes',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2A4D69),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      hintText: 'Buscar...',
                                      prefixIcon: const Icon(Icons.search),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      fillColor: Colors.grey[200],
                                      filled: true,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _searchQuery = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: ['Nombre', 'ID', 'Fecha'].map((filtro) {
                                      return ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _selectedFilter = filtro;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: _selectedFilter == filtro
                                              ? const Color(0xFF2A4D69)
                                              : Colors.grey[300],
                                          foregroundColor: _selectedFilter == filtro
                                              ? Colors.white
                                              : const Color(0xFF455A64),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Text(filtro),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 12),

                                  // Lista de clientes compacta
                                  SizedBox(
                                    height: 200,
                                    child: FutureBuilder<List<Cliente>>(
                                      future: _futureClientes,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const Center(child: CircularProgressIndicator());
                                        } else if (snapshot.hasError) {
                                          return Center(child: Text('Error: ${snapshot.error}'));
                                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                          return const Center(child: Text('No hay clientes disponibles.'));
                                        }

                                        final clientes = snapshot.data!;
                                        final q = _searchQuery.toLowerCase();

                                        final filtrados = clientes.where((c) {
                                          if (_selectedFilter == 'Nombre') {
                                            return c.nombre.toLowerCase().contains(q);
                                          } else if (_selectedFilter == 'ID') {
                                            return c.idPersona.toString().contains(q);
                                          } else if (_selectedFilter == 'Fecha') {
                                            return '2024-06-20'.contains(q);
                                          }
                                          return true;
                                        }).toList();

                                        return ListView.builder(
                                          itemCount: filtrados.length,
                                          itemBuilder: (context, i) {
                                            final cliente = filtrados[i];
                                            return ListTile(
                                              leading: const Icon(Icons.person_outline, color: Color(0xFF2A4D69)),
                                              title: Text(cliente.nombre),
                                              subtitle: Text('NIT: ${cliente.nit} | ID: ${cliente.idPersona}'),
                                              trailing: Text(cliente.email),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Agregar Cliente'),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nombreController,
                        decoration: const InputDecoration(labelText: 'Nombre'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese el nombre';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _nitController,
                        decoration: const InputDecoration(labelText: 'NIT'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese el NIT';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese el email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Por favor, ingrese un email válido';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar'),
                ),
                ElevatedButton(
                  onPressed: _agregarCliente,
                  child: const Text('Confirmar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
