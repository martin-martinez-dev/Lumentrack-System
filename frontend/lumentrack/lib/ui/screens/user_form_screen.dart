import 'package:flutter/material.dart';
import '../../models/users_model.dart';
import '../../services/users_service.dart';
import '../../models/roles_model.dart';
import '../../services/roles_service.dart';

class UserFormScreen extends StatefulWidget {
  final UserItem? user;

  const UserFormScreen({super.key, this.user});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final UsersService _usersService = UsersService();
  final RolesService _rolesService = RolesService();
  bool _isSaving = false;
  bool _isLoadingRoles = true;

  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  late TextEditingController _mailController;
  late TextEditingController _phoneController;
  int? _selectedRoleId;

  List<RoleItem> _rolesList = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.userName ?? '');
    _lastNameController = TextEditingController(
      text: widget.user?.userLastName ?? '',
    );
    _mailController = TextEditingController(text: widget.user?.userMail ?? '');
    _phoneController = TextEditingController(
      text: widget.user?.userPhoneNumber ?? '',
    );

    _selectedRoleId = widget.user?.userRoleId;
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    try {
      final roles = await _rolesService.retrieveRoles();
      setState(() {
        _rolesList = roles;
        _isLoadingRoles = false;
      });
    } catch (e) {
      setState(() => _isLoadingRoles = false);
      debugPrint("Error al cargar catálogo de roles: $e");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _mailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final userData = UserItem(
      userId: widget.user?.userId,
      userName: _nameController.text,
      userLastName: _lastNameController.text,
      userMail: _mailController.text,
      userPhoneNumber: _phoneController.text,
      userRoleId: _selectedRoleId ?? 0,
    );

    try {
      if (widget.user == null) {
        await _usersService.saveUser(userData);
      } else {
        await _usersService.updateUser(userData);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al guardar usuario: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.user != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? "Modificar Usuario" : "Nuevo Usuario",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFA8BCB1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: (_isSaving || _isLoadingRoles)
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFA8BCB1)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField(
                      _nameController,
                      "Nombre",
                      Icons.person_outline,
                    ),
                    const SizedBox(height: 15),
                    _buildField(
                      _lastNameController,
                      "Apellidos",
                      Icons.people_outline,
                    ),
                    const SizedBox(height: 15),
                    _buildField(
                      _mailController,
                      "Correo",
                      Icons.alternate_email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    _buildField(
                      _phoneController,
                      "Teléfono",
                      Icons.phone_android,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 15),

                    DropdownButtonFormField<int>(
                      value: _selectedRoleId,
                      decoration: InputDecoration(
                        labelText: "Rol/Responsabilidades",
                        prefixIcon: const Icon(
                          Icons.admin_panel_settings,
                          color: Color(0xFFA8BCB1),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: _rolesList
                          .map(
                            (role) => DropdownMenuItem<int>(
                              value: role.roleId,
                              child: Text(role.roleDisplayName),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => _selectedRoleId = val),
                      validator: (v) => v == null ? "Seleccione un rol" : null,
                    ),

                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _saveForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA8BCB1),
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isEdit ? "ACTUALIZAR USUARIO" : "CREAR USUARIO",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isEdit) ...[
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () => _confirmDelete(),
                        child: const Text(
                          "Dar de baja usuario",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFA8BCB1)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (v) => (v == null || v.isEmpty) ? "Campo requerido" : null,
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar acción"),
        content: const Text(
          "¿Realmente desea eliminar a este usuario del sistema?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No, cancelar"),
          ),
          TextButton(
            onPressed: () async {
              await _usersService.deleteUser(widget.user!.userId!);
              if (mounted) {
                Navigator.pop(context);
                Navigator.pop(context, true);
              }
            },
            child: const Text(
              "Sí, eliminar",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
