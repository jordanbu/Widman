class PrecioProducto {
  final int nsProducto;
  final double precio;
  final double descuento;

  PrecioProducto({
    required this.nsProducto,
    required this.precio,
    required this.descuento,
  });

  factory PrecioProducto.fromJson(Map<String, dynamic> json) {
    return PrecioProducto(
      nsProducto: json['ns_Producto'],
      precio: (json['precio'] as num).toDouble(),
      descuento: (json['precio_por_descuento'] as num).toDouble(),
    );
  }
}


