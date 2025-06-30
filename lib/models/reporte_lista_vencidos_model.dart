// models/reporte_lista_vencidos_model.dart

class ReporteListaVencidos {
  final int nroGestion;
  final String fechaInicio;
  final String fechaFin;
  final Cliente cliente;
  final Sucursal sucursal;
  final Vendedor vendedor;

  ReporteListaVencidos({
    required this.nroGestion,
    required this.fechaInicio,
    required this.fechaFin,
    required this.cliente,
    required this.sucursal,
    required this.vendedor,
  });
}

class Cliente {
  final int id;
  final String nombre;

  Cliente({required this.id, required this.nombre});
}

class Sucursal {
  final int id;
  final String nombre;

  Sucursal({required this.id, required this.nombre});
}

class Vendedor {
  final int id;
  final String nombre;

  Vendedor({required this.id, required this.nombre});
}
