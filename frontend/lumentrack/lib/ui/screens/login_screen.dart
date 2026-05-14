import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // --- ESTE ES EL MÉTODO QUE FALTABA ---
  void _handleLogin() {
    // Por ahora, navegamos directo al Dashboard sin validar con el Backend
    // Esto te permite probar la app aunque no tengas el servicio de Auth listo
    Navigator.pushReplacementNamed(context, '/dashboard');
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
