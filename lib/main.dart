import 'package:flutter/material.dart';
import 'package:frontend_test/core/router/app_router.dart';
import 'injection_container.dart' as di;

// Funcion principal
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar dependencias
  di.init();
  runApp(const MainApp());
}

// Clase principal
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Universidades App',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
    );
  }
}
