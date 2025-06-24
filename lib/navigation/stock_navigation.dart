import 'package:flutter/material.dart';
import 'package:widmancrm/Screens/ScreenStock/wave_clipper.dart';
import '../api/api_Service.dart';
import '../models/stock_item_models.dart';

class StockNavigation extends StatefulWidget {
  const StockNavigation({super.key});

  @override
  State<StockNavigation> createState() => _StockNavigationState();
}

class _StockNavigationState extends State<StockNavigation> {
  final ApiService _apiService = ApiService();
  late Future<List<StockItem>> _futureStock;

  @override
  void initState() {
    super.initState();
    _futureStock = _apiService.fetchStock();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
              height: size.height * 0.6,
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
                        icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 16),
                      const Text('Stock de Productos',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: FutureBuilder<List<StockItem>>(
                          future: _futureStock,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text('No hay productos en stock.'));
                            } else {
                              final stockList = snapshot.data!;
                              return ListView.builder(
                                itemCount: stockList.length,
                                itemBuilder: (context, index) {
                                  final item = stockList[index];
                                  return ListTile(
                                    title: Text('Producto ID: ${item.nsProducto}'),
                                    subtitle: Text(
                                        'Cantidad: ${item.cantFisica} | Almacén: ${item.nsAlmacen}'),
                                    leading: const Icon(Icons.inventory),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
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
