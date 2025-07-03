// utils/navigation_helper.dart
import 'package:flutter/material.dart';

// Importa todas las pantallas necesarias
import 'package:widmancrm/Screens/ScreenOtrasAcciones/otras_acciones.dart';
import 'package:widmancrm/navigation/agenda.dart';
import 'package:widmancrm/navigation/cotizacion_navigation.dart';
import 'package:widmancrm/navigation/create_prospet.dart';
import 'package:widmancrm/navigation/cuentas_p_vencer.dart';
import 'package:widmancrm/navigation/pizarra_virtual.dart';
import 'package:widmancrm/navigation/report_list_vencidas.dart';
import 'package:widmancrm/navigation/stock_navigation.dart';
import 'package:widmancrm/navigation/vent_navigation.dart';
import 'package:widmancrm/view/login_view.dart';

class NavigationHelper {
  // Método genérico para navegar
  static void _navigate(BuildContext context, Widget destination) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  // Métodos específicos para cada pantalla
  static void navigateToCotizacion(BuildContext context) {
    _navigate(context, const CotizacionNavigation());
  }

  static void navigateToVentas(BuildContext context) {
    _navigate(context, const VentNavigation());
  }

  static void navigateToStock(BuildContext context) {
    _navigate(context, const StockNavigation());
  }

  static void navigateToProspecto(BuildContext context) {
    _navigate(context, const CreateProspect());
  }

  static void navigateToPizarra(BuildContext context) {
    _navigate(context, const PizarraVirtual());
  }

  static void navigateToReporteVencidas(BuildContext context) {
    _navigate(context, const ReportListVencidas());
  }

  static void navigateToCuentasVencer(BuildContext context) {
    _navigate(context, const CuentasPVencer());
  }

  static void navigateToAgenda(BuildContext context) {
    _navigate(context, const Agenda());
  }

  static void navigateToOtrasAcciones(BuildContext context) {
    _navigate(context, OtrasAccionesScreen());
  }

  // Método para cerrar sesión
  static void logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginView()),
    );
  }
}