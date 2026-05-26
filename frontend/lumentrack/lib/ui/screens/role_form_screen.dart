import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/roles_model.dart';
import '../../services/roles_service.dart';

class RoleFormScreen extends StatefulWidget {
  final RoleItem? role;

  const RoleFormScreen({super.key, this.role});

  @override
  State<RoleFormScreen> createState() => _RoleFormScreenState();
}

class _RoleFormScreenState extends State<RoleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final RolesService _rolesService = RolesService();
  bool _isSaving = false;

  late TextEditingController _nameController;
  late TextEditingController _displayNameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.role?.roleName ?? '');
    _displayNameController = TextEditingController(
      text: widget.role?.roleDisplayName ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.role?.roleDescription ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _displayNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final roleData = RoleItem(
      roleId: widget.role?.roleId,
      roleName: _nameController.text.trim(),
      roleDisplayName: _displayNameController.text.trim(),
      roleDescription: _descriptionController.text.trim(),
    );

    try {
      if (widget.role == null) {
        await _rolesService.saveRole(roleData);
      } else {
        await _rolesService.updateRole(roleData);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al procesar el rol: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.role != null;
    const adminColor = Color(0xFFA8BCB1);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? "Editar Definición de Rol" : "Configurar Nuevo Rol",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: adminColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator(color: adminColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Identificadores del Sistema",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: adminColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildField(
                      _nameController,
                      "Nombre Técnico (Ej: ROLE_ADMIN)",
                      Icons.code,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z_]')),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          return newValue.copyWith(
                            text: newValue.text.toUpperCase(),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _buildField(
                      _displayNameController,
                      "Nombre a Mostrar (Ej: Administrador)",
                      Icons.badge_outlined,
                    ),
                    const SizedBox(height: 15),
                    _buildField(
                      _descriptionController,
                      "Descripción de Responsabilidades",
                      Icons.description_outlined,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _saveForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: adminColor,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isEdit ? "GUARDAR CAMBIOS" : "ACTIVAR ROL",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFA8BCB1)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (v) => (v == null || v.isEmpty)
          ? "Este dato es necesario para la jerarquía"
          : null,
    );
  }
}
