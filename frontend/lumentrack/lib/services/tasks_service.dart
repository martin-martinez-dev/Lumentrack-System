import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/task_model.dart';

class TasksService {
  // Encabezados estándar para la API REST de Spring Boot
  final Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  };

  /// 1. Registrar una nueva Tarea / Evidencia (POST /tasks/save)
  Future<Task> saveTask(Task task) async {
    final url = Uri.parse('${ApiConfig.tasks}/save');

    try {
      debugPrint("Enviando a guardar tarea: ${task.taskName}");
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(task.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return Task.fromJson(data);
      } else {
        throw Exception(
          "Error al guardar tarea (${response.statusCode}): ${response.body}",
        );
      }
    } catch (e) {
      debugPrint("Error en saveTask: $e");
      rethrow;
    }
  }

  /// 2. Listar todas las tareas globales (GET /tasks/list)
  Future<List<Task>> retrieveAllTasks() async {
    final url = Uri.parse('${ApiConfig.tasks}/list');

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(utf8.decode(response.bodyBytes));
        return list.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception(
          "Error al listar tareas de Lumentrack: Código ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("Error en retrieveAllTasks: $e");
      rethrow;
    }
  }

  /// 3. Buscar una tarea por su ID - Consulta simple (GET /tasks/search/{id})
  Future<Task?> searchTaskById(int id) async {
    final url = Uri.parse('${ApiConfig.tasks}/search/$id');

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return Task.fromJson(data);
      } else if (response.statusCode == 404) {
        return null; // Retorna nulo limpio si no se encuentra en el repositorio
      } else {
        throw Exception(
          "Error al buscar tarea id $id: Código ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("Error en searchTaskById: $e");
      rethrow;
    }
  }

  /// 4. Actualizar información o estado de una tarea (POST /tasks/update)
  Future<Task> updateTask(Task task) async {
    final url = Uri.parse('${ApiConfig.tasks}/update');

    try {
      debugPrint("Actualizando tarea con ID: ${task.taskId}");
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(task.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return Task.fromJson(data);
      } else {
        throw Exception(
          "Error al modificar tarea: Código ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("Error en updateTask: $e");
      rethrow;
    }
  }

  /// 5. Eliminar registro de tarea física (DELETE /tasks/delete/{id})
  Future<void> deleteTask(int id) async {
    final url = Uri.parse('${ApiConfig.tasks}/delete/$id');

    try {
      final response = await http.delete(url, headers: _headers);

      // Maneja el HttpStatus.NO_CONTENT (204) de forma correcta
      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception(
          "Error al eliminar tarea id $id: Código ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("Error en deleteTask: $e");
      rethrow;
    }
  }

  /// 6. Consultar los detalles específicos extendidos de la tarea (GET /tasks/getTasksDetails/{id})
  Future<Task> getTasksDetails(int id) async {
    final url = Uri.parse('${ApiConfig.tasks}/getTasksDetails/$id');

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return Task.fromJson(data);
      } else {
        throw Exception(
          "Error al recuperar detalle extendido de tarea id $id: Código ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("Error en getTasksDetails: $e");
      rethrow;
    }
  }
}
