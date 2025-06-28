
import 'package:flutter/material.dart';

class TimeSelector extends StatelessWidget {
  final TimeOfDay selectedTime;
  final VoidCallback onTap;

  const TimeSelector({
    super.key,
    required this.selectedTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        leading: const Icon(Icons.access_time, color: Color(0xFF2A4D69)),
        title: const Text(
          'Hora de la cita',
          style: TextStyle(color: Color(0xFF2A4D69), fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.keyboard_arrow_right, color: Color(0xFF2A4D69)),
        onTap: onTap,
      ),
    );
  }
}

