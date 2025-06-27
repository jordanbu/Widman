// widgets/add_client_dialog.dart
import 'package:flutter/material.dart';
import 'package:widmancrm/controllers/home_controller.dart';

class AddClientDialog extends StatelessWidget {
  final HomeController controller;
  final VoidCallback onClientAdded;

  const AddClientDialog({
    super.key,
    required this.controller,
    required this.onClientAdded,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar Cliente'),
      content: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller.nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controller.nitController,
                decoration: const InputDecoration(labelText: 'NIT'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el NIT';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controller.emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Por favor, ingrese un email válido';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cerrar'),
        ),
        ElevatedButton(
          onPressed: () async {
            final success = await controller.agregarCliente(context);
            if (success) {
              onClientAdded();
              Navigator.of(context).pop();
            }
          },
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
