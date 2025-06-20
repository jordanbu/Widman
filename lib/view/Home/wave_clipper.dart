import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.30,
      size.width * 0.4,
      size.height * 0.55,
    );
    path.quadraticBezierTo(
      size.width * 0.85,
      size.height * 1.05,
      size.width,
      size.height * 0.7,
    );
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
