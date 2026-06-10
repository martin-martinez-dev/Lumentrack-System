import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../core/session_manager.dart';
import '../../models/auth_models.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  Future<void> _handleLogin() async {
    final email = _userController.text.trim();
    final pass = _passwordController.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, ingrese sus credenciales")),
      );
      return;
    }

    try {
      final response = await _authService.login(email, pass);

      if (mounted) {
        // Almacenamos los datos en el singleton SessionManager
        SessionManager().saveSession(response);

        // Validación de Rol ROLE_NONE: Si el usuario no tiene permisos, lo mandamos a la pantalla de aviso
        if (response.roleName == "ROLE_NONE") {
          Navigator.pushReplacementNamed(context, '/no-role');
          return;
        }

        // Diálogo de bienvenida personalizado
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text("¡Bienvenido!"),
            content: Text(
              "Hola, ${response.userName} ${response.userLastName}",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Cerrar diálogo
                  Navigator.pushReplacementNamed(context, '/dashboard');
                },
                child: const Text("Aceptar"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // Si ocurre un 403 o error de red, mostramos SnackBar y nos quedamos aquí
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No se pudo autenticar al usuario"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono en Terracota
              Icon(
                Icons.lightbulb_outline_rounded,
                size: 90,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 10),

              Text(
                'Lumentrack',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  letterSpacing: 1.2,
                ),
              ),

              const Text(
                'Siguiendo el camino a un mundo de luz',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFA7B3A9),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 50),

              TextField(
                controller: _userController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(hintText: 'Usuario'),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: _passwordController,
                textAlign: TextAlign.center,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Contraseña'),
              ),

              const SizedBox(height: 30),

              // Botón de acceso en Verde Oliva
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _handleLogin, // Llamada al método
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    elevation: 0,
                  ),
                  child: const Text(
                    'Entrar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: Text(
                  '¿No tienes cuenta? Regístrate aquí',
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 80),

              const Text(
                'Developed for ula',
                style: TextStyle(fontSize: 10, color: Color(0xFFA7B3A9)),
              ),
              const Text(
                'By ZBK Systems',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFA7B3A9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
