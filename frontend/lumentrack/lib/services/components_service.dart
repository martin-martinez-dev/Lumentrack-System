import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/api_config.dart'; // Asegúrate de que apunte correctamente a tu configuración de IP/puerto
import '../models/component_model.dart';

class ComponentsService {
  // Encabezados estándar para comunicarse con Spring Boot
  final Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  };

  /// 1. Guardar un componente nuevo (POST /components/save)
  Future<Component> saveComponent(Component component) async {
    final url = Uri.parse('${ApiConfig.components}/save');

    try {
      debugPrint("Enviando a guardar componente: ${component.componentName}");
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(component.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return Component.fromJson(data);
      } else {
        throw Exception(
          "Error del servidor (${response.statusCode}): ${response.body}",
        );
      }
    } catch (e) {
      debugPrint("Error en saveComponent: $e");
      rethrow;
    }
  }

  /// 2. Obtener todos los componentes (GET /components/list)
  Future<List<Component>> retrieveAll() async {
    final url = Uri.parse('${ApiConfig.components}/list');

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(utf8.decode(response.bodyBytes));
        return list.map((json) => Component.fromJson(json)).toList();
      } else {
        throw Exception(
          "Error al listar componentes: Código ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("Error en retrieveAll: $e");
      rethrow;
    }
  }

  /// 3. Buscar componente por ID - Consulta básica (GET /components/search/{id})
  Future<Component?> searchComponentById(int id) async {
    final url = Uri.parse('${ApiConfig.components}/search/$id');

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return Component.fromJson(data);
      } else if (response.statusCode == 404) {
        return null; // El controlador responde build() notFound si está vacío
      } else {
        throw Exception(
          "Error al buscar componente id $id: Código ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("Error en searchComponentById: $e");
      rethrow;
    }
  }

  /// 4. Actualizar información de un componente existente (POST /components/update)
  Future<Component> updateComponent(Component component) async {
    final url = Uri.parse('${ApiConfig.components}/update');

    try {
      debugPrint("Actualizando componente ID: ${component.componentId}");
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(component.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return Component.fromJson(data);
      } else {
        throw Exception(
          "Error al actualizar componente: Código ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("Error en updateComponent: $e");
      rethrow;
    }
  }

  /// 5. Eliminar componente por ID (DELETE /components/delete/{id})
  Future<void> deleteComponent(int id) async {
    final url = Uri.parse('${ApiConfig.components}/delete/$id');

    try {
      final response = await http.delete(url, headers: _headers);

      // El controlador tiene @ResponseStatus(HttpStatus.NO_CONTENT) -> Retorna 204
      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception(
          "Error al eliminar componente id $id: Código ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("Error en deleteComponent: $e");
      rethrow;
    }
  }

  /// 6. Obtener el detalle extendido del componente (GET /components/getComponentDetails/{id})
  /// 🟢 REQUERIMIENTO CLAVE: Carga el componente junto con su jerarquía completa de tareas (taskList)
  Future<Component> getComponentDetails(int id) async {
    final url = Uri.parse('${ApiConfig.components}/getComponentDetails/$id');

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return Component.fromJson(data);
      } else {
        throw Exception(
          "Error al obtener detalles extendidos del componente id $id: Código ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("Error en getComponentDetails: $e");
      rethrow;
    }
  }
}
