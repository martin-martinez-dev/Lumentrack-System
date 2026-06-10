class LoginRequest {
  final String userMail;
  final String password;

  LoginRequest({required this.userMail, required this.password});

  Map<String, dynamic> toJson() => {'userMail': userMail, 'password': password};
}

class AuthResponse {
  final String jwt;
  final int userId;
  final String userName;
  final String userLastName;
  final int roleId;
  final String roleName;
  final String roleDisplayName;

  AuthResponse({
    required this.jwt,
    required this.userId,
    required this.userName,
    required this.userLastName,
    required this.roleId,
    required this.roleName,
    required this.roleDisplayName,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      jwt: json['jwt'] ?? '',
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      userLastName: json['userLastName'] ?? '',
      roleId: json['roleId'] ?? 0,
      roleName: json['roleName'] ?? '',
      roleDisplayName: json['roleDisplayName'] ?? '',
    );
  }
}
