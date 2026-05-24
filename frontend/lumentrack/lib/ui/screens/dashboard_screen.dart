import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/dashboard_model.dart';
import '../../services/dashboard_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardService _service = DashboardService();
  late Future<DashboardData> _futureDashboard;

  @override
  void initState() {
    super.initState();
    _futureDashboard = _service.fetchDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    // Eliminamos Scaffold/AppBar aquí para que use el del MainWrapper
    return FutureBuilder<DashboardData>(
      future: _futureDashboard,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error de conexión al puerto 8081'));
        }

        final data = snapshot.data!;

        return RefreshIndicator(
          color: const Color(0xFF934B3D),
          onRefresh: () async {
            setState(() {
              _futureDashboard = _service.fetchDashboardData();
            });
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Panel de Control',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Tarjetas de Resumen
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryCard(
                      "Proyectos",
                      "${data.ordersCount}",
                      const Color(0xFF934B3D),
                    ),
                    _buildSummaryCard(
                      "Muestras",
                      "${data.sampleCount}",
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

                // Gráfica de Pay
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: data.ordersCount.toDouble(),
                          color: const Color(0xFF934B3D),
                          title: '${data.ordersCount}',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          value: data.sampleCount.toDouble(),
                          color: const Color(0xFF3E5B42),
                          title: '${data.sampleCount}',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          value: data.tasksCount.toDouble(),
                          color: const Color(0xFFD9B44A),
                          title: '${data.tasksCount}',
                          radius: 50,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                const Divider(),

                // Listas Colapsables
                _buildCollapsibleList(
                  "Proyectos",
                  data.ordersList,
                  Icons.inventory_2_outlined,
                  const Color(0xFF934B3D),
                ),
                _buildCollapsibleList(
                  "Muestras",
                  data.samplesList,
                  Icons.lightbulb_outline,
                  const Color(0xFF3E5B42),
                ),
                _buildCollapsibleList(
                  "Tareas",
                  data.tasksList,
                  Icons.grid_view_rounded,
                  const Color(0xFFD9B44A),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Métodos _buildSummaryCard y _buildCollapsibleList se mantienen iguales...
  Widget _buildSummaryCard(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(8),
        color: color.withValues(alpha: 0.05),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          Text(
            count,
            style: TextStyle(
              fontSize: 22,
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
    Color color,
  ) {
    return ExpansionTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      children: items.isEmpty
          ? [const ListTile(title: Text("Sin elementos pendientes"))]
          : items
                .map(
                  (item) => ListTile(
                    title: Text(item),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                  ),
                )
                .toList(),
    );
  }
}
