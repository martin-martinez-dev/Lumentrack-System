import 'package:flutter/material.dart';
import '../../models/roles_model.dart';
import '../../services/roles_service.dart';
import 'role_form_screen.dart';

class RoleListScreen extends StatefulWidget {
  const RoleListScreen({super.key});

  @override
  State<RoleListScreen> createState() => _RoleListScreenState();
}

class _RoleListScreenState extends State<RoleListScreen> {
  final RolesService _rolesService = RolesService();
  List<RoleItem> _roles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    try {
      final data = await _rolesService.retrieveRoles();
      setState(() {
        _roles = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error al cargar roles: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const adminColor = Color(0xFFA8BCB1);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Catálogo de Roles",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: adminColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: adminColor))
          : RefreshIndicator(
              onRefresh: _loadRoles,
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: _roles.length,
                itemBuilder: (context, index) {
                  final role = _roles[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: adminColor,
                        child: Icon(Icons.security, color: Colors.white),
                      ),
                      title: Text(
                        role.roleDisplayName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${role.roleName}\n${role.roleDescription ?? 'Sin descripción'}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      isThreeLine: true,
                      trailing: const Icon(Icons.edit, color: adminColor),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoleFormScreen(role: role),
                          ),
                        );
                        if (result == true) _loadRoles();
                      },
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: adminColor,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RoleFormScreen()),
          );
          if (result == true) _loadRoles();
        },
        child: const Icon(Icons.add_moderator, color: Colors.white),
      ),
    );
  }
}
