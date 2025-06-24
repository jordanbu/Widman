// models/prospecto_model.dart
class Prospecto {
  final int idProspecto;
  final String nombre;

  Prospecto({required this.idProspecto, required this.nombre});

  factory Prospecto.fromJson(Map<String, dynamic> json) {
    return Prospecto(
      idProspecto: json['IDProspecto'],
      nombre: json['Nombre']?.toString().trim() ?? '',
    );
  }
}
