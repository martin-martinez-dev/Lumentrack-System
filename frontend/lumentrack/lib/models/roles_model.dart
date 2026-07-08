class RoleItem {
  final int? roleId;
  final String roleDisplayName;
  final String roleName;
  final String? roleDescription;

  RoleItem({
    this.roleId,
    required this.roleDisplayName,
    required this.roleName,
    this.roleDescription,
  });

  /// Factory para deserealizar el JSON proveniente de Roles DTO en Spring Boot
  factory RoleItem.fromJson(Map<String, dynamic> json) {
    return RoleItem(
      roleId: json['roleId'] as int?,
      roleDisplayName: json['roleDisplayName'] ?? '',
      roleName: json['roleName'] ?? '',
      roleDescription: json['roleDescription'] as String?,
    );
  }

  /// Convertir a JSON para enviar a los endpoints POST/PUT (/roles/save o /roles/update)
  Map<String, dynamic> toJson() => {
    'roleId': roleId,
    'roleDisplayName': roleDisplayName,
    'roleName': roleName,
    'roleDescription': roleDescription,
  };

  RoleItem copyWith({
    int? roleId,
    String? roleDisplayName,
    String? roleName,
    String? roleDescription,
  }) {
    return RoleItem(
      roleId: roleId ?? this.roleId,
      roleDisplayName: roleDisplayName ?? this.roleDisplayName,
      roleName: roleName ?? this.roleName,
      roleDescription: roleDescription ?? this.roleDescription,
    );
  }
}
