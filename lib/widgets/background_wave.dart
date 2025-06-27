// lib/screens/agenda/widgets/background_wave.dart
import 'package:flutter/material.dart';
import 'package:widmancrm/Screens/ScreenAgenda/wave_clipper.dart';

class BackgroundWave extends StatelessWidget {
  const BackgroundWave({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2A4D69),
              Color(0xFF3C5A74),
              Color(0xFF4E6B7F),
            ],
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.35,
      ),
    );
  }
}
