class DashboardData {
  final int sampleCount;
  final int ordersCount;
  final int tasksCount;
  final List<String> samplesList;
  final List<String> ordersList;
  final List<String> tasksList;

  DashboardData({
    required this.sampleCount,
    required this.ordersCount,
    required this.tasksCount,
    required this.samplesList,
    required this.ordersList,
    required this.tasksList,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      sampleCount: json['sampleCount'] ?? 0,
      ordersCount: json['ordersCount'] ?? 0,
      tasksCount: json['tasksCount'] ?? 0,
      // Mapeamos las listas de objetos a solo los nombres para las listas colapsables
      samplesList: (json['samplesList'] as List)
          .map((e) => e['sampleName'] as String)
          .toList(),
      ordersList: (json['ordersList'] as List)
          .map((e) => e['orderName'] as String)
          .toList(),
      tasksList: (json['tasksList'] as List)
          .map((e) => e['taskName'] as String)
          .toList(),
    );
  }
}
