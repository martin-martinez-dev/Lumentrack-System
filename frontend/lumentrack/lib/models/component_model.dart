import 'package:intl/intl.dart';
import 'task_model.dart'; // Importará tu clase limpia 'Task'

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

  // 2. Campos informativos (@Transient en Spring Boot)
  final String sampleName;
  final String materialName;
  final List<Task> taskList;

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
    this.taskList = const [],
  });

  /// 3. Mapeo seguro contra nulos desde Spring Boot (Mesa de Entrada)
  factory Component.fromJson(Map<String, dynamic> json) {
    // Parseo de la jerarquía modular de tareas de forma segura
    var list = json['taskList'] as List?;
    List<Task> tasks = list != null
        ? list.map((i) => Task.fromJson(i)).toList()
        : [];

    return Component(
      componentId: json['componentId'] as int?,
      sampleId: json['sampleId'] ?? 0,
      sampleName: json['sampleName'] ?? '',
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
      taskList: tasks,
    );
  }

  /// 4. Conversión a JSON para enviar a los endpoints POST / PUT en Spring Boot (Mesa de Salida)
  Map<String, dynamic> toJson() => {
    'componentId': componentId,
    'sampleId': sampleId,
    'componentName': componentName,
    'componentType': componentType,
    'componentDescription': componentDescription,
    'componentPhotoUrl': componentPhotoUrl,
    'componentPhotoId': componentPhotoId,
    'isExternal': isExternal,
    // Formateo correcto para nulos nativos si se captura vacío en la UI
    'deliveryDate': deliveryDate.isEmpty || deliveryDate == "Sin fecha"
        ? null
        : Component.formatToServer(deliveryDate),
    'materialId': materialId,
    'statusResume': statusResume,
    'ulaLightEmployee': ulaLightEmployee,
    // Opcional por si el backend requiere persistencia en cascada de subtareas:
    'taskList': taskList.map((e) => e.toJson()).toList(),
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
      DateTime parsedDate = DateTime.parse(deliveryDate);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return deliveryDate; // Fallback seguro
    }
  }

  /// Convierte la fecha del DatePicker o UI (dd/MM/yyyy) al formato compatible LocalDateTime de tu DTO (yyyy-MM-ddTHH:mm:ss)
  static String? formatToServer(String uiDate) {
    if (uiDate.isEmpty || uiDate == "Sin fecha") {
      return null;
    }

    try {
      DateTime parsedDate;

      // 1. Intentar parsear como yyyy-MM-dd HH:mm:ss (Formato final)
      if (uiDate.length == 19 && uiDate.contains('-') && uiDate.contains(' ')) {
        return uiDate;
      }
      // 2. Intentar parsear como ISO 8601 (yyyy-MM-ddTHH:mm:ss) para normalizar
      else if (uiDate.contains('T')) {
        parsedDate = DateTime.parse(uiDate);
      }
      // 3. Intentar parsear como yyyy-MM-dd (Proveniente del DatePicker)
      else if (uiDate.length == 10 && uiDate.contains('-')) {
        parsedDate = DateFormat('yyyy-MM-dd').parse(uiDate);
      }
      // 4. Intentar parsear como dd/MM/yyyy HH:mm
      else if (uiDate.contains('/')) {
        String pattern = uiDate.contains(' ')
            ? 'dd/MM/yyyy HH:mm'
            : 'dd/MM/yyyy';
        parsedDate = DateFormat(pattern).parse(uiDate);
      } else {
        parsedDate = DateTime.parse(uiDate);
      }

      // Retornamos solo la fecha para coincidir con LocalDate en el Backend
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return null;
    }
  }
}
