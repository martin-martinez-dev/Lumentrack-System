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
        : deliveryDate,
    'materialId': materialId,
    'statusResume': statusResume,
    'ulaLightEmployee': ulaLightEmployee,
    // Opcional por si el backend requiere persistencia en cascada de subtareas:
    // 'taskList': taskList.map((e) => e.toJson()).toList(),
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

    // Si ya viene formateada con la T de LocalDateTime o guiones de edición previa, pasa directo
    if (uiDate.contains('-') || uiDate.contains('T')) return uiDate;

    try {
      DateFormat inputFormat = DateFormat('dd/MM/yyyy');
      DateTime parsedDate = inputFormat.parse(uiDate);

      // Construimos el String añadiéndole la hora base cero para que Jackson no lance un HttpMessageNotReadableException
      return "${DateFormat('yyyy-MM-dd').format(parsedDate)}T00:00:00";
    } catch (e) {
      return uiDate;
    }
  }
}
