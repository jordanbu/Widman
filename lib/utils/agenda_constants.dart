
import 'package:flutter/material.dart';

class AgendaConstants {
  static const Color primaryColor = Color(0xFF2A4D69);
  static const Color secondaryColor = Color(0xFF3C5A74);
  static const Color tertiaryColor = Color(0xFF4E6B7F);
  static const Color textColor = Color(0xFF455A64);

  static const double borderRadius = 15.0;
  static const double cardBorderRadius = 20.0;
  static const double iconSize = 24.0;

  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
  static const EdgeInsets cardPadding = EdgeInsets.all(20.0);

  static BoxShadow get defaultShadow => BoxShadow(
    color: Colors.grey.withOpacity(0.1),
    spreadRadius: 2,
    blurRadius: 8,
    offset: const Offset(0, 4),
  );
}
