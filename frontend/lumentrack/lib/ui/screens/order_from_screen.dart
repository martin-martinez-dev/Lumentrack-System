import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/orders_model.dart';
import '../../services/orders_service.dart';

class OrderFormScreen extends StatefulWidget {
  final Order?
  order; // Al igual que en muestras, si viene null es una "Alta Nueva"

  const OrderFormScreen({super.key, this.order});

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final OrdersService _ordersService = OrdersService();

  // Controllers para los campos editables del Proyecto
  late TextEditingController _nameController;
  late TextEditingController _numberController;
  late TextEditingController _clientController;
  late TextEditingController _estimatedDateController;

  bool _isEditing = false;
  bool _isNew = false;

  @override
  void initState() {
    super.initState();
    _isNew = widget.order == null;
    _isEditing = _isNew; // Si es nuevo proyecto, entra editable por defecto

    // Inicialización limpia de los campos de la Orden
    _nameController = TextEditingController(
      text: widget.order?.orderName ?? '',
    );
    _numberController = TextEditingController(
      text: widget.order != null ? widget.order!.orderNumber.toString() : '',
    );
    _clientController = TextEditingController(
      text: widget.order != null ? widget.order!.clientId.toString() : '',
    );
    _estimatedDateController = TextEditingController(
      text: widget.order?.estimatedDeliveryDate ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _clientController.dispose();
    _estimatedDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF3E5B42), // Verde Lumentrack
            onPrimary: Colors.white,
            onSurface: Colors.black87,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _estimatedDateController.text = DateFormat('yyyy-MM-dd').format(picked);
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
          if (!_isNew) // Si es un proyecto existente, mostramos el botón de Editar/Cancelar
            IconButton(
              icon: Icon(_isEditing ? Icons.cancel : Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                  if (!_isEditing) {
                    // Si cancela, restauramos los valores originales de la Orden
                    _nameController.text = widget.order?.orderName ?? '';
                    _numberController.text =
                        widget.order?.orderNumber.toString() ?? '';
                    _clientController.text =
                        widget.order?.clientId.toString() ?? '';
                    _estimatedDateController.text =
                        widget.order?.estimatedDeliveryDate ?? '';
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
            children: [
              _buildTextField(
                controller: _nameController,
                label: "Nombre del Proyecto / Orden",
                icon: Icons.inventory_2_outlined,
                enabled: _isEditing,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _numberController,
                label: "Número de Orden",
                icon: Icons.tag,
                enabled: _isEditing,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _clientController,
                label: "ID del Cliente",
                icon: Icons.business,
                enabled: _isEditing,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),

              // Campo de fecha con la propiedad readOnly nativa (A prueba de cuelgues)
              _buildTextField(
                controller: _estimatedDateController,
                label: "Fecha Estimada de Entrega",
                icon: Icons.calendar_today,
                enabled: _isEditing,
                readOnly: true,
                onTap: _isEditing ? () => _selectDate(context) : null,
              ),
              const SizedBox(height: 40),

              // 🟢 NOTA DE AISLAMIENTO: Las muestras ("sampleList") no se dibujan aquí.
              // Quedan intactas en el objeto pero ocultas al usuario en esta vista.
              if (_isEditing)
                ElevatedButton(
                  onPressed: _procesarEnvio,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF934B3D), // Terracota
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _isNew ? "REGISTRAR PROYECTO" : "GUARDAR CAMBIOS",
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool enabled,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF3E5B42)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: !enabled,
        fillColor: enabled ? Colors.white : Colors.grey[100],
      ),
      validator: (value) =>
          (value == null || value.isEmpty) ? "Este campo es obligatorio" : null,
    );
  }

  void _procesarEnvio() async {
    if (!_formKey.currentState!.validate()) return;

    // Mostrar spinner de carga de forma asíncrona
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF3E5B42)),
      ),
    );

    try {
      // 🟢 CLAVE DE PROTECCIÓN: Construimos el objeto preservando las muestras originales
      // para que al actualizar la Orden en el backend no se rompa la relación.
      final orderData = Order(
        orderId: widget.order?.orderId,
        orderName: _nameController.text,
        orderNumber: int.parse(_numberController.text),
        clientId: int.parse(_clientController.text),
        estimatedDeliveryDate: _estimatedDateController.text,
        realDeliveryDate:
            widget.order?.realDeliveryDate, // Se mantiene el valor actual
        sampleList:
            widget.order?.sampleList ??
            [], // 🟢 ¡Aquí se cuida y preserva el listado!
      );

      if (_isNew) {
        await _ordersService.createOrder(
          orderData,
        ); // Tu servicio POST para el puerto 8083
      } else {
        await _ordersService.updateOrder(
          orderData,
        ); // Tu servicio PUT para el puerto 8083
      }

      Navigator.pop(context); // Quita el spinner
      Navigator.pop(
        context,
        true,
      ); // Regresa al listado y avisa que hubo cambios para refrescar la pantalla

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isNew
                ? "Proyecto registrado con éxito"
                : "Cambios guardados con éxito",
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Quita el spinner en caso de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al procesar el proyecto: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
