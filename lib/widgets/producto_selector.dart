// widgets/producto_selector.dart
import 'package:flutter/material.dart';
import 'package:widmancrm/api/api_service.dart';
import 'package:widmancrm/models/lista_producto_venta_model.dart';

class ProductoSelector extends StatefulWidget {
  final Function(ProductoVenta) onProductoSelected;

  const ProductoSelector({super.key, required this.onProductoSelected});

  @override
  State<ProductoSelector> createState() => _ProductoSelectorState();
}

class _ProductoSelectorState extends State<ProductoSelector> {
  final ApiService _apiService = ApiService();
  late Future<List<ProductoVenta>> _futureProductos;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _searchError;

  @override
  void initState() {
    super.initState();
    _futureProductos = _apiService.fetchListaProductoVenta();
    _searchController.addListener(_validateAndFilter);
  }

  void _validateAndFilter() {
    final query = _searchController.text.trim();
    setState(() {
      if (query.isEmpty) {
        _searchError = null;
        _searchQuery = '';
      } else if (query.length < 2) {
        _searchError = 'Ingrese al menos 2 caracteres';
        _searchQuery = '';
      } else if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(query)) {
        _searchError = 'Solo letras y números';
        _searchQuery = '';
      } else {
        _searchError = null;
        _searchQuery = query.toLowerCase();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar producto...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                fillColor: Colors.white,
                filled: true,
                errorText: _searchError,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ProductoVenta>>(
              future: _futureProductos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final productos = snapshot.data ?? [];
                final filtered = _searchQuery.isEmpty
                    ? productos
                    : productos.where((p) {
                  return p.nombre.toLowerCase().contains(_searchQuery) ||
                      p.numSec.toString().contains(_searchQuery);
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No se encontraron productos.'));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final producto = filtered[index];
                    return ListTile(
                      title: Text(producto.nombre),
                      subtitle: Text('Código: ${producto.codAlterno}'),
                      trailing: Text('ID: ${producto.numSec}'),
                      onTap: () {
                        widget.onProductoSelected(producto);
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
