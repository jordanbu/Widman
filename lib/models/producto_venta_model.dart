class ProductoVenta {
  final int numSec;
  final String nombre;
  final String codAlterno;

  ProductoVenta({
    required this.numSec,
    required this.nombre,
    required this.codAlterno,
  });

  factory ProductoVenta.fromJson(Map<String, dynamic> json) {
    return ProductoVenta(
      numSec: json['numSec'],
      nombre: json['nombre'],
      codAlterno: json['codAlterno'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numSec': numSec,
      'nombre': nombre,
      'codAlterno': codAlterno,
    };
  }
}
