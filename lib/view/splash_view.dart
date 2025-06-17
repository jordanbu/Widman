import 'dart:async';
import 'package:flutter/material.dart';
import 'login_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (_SplashViewState,_, _) => LoginView(),
        transitionsBuilder: (_SplashViewState, animation, _, child) {
      return FadeTransition(
      opacity: animation,
      child: child,
      );
      },
        transitionDuration: const Duration(milliseconds: 300), // Reduced from 500ms to 300ms
      ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF455A64), Color(0xFFECEFF1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/logo_widman.png',
            height: 190,
            width: 190,
          ),
        ),
      ),
    );
  }
}