import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/samples_view_model.dart';
import '../../models/orders_model.dart';
import '../../services/samples_service.dart';
import '../../services/orders_service.dart'; // <--- Importamos tu servicio de órdenes

class SampleFormScreen extends StatefulWidget {
  final SampleView? sample;

  const SampleFormScreen({super.key, this.sample});

  @override
  State<SampleFormScreen> createState() => _SampleFormScreenState();
}

class _SampleFormScreenState extends State<SampleFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Inyección de ambos servicios independientes
  final SamplesService _samplesService = SamplesService();
  final OrdersService _ordersService = OrdersService(); // <--- Instanciado aquí

  // Controladores para los campos de texto
  late TextEditingController _nameController;
  late TextEditingController _dateController;

  // Variables para el control del ComboBox de Órdenes
  int? _selectedOrderId;
  List<Order> _availableOrders = [];
  bool _isLoadingOrders = true;

  // Variables de control de estado de la UI
  bool _isEditing = false;
  bool _isNew = false;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _isNew = widget.sample == null;
    _isEditing = _isNew;

    _nameController = TextEditingController(
      text: widget.sample?.sampleName ?? '',
    );
    _dateController = TextEditingController(
      text: widget.sample?.estimatedDeliveryDate ?? '',
    );

    if (!_isNew) {
      _selectedOrderId = widget.sample?.orderId;
    }

    // Cargamos el catálogo usando el servicio correcto
    _loadOrdersCatalog();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // Carga inicial utilizando OrdersService
  Future<void> _loadOrdersCatalog() async {
    try {
      // Usamos el servicio de órdenes para traer el listado desde el controlador de Java
      final orders = await _ordersService.fetchOrders();
      setState(() {
        _availableOrders = orders;
        _isLoadingOrders = false;
      });
    } catch (e) {
      setState(() => _isLoadingOrders = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al cargar catálogo de órdenes: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _takePicture() async {
    if (!_isEditing) return;

    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1000,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    _dateController.text =
                        widget.sample?.estimatedDeliveryDate ?? '';
                    _imageFile = null;
                  }
                });
              },
            ),
        ],
      ),
      body: _isLoadingOrders
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildPhotoSection(),
                    const SizedBox(height: 30),

                    _buildTextField(
                      controller: _nameController,
                      label: "Nombre de la Luminaria",
                      icon: Icons.lightbulb_outline,
                    ),
                    const SizedBox(height: 15),

                    // COMBO BOX: ÓRDENES DE PRODUCCIÓN
                    DropdownButtonFormField<int>(
                      value: _selectedOrderId,
                      disabledHint: Text(
                        _availableOrders
                            .firstWhere(
                              (o) => o.orderId == _selectedOrderId,
                              orElse: () => Order(
                                orderNumber: 0,
                                orderName:
                                    widget.sample?.orderName ?? 'Sin Orden',
                                clientId: 0,
                                estimatedDeliveryDate: '',
                              ),
                            )
                            .orderName,
                        style: const TextStyle(color: Colors.black87),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Orden de Production',
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
                      onChanged: (_isNew && _isEditing)
                          ? (int? newValue) {
                              setState(() {
                                _selectedOrderId = newValue;
                              });
                            }
                          : null,
                      validator: (value) =>
                          value == null ? "Debes seleccionar una orden" : null,
                      items: _availableOrders.map<DropdownMenuItem<int>>((
                        Order order,
                      ) {
                        return DropdownMenuItem<int>(
                          value: order.orderId,
                          child: Text(order.orderName),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 15),

                    _buildTextField(
                      controller: _dateController,
                      label: "Fecha de Entrega (yyyy-MM-dd HH:mm:ss)",
                      icon: Icons.calendar_today,
                    ),

                    const SizedBox(height: 40),

                    if (_isEditing)
                      ElevatedButton(
                        onPressed: _processData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF934B3D),
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
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPhotoSection() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: _imageFile != null
                ? Image.file(_imageFile!, fit: BoxFit.cover)
                : (widget.sample?.samplePhotoUrl.isNotEmpty ?? false
                      ? Image.network(
                          widget.sample!.samplePhotoUrl,
                          fit: BoxFit.cover,
                        )
                      : const Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 80,
                            color: Colors.grey,
                          ),
                        )),
          ),
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      enabled: _isEditing,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF3E5B42)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: !_isEditing,
        fillColor: Colors.grey[100],
      ),
      validator: (value) => value!.isEmpty ? "Este campo es obligatorio" : null,
    );
  }

  // Persistencia utilizando SamplesService
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

      final sampleData = SampleView(
        sampleId: widget.sample?.sampleId,
        sampleName: _nameController.text,
        orderId: _selectedOrderId!,
        orderName: selectedOrderObj.orderName,
        samplePhotoUrl: widget.sample?.samplePhotoUrl ?? '',
        samplePhotoId: widget.sample?.samplePhotoId ?? '',

        //Se convierte el formato de fecha
        estimatedDeliveryDate:
            SampleView.formatToServer(_dateController.text) ?? '',
        realDeliveryDate:
            SampleView.formatToServer(
              widget.sample?.realDeliveryDate ?? 'Sin fecha',
            ) ??
            '',
      );

      print("=== ENVIANDO DATOS AL BACKEND ===");
      print("Modo: ${_isNew ? 'NUEVO' : 'EDICIÓN (UPDATE)'}");
      print("JSON a enviar: ${sampleData.toJson()}");

      if (_isNew) {
        // El guardado sigue perteneciendo al microservicio de muestras
        await _samplesService.createSample(sampleData);
      } else {
        await _samplesService.updateSample(sampleData);
      }

      print("=== PETICIÓN COMPLETADA CON ÉXITO ===");

      Navigator.pop(context);
      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isNew ? "Muestra registrada con éxito" : "Cambios guardados",
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error de comunicación: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
