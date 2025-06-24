import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:widmancrm/Screens/ScreenCuentasPorVencer/wave_clipper.dart';
import 'dart:convert';

// Modelo de Producto
class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      image: json['image'],
    );
  }
}

class CuentasPVencer extends StatefulWidget {
  const CuentasPVencer({super.key});

  @override
  _CuentasPVenderState createState() => _CuentasPVenderState();
}

class _CuentasPVenderState extends State<CuentasPVencer> {
  late Future<List<Product>> products;

  @override
  void initState() {
    super.initState();
    products = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con curva
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
          // Contenido
          SafeArea(
            child: Column(
              children: [
                // AppBar personalizado
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white, size: 35),
                        onPressed: () {
                          Navigator.pop(context); // CORREGIDO
                        },
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Cuentas por Vencer',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.white,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Productos',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF455A64),
                              ),
                            ),
                          ),
                          Expanded(
                            child: FutureBuilder<List<Product>>(
                              future: products,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                } else if (snapshot.hasData) {
                                  final productList = snapshot.data!;
                                  return ListView.builder(
                                    padding: const EdgeInsets.all(16.0),
                                    itemCount: productList.length,
                                    itemBuilder: (context, index) {
                                      final product = productList[index];
                                      return ListTile(
                                        leading: Image.network(
                                          product.image,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(Icons.error);
                                          },
                                        ),
                                        title: Text(
                                          product.title,
                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                                        onTap: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Selected: ${product.title}')),
                                          );
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  return const Center(child: Text('No products found'));
                                }
                              },
                            ),
                          ),
                        ],
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
