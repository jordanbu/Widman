class CuentaPorCobrar {
  final int id;
  final double monto;
  final String fecha;
  final String cliente;

  CuentaPorCobrar({
    required this.id,
    required this.monto,
    required this.fecha,
    required this.cliente,
  });

  factory CuentaPorCobrar.fromJson(Map<String, dynamic> json) {
    return CuentaPorCobrar(
      id: json['IDCuenta'] ?? 0,
      monto: json['Monto']?.toDouble() ?? 0,
      fecha: json['Fecha'] ?? '',
      cliente: json['Cliente'] ?? '',
    );
  }
}
