
import 'package:widmancrm/models/cliente_model.dart';

class AgendaValidators {
  static String? validateCita({
    required Cliente? cliente,
    required DateTime? fecha,
    required String motivo,
  }) {
    if (cliente == null) {
      return 'Debe seleccionar un cliente';
    }

    if (fecha == null) {
      return 'Debe seleccionar una fecha';
    }

    if (motivo.trim().isEmpty) {
      return 'Debe ingresar el motivo de la cita';
    }

    if (fecha.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      return 'No se pueden programar citas en fechas pasadas';
    }

    return null;
  }

  static bool isValidMotivo(String motivo) {
    return motivo.trim().isNotEmpty && motivo.trim().length >= 5;
  }
}
