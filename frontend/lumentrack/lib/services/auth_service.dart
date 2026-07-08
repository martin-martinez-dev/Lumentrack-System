import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/auth_models.dart';

class AuthService {
  final Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  };

  /// Consumo del endpoint /auth/login en el puerto 8084
  Future<AuthResponse> login(String email, String password) async {
    final url = Uri.parse("${ApiConfig.auth}/login");
    final body = jsonEncode(
      LoginRequest(userMail: email, password: password).toJson(),
    );

    try {
      final response = await http.post(url, headers: _headers, body: body);

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)),
        );
        debugPrint("DEBUG: Objeto AuthResponse recibido: $authResponse");
        return authResponse;
      } else {
        // Cualquier otro código (como el 403 Forbidden) lanza una excepción
        debugPrint(
          "Error en Login - Status: ${response.statusCode}, Body: ${response.body}",
        );
        throw Exception("Error de autenticación: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      // 🟢 Inicio: Captura y muestra de la excepción detallada
      debugPrint("!!!!!!!!!!!!!! LOGIN EXCEPTION !!!!!!!!!!!!!!");
      debugPrint("Exception Type: ${e.runtimeType}");
      debugPrint("Exception Message: $e");
      debugPrint("Stack Trace: $stackTrace");
      debugPrint("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      // 🟢 Fin: Captura de excepción
      rethrow;
    }
  }
}
