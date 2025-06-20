import 'package:flutter/material.dart';
import 'package:widmancrm/view/Home/home_drawer.dart';
import 'package:widmancrm/view/Home/wave_clipper.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white, size: 36),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const Center(child: SizedBox(height: 20)),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
      drawer: const HomeDrawer(),  // drawer separado
    );
  }
}

