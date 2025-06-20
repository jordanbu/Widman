import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Screens/ScreenAgenda/wave_clipper.dart' show WaveClipper;

class Agenda extends StatefulWidget {
  const Agenda({super.key});

  @override
  State<Agenda> createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.utc(2025, 6, 18);
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with wave curve
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
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // AppBar personalizado
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
                        if (_selectedDay != null)
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Detalles para ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF455A64),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Próximos Eventos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF455A64),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text('Reunión con Juan | 2 horas'),
                        Text('Reunión con ADISA | Hoy, 3:40 PM'),
                        Text('Mañana'),
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

//