import 'package:flutter/material.dart';
import '../../core/session_manager.dart';

class NoRoleScreen extends StatelessWidget {
  const NoRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_person_outlined,
              size: 100,
              color: Color(0xFF934B3D), // Terracota de advertencia
            ),
            const SizedBox(height: 30),
            const Text(
              "Upss, esto no debería pasar.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF934B3D),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Tu usuario se encuentra en sistema pero aun no tiene los permisos requeridos asignados, contacta a tu administrador de sistema o lider de equipo para que se te asignen los permisos necesarios.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // 1. Limpiar la sesión (matar el token y datos en memoria)
                  SessionManager().clearSession();
                  // 2. Devolver al Login
                  Navigator.pushReplacementNamed(context, '/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF934B3D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Aceptar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
