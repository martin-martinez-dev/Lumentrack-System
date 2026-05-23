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

  /// 1. Obtener todos los clientes (GET /clients/list)
  Future<List<Client>> fetchClients() async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/list"),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
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

  /// 2. Guardar un nuevo cliente (POST /clients/save)
  Future<Client> saveClient(Client client) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/save"),
        headers: _headers,
        body: jsonEncode(client.toJson()),
      );

      if (response.statusCode == 201) {
        return Client.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Error al guardar cliente: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de red al guardar cliente: $e');
    }
  }

  /// 3. Buscar cliente por ID (GET /clients/search/{id})
  Future<Client?> searchClientById(int id) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/search/$id"),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return Client.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Error al buscar cliente: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de red al buscar cliente: $e');
    }
  }

  /// 4. Actualizar cliente (POST /clients/update)
  Future<Client> updateClient(Client client) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/update"),
        headers: _headers,
        body: jsonEncode(client.toJson()),
      );

      if (response.statusCode == 200) {
        return Client.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Error al actualizar cliente: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de red al actualizar cliente: $e');
    }
  }

  /// 5. Eliminar cliente (DELETE /clients/delete/{id})
  Future<void> deleteClient(int id) async {
    try {
      final response = await http.delete(
        Uri.parse("$_baseUrl/delete/$id"),
        headers: _headers,
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Error al eliminar cliente: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de red al eliminar cliente: $e');
    }
  }
}
