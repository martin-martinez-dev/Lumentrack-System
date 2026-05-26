import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/roles_model.dart';

class RolesService {
  final Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  };

  /// 1. Registrar un nuevo rol (POST /roles/save)
  Future<RoleItem> saveRole(RoleItem role) async {
    final url = Uri.parse('${ApiConfig.roles}/save');
    try {
      debugPrint("Guardando rol: ${role.roleDisplayName}");
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(role.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return RoleItem.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception("Error al registrar rol: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error en saveRole: $e");
      rethrow;
    }
  }

  /// 2. Listar todos los roles (GET /roles/list)
  Future<List<RoleItem>> retrieveRoles() async {
    final url = Uri.parse('${ApiConfig.roles}/list');
    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(utf8.decode(response.bodyBytes));
        return list.map((json) => RoleItem.fromJson(json)).toList();
      } else {
        throw Exception("Error al listar roles: Código ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error en retrieveRoles: $e");
      rethrow;
    }
  }

  /// 3. Actualizar información del rol (POST /roles/update)
  Future<RoleItem> updateRole(RoleItem role) async {
    final url = Uri.parse('${ApiConfig.roles}/update');
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(role.toJson()),
      );

      if (response.statusCode == 200) {
        return RoleItem.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception("Error al actualizar rol: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error en updateRole: $e");
      rethrow;
    }
  }

  /// 4. Eliminar rol (DELETE /roles/delete/{id})
  Future<void> deleteRole(int id) async {
    final url = Uri.parse('${ApiConfig.roles}/delete/$id');
    try {
      final response = await http.delete(url, headers: _headers);
      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception("Error al eliminar rol: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error en deleteRole: $e");
      rethrow;
    }
  }

  /// 5. Buscar por ID (GET /roles/search/{id})
  Future<RoleItem?> searchRoleById(int id) async {
    final url = Uri.parse('${ApiConfig.roles}/search/$id');
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        return RoleItem.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception("Error al buscar rol: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error en searchRoleById: $e");
      rethrow;
    }
  }
}
