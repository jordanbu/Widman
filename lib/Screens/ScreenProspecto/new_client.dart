import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:widmancrm/api/api_service.dart';
import 'package:widmancrm/Screens/ScreenProspecto/wave_clipper.dart';

class NewClient extends StatefulWidget {
  const NewClient({super.key});

  @override
  _NewClientState createState() => _NewClientState();
}

class _NewClientState extends State<NewClient> {
  final ApiService _apiService = ApiService();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _nitController = TextEditingController();
  final _razonSocialController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _telefono2Controller = TextEditingController();
  final _telefono3Controller = TextEditingController();
  final _carnetController = TextEditingController();
  final _codigoController = TextEditingController();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final prospectoData = {
        'NombreCliente': _nombreController.text.trim(),
        'Nit': _nitController.text.trim(),
        'RazonSocial': _razonSocialController.text.trim(),
        'Telefono': _telefonoController.text.trim(),
        'Telefono2': _telefono2Controller.text.trim(),
        'Telefono3': _telefono3Controller.text.trim(),
        'Carnet': _carnetController.text.trim(),
        'Codigo': _codigoController.text.trim(),
      };

      try {
        final id = await _apiService.registrarProspecto(prospectoData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Prospecto registrado con ID: $id')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _nitController.dispose();
    _razonSocialController.dispose();
    _telefonoController.dispose();
    _telefono2Controller.dispose();
    _telefono3Controller.dispose();
    _carnetController.dispose();
    _codigoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF2A4D69), Color(0xFF3C5A74)],
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.6,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 35),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Nuevo Prospecto',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            const SizedBox(height: 20),
                            Center(
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey,
                                    image: _image != null
                                        ? DecorationImage(
                                      image: FileImage(_image!),
                                      fit: BoxFit.cover,
                                    )
                                        : null,
                                  ),
                                  child: _image == null
                                      ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text('Nombre:', style: TextStyle(fontSize: 16)),
                            TextFormField(
                              controller: _nombreController,
                              decoration: InputDecoration(
                                hintText: 'Nombre del Cliente',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              validator: (value) =>
                              value!.isEmpty ? 'Campo requerido' : null,
                            ),
                            const SizedBox(height: 16),
                            const Text('NIT:', style: TextStyle(fontSize: 16)),
                            TextFormField(
                              controller: _nitController,
                              decoration: InputDecoration(
                                hintText: 'NIT',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              validator: (value) =>
                              value!.isEmpty ? 'Campo requerido' : null,
                            ),
                            const SizedBox(height: 16),
                            const Text('Razón Social:', style: TextStyle(fontSize: 16)),
                            TextFormField(
                              controller: _razonSocialController,
                              decoration: InputDecoration(
                                hintText: 'Razón Social',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text('Teléfono:', style: TextStyle(fontSize: 16)),
                            TextFormField(
                              controller: _telefonoController,
                              decoration: InputDecoration(
                                hintText: 'Teléfono',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo requerido';
                                }
                                final regex = RegExp(r'^[0-9]+$');
                                if (!regex.hasMatch(value)) {
                                  return 'Solo se permiten números';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            const Text('Teléfono 2:', style: TextStyle(fontSize: 16)),
                            TextFormField(
                              controller: _telefono2Controller,
                              decoration: InputDecoration(
                                hintText: 'Teléfono 2',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 16),
                            const Text('Teléfono 3:', style: TextStyle(fontSize: 16)),
                            TextFormField(
                              controller: _telefono3Controller,
                              decoration: InputDecoration(
                                hintText: 'Teléfono 3',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 16),
                            const Text('Carnet:', style: TextStyle(fontSize: 16)),
                            TextFormField(
                              controller: _carnetController,
                              decoration: InputDecoration(
                                hintText: 'Carnet',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text('Código:', style: TextStyle(fontSize: 16)),
                            TextFormField(
                              controller: _codigoController,
                              decoration: InputDecoration(
                                hintText: 'Código',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2A4D69),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  'Guardar',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
