import 'package:flutter/material.dart';
import 'package:widmancrm/models/cita_model.dart';

class CitaItem extends StatelessWidget {
  final Cita cita;
  final VoidCallback onDelete;

  const CitaItem({
    super.key,
    required this.cita,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF2A4D69),
          child: Text(
            cita.clienteNombre[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          cita.clienteNombre,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2A4D69),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(cita.fechaFormateada),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(cita.horaFormateada),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              cita.motivo,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          icon: const Icon(Icons.more_vert, color: Color(0xFF2A4D69)),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Eliminar'),
                ],
              ),
              onTap: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}