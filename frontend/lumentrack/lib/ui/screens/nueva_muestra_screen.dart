import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../core/api_config.dart';

class NuevaMuestraScreen extends StatefulWidget {
  const NuevaMuestraScreen({super.key});

  @override
  State<NuevaMuestraScreen> createState() => _NuevaMuestraScreenState();
}

class _NuevaMuestraScreenState extends State<NuevaMuestraScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();

  File? _imageFile;
  String? _selectedProjectId;
  String _clientName = ""; // Campo no editable
  DateTime? _rawDate;

  // Datos simulados de Proyectos (esto debería venir de ApiConfig.projects)
  final List<Map<String, String>> _projects = [
    {'id': '1', 'nombre': 'Torre de Luz', 'cliente': 'ULA Corporativo'},
    {'id': '2', 'nombre': 'Reflector Industrial', 'cliente': 'ZBK Industrial'},
  ];

  // Captura de fotografía (Boceto 03)
  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  // Lógica de guardado e integración con Cloudinary
  Future<void> _saveSample() async {
    if (_imageFile == null || _selectedProjectId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Falta imagen o proyecto")));
      return;
    }

    // 1. Subir a Cloudinary primero
    var imageReq = http.MultipartRequest(
      'POST',
      Uri.parse("${ApiConfig.images}upload"),
    );
    imageReq.files.add(
      await http.MultipartFile.fromPath('file', _imageFile!.path),
    );
    imageReq.fields['folder'] = 'muestras';

    final imageRes = await imageReq.send();
    if (imageRes.statusCode == 200) {
      final resData = await http.Response.fromStream(imageRes);
      final photoUrl = jsonDecode(resData.body)['url'];

      // 2. Guardar Muestra en base de datos
      final sampleData = {
        'projectId': int.parse(_selectedProjectId!),
        'sampleName': _nameCtrl.text,
        'estimatedDeliveryDate': DateFormat(
          'yyyy-MM-dd HH:mm:ss',
        ).format(_rawDate!),
        'samplePhotoUrl': photoUrl,
      };

      final response = await http.post(
        Uri.parse("${ApiConfig.samples}save"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(sampleData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Nueva Muestra")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Registro de Muestra",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),

              // Nombre de la Muestra
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: "Nombre de la Muestra",
                ),
              ),
              const SizedBox(height: 15),

              // Dropdown de Proyectos
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Seleccionar Proyecto",
                ),
                items: _projects
                    .map(
                      (p) => DropdownMenuItem(
                        value: p['id'],
                        child: Text(p['nombre']!),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedProjectId = val;
                    _clientName = _projects.firstWhere(
                      (p) => p['id'] == val,
                    )['cliente']!;
                  });
                },
              ),
              const SizedBox(height: 15),

              // Campo de Cliente (No editable - Boceto 03)
              TextFormField(
                controller: TextEditingController(text: _clientName),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Cliente",
                  fillColor: Colors.grey[100],
                  filled: true,
                ),
              ),
              const SizedBox(height: 20),

              // Visualizador de Cámara (Centrado)
              Center(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: _imageFile == null
                          ? Icon(
                              Icons.camera_enhance_outlined,
                              size: 60,
                              color: theme.colorScheme.primary,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(_imageFile!, fit: BoxFit.cover),
                            ),
                    ),
                    TextButton.icon(
                      onPressed: _takePicture,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text("Tomar Foto"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Fecha estimada
              TextFormField(
                controller: _dateCtrl,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Fecha estimada entrega",
                  suffixIcon: Icon(Icons.calendar_month),
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setState(() {
                      _rawDate = picked;
                      _dateCtrl.text = DateFormat('dd/MM/yyyy').format(picked);
                    });
                  }
                },
              ),
              const SizedBox(height: 30),

              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancelar"),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveSample,
                      child: const Text("Guardar"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
