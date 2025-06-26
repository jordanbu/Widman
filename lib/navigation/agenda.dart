import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:widmancrm/api/api_service.dart';
import 'package:widmancrm/models/cliente_model.dart';
import '../Screens/ScreenAgenda/wave_clipper.dart' show WaveClipper;

class Agenda extends StatefulWidget {
  const Agenda({super.key});

  @override
  State<Agenda> createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  final ApiService _apiService = ApiService();
  late Future<List<Cliente>> _futureClientes;
  Cliente? _selectedCliente;
  List<Map<String, dynamic>> _citas = [];

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _futureClientes = _apiService.fetchClientes();
  }

  void _guardarCita() {
    if (_selectedCliente == null || _selectedDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un cliente y una fecha')),
      );
      return;
    }

    setState(() {
      _citas.add({
        'cliente': _selectedCliente!,
        'fecha': _selectedDay!,
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cita guardada')),
    );
  }

  Widget _buildClienteDropdown(List<Cliente> clientes) {
    return DropdownButtonFormField<Cliente>(
      value: _selectedCliente,
      decoration: const InputDecoration(
        labelText: 'Seleccionar Cliente',
        hintText: 'Elige un cliente',
        border: OutlineInputBorder(),
      ),
      items: clientes.map((cliente) {
        return DropdownMenuItem<Cliente>(
          value: cliente,
          child: Text(
            cliente.nombre,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (cliente) {
        setState(() {
          _selectedCliente = cliente;
        });
      },
      isExpanded: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con curva
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // AppBar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white, size: 35),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Agenda',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  // Dropdown de clientes
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: FutureBuilder<List<Cliente>>(
                      future: _futureClientes,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Text('Error al cargar clientes');
                        }

                        final clientes = snapshot.data ?? [];
                        return _buildClienteDropdown(clientes);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Calendario
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${_focusedDay.month} ${_focusedDay.year}',
                          style: const TextStyle(
                            fontSize: 25,
                            height: 3,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF455A64),
                          ),
                        ),
                        TableCalendar(
                          firstDay: DateTime.utc(2000, 1, 1),
                          lastDay: DateTime.utc(2100, 12, 31),
                          focusedDay: _focusedDay,
                          calendarFormat: _calendarFormat,
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          },
                          onFormatChanged: (format) {
                            if (_calendarFormat != format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            }
                          },
                          onPageChanged: (focusedDay) {
                            setState(() {
                              _focusedDay = focusedDay;
                            });
                          },
                          calendarStyle: const CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: Color(0xFF455A64),
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                          ),
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                          ),
                          daysOfWeekStyle: const DaysOfWeekStyle(
                            weekdayStyle: TextStyle(color: Color(0xFF455A64)),
                            weekendStyle: TextStyle(color: Color(0xFF455A64)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_selectedDay != null && _selectedCliente != null)
                          Text(
                            'Agenda con ${_selectedCliente!.nombre} el ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF455A64),
                            ),
                          ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _guardarCita,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2A4D69),
                          ),
                          child: const Text('Guardar Cita', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),

                  // Lista de citas guardadas
                  if (_citas.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Citas Guardadas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF455A64),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ..._citas.map((cita) {
                            final cliente = cita['cliente'] as Cliente;
                            final fecha = cita['fecha'] as DateTime;
                            return ListTile(
                              title: Text(cliente.nombre),
                              subtitle: Text('${fecha.day}/${fecha.month}/${fecha.year}'),
                              leading: const Icon(Icons.event_note, color: Color(0xFF2A4D69)),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
