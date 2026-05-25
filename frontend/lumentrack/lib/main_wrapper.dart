import 'package:flutter/material.dart';
import 'ui/screens/dashboard_screen.dart';
import 'ui/screens/muestras_list_screen.dart';
import 'ui/screens/order_list_screen.dart'; // Para el puerto 8083
import 'ui/screens/admin_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const OrdersListScreen(),
    const MuestrasListScreen(), // Conectada al puerto 8082
    const AdminScreen(),
  ];

  Color _getAppBarColor() {
    switch (_selectedIndex) {
      case 0: // Inicio / Dashboard
        return const Color(0xFF934B3D); // Terracota por defecto
      case 1: // Proyectos
        return const Color(0xFF934B3D); // Terracota
      case 2: // Muestras
        return const Color(0xFF3E5B42); // Verde
      case 3: // Admin
        return const Color(0xFFA8BCB1); // Verde Pastel Administración
      default:
        return const Color(0xFF934B3D);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lumentrack",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: _getAppBarColor(),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _getAppBarColor(),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Proyectos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            activeIcon: Icon(Icons.lightbulb),
            label: 'Muestras',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Admin',
          ),
        ],
      ),
    );
  }
}
