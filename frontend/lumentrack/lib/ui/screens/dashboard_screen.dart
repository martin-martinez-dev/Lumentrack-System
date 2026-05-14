import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '/models/dashboard_model.dart';
import '/services/dashboard_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  // Definimos el Future que traerá los datos del backend
  late Future<DashboardData> _futureDashboard;
  final DashboardService _service = DashboardService();

  @override
  void initState() {
    super.initState();
    // Iniciamos la petición al backend al cargar la pantalla
    _futureDashboard = _service.fetchDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lumentrack',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      // Usamos FutureBuilder para manejar los estados: Carga, Error o Éxito
      body: FutureBuilder<DashboardData>(
        future: _futureDashboard,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No se encontraron datos'));
          }

          // Si llegamos aquí, tenemos datos exitosos en snapshot.data
          final data = snapshot.data!;

          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Panel de Control',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 1. Cuadros de resumen con datos del servicio
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryCard(
                          "Muestras",
                          "${data.sampleCount}",
                          const Color(0xFF934B3D),
                        ),
                        _buildSummaryCard(
                          "Producción",
                          "${data.ordersCount}",
                          const Color(0xFF3E5B42),
                        ),
                        _buildSummaryCard(
                          "Tareas",
                          "${data.tasksCount}",
                          const Color(0xFFD9B44A),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // 2. Gráfica de Pay (se actualiza con valores reales)
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: data.sampleCount.toDouble(),
                              color: const Color(0xFF934B3D),
                              radius: 50,
                              title: '${data.sampleCount}',
                            ),
                            PieChartSectionData(
                              value: data.ordersCount.toDouble(),
                              color: const Color(0xFF3E5B42),
                              radius: 50,
                              title: '${data.ordersCount}',
                            ),
                            PieChartSectionData(
                              value: data.tasksCount.toDouble(),
                              color: const Color(0xFFD9B44A),
                              radius: 50,
                              title: '${data.tasksCount}',
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    const Divider(),

                    // 3. Listas Colapsables con nombres del backend
                    _buildCollapsibleList(
                      "Muestras",
                      data.samplesList,
                      Icons.lightbulb_outline,
                    ),
                    _buildCollapsibleList(
                      "Producción",
                      data.ordersList,
                      Icons.inventory_2_outlined,
                    ),
                    _buildCollapsibleList(
                      "Tareas",
                      data.tasksList,
                      Icons.grid_view_rounded,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'Muestras',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Producción',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Admin',
          ),
        ],
      ),
    );
  }

  // Métodos auxiliares de diseño (se mantienen igual pero reciben datos dinámicos)
  Widget _buildSummaryCard(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 12)),
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsibleList(
    String title,
    List<String> items,
    IconData icon,
  ) {
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(title),
      children: items.isEmpty
          ? [const ListTile(title: Text("Sin elementos"))]
          : items
                .map(
                  (item) => ListTile(
                    title: Text(item),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                )
                .toList(),
    );
  }
}
