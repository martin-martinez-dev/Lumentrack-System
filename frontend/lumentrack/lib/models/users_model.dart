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
      userName: (json['userName'] as String?) ?? '',
      userLastName: (json['userLastName'] as String?) ?? '',
      userMail: (json['userMail'] as String?) ?? '',
      userPhoneNumber: json['userPhoneNumber'] as String?,
      userRole: (json['userRole'] as String?) ?? '',
    );
  }

  /// Método copyWith para facilitar la edición en formularios (Equivalente al @Builder de Lombok)
  UserItem copyWith({
    int? userId,
    String? userName,
    String? userLastName,
    String? userMail,
    String? userPhoneNumber,
    String? userRole,
  }) {
    return UserItem(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userLastName: userLastName ?? this.userLastName,
      userMail: userMail ?? this.userMail,
      userPhoneNumber: userPhoneNumber ?? this.userPhoneNumber,
      userRole: userRole ?? this.userRole,
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
