import 'package:flutter/material.dart';
import 'package:widmancrm/api/api_service.dart';
import 'package:widmancrm/models/prospecto_model.dart';
import 'package:widmancrm/Screens/ScreenProspecto/wave_clipper.dart';
import 'package:widmancrm/Screens/ScreenProspecto/new_client.dart';

class CreateProspect extends StatefulWidget {
  const CreateProspect({super.key});

  @override
  _CreateProspectState createState() => _CreateProspectState();
}

class _CreateProspectState extends State<CreateProspect> {
  final ApiService _apiService = ApiService();
  late Future<List<Prospecto>> _futureProspectos;

  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _futureProspectos = _apiService.fetchProspectos();
  }

  void _refreshList() {
    setState(() {
      _futureProspectos = _apiService.fetchProspectos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF2A4D69), Color(0xFF3C5A74)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Prospectos',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar prospecto...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ['All', 'Name', 'ID'].map((filter) {
                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedFilter == filter
                              ? const Color(0xFF2A4D69)
                              : Colors.grey[300],
                          foregroundColor: _selectedFilter == filter
                              ? Colors.white
                              : const Color(0xFF455A64),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(filter == 'All' ? 'Todos' : filter),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      child: FutureBuilder<List<Prospecto>>(
                        future: _futureProspectos,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('No hay clientes disponibles.'));
                          }

                          final all = snapshot.data!;
                          final q = _searchQuery.toLowerCase();

                          final filtered = all.where((p) {
                            if (_selectedFilter == 'Name') {
                              return p.nombre.toLowerCase().contains(q);
                            } else if (_selectedFilter == 'ID') {
                              return p.idProspecto.toString().contains(q);
                            }
                            return p.nombre.toLowerCase().contains(q) ||
                                p.idProspecto.toString().contains(q);
                          }).toList();

                          return ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, i) {
                              final p = filtered[i];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFF2A4D69),
                                  child: Text(
                                    p.idProspecto.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(p.nombre),
                                subtitle: Text('ID: ${p.idProspecto}'),
                                onTap: () {},
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
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                backgroundColor: const Color(0xFF2A4D69),
                child: const Icon(Icons.add,
                color: Colors.white,
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NewClient()),
                  );
                  if (result == true) _refreshList();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
