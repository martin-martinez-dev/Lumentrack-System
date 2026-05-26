import 'package:flutter/material.dart';
import '../../models/users_model.dart';
import '../../services/users_service.dart'; // Asumiendo la ubicación estándar
import 'user_form_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final UsersService _usersService = UsersService();
  List<UserItem> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final data = await _usersService.retrieveUsersDetails();
      setState(() {
        _users = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al cargar usuarios: $e")));
    }
  }

  String _getInitials(UserItem user) {
    String first = user.userName.isNotEmpty ? user.userName[0] : '';
    String last = user.userLastName.isNotEmpty ? user.userLastName[0] : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Administración de Usuarios",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFFA8BCB1),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFA8BCB1)),
            )
          : RefreshIndicator(
              onRefresh: _loadUsers,
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFFA8BCB1),
                        child: Text(
                          _getInitials(user),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        "${user.userName} ${user.userLastName}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${user.roleDisplayName ?? 'Sin Rol'} • ${user.userMail}",
                      ),
                      trailing: const Icon(
                        Icons.manage_accounts,
                        color: Color(0xFFA8BCB1),
                      ),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserFormScreen(user: user),
                          ),
                        );
                        if (result == true) _loadUsers();
                      },
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFA8BCB1),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserFormScreen()),
          );
          if (result == true) _loadUsers();
        },
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }
}
