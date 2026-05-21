import 'package:flutter/material.dart';
import 'ui/screens/login_screen.dart';
//import 'ui/screens/nueva_muestra_screen.dart';
import 'ui/screens/carga_tarea_screen.dart';
import 'ui/screens/carga_componente_screen.dart';
import 'main_wrapper.dart'; // Asegúrate de crearlo

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
          seedColor: const Color(0xFF934B3D),
          primary: const Color(0xFF934B3D),
          secondary: const Color(0xFF3E5B42),
          surface: const Color(0xFFF9F7F5),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF934B3D),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        // ... (resto de tu configuración de temas intacta)
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) =>
            const MainWrapper(), // Ahora envuelve las pantallas principales
        //'/nueva-muestra': (context) => const NuevaMuestraScreen(),
        '/carga-tarea': (context) => const CargaTareaScreen(),
        '/carga-componente': (context) => const CargaComponenteScreen(),
      },
    );
  }
}
