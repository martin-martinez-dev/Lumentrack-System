import '../core/date_formatter.dart';

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
    final componentMap = json['component'] as Map<String, dynamic>?;

    return Task(
      taskId: json['taskId'] as int?,
      taskName: json['taskName'] ?? '',
      taskDescription: json['taskDescription'] ?? '',
      componentId:
          json['componentId'] ??
          (componentMap != null ? (componentMap['componentId'] ?? 0) : 0),
      componentName:
          json['componentName'] ??
          (componentMap != null ? (componentMap['componentName'] ?? '') : ''),
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
    'componentId': componentId, // 🟢 Alineado con TaskRequest.componentId
    'taskPhotoUrl': taskPhotoUrl,
    'taskPhotoId': taskPhotoId,
    'taskEstimatedDate': DateFormatter.toServer(taskEstimatedDate),
    'taskRealDateTime': DateFormatter.toServer(taskRealDateTime),
  };

  // =========================================================================
  // GETTERS Y FORMATEADORES DE FECHA PARA LA INTERFAZ (UI)
  // =========================================================================

  String get formattedEstimatedDate {
    if (taskEstimatedDate.isEmpty) return "Sin fecha";
    try {
      return DateFormatter.toUi(taskEstimatedDate, includeTime: true);
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
      return DateFormatter.toUi(taskRealDateTime, includeTime: true);
    } catch (e) {
      return taskRealDateTime;
    }
  }
}
