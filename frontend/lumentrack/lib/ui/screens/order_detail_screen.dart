import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/orders_model.dart';
import '../../models/client_model.dart'; // 🟢 Importamos el nuevo modelo
import '../../services/orders_service.dart';
import '../../services/client_service.dart'; // 🟢 Importamos el nuevo servicio
import 'sample_form_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  final int? orderId;

  const OrderDetailScreen({super.key, this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final OrdersService _ordersService = OrdersService();
  final ClientService _clientService =
      ClientService(); // 🟢 Instanciamos servicio de clientes

  Order? _currentOrder;
  List<Client> _clientsList = []; // 🟢 Almacén del catálogo de clientes
  int? _selectedClientId; // 🟢 ID seleccionado en el ComboBox

  bool _isLoading = true;
  bool _isEditing = false;
  bool _isNew = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _estimatedDateController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _isNew = widget.orderId == null;
    _isEditing = _isNew;

    _inicializarPantalla();
  }

  Future<void> _inicializarPantalla() async {
    try {
      // 1. Cargamos el catálogo de clientes siempre (lo necesitaremos para el combo)
      _clientsList = await _clientService.fetchClients();

      if (!_isNew) {
        // 2. Si es edición/lectura, cargamos el proyecto
        final order = await _ordersService.fetchOrderDetails(widget.orderId!);
        _currentOrder = order;
        _nameController.text = order.orderName;
        _numberController.text = order.orderNumber.toString();
        _estimatedDateController.text = order.estimatedDeliveryDate;
        _selectedClientId =
            order.clientId; // Seteamos el ID actual de la base de datos
      }

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error de inicialización: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // (Conserva tus métodos de _selectDate y dispose igual...)
  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _estimatedDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _estimatedDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF3E5B42)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isNew
              ? "Nuevo Proyecto"
              : (_isEditing ? "Editar Proyecto" : _nameController.text),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF3E5B42),
        actions: [
          if (!_isNew)
            IconButton(
              icon: Icon(_isEditing ? Icons.cancel_outlined : Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                  if (!_isEditing) {
                    _nameController.text = _currentOrder?.orderName ?? '';
                    _numberController.text =
                        _currentOrder?.orderNumber.toString() ?? '';
                    _estimatedDateController.text =
                        _currentOrder?.estimatedDeliveryDate ?? '';
                    _selectedClientId =
                        _currentOrder?.clientId; // Restaurar combo
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
              const Text(
                "Datos de la Orden de Producción",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E5B42),
                ),
              ),
              const SizedBox(height: 15),

              _buildTextField(
                controller: _nameController,
                label: "Nombre del Proyecto",
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

              // 🟢 EL COMBOBOX SOLICITADO: Muestra nombres pero controla IDs nulos/enteros
              DropdownButtonFormField<int>(
                value: _selectedClientId,
                //enabled: _isEditing,
                decoration: InputDecoration(
                  labelText: "Cliente Asignado",
                  prefixIcon: const Icon(
                    Icons.business,
                    color: Color(0xFF3E5B42),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: !_isEditing,
                  fillColor: _isEditing ? Colors.white : Colors.grey[100],
                ),
                // Transformamos la lista de objetos Client a DropdownMenuItems
                items: _clientsList.map((Client client) {
                  return DropdownMenuItem<int>(
                    value: client.clientId,
                    child: Text(client.clientName),
                  );
                }).toList(),
                onChanged: _isEditing
                    ? (int? newValue) {
                        setState(() {
                          _selectedClientId = newValue;
                        });
                      }
                    : null,
                validator: (value) =>
                    value == null ? "Por favor selecciona un cliente" : null,
              ),
              const SizedBox(height: 15),

              _buildTextField(
                controller: _estimatedDateController,
                label: "Fecha Estimada de Entrega",
                icon: Icons.calendar_today,
                enabled: _isEditing,
                readOnly: true,
                onTap: _isEditing ? () => _selectDate(context) : null,
              ),
              const SizedBox(height: 30),

              if (_isEditing)
                ElevatedButton(
                  onPressed: _procesarEnvio,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF934B3D),
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
                )
              else ...[
                const Text(
                  "Muestras de Luminarias Asignadas",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E5B42),
                  ),
                ),
                const SizedBox(height: 12),
                _currentOrder == null || _currentOrder!.sampleList.isEmpty
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        child: const Center(
                          child: Text(
                            "Este proyecto no cuenta con muestras registradas.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _currentOrder!.sampleList.length,
                        itemBuilder: (context, index) {
                          final sample = _currentOrder!.sampleList[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              leading: const Icon(
                                Icons.lightbulb,
                                color: Color(0xFF934B3D),
                              ),
                              title: Text(
                                sample.sampleName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "Estado Real: ${sample.realDeliveryDate ?? 'Pendiente'}",
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: Colors.grey,
                              ),
                              onTap: () async {
                                // Navegamos a tu pantalla real pasándole la muestra actual en el parámetro 'sample'
                                final seActualizoMuestra =
                                    await Navigator.push<bool>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SampleFormScreen(sample: sample),
                                      ),
                                    );

                                // Si el usuario guardó cambios dentro de SampleFormScreen, refrescamos el detalle de la orden
                                if (seActualizoMuestra == true) {
                                  _inicializarPantalla(); // Invoca tu método actual que vuelve a pedir la orden a Spring Boot
                                }
                              },
                            ),
                          );
                        },
                      ),
              ],
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
      validator: (v) =>
          (v == null || v.isEmpty) ? "Este campo es obligatorio" : null,
    );
  }

  void _procesarEnvio() async {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF3E5B42)),
      ),
    );

    try {
      // Obtenemos el nombre del cliente de la lista para guardarlo localmente si es necesario
      final selectedClient = _clientsList.firstWhere(
        (c) => c.clientId == _selectedClientId,
      );

      final orderData = Order(
        orderId: _currentOrder?.orderId,
        orderName: _nameController.text,
        orderNumber: int.parse(_numberController.text),
        clientId:
            _selectedClientId!, // Obligatorio y controlado por el Dropdown
        clientName: null, // 🔥 Totalmente válido ahora que es 'String?'
        estimatedDeliveryDate: _estimatedDateController.text,
      );

      if (_isNew) {
        await _ordersService.createOrder(orderData);
      } else {
        await _ordersService.updateOrder(orderData);
      }

      Navigator.pop(context); // Quitar spinner
      Navigator.pop(context, true); // Regresar a la lista

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isNew
                ? "Proyecto creado con éxito"
                : "Cambios guardados con éxito",
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Quitar spinner
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al procesar: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
