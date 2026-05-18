import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dashboard_model.dart';

class ApiServices {
  // IP para emulador Android. Si usas celular físico, usa tu IP 192.168.x.x
  static const String _baseIp = "10.0.2.2";

  // Dashboard - Puerto 8081
  Future<DashboardData> fetchDashboard() async {
    final response = await http.get(
      Uri.parse("http://$_baseIp:8081/lumentrack/dashboard"),
    );
    if (response.statusCode == 200) {
      return DashboardData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error en Dashboard (8081)');
    }
  }

  // Muestras - Puerto 8082
  Future<List<dynamic>> fetchMuestras() async {
    final response = await http.get(
      Uri.parse("http://$_baseIp:8082/lumentrack/muestras"),
    );
    if (response.statusCode == 200) return json.decode(response.body);
    throw Exception('Error en Muestras (8082)');
  }

  // Producción - Puerto 8083
  Future<List<dynamic>> fetchProduccion() async {
    final response = await http.get(
      Uri.parse("http://$_baseIp:8083/lumentrack/produccion"),
    );
    if (response.statusCode == 200) return json.decode(response.body);
    throw Exception('Error en Producción (8083)');
  }
}
