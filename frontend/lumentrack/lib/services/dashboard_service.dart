import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dashboard_model.dart';
import '../core/api_config.dart';

class DashboardService {
  // Endpoint para datos generales del dashboard
  final String _generalDashboardUrl = ApiConfig.dashboard;
  // Endpoint para datos del dashboard filtrados por usuario
  final String _userFilteredDashboardUrl = ApiConfig.dashboardUserFiltered;

  final Map<String, String> _headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  Future<DashboardData> fetchDashboardData() async {
    print("DEBUG: Enviando petición GET al Dashboard: $_generalDashboardUrl");
    final response = await http.get(
      Uri.parse(_generalDashboardUrl),
      headers: _headers,
    );

    print(
      "DEBUG: Respuesta del Dashboard [Status ${response.statusCode}]: ${response.body}",
    );

    if (response.statusCode == 200) {
      return DashboardData.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)),
      );
    } else {
      throw Exception('Fallo al cargar el dashboard general');
    }
  }

  Future<DashboardData> fetchDashboardDataForUser(int userId) async {
    final url = '$_userFilteredDashboardUrl/$userId';
    print(
      "DEBUG: Enviando petición GET al Dashboard filtrado por usuario: $url",
    );
    final response = await http.get(Uri.parse(url), headers: _headers);

    print(
      "DEBUG: Respuesta del Dashboard filtrado [Status ${response.statusCode}]: ${response.body}",
    );

    if (response.statusCode == 200) {
      return DashboardData.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)),
      );
    } else {
      throw Exception('Fallo al cargar el dashboard para el usuario $userId');
    }
  }
}
