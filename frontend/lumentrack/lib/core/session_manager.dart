import '../models/auth_models.dart';

class SessionManager {
  // Singleton
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  // Datos de sesión "vivos"
  String? token;
  int? userId;
  String? userName;
  String? userLastName;
  int? roleId;
  String? roleName;
  String? roleDisplayName;

  void saveSession(AuthResponse response) {
    token = response.jwt;
    userId = response.userId;
    userName = response.userName;
    userLastName = response.userLastName;
    roleId = response.roleId;
    roleName = response.roleName;
    roleDisplayName = response.roleDisplayName;
  }

  void clearSession() {
    token = null;
    userId = null;
    userName = null;
    userLastName = null;
    roleId = null;
    roleName = null;
    roleDisplayName = null;
  }

  bool get isLoggedIn => token != null;
}
