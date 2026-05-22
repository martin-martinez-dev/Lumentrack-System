import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../models/samples_model.dart';
import '../../models/orders_model.dart';
import '../../models/component_model.dart';
import '../../models/cloudinary_response_model.dart';
import '../../services/samples_service.dart';
import '../../services/orders_service.dart';
import '../../services/images_service.dart';
import 'component_form_screen.dart'; // Importación integrada

class SampleFormScreen extends StatefulWidget {
  final Sample? sample;

  const SampleFormScreen({super.key, this.sample});

  @override
  State<SampleFormScreen> createState() => _SampleFormScreenState();
}

class _SampleFormScreenState extends State<SampleFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final SamplesService _samplesService = SamplesService();
  final OrdersService _ordersService = OrdersService();
  final ImagesService _imagesService = ImagesService();

  late TextEditingController _nameController;
  late TextEditingController _estimatedDateController;
  late TextEditingController _realDateController;

  int? _selectedOrderId;
  List<Order> _availableOrders = [];
  bool _isLoadingOrders = true;

  bool _isEditing = false;
  bool _isNew = false;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  bool _isUploadingToCloudinary = false;
  String? _uploadedPhotoUrl;
  String? _uploadedPhotoId;

  // State local para renderizar de manera reactiva la lista de componentes de la muestra
  List<Component> _associatedComponents = [];

  @override
  void initState() {
    super.initState();
    _isNew = widget.sample == null;
    _isEditing = _isNew;

    _nameController = TextEditingController(
      text: widget.sample?.sampleName ?? '',
    );
    _estimatedDateController = TextEditingController(
      text: widget.sample?.estimatedDeliveryDate ?? '',
    );

    String inicialRealDate = widget.sample?.realDeliveryDate ?? '';
    if (inicialRealDate.toLowerCase().contains('sin fecha')) {
      inicialRealDate = '';
    }
    _realDateController = TextEditingController(text: inicialRealDate);

    if (!_isNew) {
      _selectedOrderId = widget.sample?.orderId;
      _uploadedPhotoUrl = widget.sample?.samplePhotoUrl;
      _uploadedPhotoId = widget.sample?.samplePhotoId;

      // 1. Carga inicial instantánea con lo que hereda de la vista anterior (UX veloz)
      _associatedComponents = widget.sample?.componentList ?? [];

      // 2. 🟢 CONEXIÓN ASÍNCRONA: Vamos al backend por los datos reales y unificados en segundo plano
      _inicializarComponentesGenuinos();
    }

    _loadOrdersCatalog();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _estimatedDateController.dispose();
    _realDateController.dispose();
    super.dispose();
  }

  // 🟢 NUEVO MÉTODO: Trae la muestra completa usando el endpoint detallado con componentes
  Future<void> _inicializarComponentesGenuinos() async {
    if (widget.sample?.sampleId == null) return;
    try {
      final sampleCompleta = await _samplesService.fetchSampleWithComponents(
        widget.sample!.sampleId!,
      );
      setState(() {
        _associatedComponents = sampleCompleta.componentList;
      });
    } catch (e) {
      debugPrint(
        "Error al inicializar componentes desde el JSON unificado: $e",
      );
    }
  }

  Future<void> _loadOrdersCatalog() async {
    try {
      final orders = await _ordersService.fetchOrders();
      setState(() {
        _availableOrders = orders;
        _isLoadingOrders = false;
      });
    } catch (e) {
      setState(() => _isLoadingOrders = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al cargar órdenes de producción: $e"),
          backgroundColor: Colors.red,
        ),
      );
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
    setState(() {
      _isUploadingToCloudinary = true;
    });
    try {
      CloudinaryResponse response = await _imagesService.uploadImage(
        _imageFile!,
        "samples",
      );
      setState(() {
        _uploadedPhotoUrl = response.url;
        _uploadedPhotoId = response.publicId;
        _imageFile = null;
        _isUploadingToCloudinary = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Imagen vinculada con éxito"),
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
            primary: Color(0xFF3E5B42), // Verde Oliva Lumentrack
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
        title: const Text(
          "Lumentrack",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF3E5B42),
        actions: [
          if (!_isNew)
            IconButton(
              icon: Icon(_isEditing ? Icons.cancel : Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                  if (!_isEditing) {
                    _nameController.text = widget.sample?.sampleName ?? '';
                    _estimatedDateController.text =
                        widget.sample?.estimatedDeliveryDate ?? '';
                    _realDateController.text =
                        widget.sample?.realDeliveryDate ?? '';
                    _imageFile = null;
                    _uploadedPhotoUrl = widget.sample?.samplePhotoUrl;
                    _uploadedPhotoId = widget.sample?.samplePhotoId;
                  }
                });
              },
            ),
        ],
      ),
      body: _isLoadingOrders
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF3E5B42)),
                  SizedBox(height: 16),
                  Text(
                    "Cargando datos de la muestra...",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
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
                              : "SUBIR IMAGEN A CLOUDINARY",
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
                      label: "Nombre de la Luminaria",
                      icon: Icons.lightbulb_outline,
                      enabled: _isEditing,
                    ),
                    const SizedBox(height: 15),

                    DropdownButtonFormField<int>(
                      value: _selectedOrderId,
                      disabledHint: Text(
                        _availableOrders.isEmpty
                            ? (widget.sample?.orderName ?? 'Sin Orden')
                            : _availableOrders
                                  .firstWhere(
                                    (o) => o.orderId == _selectedOrderId,
                                    orElse: () => Order(
                                      orderNumber: 0,
                                      orderName:
                                          widget.sample?.orderName ??
                                          'Sin Orden',
                                      clientId: 0,
                                      estimatedDeliveryDate: '',
                                    ),
                                  )
                                  .orderName,
                        style: const TextStyle(color: Colors.black87),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Orden de Producción',
                        prefixIcon: const Icon(
                          Icons.assignment_outlined,
                          color: Color(0xFF3E5B42),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fillColor: Colors.grey[100],
                        filled: !_isNew,
                      ),
                      onChanged: _isNew
                          ? (int? value) =>
                                setState(() => _selectedOrderId = value)
                          : null,
                      validator: (value) =>
                          value == null ? "Debes vincular una orden" : null,
                      items: _availableOrders
                          .map(
                            (o) => DropdownMenuItem(
                              value: o.orderId,
                              child: Text(o.orderName),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 15),

                    _buildTextField(
                      controller: _estimatedDateController,
                      label: "Fecha Estimada de Entrega",
                      icon: Icons.calendar_today,
                      enabled: _isNew,
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

                    _buildTextField(
                      controller: _realDateController,
                      label: "Fecha Real de Entrega",
                      icon: Icons.calendar_month_outlined,
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
                    const SizedBox(height: 30),

                    if (_isEditing)
                      ElevatedButton(
                        onPressed: _processData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF934B3D), // Terracota
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _isNew ? "REGISTRAR MUESTRA" : "GUARDAR CAMBIOS",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),

                    // COMPONENTES ASOCIADOS: Se despliega si la muestra ya está registrada en base de datos
                    if (!_isNew) ...[
                      const Divider(height: 50, thickness: 1.5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Componentes Asignados",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3E5B42),
                                ),
                              ),
                              Text(
                                "Insumos vinculados a esta muestra (${_associatedComponents.length})",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle,
                              color: Color(0xFF3E5B42),
                              size: 32,
                            ),
                            onPressed: () async {
                              final bool? actualizado = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ComponentFormScreen(
                                    sampleId: widget.sample!.sampleId!,
                                  ),
                                ),
                              );
                              if (actualizado == true) {
                                _recargarMuestra();
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      _buildComponentsList(),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildComponentsList() {
    if (_associatedComponents.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: const Column(
          children: [
            Icon(Icons.layers_clear_outlined, color: Colors.grey, size: 40),
            SizedBox(height: 8),
            Text(
              "Sin componentes. Presiona '+' para agregar.",
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _associatedComponents.length,
      itemBuilder: (context, index) {
        final component = _associatedComponents[index];

        // Extracción segura de la URL de foto
        final String photoUrl = component.componentPhotoUrl ?? '';

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          elevation: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: photoUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      photoUrl,
                      width: 55,
                      height: 55,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3E5B42).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.token_outlined,
                      color: Color(0xFF3E5B42),
                    ),
                  ),
            title: Text(
              component.componentName ?? 'Sin nombre',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                "${component.componentType ?? 'General'} • Encargado: ${component.ulaLightEmployee ?? 'Sin asignar'}",
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey,
            ),
            onTap: () async {
              // Navegamos a la pantalla de edición del componente enviando el objeto actual
              final bool? refresh = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ComponentFormScreen(
                    sampleId: widget.sample!.sampleId!,
                    component:
                        component, // Pasamos el componente seleccionado para editarlo
                  ),
                ),
              );

              if (refresh == true) {
                _recargarMuestra(); // Sincronizamos la lista si hubo cambios
              }
            },
          ),
        );
      },
    );
  }

  // Método auxiliar para recargar la información al regresar de un módulo hijo
  Future<void> _recargarMuestra() async {
    if (widget.sample?.sampleId == null) return;
    try {
      // 🟢 USAR EL MISMO MÉTODO QUE EN INITSTATE: Asegura que traiga la lista de componentes
      final sampleActualizada = await _samplesService.fetchSampleWithComponents(
        widget.sample!.sampleId!,
      );
      setState(() {
        _associatedComponents = sampleActualizada.componentList;
      });
    } catch (e) {
      debugPrint("Error al sincronizar componentes de la muestra: $e");
    }
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
                            Icons.broken_image_outlined,
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
                backgroundColor: const Color(0xFF3E5B42),
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
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
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
      final selectedOrderObj = _availableOrders.firstWhere(
        (o) => o.orderId == _selectedOrderId,
      );

      final sampleData = Sample(
        sampleId: widget.sample?.sampleId,
        sampleName: _nameController.text,
        orderId: _selectedOrderId!,
        orderName: selectedOrderObj.orderName,
        samplePhotoUrl: _uploadedPhotoUrl ?? '',
        samplePhotoId: _uploadedPhotoId ?? '',
        estimatedDeliveryDate:
            Sample.formatToServer(_estimatedDateController.text) ?? '',
        realDeliveryDate: _realDateController.text.isNotEmpty
            ? (Sample.formatToServer(_realDateController.text) ?? '')
            : 'Sin fecha',
        componentList:
            _associatedComponents, // Preservamos el estado reactivo actual
      );

      if (_isNew) {
        await _samplesService.createSample(sampleData);
      } else {
        await _samplesService.updateSample(sampleData);
      }

      Navigator.pop(context);
      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isNew
                ? "Muestra registrada con éxito"
                : "Cambios guardados con éxito",
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error en la petición: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
