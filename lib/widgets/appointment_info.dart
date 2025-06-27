// lib/screens/agenda/widgets/appointment_info.dart
import 'package:flutter/material.dart';
import 'package:widmancrm/models/cliente_model.dart';

class AppointmentInfo extends StatelessWidget {
  final Cliente selectedCliente;
  final DateTime selectedDay;
  final TimeOfDay selectedTime;

  const AppointmentInfo({
    super.key,
    required this.selectedCliente,
    required this.selectedDay,
    required this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A4D69).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF2A4D69)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Cita con ${selectedCliente.nombre}\n${selectedDay.day}/${selectedDay.month}/${selectedDay.year} a las ${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2A4D69),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
