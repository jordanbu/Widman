// lib/models/vendedor_model.dart
class Vendedor {
  final String nombre;
  final int numSec;

  Vendedor({
    required this.nombre,
    required this.numSec,
  });

  factory Vendedor.fromJson(Map<String, dynamic> json) {
    return Vendedor(
      nombre: json['Nombre'] ?? '',
      numSec: json['num_sec'] ?? 0,
    );
  }
}
