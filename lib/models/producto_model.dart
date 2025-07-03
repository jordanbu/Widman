class Producto {
  final int idProducto;
  final String nombre;
  final double precio;

  Producto({required this.idProducto, required this.nombre, required this.precio});

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idProducto: json['idProducto'],
      nombre: json['nombre'],
      precio: json['precio'].toDouble(),
    );
  }
}
