// widgets/navigation_grid.dart
import 'package:flutter/material.dart';
import 'package:widmancrm/controllers/home_controller.dart';
import 'package:widmancrm/utils/navigation_helper.dart';
import 'navigation_box.dart';

class NavigationGrid extends StatelessWidget {
  final HomeController controller;

  const NavigationGrid({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Grid principal
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            NavigationBox(
              icon: Icons.app_registration,
              title: 'Cotización',
              onTap: () => NavigationHelper.navigateToCotizacion(context),
            ),
            NavigationBox(
              icon: Icons.attach_money,
              title: 'Ventas',
              onTap: () => NavigationHelper.navigateToVentas(context),
            ),
            NavigationBox(
              icon: Icons.bar_chart,
              title: 'Stock',
              onTap: () => NavigationHelper.navigateToStock(context),
            ),
            NavigationBox(
              icon: Icons.supervised_user_circle,
              title: 'Prospecto',
              onTap: () => NavigationHelper.navigateToProspecto(context),
            ),
            NavigationBox(
              icon: Icons.video_label,
              title: 'Pizarra Virtual',
              onTap: () => NavigationHelper.navigateToPizarra(context),
            ),
            NavigationBox(
              icon: Icons.analytics,
              title: 'Reporte Listas Vencidas',
              onTap: () => NavigationHelper.navigateToReporteVencidas(context),
            ),
            NavigationBox(
              icon: Icons.schedule,
              title: 'Cuentas por Vencer',
              onTap: () => NavigationHelper.navigateToCuentasVencer(context),
            ),
            NavigationBox(
              icon: Icons.calendar_month,
              title: 'Agenda',
              onTap: () => NavigationHelper.navigateToAgenda(context),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Sección de acciones adicionales
        Row(
          children: [
            Expanded(
              child: NavigationBox(
                icon: Icons.more_horiz,
                title: 'Otras Acciones',
                onTap: () => NavigationHelper.navigateToOtrasAcciones(context),
              ),
            ),
            const SizedBox(width: 16),
            // Espacio para futuras acciones
          ],
        ),
      ],
    );
  }
}
