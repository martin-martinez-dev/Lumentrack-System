class MaterialItem {
  final int?
  materialId; // Opcional porque un nuevo material no tiene ID asignado aún
  final String materialName;

  MaterialItem({this.materialId, required this.materialName});

  /// Factory para deserializar el JSON proveniente de Spring Boot
  factory MaterialItem.fromJson(Map<String, dynamic> json) {
    return MaterialItem(
      materialId: json['materialId'] as int?,
      materialName: json['materialName'] ?? '',
    );
  }

  /// Convertir a JSON para enviar a los endpoints POST/PUT de Spring Boot
  Map<String, dynamic> toJson() => {
    'materialId': materialId,
    'materialName': materialName,
  };
}
