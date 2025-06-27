// widgets/client_search_section.dart
import 'package:flutter/material.dart';
import 'package:widmancrm/controllers/home_controller.dart';
import 'package:widmancrm/models/cliente_model.dart';

class ClientSearchSection extends StatefulWidget {
  final HomeController controller;

  const ClientSearchSection({
    super.key,
    required this.controller,
  });

  @override
  State<ClientSearchSection> createState() => _ClientSearchSectionState();
}

class _ClientSearchSectionState extends State<ClientSearchSection> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Buscar Clientes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2A4D69),
              ),
            ),
            const SizedBox(height: 12),

            // Campo de búsqueda
            TextField(
              controller: widget.controller.searchController,
              decoration: InputDecoration(
                hintText: 'Buscar...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
              onChanged: (value) {
                setState(() {
                  widget.controller.updateSearchQuery(value);
                });
              },
            ),

            const SizedBox(height: 8),

            // Filtros
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['Nombre', 'ID', 'Fecha'].map((filtro) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.controller.updateSelectedFilter(filtro);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.controller.selectedFilter == filtro
                        ? const Color(0xFF2A4D69)
                        : Colors.grey[300],
                    foregroundColor: widget.controller.selectedFilter == filtro
                        ? Colors.white
                        : const Color(0xFF455A64),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(filtro),
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            // Lista de clientes
            SizedBox(
              height: 200,
              child: FutureBuilder<List<Cliente>>(
                future: widget.controller.futureClientes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No hay clientes disponibles.'));
                  }

                  final clientes = snapshot.data!;
                  final filtrados = widget.controller.filterClientes(clientes);

                  return ListView.builder(
                    itemCount: filtrados.length,
                    itemBuilder: (context, i) {
                      final cliente = filtrados[i];
                      return ListTile(
                        leading: const Icon(Icons.person_outline, color: Color(0xFF2A4D69)),
                        title: Text(cliente.nombre),
                        subtitle: Text('NIT: ${cliente.nit} | ID: ${cliente.idPersona}'),
                        trailing: Text(cliente.email),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
