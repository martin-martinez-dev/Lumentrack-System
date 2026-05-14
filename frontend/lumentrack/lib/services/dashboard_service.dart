import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dashboard_model.dart';

class DashboardService {
  //final String baseUrl =
  //    "http://10.0.2.2:8081/lumentrack/dashboard/getData"; // endpoint para
  final String baseUrl =
      "http://192.168.100.15:8081/lumentrack/dashboard/getData"; // Ajusta tu endpoint

  Future<DashboardData> fetchDashboardData() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return DashboardData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Fallo al cargar el dashboard');
    }
  }
}
