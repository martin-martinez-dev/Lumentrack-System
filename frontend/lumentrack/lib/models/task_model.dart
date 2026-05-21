import 'package:intl/intl.dart';

class Task {
  final int? taskId; // Opcional porque una nueva tarea no tiene ID de MySQL aún
  final String taskName;
  final String taskDescription;
  final int componentId;
  final String componentName; // @Transient
  final String taskPhotoUrl;
  final String taskPhotoId;
  final String
  taskEstimatedDate; // Almacenado como String (yyyy-MM-dd HH:mm:ss)
  final String taskRealDateTime; // Almacenado como String (yyyy-MM-dd HH:mm:ss)

  Task({
    this.taskId,
    required this.taskName,
    required this.taskDescription,
    required this.componentId,
    this.componentName = '',
    this.taskPhotoUrl = '',
    this.taskPhotoId = '',
    required this.taskEstimatedDate,
    this.taskRealDateTime = '',
  });

  /// Factory para deserealizar el JSON proveniente de Spring Boot
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['taskId'] as int?,
      taskName: json['taskName'] ?? '',
      taskDescription: json['taskDescription'] ?? '',
      componentId: json['componentId'] ?? 0,
      componentName: json['componentName'] ?? '',
      taskPhotoUrl: json['taskPhotoUrl'] ?? '',
      taskPhotoId: json['taskPhotoId'] ?? '',
      taskEstimatedDate: json['taskEstimatedDate']?.toString() ?? '',
      taskRealDateTime: json['taskRealDateTime']?.toString() ?? '',
    );
  }

  /// Convertir a JSON para enviar a los endpoints POST/PUT de Spring Boot
  Map<String, dynamic> toJson() => {
    'taskId': taskId,
    'taskName': taskName,
    'taskDescription': taskDescription,
    'componentId': componentId,
    'taskPhotoUrl': taskPhotoUrl,
    'taskPhotoId': taskPhotoId,
    // Mapeo seguro de fechas para evitar enviar cadenas vacías al backend
    'taskEstimatedDate': taskEstimatedDate.isEmpty ? null : taskEstimatedDate,
    'taskRealDateTime':
        (taskRealDateTime.isEmpty ||
            taskRealDateTime.toLowerCase().contains('sin fecha') ||
            taskRealDateTime.toLowerCase().contains('sin entrega'))
        ? null
        : taskRealDateTime,
  };

  // =========================================================================
  // GETTERS Y FORMATEADORES DE FECHA PARA LA INTERFAZ (UI)
  // =========================================================================

  String get formattedEstimatedDate {
    if (taskEstimatedDate.isEmpty) return "Sin fecha";
    try {
      DateTime parsed = DateTime.parse(taskEstimatedDate);
      return DateFormat('dd/MM/yyyy HH:mm').format(parsed);
    } catch (e) {
      return taskEstimatedDate;
    }
  }

  String get formattedRealDateTime {
    if (taskRealDateTime.isEmpty ||
        taskRealDateTime.toLowerCase().contains('sin fecha') ||
        taskRealDateTime.toLowerCase().contains('sin entrega')) {
      return "Pendiente";
    }
    try {
      DateTime parsed = DateTime.parse(taskRealDateTime);
      return DateFormat('dd/MM/yyyy HH:mm').format(parsed);
    } catch (e) {
      return taskRealDateTime;
    }
  }

  /// Convierte una fecha de formato UI (dd/MM/yyyy HH:mm) al formato ISO de Spring Boot (yyyy-MM-dd HH:mm:ss)
  static String? formatToServer(String uiDate) {
    if (uiDate.isEmpty ||
        uiDate.toLowerCase().contains('sin') ||
        uiDate.toLowerCase().contains('pendiente')) {
      return null;
    }
    if (uiDate.contains('-')) return uiDate;

    try {
      DateFormat inputFormat = DateFormat('dd/MM/yyyy HH:mm');
      DateTime parsedDate = inputFormat.parse(uiDate);
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedDate);
    } catch (e) {
      return uiDate;
    }
  }
}
