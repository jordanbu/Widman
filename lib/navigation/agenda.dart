// ===============================================
// lib/screens/agenda/agenda_screen.dart
// ===============================================

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:widmancrm/api/api_service.dart';
import 'package:widmancrm/models/cliente_model.dart';
import 'package:widmancrm/services_auth/agenda_Services.dart';
import 'package:widmancrm/widgets/agenda/cliente_dropdown.dart';
import 'package:widmancrm/widgets/agenda/motivo_field.dart';
import 'package:widmancrm/widgets/agenda/time_selector.dart';
import 'package:widmancrm/widgets/agenda/agenda_calendar.dart';
import 'package:widmancrm/widgets/agenda/citas_list.dart';
import 'package:widmancrm/utils/agenda_constants.dart';
import 'package:widmancrm/utils/agenda_validators.dart';
import '../Screens/ScreenAgenda/wave_clipper.dart' show WaveClipper;

class Agenda extends StatefulWidget {
  const Agenda({super.key});

  @override
  State<Agenda> createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  // Services
  final ApiService _apiService = ApiService();
  final AgendaService _agendaService = AgendaService();

  // Form Controllers
  final TextEditingController _motivoController = TextEditingController();

  // Form State
  late Future<List<Cliente>> _futureClientes;
  Cliente? _selectedCliente;
  TimeOfDay _selectedTime = TimeOfDay.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _futureClientes = _apiService.fetchClientes();
  }

  @override
  void dispose() {
    _motivoController.dispose();
    super.dispose();
  }

  // ===============================================
  // Event Handlers
  // ===============================================

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AgendaConstants.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _onFormatChanged(CalendarFormat format) {
    if (_calendarFormat != format) {
      setState(() {
        _calendarFormat = format;
      });
    }
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
  }

  void _goToToday() {
    setState(() {
      _focusedDay = DateTime.now();
      _selectedDay = DateTime.now();
    });
  }

  // ===============================================
  // Business Logic
  // ===============================================

  void _guardarCita() {
    final validationError = AgendaValidators.validateCita(
      cliente: _selectedCliente,
      fecha: _selectedDay,
      motivo: _motivoController.text,
    );

    if (validationError != null) {
      _showSnackBar(validationError, Colors.red);
      return;
    }

    try {
      _agendaService.agregarCita(
        cliente: _selectedCliente!,
        fecha: _selectedDay!,
        hora: _selectedTime,
        motivo: _motivoController.text.trim(),
      );

      _clearForm();
      _showSnackBar('Cita guardada exitosamente', Colors.green);

      setState(() {}); // Refresh UI
    } catch (e) {
      _showSnackBar('Error al guardar la cita', Colors.red);
    }
  }

  void _eliminarCita(String citaId) {
    try {
      _agendaService.eliminarCita(citaId);
      _showSnackBar('Cita eliminada', Colors.red);
      setState(() {}); // Refresh UI
    } catch (e) {
      _showSnackBar('Error al eliminar la cita', Colors.red);
    }
  }

  void _clearForm() {
    _motivoController.clear();
    setState(() {
      _selectedCliente = null;
      _selectedDay = null;
      _selectedTime = TimeOfDay.now();
    });
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Mi Agenda',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.today, color: Colors.white, size: 24),
              onPressed: _goToToday,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AgendaConstants.primaryColor,
              AgendaConstants.secondaryColor,
              AgendaConstants.tertiaryColor,
            ],
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.35,
      ),
    );
  }

  Widget _buildNewCitaForm(List<Cliente> clientes) {
    return Container(
      padding: AgendaConstants.cardPadding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AgendaConstants.cardBorderRadius),
        boxShadow: [AgendaConstants.defaultShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.event_note,
            title: 'Nueva Cita',
          ),
          const SizedBox(height: 20),

          ClienteDropdown(
            selectedCliente: _selectedCliente,
            clientes: clientes,
            onChanged: (cliente) => setState(() => _selectedCliente = cliente),
          ),
          const SizedBox(height: 16),

          MotivoField(controller: _motivoController),
          const SizedBox(height: 16),

          TimeSelector(
            selectedTime: _selectedTime,
            onTap: _selectTime,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    Color? iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? AgendaConstants.primaryColor).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor ?? AgendaConstants.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AgendaConstants.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCitaPreview() {
    if (_selectedDay == null || _selectedCliente == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AgendaConstants.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AgendaConstants.primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Cita con ${_selectedCliente!.nombre}\n${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year} a las ${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 14,
                color: AgendaConstants.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: _guardarCita,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text(
          'Guardar Cita',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AgendaConstants.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AgendaConstants.borderRadius),
          ),
          elevation: 3,
        ),
      ),
    );
  }

  // ===============================================
  // Main Build Method
  // ===============================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildHeader(),
          SafeArea(
            child: SingleChildScrollView(
              padding: AgendaConstants.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAppBar(),
                  const SizedBox(height: 20),

                  // Formulario de nueva cita
                  FutureBuilder<List<Cliente>>(
                    future: _futureClientes,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Container(
                          padding: AgendaConstants.cardPadding,
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(AgendaConstants.cardBorderRadius),
                          ),
                          child: const Text(
                            'Error al cargar clientes',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      final clientes = snapshot.data ?? [];
                      return _buildNewCitaForm(clientes);
                    },
                  ),

                  const SizedBox(height: 20),

                  // Calendario
                  AgendaCalendar(
                    focusedDay: _focusedDay,
                    selectedDay: _selectedDay,
                    calendarFormat: _calendarFormat,
                    onDaySelected: _onDaySelected,
                    onFormatChanged: _onFormatChanged,
                    onPageChanged: _onPageChanged,
                    citas: _agendaService.citas,
                  ),

                  const SizedBox(height: 20),

                  // Preview de la cita
                  _buildCitaPreview(),
                  if (_selectedDay != null && _selectedCliente != null)
                    const SizedBox(height: 20),

                  // Botón guardar
                  if (_selectedDay != null && _selectedCliente != null)
                    _buildSaveButton(),

                  const SizedBox(height: 20),

                  // Lista de citas
                  CitasList(
                    citas: _agendaService.citas,
                    onDeleteCita: _eliminarCita,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
