class Cliente {
  final int idPersona;
  final String nombre;
  final String nit;
  final bool conCredito;
  final double descuento;
  final double limiteCredito;
  final String email;

  Cliente({
    required this.idPersona,
    required this.nombre,
    required this.nit,
    required this.conCredito,
    required this.descuento,
    required this.limiteCredito,
    required this.email,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      idPersona: json['IDPersona'],
      nombre: json['NombreCliente'] ?? '',
      nit: json['Nit'] ?? '',
      conCredito: json['conCredito'] == 1,
      descuento: (json['descuento'] ?? 0).toDouble(),
      limiteCredito: (json['limiteCredito'] ?? 0).toDouble(),
      email: json['Email'] ?? '',
    );
  }
}


