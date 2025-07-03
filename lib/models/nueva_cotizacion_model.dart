import 'package:widmancrm/models/lista_producto_venta_model.dart';

class NuevaCotizacion {
  final int idCliente;
  final int tipo;
  final String observacion;
  final List<ProductoVenta> productos;

  NuevaCotizacion({
    required this.idCliente,
    required this.tipo,
    required this.observacion,
    required this.productos,
  });

  Map<String, dynamic> toJson() {
    return {
      'idcliente': idCliente,
      'tipo': tipo,
      'observacion': observacion,
      'productos': productos.map((p) => p.toJson()).toList(),
    };
  }
}
