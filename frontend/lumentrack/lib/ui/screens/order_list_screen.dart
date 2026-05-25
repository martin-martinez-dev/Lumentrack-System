import 'package:flutter/material.dart';
import '../../models/orders_model.dart';
import '../../services/orders_service.dart';
import 'order_detail_screen.dart';

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  final OrdersService _ordersService = OrdersService();
  late Future<List<Order>> _futureOrders;

  @override
  void initState() {
    super.initState();
    _cargarProyectos();
  }

  void _cargarProyectos() {
    setState(() {
      _futureOrders = _ordersService.fetchOrders();
    });
  }

  // 🟢 Método centralizado de navegación para cuidar los refrescos automáticos
  void _navegarAProyecto({int? id}) async {
    final seActualizo = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        // Si 'id' es null, viaja como null y la pantalla unificada se abrirá en modo "Alta Nueva"
        builder: (context) => OrderDetailScreen(orderId: id),
      ),
    );

    // Si la pantalla de detalle/edición retorna un 'true', refrescamos los datos de Spring Boot
    if (seActualizo == true) {
      _cargarProyectos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Proyectos",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF934B3D),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Order>>(
        future: _futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF3E5B42)),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Error al cargar los proyectos",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      "${snapshot.error}",
                      style: const TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _cargarProyectos,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E5B42),
                    ),
                    child: const Text(
                      "Reintentar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No hay proyectos registrados.",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          final proyectos = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async => _cargarProyectos(),
            color: const Color(0xFF934B3D),
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: proyectos.length,
              itemBuilder: (context, index) {
                final proyecto = proyectos[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF3E5B42),
                      child: Icon(Icons.folder_open, color: Colors.white),
                    ),
                    title: Text(
                      proyecto.orderName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      key: ValueKey(proyecto.orderId),
                      child: Text("ID Orden: # ${proyecto.orderNumber}"),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color(0xFF3E5B42),
                    ),
                    onTap: () => _navegarAProyecto(
                      id: proyecto.orderId,
                    ), // 🟢 Navegación segura controlada
                  ),
                );
              },
            ),
          );
        },
      ),

      // 🟢 EL NUEVO BOTÓN SOLICITADO PARA CREAR REGISTROS
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF934B3D),
        tooltip: "Añadir Proyecto",
        onPressed: () =>
            _navegarAProyecto(), // 🟢 Se invoca sin ID para que entre como "Alta Nueva"
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
