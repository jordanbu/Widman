class ProductoVenta {
  final String codAlterno;
  final String nombre;
  final int nsUnidad;
  final int numSec;
  final int tipo;

  ProductoVenta({
    required this.codAlterno,
    required this.nombre,
    required this.nsUnidad,
    required this.numSec,
    required this.tipo,
  });

  factory ProductoVenta.fromJson(Map<String, dynamic> json) {
    return ProductoVenta(
      codAlterno: json['codAlterno'],
      nombre: json['nombre'],
      nsUnidad: json['ns_Unidad'],
      numSec: json['num_sec'],
      tipo: json['tipo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codAlterno': codAlterno,
      'nombre': nombre,
      'ns_Unidad': nsUnidad,
      'num_sec': numSec,
      'tipo': tipo,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProductoVenta && runtimeType == other.runtimeType && numSec == other.numSec;

  @override
  int get hashCode => numSec.hashCode;
}
