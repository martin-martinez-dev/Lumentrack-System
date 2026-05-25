import 'package:flutter/material.dart';
import 'client_list_screen.dart';
import 'user_list_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Administración",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFA8BCB1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Gestión de Catálogos",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFA8BCB1),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            _buildMenuButton(
              context,
              label: "Clientes",
              icon: Icons.business_center_outlined,
              destination: const ClientListScreen(),
            ),
            const SizedBox(height: 20),
            _buildMenuButton(
              context,
              label: "Usuarios",
              icon: Icons.manage_accounts_outlined,
              destination: const UserListScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Widget destination,
  }) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      icon: Icon(icon, color: Colors.white, size: 28),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFA8BCB1),
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
      ),
    );
  }
}
