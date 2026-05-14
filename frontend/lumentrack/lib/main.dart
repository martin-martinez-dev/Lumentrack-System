import 'package:flutter/material.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/dashboard_screen.dart';
import 'ui/screens/muestras_list_screen.dart';
import 'ui/screens/nueva_muestra_screen.dart';
import 'ui/screens/carga_tarea_screen.dart';
import 'ui/screens/carga_componente_screen.dart';

void main() => runApp(const LumenTrackApp());

class LumenTrackApp extends StatelessWidget {
  const LumenTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lumentrack',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF934B3D), // Terracota Ula
          primary: const Color(0xFF934B3D),
          secondary: const Color(0xFF3E5B42), // Verde Oliva
          surface: const Color(0xFFF9F7F5),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF934B3D),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3E5B42),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/muestras-list': (context) => const MuestrasListScreen(),
        '/nueva-muestra': (context) => const NuevaMuestraScreen(),
        '/carga-tarea': (context) => const CargaTareaScreen(),
        '/carga-componente': (context) => const CargaComponenteScreen(),
      },
    );
  }
}
