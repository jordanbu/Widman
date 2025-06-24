class Cotizacion {
  final String codEstado;
  final String fecha;
  final int idCliente;
  final String nombre;
  final int numSec;
  final String observacion;
  final int tipo;

  Cotizacion({
    required this.codEstado,
    required this.fecha,
    required this.idCliente,
    required this.nombre,
    required this.numSec,
    required this.observacion,
    required this.tipo,
  });

  factory Cotizacion.fromJson(Map<String, dynamic> json) {
    return Cotizacion(
      codEstado: json['cod_estado'] ?? '',
      fecha: json['fecha'] ?? '',
      idCliente: json['idcliente'] ?? 0,
      nombre: json['nombre'] ?? '',
      numSec: json['num_sec'] ?? 0,
      observacion: json['observacion'] ?? '',
      tipo: json['tipo'] ?? 0,
    );
  }
}
