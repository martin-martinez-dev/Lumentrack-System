import 'package:flutter/material.dart';
import '../../models/client_model.dart';
import '../../services/client_service.dart';
import '../../models/users_model.dart';
import '../../services/users_service.dart';

class ClientFormScreen extends StatefulWidget {
  final Client? client;

  const ClientFormScreen({super.key, this.client});

  @override
  State<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ClientService _clientService = ClientService();
  final UsersService _usersService = UsersService();
  bool _isSaving = false;
  bool _isLoadingData = true;
  List<UserItem> _usersList = [];
  String? _selectedUlaEmployee;

  late TextEditingController _nameController;
  late TextEditingController _companyController;
  late TextEditingController _contactController;
  late TextEditingController _phoneController;
  late TextEditingController _mailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.client?.clientName ?? '',
    );
    _companyController = TextEditingController(
      text: widget.client?.companyName ?? '',
    );
    _contactController = TextEditingController(
      text: widget.client?.clientContactName ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.client?.clientPhoneNumber ?? '',
    );
    _mailController = TextEditingController(
      text: widget.client?.clientMail ?? '',
    );

    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final users = await _usersService.retrieveUsers();
      setState(() {
        _usersList = users;
        // Validamos que el empleado guardado realmente exista en la lista cargada
        if (widget.client != null &&
            widget.client!.ulaLightEmployee.isNotEmpty) {
          final bool exists = users.any(
            (u) => u.fullName == widget.client!.ulaLightEmployee,
          );
          if (exists) {
            _selectedUlaEmployee = widget.client!.ulaLightEmployee;
          } else {
            _selectedUlaEmployee =
                null; // Evita el crash si el dato es inconsistente
          }
        }
        _isLoadingData = false;
      });
    } catch (e) {
      setState(() => _isLoadingData = false);
      // Error silencioso o snackbar según prefieras
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    _mailController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final clientData = Client(
      clientId: widget
          .client
          ?.clientId, // Preservamos el ID oculto para actualizaciones
      clientName: _nameController.text,
      companyName: _companyController.text,
      clientContactName: _contactController.text,
      clientPhoneNumber: _phoneController.text,
      clientMail: _mailController.text,
      ulaLightEmployee: _selectedUlaEmployee ?? '',
    );

    try {
      if (widget.client == null) {
        await _clientService.saveClient(clientData);
      } else {
        await _clientService.updateClient(clientData);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al procesar: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.client != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? "Editar Cliente" : "Nuevo Cliente",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFA8BCB1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: (_isSaving || _isLoadingData)
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
                      "Nombre de Cliente",
                      Icons.person,
                    ),
                    const SizedBox(height: 15),
                    _buildField(
                      _companyController,
                      "Razón Social",
                      Icons.business,
                    ),
                    const SizedBox(height: 15),
                    _buildField(
                      _contactController,
                      "Representante de Cliente",
                      Icons.assignment_ind,
                    ),
                    const SizedBox(height: 15),
                    _buildField(
                      _phoneController,
                      "Numero de Contacto de Cliente",
                      Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 15),
                    _buildField(
                      _mailController,
                      "Correo de Cliente",
                      Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),

                    // Obtenemos nombres únicos para evitar errores de duplicados "2 or more items"
                    // y validamos que el valor seleccionado exista en la lista actual.
                    if (!_isLoadingData)
                      DropdownButtonFormField<String>(
                        value:
                            _usersList.any(
                              (u) => u.fullName == _selectedUlaEmployee,
                            )
                            ? _selectedUlaEmployee
                            : null,
                        decoration: InputDecoration(
                          labelText: "Representante de Ula",
                          prefixIcon: const Icon(
                            Icons.badge,
                            color: Color(0xFFA8BCB1),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: _usersList
                            .map((u) => u.fullName)
                            .toSet() // 🟢 Evita el error de duplicados si hay nombres iguales
                            .map((name) {
                              return DropdownMenuItem<String>(
                                value: name,
                                child: Text(name),
                              );
                            })
                            .toList(),
                        onChanged: (val) {
                          setState(() => _selectedUlaEmployee = val);
                        },
                        validator: (v) => (v == null || v.isEmpty)
                            ? "Seleccione un representante"
                            : null,
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
                        isEdit ? "ACTUALIZAR DATOS" : "REGISTRAR CLIENTE",
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
                          "Eliminar Cliente",
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
      validator: (v) => (v == null || v.isEmpty) ? "Campo obligatorio" : null,
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar eliminación"),
        content: const Text(
          "¿Estás seguro de que deseas eliminar este cliente?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              await _clientService.deleteClient(widget.client!.clientId!);
              if (mounted) {
                Navigator.pop(context);
                Navigator.pop(context, true);
              }
            },
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
