import 'task_model.dart'; // Importará tu clase limpia 'Task'
import '../core/date_formatter.dart';

class Component {
  // 1. Campos base de la tabla MySQL
  final int? componentId;
  final int sampleId;
  final String componentName;
  final String componentType;
  final String componentDescription;
  final String componentPhotoUrl;
  final String componentPhotoId;
  final bool isExternal;
  final String
  deliveryDate; // Almacenado de manera interna como ISO (yyyy-MM-ddTHH:mm:ss)
  final int materialId;
  final String? statusResume;
  final String ulaLightEmployee;
  final int? userId; // Nuevo campo detectado en el DTO de Java

  // 2. Campos informativos (@Transient en Spring Boot)
  final String sampleName;
  final String materialName;
  final List<Task> tasks;

  Component({
    this.componentId,
    required this.sampleId,
    this.sampleName = '',
    required this.componentName,
    required this.componentType,
    required this.componentDescription,
    this.componentPhotoUrl = '',
    this.componentPhotoId = '',
    this.isExternal = false,
    required this.deliveryDate,
    required this.materialId,
    this.materialName = 'Sin Material',
    this.statusResume,
    required this.ulaLightEmployee,
    this.userId,
    this.tasks = const [],
  });

  /// 3. Mapeo seguro contra nulos desde Spring Boot (Mesa de Entrada)
  factory Component.fromJson(Map<String, dynamic> json) {
    // Parseo de la jerarquía modular de tareas de forma segura
    var list = json['tasks'] as List?;
    List<Task> taskList = list != null
        ? list.map((i) => Task.fromJson(i)).toList()
        : [];

    // Extraer datos del objeto relacional 'sample'
    final sampleMap = json['sample'] as Map<String, dynamic>?;

    return Component(
      componentId: json['componentId'] as int?,
      sampleId:
          json['sampleId'] ??
          (sampleMap != null ? (sampleMap['sampleId'] ?? 0) : 0),
      sampleName:
          json['sampleName'] ??
          (sampleMap != null ? (sampleMap['sampleName'] ?? '') : ''),
      componentName: json['componentName'] ?? '',
      componentType: json['componentType'] ?? '',
      componentDescription: json['componentDescription'] ?? '',
      componentPhotoUrl: json['componentPhotoUrl'] ?? '',
      componentPhotoId: json['componentPhotoId'] ?? '',
      isExternal: json['isExternal'] ?? false,
      deliveryDate: json['deliveryDate']?.toString() ?? '',
      materialId: json['materialId'] ?? 0,
      materialName: json['materialName'] ?? 'Sin Material',
      statusResume: json['statusResume'],
      ulaLightEmployee: json['ulaLightEmployee'] ?? '',
      userId: json['userId'] as int?,
      tasks: taskList,
    );
  }

  /// 4. Conversión a JSON para enviar a los endpoints POST / PUT en Spring Boot (Mesa de Salida)
  Map<String, dynamic> toJson() => {
    'componentId': componentId,
    'sampleId': sampleId, // 🟢 Alineado con ComponentRequest.sampleId
    'componentName': componentName,
    'componentType': componentType,
    'componentDescription': componentDescription,
    'componentPhotoUrl': componentPhotoUrl,
    'componentPhotoId': componentPhotoId,
    'isExternal': isExternal,
    // Formateo correcto para nulos nativos si se captura vacío en la UI
    'deliveryDate': DateFormatter.toServer(deliveryDate),
    'materialId': materialId,
    'statusResume': statusResume,
    'ulaLightEmployee': ulaLightEmployee,
    'userId': userId,
  };

  // =========================================================================
  // 5. GETTERS Y FORMATEADORES DE FECHA UNIFICADOS (Lógica Centralizada)
  // =========================================================================

  /// Retorna un formato amigable para pintar en tarjetas o ListTiles de la UI (Ej: 31/05/2026)
  String get formattedDeliveryDate {
    if (deliveryDate.isEmpty ||
        deliveryDate.toLowerCase().contains("sin fecha")) {
      return "Sin fecha";
    }
    try {
      // Intenta parsear la cadena ISO de la base de datos (Soporta 'yyyy-MM-dd' o 'yyyy-MM-ddTHH:mm:ss')
      return DateFormatter.toUi(deliveryDate);
    } catch (e) {
      return deliveryDate; // Fallback seguro
    }
  }
}
