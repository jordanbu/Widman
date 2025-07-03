class ProductoVenta {
  final int numSec;
  final String nombre;
  final String codAlterno;
  final int cantidad;
  final double precioUnitario;

  ProductoVenta({
    required this.numSec,
    required this.nombre,
    required this.codAlterno,
    this.cantidad = 1,
    this.precioUnitario = 0.0,
  });

  factory ProductoVenta.fromJson(Map<String, dynamic> json) {
    return ProductoVenta(
      numSec: json['num_sec'] ?? 0,
      nombre: json['nombre'] ?? '',
      codAlterno: json['cod_alterno'] ?? '',
      precioUnitario: (json['precio_unitario'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'num_sec': numSec,
      'nombre': nombre,
      'cod_alterno': codAlterno,
      'cantidad': cantidad,
      'precio_unitario': precioUnitario,
    };
  }
}
