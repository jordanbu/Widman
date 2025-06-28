
import 'package:flutter/material.dart';
import 'package:widmancrm/models/cliente_model.dart';

class ClienteDropdown extends StatelessWidget {
  final Cliente? selectedCliente;
  final List<Cliente> clientes;
  final Function(Cliente?) onChanged;

  const ClienteDropdown({
    super.key,
    required this.selectedCliente,
    required this.clientes,
    required this.onChanged,
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
      child: DropdownButtonFormField<Cliente>(
        value: selectedCliente,
        decoration: const InputDecoration(
          labelText: 'Seleccionar Cliente',
          labelStyle: TextStyle(color: Color(0xFF2A4D69)),
          prefixIcon: Icon(Icons.person, color: Color(0xFF2A4D69)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: clientes.map((cliente) {
          return DropdownMenuItem<Cliente>(
            value: cliente,
            child: Text(
              cliente.nombre,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF455A64)),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        isExpanded: true,
      ),
    );
  }
}
