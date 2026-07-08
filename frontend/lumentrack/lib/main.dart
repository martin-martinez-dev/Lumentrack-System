import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // 🟢 Importar
import 'ui/screens/login_screen.dart';
import 'core/session_manager.dart'; // Import SessionManager
import 'ui/screens/register_screen.dart';
import 'ui/screens/no_role_screen.dart';
import 'core/api_config.dart'; // 🟢 Importar ApiConfig
import 'main_wrapper.dart'; // Asegúrate de crearlo

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 🟢 Usamos las opciones por defecto para asegurar compatibilidad con iOS y Android
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🟢 Imprime la URL que la app está usando para verificar la compilación
  debugPrint("======================================================");
  debugPrint("APP INICIADA CON BASE URL: ${ApiConfig.baseUrl}");
  debugPrint("======================================================");
  runApp(const LumenTrackApp());
}

class LumenTrackApp extends StatelessWidget {
  const LumenTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // 🟢 INICIO: Configuración de localización
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'MX'), // Español (México)
      ],
      // 🟢 FIN: Configuración de localización
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
        '/dashboard': (context) {
          final roleName = SessionManager().roleName;
          int initialIndexHint = 0; // Default: Dashboard

          if (roleName == 'ROLE_PRODUCTION' || roleName == 'ROLE_SALES') {
            initialIndexHint = 1; // Hint for Orders screen
          }

          return MainWrapper(initialIndexHint: initialIndexHint);
        },
        '/register': (context) => const RegisterScreen(),
        '/no-role': (context) => const NoRoleScreen(),
      },
    );
  }
}
