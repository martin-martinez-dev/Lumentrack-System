import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/users_model.dart';

class UsersService {
  // Encabezados estándar de comunicación JSON para Lumentrack
  final Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  };

  /// 1. Registrar un nuevo usuario (POST /users/save)
  Future<UserItem> saveUser(UserItem user) async {
    // Usamos directamente el string configurado en ApiConfig
    final url = Uri.parse('${ApiConfig.users}/save');

    try {
      debugPrint("Enviando a guardar usuario: ${user.userName}");
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return UserItem.fromJson(data);
      } else {
        throw Exception(
          "Error al registrar usuario (${response.statusCode}): ${response.body}",
        );
      }
    } catch (e) {
      debugPrint("Error en saveUser: $e");
      rethrow;
    }
  }

  /// 2. Listar todos los usuarios / empleados (GET /users/list)
  /// 🟢 FUNDAMENTAL: Lo usaremos para alimentar el dropdown del encargado (ulaLightEmployee)
  Future<List<UserItem>> retrieveUsers() async {
    final url = Uri.parse('${ApiConfig.users}/list');

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(utf8.decode(response.bodyBytes));
        return list.map((json) => UserItem.fromJson(json)).toList();
      } else {
        throw Exception(
          "Error al obtener lista de usuarios: Código ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("Error en retrieveUsers: $e");
      rethrow;
    }
  }

  /// 3. Obtener los detalles específicos de un usuario (GET /users/getUserDetails/{id})
  Future<UserItem> getUserDetails(int id) async {
    final url = Uri.parse('${ApiConfig.users}/getUserDetails/$id');

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return UserItem.fromJson(data);
      } else {
        throw Exception(
          "Error al recuperar detalles del usuario id $id: Código ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("Error en getUserDetails: $e");
      rethrow;
    }
  }

  /// 4. Actualizar información del usuario (POST /users/update)
  Future<UserItem> updateUser(UserItem user) async {
    final url = Uri.parse('${ApiConfig.users}/update');

    try {
      debugPrint("Actualizando datos del usuario ID: ${user.userId}");
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return UserItem.fromJson(data);
      } else {
        throw Exception(
          "Error al modificar usuario: Código ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("Error en updateUser: $e");
      rethrow;
    }
  }

  /// 5. Eliminar un usuario del sistema (DELETE /users/delete/{id})
  Future<void> deleteUser(int id) async {
    final url = Uri.parse('${ApiConfig.users}/delete/$id');

    try {
      final response = await http.delete(url, headers: _headers);

      // Soportando el HttpStatus.NO_CONTENT (204) configurado en tu Spring Boot
      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception(
          "Error al eliminar usuario id $id: Código ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("Error en deleteUser: $e");
      rethrow;
    }
  }

  /// 6. Listar usuarios con detalles enriquecidos (GET /users/listUserDetails)
  /// 🟢 REQUERIMIENTO: Trae el objeto UserItem incluyendo campos @Transient como roleDisplayName
  Future<List<UserItem>> retrieveUsersDetails() async {
    final url = Uri.parse('${ApiConfig.users}/listUserDetails');

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(utf8.decode(response.bodyBytes));
        return list.map((json) => UserItem.fromJson(json)).toList();
      } else {
        throw Exception(
          "Error al listar detalles de usuarios: Código ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("Error en retrieveUsersDetails: $e");
      rethrow;
    }
  }
}
