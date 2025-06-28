import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import'package:widmancrm/api/api_service.dart';
import 'package:widmancrm/models/cliente_model.dart';
import '../Screens/ScreenAgenda/wave_clipper.dart' show WaveClipper;

class Agenda extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class Cita {
  final String id;
  final String clienteId;
  final String clienteNombre;
  final DateTime fecha;
  final TimeOfDay hora;
  final String motivo;
  final DateTime fechaCreacion;

  Cita({
    required this.id,
    required this.clienteId,
    required this.clienteNombre,
    required this.fecha,
    required this.hora,
    required this.motivo,
    required this.fechaCreacion,
  });

  factory Cita.fromMap(Map<String, dynamic> map) {
    return Cita(
      id: map['id'] ?? '',
      clienteId: map['clienteId'] ?? '',
      clienteNombre: map['clienteNombre'] ?? '',
      fecha: DateTime.parse(map['fecha']),
      hora: TimeOfDay(
        hour: map['hora']['hour'],
        minute: map['hora']['minute'],
      ),
      motivo: map['motivo'] ?? '',
      fechaCreacion: DateTime.parse(map['fechaCreacion']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clienteId': clienteId,
      'clienteNombre': clienteNombre,
      'fecha': fecha.toIso8601String(),
      'hora': {
        'hour': hora.hour,
        'minute': hora.minute,
      },
      'motivo': motivo,
      'fechaCreacion': fechaCreacion.toIso8601String(),
    };
  }

  String get fechaFormateada => '${fecha.day}/${fecha.month}/${fecha.year}';
  String get horaFormateada => '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}';
}
