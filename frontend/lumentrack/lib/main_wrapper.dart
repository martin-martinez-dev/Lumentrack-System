import 'package:flutter/material.dart';
import 'ui/screens/dashboard_screen.dart';
import 'ui/screens/muestras_list_screen.dart';
import 'ui/screens/order_list_screen.dart'; // Para el puerto 8083
import 'ui/screens/admin_screen.dart';
import 'core/session_manager.dart'; // Import SessionManager

class MainWrapper extends StatefulWidget {
  final int initialIndexHint; // Hint for initial screen based on role

  const MainWrapper({super.key, this.initialIndexHint = 0});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  late int _selectedIndex;
  late List<Widget> _accessibleScreens;
  late List<BottomNavigationBarItem> _bottomNavItems;

  @override
  void initState() {
    super.initState();
    _updateAccessibleUI();
    _selectedIndex = _mapInitialIndexHint(widget.initialIndexHint);
  }

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

  void _updateAccessibleUI() {
    final userRole = SessionManager().roleName;
    _bottomNavItems = [];
    _accessibleScreens = [];

    // Dashboard
    if (userRole == 'ROLE_SUPER_ADMIN' ||
        userRole == 'ROLE_ADMIN' ||
        userRole == 'ROLE_DESIGN') {
      _bottomNavItems.add(
        const BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Inicio',
        ),
      );
      _accessibleScreens.add(const DashboardScreen());
    }

    // Proyectos (Orders)
    if (userRole == 'ROLE_SUPER_ADMIN' ||
        userRole == 'ROLE_ADMIN' ||
        userRole == 'ROLE_DESIGN' ||
        userRole == 'ROLE_PRODUCTION' ||
        userRole == 'ROLE_SALES') {
      _bottomNavItems.add(
        const BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          activeIcon: Icon(Icons.inventory_2),
          label: 'Proyectos',
        ),
      );
      _accessibleScreens.add(const OrdersListScreen());
    }

    // Muestras (Samples)
    if (userRole == 'ROLE_SUPER_ADMIN' ||
        userRole == 'ROLE_ADMIN' ||
        userRole == 'ROLE_DESIGN' ||
        userRole == 'ROLE_PRODUCTION' ||
        userRole == 'ROLE_SALES') {
      _bottomNavItems.add(
        const BottomNavigationBarItem(
          icon: Icon(Icons.lightbulb_outline),
          activeIcon: Icon(Icons.lightbulb),
          label: 'Muestras',
        ),
      );
      _accessibleScreens.add(const MuestrasListScreen());
    }

    // Admin
    if (userRole == 'ROLE_SUPER_ADMIN' || userRole == 'ROLE_ADMIN') {
      _bottomNavItems.add(
        const BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: 'Admin',
        ),
      );
      _accessibleScreens.add(const AdminScreen());
    }
  }

  // Maps the logical initial index (0=Dashboard, 1=Orders) to the actual index
  // in the filtered _accessibleScreens list.
  int _mapInitialIndexHint(int hint) {
    if (_accessibleScreens.isEmpty)
      return 0; // Should not happen if roles are set

    // Logical index 0 is Dashboard
    if (hint == 0 &&
        _accessibleScreens.any((screen) => screen is DashboardScreen)) {
      return _accessibleScreens.indexWhere(
        (screen) => screen is DashboardScreen,
      );
    }
    // Logical index 1 is Orders
    if (hint == 1 &&
        _accessibleScreens.any((screen) => screen is OrdersListScreen)) {
      return _accessibleScreens.indexWhere(
        (screen) => screen is OrdersListScreen,
      );
    }
    // Fallback to the first accessible screen if hint doesn't match or is invalid
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    // Re-evaluate accessible UI if role changes dynamically (e.g., after admin action)
    // For now, assuming role is static after login. If not, call _updateAccessibleUI() here.

    // Ensure selected index is valid for current accessible screens
    if (_selectedIndex >= _accessibleScreens.length) {
      _selectedIndex = 0; // Fallback to first accessible screen
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lumentrack",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: _getAppBarColor(),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _accessibleScreens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _getAppBarColor(),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        items: _bottomNavItems,
      ),
    );
  }
}
