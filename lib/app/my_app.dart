import 'package:flutter/material.dart';

import '../core/shared/service_registry.dart';
import '../features/orders/presentation/dashboard_screen.dart';

class SmartAhwa extends StatelessWidget {
  const SmartAhwa({super.key});

  @override
  Widget build(BuildContext context) {
    return ServiceRegistry(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Ahwa Manager',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const DashboardScreen(),
      ),
    );
  }
}
