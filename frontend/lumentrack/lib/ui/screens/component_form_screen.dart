import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // 🟢 Requerido para formatear la fecha de entrega
import '../../models/component_model.dart';
import '../../models/material_model.dart';
import '../../models/users_model.dart';
import '../../models/task_model.dart';
import '../../models/cloudinary_response_model.dart';
import '../../services/components_service.dart';
import '../../services/material_service.dart';
import '../../services/users_service.dart';
import '../../services/images_service.dart';
import 'task_form_screen.dart';

class ComponentFormScreen extends StatefulWidget {
  final Component? component;
  final int? sampleId;

  const ComponentFormScreen({super.key, this.component, this.sampleId});

  @override
  State<ComponentFormScreen> createState() => _ComponentFormScreenState();
}

class _ComponentFormScreenState extends State<ComponentFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final ComponentsService _componentsService = ComponentsService();
  final MaterialService _materialService = MaterialService();
  final UsersService _usersService = UsersService();
  final ImagesService _imagesService = ImagesService();

  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _descriptionController;
  late TextEditingController
  _deliveryDateController; // 🟢 Controlador para la fecha de entrega

  List<MaterialItem> _materials = [];
  List<UserItem> _users = [];
  List<Task> _componentTasks = [];

  int? _selectedMaterialId;
  String? _selectedEmployeeName;
  String?
  _selectedStatus; // 🟢 Estado para almacenar el statusResume del ComboBox

  // Opciones hardcodeadas para el estatus de avance del componente
  final List<String> _statusOptions = ["Nuevo", "En proceso", "Finalizado"];

  bool _isLoadingDropdowns = true;
  bool _isLoadingDetails = false;
  bool _isEditing = false;
  bool _isNew = false;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isUploadingToCloudinary = false;
  String? _uploadedPhotoUrl;
  String? _uploadedPhotoId;

  @override
  void initState() {
    super.initState();
    _isNew = widget.component == null;
    _isEditing = _isNew;

    _nameController = TextEditingController(
      text: widget.component?.componentName ?? '',
    );
    _typeController = TextEditingController(
      text: widget.component?.componentType ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.component?.componentDescription ?? '',
    );

    // Inicializar fecha de entrega. Si viene del backend "Sin fecha", lo dejamos vacío para obligar la captura
    String initialDeliveryDate = widget.component?.deliveryDate ?? '';
    if (initialDeliveryDate.toLowerCase().contains('sin fecha')) {
      initialDeliveryDate = '';
    }
    _deliveryDateController = TextEditingController(text: initialDeliveryDate);

    if (!_isNew) {
      _uploadedPhotoUrl = widget.component?.componentPhotoUrl;
      _uploadedPhotoId = widget.component?.componentPhotoId;
      _selectedMaterialId = widget.component?.materialId;
      _selectedEmployeeName = widget.component?.ulaLightEmployee.isEmpty == true
          ? null
          : widget.component?.ulaLightEmployee;

      // Validamos que el estado del backend coincida con nuestras opciones fijas
      final backendStatus = widget.component?.statusResume;
      if (_statusOptions.contains(backendStatus)) {
        _selectedStatus = backendStatus;
      } else {
        _selectedStatus = "Nuevo"; // Estado por defecto seguro
      }
    } else {
      _selectedStatus =
          "Nuevo"; // Estado inicial predeterminado para componentes nuevos
    }

    _loadInitialData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _descriptionController.dispose();
    _deliveryDateController
        .dispose(); // 🟢 Liberar memoria del nuevo controlador
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoadingDropdowns = true);
    try {
      final data = await Future.wait([
        _materialService.retrieveMaterials(),
        _usersService.retrieveUsers(),
      ]);

      _materials = data[0] as List<MaterialItem>;
      _users = data[1] as List<UserItem>;

      if (!_isNew) {
        setState(() => _isLoadingDetails = true);
        final detailedComponent = await _componentsService.getComponentDetails(
          widget.component!.componentId!,
        );
        _componentTasks = detailedComponent.taskList;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al sincronizar catálogos: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoadingDropdowns = false;
        _isLoadingDetails = false;
      });
    }
  }

  // 🟢 NUEVO: Refresca solo la lista de tareas sin resetear los Dropdowns (Mejor UX)
  Future<void> _refreshComponentTasks() async {
    if (widget.component?.componentId == null) return;
    try {
      final detailedComponent = await _componentsService.getComponentDetails(
        widget.component!.componentId!,
      );
      setState(() {
        _componentTasks = detailedComponent.taskList;
      });
    } catch (e) {
      debugPrint("Error al sincronizar tareas del componente: $e");
    }
  }

  Future<void> _takePicture() async {
    if (!_isEditing) return;
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1200,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImageToCloudinary() async {
    if (_imageFile == null) return;
    setState(() => _isUploadingToCloudinary = true);
    try {
      CloudinaryResponse response = await _imagesService.uploadImage(
        _imageFile!,
        "samples/components",
      );
      setState(() {
        _uploadedPhotoUrl = response.url;
        _uploadedPhotoId = response.publicId;
        _imageFile = null;
        _isUploadingToCloudinary = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Imagen de insumo vinculada con éxito"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _isUploadingToCloudinary = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error en Cloudinary: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Selector de fecha nativo para el campo deliveryDate
  Future<DateTime?> _askDateOnly(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF3E5B42),
            onPrimary: Colors.white,
            onSurface: Colors.black87,
          ),
        ),
        child: child!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canUpload =
        _isEditing && !_isUploadingToCloudinary && _imageFile != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isNew ? "Agregar Componente / Insumo" : "Detalle de Insumo",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFD9B44A),
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFFD9B44A)),
        actions: [
          if (!_isNew)
            IconButton(
              icon: Icon(
                _isEditing ? Icons.cancel : Icons.edit,
                color: const Color(0xFFD9B44A),
              ),
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                  if (!_isEditing) _loadInitialData();
                });
              },
            ),
        ],
      ),
      body: _isLoadingDropdowns
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF3E5B42)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPhotoSection(),
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: canUpload ? _uploadImageToCloudinary : null,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: canUpload
                                ? const Color(0xFF3E5B42)
                                : Colors.grey[300]!,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: _isUploadingToCloudinary
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF3E5B42),
                                ),
                              )
                            : Icon(
                                Icons.cloud_upload_outlined,
                                color: canUpload
                                    ? const Color(0xFF3E5B42)
                                    : Colors.grey,
                              ),
                        label: Text(
                          _isUploadingToCloudinary
                              ? "SUBIENDO..."
                              : "SUBIR IMAGEN DE INSUMO",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: canUpload
                                ? const Color(0xFF3E5B42)
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    _buildTextField(
                      controller: _nameController,
                      label: "Nombre del Componente",
                      icon: Icons.precision_manufacturing_outlined,
                      enabled: _isEditing,
                    ),
                    const SizedBox(height: 15),

                    _buildTextField(
                      controller: _typeController,
                      label: "Tipo de Componente (Ej. Mecánico, Eléctrico)",
                      icon: Icons.category_outlined,
                      enabled: _isEditing,
                    ),
                    const SizedBox(height: 15),

                    _buildTextField(
                      controller: _descriptionController,
                      label: "Descripción del Componente",
                      icon: Icons.description_outlined,
                      enabled: _isEditing,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 15),

                    // 🟢 Campo nuevo: Fecha de Entrega del Componente (deliveryDate)
                    _buildTextField(
                      controller: _deliveryDateController,
                      label: "Fecha de Entrega / Recepción",
                      icon: Icons.calendar_today_outlined,
                      enabled: _isEditing,
                      readOnly: true,
                      onTap: _isEditing
                          ? () async {
                              final date = await _askDateOnly(context);
                              if (date != null) {
                                setState(() {
                                  _deliveryDateController.text = DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(date);
                                });
                              }
                            }
                          : null,
                    ),
                    const SizedBox(height: 15),

                    // 🟢 Campo nuevo: ComboBox Hardcodeado para el statusResume
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: InputDecoration(
                        labelText: "Estatus del Insumo",
                        prefixIcon: const Icon(
                          Icons.analytics_outlined,
                          color: Color(0xFF3E5B42),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fillColor: _isEditing ? Colors.white : Colors.grey[100],
                        filled: !_isEditing,
                      ),
                      items: _statusOptions.map((status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: _isEditing
                          ? (val) => setState(() => _selectedStatus = val)
                          : null,
                      validator: (value) =>
                          value == null ? "Seleccione el estatus actual" : null,
                    ),
                    const SizedBox(height: 15),

                    DropdownButtonFormField<int>(
                      value: _selectedMaterialId,
                      decoration: InputDecoration(
                        labelText: "Material de Manufactura",
                        prefixIcon: const Icon(
                          Icons.layers_outlined,
                          color: Color(0xFF3E5B42),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fillColor: _isEditing ? Colors.white : Colors.grey[100],
                        filled: !_isEditing,
                      ),
                      items: _materials.map((m) {
                        return DropdownMenuItem<int>(
                          value: m.materialId,
                          child: Text(m.materialName),
                        );
                      }).toList(),
                      onChanged: _isEditing
                          ? (val) => setState(() => _selectedMaterialId = val)
                          : null,
                      validator: (value) =>
                          value == null ? "Seleccione un material" : null,
                    ),
                    const SizedBox(height: 15),

                    DropdownButtonFormField<String>(
                      value: _selectedEmployeeName,
                      decoration: InputDecoration(
                        labelText: "Encargado de Operación (Empleado)",
                        prefixIcon: const Icon(
                          Icons.badge_outlined,
                          color: Color(0xFF3E5B42),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fillColor: _isEditing ? Colors.white : Colors.grey[100],
                        filled: !_isEditing,
                      ),
                      items: _users.map((u) {
                        return DropdownMenuItem<String>(
                          value: u.fullName,
                          child: Text(u.fullName),
                        );
                      }).toList(),
                      onChanged: _isEditing
                          ? (val) => setState(() => _selectedEmployeeName = val)
                          : null,
                      validator: (value) =>
                          value == null ? "Asigne un empleado encargado" : null,
                    ),
                    const SizedBox(height: 30),

                    if (_isEditing)
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD9B44A),
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _isNew ? "REGISTRAR COMPONENTE" : "GUARDAR CAMBIOS",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),

                    if (!_isEditing && !_isNew) ...[
                      const SizedBox(height: 25),
                      const Divider(thickness: 1.5),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Control de Tareas y Evidencias",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3E5B42),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle,
                              color: Color(0xFF934B3D),
                              size: 28,
                            ),
                            onPressed: _navigateToNewTask,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      _isLoadingDetails
                          ? const Center(child: CircularProgressIndicator())
                          : _buildTasksList(),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPhotoSection() {
    return Container(
      height: 230,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: _imageFile != null
                ? Image.file(
                    _imageFile!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : (_uploadedPhotoUrl != null && _uploadedPhotoUrl!.isNotEmpty
                      ? Image.network(
                          _uploadedPhotoUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : const Center(
                          child: Icon(
                            Icons.shutter_speed_outlined,
                            size: 70,
                            color: Colors.grey,
                          ),
                        )),
          ),
          if (_isEditing)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: FloatingActionButton(
                mini: true,
                backgroundColor: const Color(0xFFD9B44A),
                onPressed: _takePicture,
                child: const Icon(Icons.camera_alt, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool enabled,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF3E5B42)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: !enabled,
        fillColor: enabled ? Colors.white : Colors.grey[100],
      ),
      validator:
          validator ??
          (value) => (value == null || value.isEmpty)
              ? "Este campo es obligatorio"
              : null,
    );
  }

  Widget _buildTasksList() {
    if (_componentTasks.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            "No hay tareas registradas para este insumo.",
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _componentTasks.length,
      itemBuilder: (context, index) {
        final task = _componentTasks[index];
        final isCompleted = task.taskRealDateTime.isNotEmpty;

        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isCompleted
                  ? const Color(0xFF3E5B42)
                  : Colors.orange[100],
              child: Icon(
                isCompleted ? Icons.check_circle : Icons.pending_actions,
                color: isCompleted ? Colors.white : Colors.orange[800],
              ),
            ),
            title: Text(
              task.taskName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Estimado: ${task.formattedEstimatedDate}"),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskFormScreen(
                    componentId: widget.component!.componentId!,
                    task: task,
                  ),
                ),
              );
              if (result == true) _refreshComponentTasks();
            },
          ),
        );
      },
    );
  }

  void _navigateToNewTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TaskFormScreen(componentId: widget.component!.componentId),
      ),
    );
    if (result == true) _refreshComponentTasks();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 🟢 Payload completo incluyendo deliveryDate y statusResume mapeados correctamente
      final componentData = Component(
        componentId: widget.component?.componentId,
        sampleId: widget.component?.sampleId ?? widget.sampleId ?? 0,
        componentName: _nameController.text,
        componentType: _typeController.text,
        componentDescription: _descriptionController.text,
        materialId: _selectedMaterialId!,
        ulaLightEmployee: _selectedEmployeeName!,
        componentPhotoUrl: _uploadedPhotoUrl ?? '',
        componentPhotoId: _uploadedPhotoId ?? '',
        deliveryDate: _deliveryDateController.text.isNotEmpty
            ? Component.formatToServer(_deliveryDateController.text) ??
                  'Sin fecha'
            : 'Sin fecha', // 🟢 Guardado correcto
        statusResume:
            _selectedStatus!, // 🟢 Atributo asignado desde el ComboBox hardcodeado
        taskList: _componentTasks,
      );

      if (_isNew) {
        await _componentsService.saveComponent(componentData);
      } else {
        await _componentsService.updateComponent(componentData);
      }

      Navigator.pop(context);
      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isNew ? "Insumo guardado con éxito" : "Componente actualizado",
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al guardar: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
