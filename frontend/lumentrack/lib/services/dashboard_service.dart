import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dashboard_model.dart';
import '../core/api_config.dart';

class DashboardService {
  //Escritorio
  final String baseUrl = ApiConfig.dashboard;

  Future<DashboardData> fetchDashboardData() async {
    print("DEBUG: Enviando petición GET al Dashboard: $baseUrl");
    final response = await http.get(Uri.parse(baseUrl));

    print(
      "DEBUG: Respuesta del Dashboard [Status ${response.statusCode}]: ${response.body}",
    );

    if (response.statusCode == 200) {
      return DashboardData.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)),
      );
    } else {
      throw Exception('Fallo al cargar el dashboard');
    }
  }
}
