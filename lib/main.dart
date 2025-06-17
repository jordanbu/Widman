import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'view/splash_view.dart'; // Import the SplashView

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widson CRM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/', //
      routes: {
        '/': (context) => const SplashView(), // Map '/' to SplashView
        ...AppRoutes.routes, // Include existing routes from AppRoutes
      },
    );
  }
}
