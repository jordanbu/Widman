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
    super.dispose();
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
                      const Text(
                        'Clientes',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
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
                              // CAMPO SIMULADO (modificar cuando tengas fecha real)
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
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
