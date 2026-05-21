class UserItem {
  final int?
  userId; // Opcional porque un usuario nuevo no tiene ID incremental de MySQL
  final String userName;
  final String userLastName;
  final String userMail;
  final String? userPhoneNumber; // Nullable según tu anotación nullable = true
  final String userRole;

  UserItem({
    this.userId,
    required this.userName,
    required this.userLastName,
    required this.userMail,
    this.userPhoneNumber,
    required this.userRole,
  });

  /// Getter de conveniencia para mostrar el nombre completo en los Dropdowns de la UI
  String get fullName => '$userName $userLastName';

  /// Factory para deserealizar el JSON proveniente de Spring Boot
  factory UserItem.fromJson(Map<String, dynamic> json) {
    return UserItem(
      userId: json['userId'] as int?,
      userName: json['userName'] ?? '',
      userLastName: json['userLastName'] ?? '',
      userMail: json['userMail'] ?? '',
      userPhoneNumber: json['userPhoneNumber'],
      userRole: json['userRole'] ?? '',
    );
  }

  /// Convertir a JSON para enviar a los endpoints POST/PUT de Spring Boot
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'userName': userName,
    'userLastName': userLastName,
    'userMail': userMail,
    'userPhoneNumber': userPhoneNumber,
    'userRole': userRole,
  };
}
