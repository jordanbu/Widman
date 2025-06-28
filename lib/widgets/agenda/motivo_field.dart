
import 'package:flutter/material.dart';

class MotivoField extends StatelessWidget {
  final TextEditingController controller;

  const MotivoField({
    super.key,
    required this.controller,
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
      child: TextFormField(
        controller: controller,
        maxLines: 3,
        decoration: const InputDecoration(
          labelText: 'Motivo de la cita',
          labelStyle: TextStyle(color: Color(0xFF2A4D69)),
          hintText: 'Describe el motivo de la reunión...',
          prefixIcon: Icon(Icons.description, color: Color(0xFF2A4D69)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
