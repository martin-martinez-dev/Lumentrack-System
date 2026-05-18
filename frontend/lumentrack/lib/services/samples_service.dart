import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/samples_model.dart';
import '../models/samples_view_model.dart';

class SamplesService {
  // Ajustamos la URL base a la nueva estructura del controlador
  //static const String _baseUrl =
  //    "http://10.0.2.2:8082/lumentrack/samples/samples";
  static const String _baseUrl =
      "http://192.168.100.15:8082/lumentrack/samples/samples";

  // 1. LISTAR (GET)
  Future<List<Sample>> fetchSamples() async {
    final response = await http.get(Uri.parse("$_baseUrl/list"));
    if (response.statusCode == 200) {
      try {
        List<dynamic> body = json.decode(response.body);
        print("JSON recibido: $body"); // Paso 1: Ver qué llega
        return body.map((item) => Sample.fromJson(item)).toList();
      } catch (e) {
        print(
          "ERROR EN EL MAPEO: $e",
        ); // Aquí verás el "type 'String' is not a subtype of 'int'"
        rethrow;
      }
    }
    throw Exception('Error de servidor');
  }

  // 2. BUSCAR POR ID (GET)
  Future<Sample> getSampleById(int id) async {
    final response = await http.get(Uri.parse("$_baseUrl/search/$id"));
    if (response.statusCode == 200) {
      return Sample.fromJson(json.decode(response.body));
    }
    throw Exception('Sample con ID $id no encontrado');
  }

  // 3. GUARDAR (POST)
  Future<void> createSample(SampleView sample) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/save"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(sample.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Fallo al registrar Sample en la base de datos');
    }
  }

  // 4. ACTUALIZAR (PUT/POST según tu backend)
  Future<void> updateSample(SampleView sample) async {
    final response = await http.post(
      // O http.put si tu backend lo requiere
      Uri.parse("$_baseUrl/update"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(sample.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Fallo al actualizar Sample');
    }
  }

  // 5. BORRAR (DELETE)
  Future<void> deleteSample(int id) async {
    final response = await http.delete(Uri.parse("$_baseUrl/delete/$id"));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Fallo al eliminar Sample con ID $id');
    }
  }

  Future<List<SampleView>> fetchSampleDetails() async {
    final response = await http.get(Uri.parse("$_baseUrl/getSamples"));
    if (response.statusCode == 200) {
      try {
        List<dynamic> body = json.decode(response.body);
        print("JSON recibido: $body");
        return body.map((item) => SampleView.fromJson(item)).toList();
      } catch (e) {
        print(
          "ERROR EN EL MAPEO: $e",
        ); // Aquí verás el "type 'String' is not a subtype of 'int'"
        rethrow;
      }
    }
    throw Exception('Error de servidor');
  }
}
