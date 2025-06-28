
import 'package:flutter/material.dart';
import 'package:widmancrm/models/cita_model.dart';
import 'package:widmancrm/models/cliente_model.dart';

class AgendaService {
  final List<Cita> _citas = [];

  List<Cita> get citas => List.unmodifiable(_citas);

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void agregarCita({
    required Cliente cliente,
    required DateTime fecha,
    required TimeOfDay hora,
    required String motivo,
  }) {
    final cita = Cita(
      id: _generateId(),
      clienteId: cliente.idPersona.toString(),
      clienteNombre: cliente.nombre,
      fecha: fecha,
      hora: hora,
      motivo: motivo,
      fechaCreacion: DateTime.now(),
    );

    _citas.add(cita);
  }

  void eliminarCita(String citaId) {
    _citas.removeWhere((cita) => cita.id == citaId);
  }

  List<Cita> obtenerCitasPorFecha(DateTime fecha) {
    return _citas.where((cita) =>
    cita.fecha.year == fecha.year &&
        cita.fecha.month == fecha.month &&
        cita.fecha.day == fecha.day
    ).toList();
  }

  List<Cita> obtenerCitasPorCliente(String clienteId) {
    return _citas.where((cita) => cita.clienteId == clienteId).toList();
  }

  bool tieneCitasEnFecha(DateTime fecha) {
    return obtenerCitasPorFecha(fecha).isNotEmpty;
  }
}
