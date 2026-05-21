import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dashboard_model.dart';
import '../core/api_config.dart';

class DashboardService {
  //Escritorio
  final String baseUrl = ApiConfig.dashboard;

  Future<DashboardData> fetchDashboardData() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return DashboardData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Fallo al cargar el dashboard');
    }
  }
}
