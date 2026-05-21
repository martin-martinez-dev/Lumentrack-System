import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/client_model.dart';
import '../core/api_config.dart';

class ClientService {
  // Asumiendo que ApiConfig.clientsEndpoint apunta a http://<tu-ip>:808X/clients
  static const String _baseUrl = ApiConfig.clients;

  final Map<String, String> _headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  /// Mapea a: retrieveAllClients() -> GET /clients/list
  Future<List<Client>> fetchClients() async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/list"),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Client.fromJson(item)).toList();
      } else {
        throw Exception(
          'Error al cargar catálogo de clientes: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de red al listar clientes: $e');
    }
  }
}
