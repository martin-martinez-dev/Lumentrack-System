import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/samples_model.dart'; // Importa el modelo de arriba
import '../core/api_config.dart';

class SamplesService {
  // Conectado a la URL base centralizada (ej: http://localhost:8082/samples)
  static const String _baseUrl = ApiConfig.samples;

  final Map<String, String> _headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  // 1. LISTAR ENTIDADES PURAS (GET /samples/list)
  Future<List<Sample>> fetchSamples() async {
    final response = await http.get(
      Uri.parse("$_baseUrl/list"),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((item) => Sample.fromJson(item)).toList();
    }
    throw Exception('Error del servidor al listar muestras base');
  }

  // 2. BUSCAR POR ID (GET /samples/search/{id})
  Future<Sample> getSampleById(int id) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/search/$id"),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return Sample.fromJson(json.decode(response.body));
    }
    throw Exception('Sample con ID $id no encontrado');
  }

  // 3. GUARDAR NUEVO MODELO (POST /samples/save)
  // Envía el DTO (SampleView) que el @RequestBody SampleViewModel de Java espera
  Future<void> createSample(Sample sample) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/save"),
      headers: _headers,
      body: json.encode(sample.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Fallo al registrar Sample en la base de datos');
    }
  }

  // 4. ACTUALIZAR (POST /samples/update)
  // 🟢 CORREGIDO: Tu controlador recibe un '@RequestBody Samples sample'.
  // Debemos mandar la estructura original 'Sample', no el DTO parcial de la UI.
  Future<void> updateSample(Sample sample) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/update"),
      headers: _headers,
      body: json.encode(sample.toJson()), // Usamos la entidad pura
    );
    if (response.statusCode != 200) {
      throw Exception('Fallo al actualizar Sample');
    }
  }

  // 5. BORRAR (DELETE /samples/delete/{id})
  Future<void> deleteSample(int id) async {
    final response = await http.delete(
      Uri.parse("$_baseUrl/delete/$id"),
      headers: _headers,
    );
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Fallo al eliminar Sample con ID $id');
    }
  }

  // 6. LISTAR MODELOS DETALLADOS (GET /samples/getSamplesDetailsList)
  // 🟢 CORREGIDO: Mapeado al endpoint real del controlador de Spring Boot
  Future<List<Sample>> fetchSampleDetails() async {
    final response = await http.get(
      Uri.parse("$_baseUrl/getSamplesDetailsList"),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((item) => Sample.fromJson(item)).toList();
    }
    throw Exception('Error de servidor al cargar detalles de muestras');
  }

  // 7. NUEVO: OBTENER MUESTRA CON COMPONENTES (GET /samples/getSampleDetails/{id})
  // 🟢 AGREGADO: Consume la estructura unificada de 'SampleDetail'
  Future<Sample> fetchSampleWithComponents(int id) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/getSampleDetails/$id"),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return Sample.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al recuperar los componentes de la luminaria');
    }
  }
}
