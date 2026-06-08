import 'package:flutter/material.dart';
import '../../models/users_model.dart';
import '../../services/users_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final UsersService _usersService = UsersService();
  bool _isSaving = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _mailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final userData = UserItem(
      userName: _nameController.text.trim(),
      userLastName: _lastNameController.text.trim(),
      userMail: _mailController.text.trim(),
      userPhoneNumber: _phoneController.text.trim(),
      userRoleId: 6, // ROLE_NONE: Usuario sin permisos asignados inicialmente
      password: _passwordController.text.trim(),
    );

    try {
      await _usersService.saveUser(userData);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Solicitud enviada. Contacta a un administrador para activar tu cuenta.",
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al registrar: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor =
        theme.colorScheme.secondary; // Usamos el Verde Oliva del Login

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Registro de Usuario",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isSaving
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "Ingresa tus datos para comenzar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildField(
                      _nameController,
                      "Nombre",
                      Icons.person_outline,
                      primaryColor,
                    ),
                    const SizedBox(height: 15),
                    _buildField(
                      _lastNameController,
                      "Apellidos",
                      Icons.people_outline,
                      primaryColor,
                    ),
                    const SizedBox(height: 15),
                    _buildField(
                      _mailController,
                      "Correo Electrónico",
                      Icons.email_outlined,
                      primaryColor,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    _buildField(
                      _phoneController,
                      "Teléfono",
                      Icons.phone_android,
                      primaryColor,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 15),
                    _buildField(
                      _passwordController,
                      "Crea tu Contraseña",
                      Icons.lock_outline,
                      primaryColor,
                      obscureText: true,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "SOLICITAR ALTA",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
    IconData icon,
    Color color, {
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: color),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (v) => (v == null || v.isEmpty) ? "Campo obligatorio" : null,
    );
  }
}
