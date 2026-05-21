import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/material_model.dart';

class MaterialService {
  // Encabezados estándar para comunicarse con Spring Boot
  final Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  };

  /// 1. Registrar un nuevo Material en el catálogo (POST /materials/save)
  Future<MaterialItem> saveMaterial(MaterialItem material) async {
    final url = Uri.parse('${ApiConfig.materials}/save');

    try {
      debugPrint("Guardando nuevo material: ${material.materialName}");
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(material.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return MaterialItem.fromJson(data);
      } else {
        throw Exception(
          "Error al guardar material (${response.statusCode}): ${response.body}",
        );
      }
    } catch (e) {
      debugPrint("Error en saveMaterial: $e");
      rethrow;
    }
  }

  /// 2. Obtener la lista completa de materiales para los Selectores/Dropdowns (GET /materials/list)
  Future<List<MaterialItem>> retrieveMaterials() async {
    final url = Uri.parse('${ApiConfig.materials}/list');

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(utf8.decode(response.bodyBytes));
        return list.map((json) => MaterialItem.fromJson(json)).toList();
      } else {
        throw Exception(
          "Error al recuperar lista de materiales: Código ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("Error en retrieveMaterials: $e");
      rethrow;
    }
  }

  /// 3. Buscar material por ID (GET /materials/search/{id})
  Future<MaterialItem?> searchMaterialById(int id) async {
    final url = Uri.parse('${ApiConfig.materials}/search/$id');

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return MaterialItem.fromJson(data);
      } else if (response.statusCode == 404) {
        return null; // Retorna null si el opcional de Java regresa build().notFound()
      } else {
        throw Exception(
          "Error al buscar material id $id: Código ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("Error en searchMaterialById: $e");
      rethrow;
    }
  }

  /// 4. Actualizar la información del material (POST /materials/update)
  Future<MaterialItem> updateMaterial(MaterialItem material) async {
    final url = Uri.parse('${ApiConfig.materials}/update');

    try {
      debugPrint("Actualizando material con ID: ${material.materialId}");
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(material.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return MaterialItem.fromJson(data);
      } else {
        throw Exception(
          "Error al actualizar material: Código ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("Error en updateMaterial: $e");
      rethrow;
    }
  }

  /// 5. Eliminar un material por ID (DELETE /materials/delete/{id})
  Future<void> deleteMaterial(int id) async {
    final url = Uri.parse('${ApiConfig.materials}/delete/$id');

    try {
      final response = await http.delete(url, headers: _headers);

      // Soportando el HttpStatus.NO_CONTENT (204) configurado en tu Spring Boot
      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception(
          "Error al eliminar material id $id: Código ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("Error en deleteMaterial: $e");
      rethrow;
    }
  }
}
