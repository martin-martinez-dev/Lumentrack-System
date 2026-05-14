import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/sample_model.dart';

class ApiService {
  // IMPORTANTE:
  // Si usas el emulador de Android, usa 10.0.2.2 en lugar de localhost.
  // Si usas un celular físico, usa la IP de tu PC (ej. 192.168.1.50).
  final String baseUrl = "http://10.0.2.2";

  //Get a Sample by its ID
  Future<Sample> buscarSample(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/searchSample/$id'));

    if (response.statusCode == 200) {
      return Sample.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception("No se encontró el registro");
    } else {
      throw Exception("Error al conectar con el servidor");
    }
  }

  //Save a sample
}
