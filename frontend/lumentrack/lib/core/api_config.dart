import 'package:flutter/foundation.dart';

class ApiConfig {
  // 🟢 Forzamos HTTPS en producción para evitar redirecciones que pierden el body del POST.
  // En modo debug, usamos la IP local para el emulador.
  static const String baseUrl = kReleaseMode
      ? "https://api.lumentrack.zbksystems.mx"
      : "http://10.0.2.2";

  // Dashboard Screen Endpoints - Usan puerto 8081
  static const String dashboard = "$baseUrl/lumentrack/dashboard/getData";
  static const String dashboardUserFiltered =
      "$baseUrl/lumentrack/dashboard/getData/user";

  // Samples Screens Endpoints - Usan puerto 8082
  static const String images = "$baseUrl/lumentrack/samples/images";
  static const String samples = "$baseUrl/lumentrack/samples/samples";
  static const String orders = "$baseUrl/lumentrack/samples/orders";
  static const String components = "$baseUrl/lumentrack/samples/components";
  static const String tasks = "$baseUrl/lumentrack/samples/tasks";

  // Admin Screens Endpoints - Usan puerto 8083
  static const String clients = "$baseUrl/lumentrack/admin/clients";
  static const String users = "$baseUrl/lumentrack/admin/users";
  static const String materials = "$baseUrl/lumentrack/admin/materials";
  static const String roles = "$baseUrl/lumentrack/admin/roles";

  // Auth Endpoints - Usan puerto 8084
  static const String auth = "$baseUrl/lumentrack/auth/auth";
}
