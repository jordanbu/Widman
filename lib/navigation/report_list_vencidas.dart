import 'package:flutter/material.dart';
import 'package:widmancrm/Screens/ScreenReporteListasVencidas/wave_clipper.dart';
import '../api/api_Service.dart';
import '../../models/vendedor_model.dart';

class ReportListVencidas extends StatefulWidget {
  const ReportListVencidas({super.key});

  @override
  State<ReportListVencidas> createState() => _ReportListVencidasState();
}

class _ReportListVencidasState extends State<ReportListVencidas> {
  late Future<List<Vendedor>> _vendedores;

  @override
  void initState() {
    super.initState();
    _vendedores = ApiService().fetchListaVendedores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 35),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Lista de Vendedores',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Vendedor>>(
                    future: _vendedores,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No hay vendedores'));
                      }

                      final vendedores = snapshot.data!;
                      return ListView.builder(
                        itemCount: vendedores.length,
                        itemBuilder: (context, index) {
                          final vendedor = vendedores[index];
                          return ListTile(
                            title: Text(vendedor.nombre),
                            subtitle: Text('Código: ${vendedor.numSec}'),
                            leading: const Icon(Icons.person),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
