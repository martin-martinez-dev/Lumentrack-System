import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../models/task_model.dart';
import '../../models/cloudinary_response_model.dart';
import '../../services/tasks_service.dart';
import '../../services/images_service.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task; // Si viene, es edición/consulta
  final int? componentId; // Obligatorio si es una tarea nueva

  const TaskFormScreen({super.key, this.task, this.componentId});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TasksService _tasksService = TasksService();
  final ImagesService _imagesService = ImagesService();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _estimatedDateController;
  late TextEditingController _realDateController;

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
    _isNew = widget.task == null;
    _isEditing = _isNew;

    _nameController = TextEditingController(text: widget.task?.taskName ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.taskDescription ?? '',
    );
    _estimatedDateController = TextEditingController(
      text: widget.task?.taskEstimatedDate ?? '',
    );

    // Limpieza de fecha real para evitar el texto "Sin fecha" en el controlador
    String initialRealDate = widget.task?.taskRealDateTime ?? '';
    if (initialRealDate.toLowerCase().contains('sin') ||
        initialRealDate.toLowerCase().contains('pendiente')) {
      initialRealDate = '';
    }
    _realDateController = TextEditingController(text: initialRealDate);

    if (!_isNew) {
      _uploadedPhotoUrl = widget.task?.taskPhotoUrl;
      _uploadedPhotoId = widget.task?.taskPhotoId;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _estimatedDateController.dispose();
    _realDateController.dispose();
    super.dispose();
  }

  // Lógica de captura de imagen idéntica a SampleForm
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

  // Lógica de subida a Cloudinary con el folder específico: samples/tasks
  Future<void> _uploadImageToCloudinary() async {
    if (_imageFile == null) return;
    setState(() => _isUploadingToCloudinary = true);
    try {
      CloudinaryResponse response = await _imagesService.uploadImage(
        _imageFile!,
        "samples/tasks", // 🟢 Folder específico solicitado
      );
      setState(() {
        _uploadedPhotoUrl = response.url;
        _uploadedPhotoId = response.publicId;
        _imageFile = null;
        _isUploadingToCloudinary = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Evidencia vinculada con éxito"),
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
          _isNew ? "Nueva Tarea / Evidencia" : "Detalle de Tarea",
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
                  if (!_isEditing) {
                    // Revertir cambios si cancela
                    _nameController.text = widget.task?.taskName ?? '';
                    _descriptionController.text =
                        widget.task?.taskDescription ?? '';
                    _estimatedDateController.text =
                        widget.task?.taskEstimatedDate ?? '';
                    _realDateController.text =
                        widget.task?.taskRealDateTime ?? '';
                    _uploadedPhotoUrl = widget.task?.taskPhotoUrl;
                  }
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPhotoSection(),
              const SizedBox(height: 12),

              // Botón de subida
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
                        : "SUBIR EVIDENCIA",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: canUpload ? const Color(0xFF3E5B42) : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              _buildTextField(
                controller: _nameController,
                label: "Nombre de la Tarea",
                icon: Icons.assignment_outlined,
                enabled: _isEditing,
              ),
              const SizedBox(height: 15),

              _buildTextField(
                controller: _descriptionController,
                label: "Descripción / Observaciones",
                icon: Icons.description_outlined,
                enabled: _isEditing,
                maxLines: 3,
              ),
              const SizedBox(height: 15),

              // Fecha Estimada
              _buildTextField(
                controller: _estimatedDateController,
                label: "Fecha Estimada de Finalización",
                icon: Icons.event_note,
                enabled: _isNew, // Solo se define al crear
                readOnly: true,
                onTap: _isNew
                    ? () async {
                        final date = await _askDateOnly(context);
                        if (date != null) {
                          setState(() {
                            _estimatedDateController.text = DateFormat(
                              'yyyy-MM-dd',
                            ).format(date);
                          });
                        }
                      }
                    : null,
              ),
              const SizedBox(height: 15),

              // Fecha Real (Se llena cuando la tarea se completa)
              _buildTextField(
                controller: _realDateController,
                label: "Fecha Real de Ejecución",
                icon: Icons.task_alt,
                enabled: _isEditing,
                readOnly: true,
                requiredField: false,
                onTap: _isEditing
                    ? () async {
                        final date = await _askDateOnly(context);
                        if (date != null) {
                          setState(() {
                            _realDateController.text = DateFormat(
                              'yyyy-MM-dd',
                            ).format(date);
                          });
                        }
                      }
                    : null,
              ),
              const SizedBox(height: 40),

              if (_isEditing)
                ElevatedButton(
                  onPressed: _processData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9B44A),
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _isNew ? "REGISTRAR TAREA" : "GUARDAR AVANCE",
                    style: const TextStyle(
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

  Widget _buildPhotoSection() {
    return Container(
      height: 250,
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
                            Icons.add_a_photo_outlined,
                            size: 80,
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
    bool readOnly = false,
    bool requiredField = true,
    int maxLines = 1,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF3E5B42)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: !enabled,
        fillColor: enabled ? Colors.white : Colors.grey[100],
      ),
      validator: (value) => (requiredField && (value == null || value.isEmpty))
          ? "Este campo es obligatorio"
          : null,
    );
  }

  void _processData() async {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final taskData = Task(
        taskId: widget.task?.taskId,
        taskName: _nameController.text,
        taskDescription: _descriptionController.text,
        componentId: widget.task?.componentId ?? widget.componentId ?? 0,
        taskPhotoUrl: _uploadedPhotoUrl ?? '',
        taskPhotoId: _uploadedPhotoId ?? '',
        taskEstimatedDate:
            Task.formatToServer(_estimatedDateController.text) ?? '',
        taskRealDateTime: _realDateController.text.isNotEmpty
            ? (Task.formatToServer(_realDateController.text) ?? '')
            : '',
      );

      if (_isNew) {
        await _tasksService.saveTask(taskData);
      } else {
        await _tasksService.updateTask(taskData);
      }

      Navigator.pop(context); // Cerrar loading
      Navigator.pop(context, true); // Regresar con éxito

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isNew ? "Tarea registrada" : "Avance guardado"),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Cerrar loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }
}
