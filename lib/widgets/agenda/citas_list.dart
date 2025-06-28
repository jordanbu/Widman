import 'package:flutter/material.dart';
import 'package:widmancrm/models/cita_model.dart';
import 'package:widmancrm/widgets/agenda/cita_item.dart';

class CitasList extends StatelessWidget {
  final List<Cita> citas;
  final Function(String) onDeleteCita;

  const CitasList({
    super.key,
    required this.citas,
    required this.onDeleteCita,
  });

  @override
  Widget build(BuildContext context) {
    if (citas.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.event_available,
                  color: Colors.green,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Citas Programadas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2A4D69),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A4D69),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${citas.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...citas.map((cita) => CitaItem(
            cita: cita,
            onDelete: () => onDeleteCita(cita.id),
          )).toList(),
        ],
      ),
    );
  }
}
