import 'package:flutter/material.dart';
import 'package:widmancrm/view/Home/home_drawer.dart';
import 'package:widmancrm/view/Home/wave_clipper.dart';
import 'package:widmancrm/api/api_service.dart';
import 'package:widmancrm/models/cliente_model.dart';

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
        'IDPersona': 0, // El servidor puede generar este ID
        'NombreCliente': _nombreController.text,
        'Nit': _nitController.text,
        'conCredito': 0, // Sin crédito por defecto
        'descuento': 0.0, // Sin descuento por defecto
        'limiteCredito': 0.0, // Sin límite de crédito por defecto
        'Email': _emailController.text,
      };

      try {
        final apiService = ApiService();
        final result = await apiService.registrarProspecto(clienteData);
        if (result > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cliente registrado exitosamente')),
          );
          _refreshClientes(); // Actualizar la lista
          Navigator.of(context).pop(); // Cerrar el diálogo
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
                height: MediaQuery.of(context).size.height * 0.6,
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
                      const Icon(Icons.add_alert, color: Colors.white),
                    ],
                  ),
                ),

                // Filtros y búsqueda
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
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
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Lista de clientes
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                              return '2024-06-20'.contains(q); // Simulado
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
