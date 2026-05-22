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
    'taskEstimatedDate': taskEstimatedDate.isEmpty
        ? null
        : Task.formatToServer(taskEstimatedDate),
    'taskRealDateTime':
        (taskRealDateTime.isEmpty ||
            taskRealDateTime.toLowerCase().contains('sin fecha') ||
            taskRealDateTime.toLowerCase().contains('sin entrega'))
        ? null
        : Task.formatToServer(taskRealDateTime),
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
  /// Este método es robusto para manejar múltiples formatos de entrada y siempre retorna el formato ISO 8601.
  static String? formatToServer(String uiDate) {
    if (uiDate.isEmpty ||
        uiDate.toLowerCase().contains('sin') ||
        uiDate.toLowerCase().contains('pendiente')) {
      return null;
    }

    try {
      DateTime parsedDate;

      // 1. Si ya es yyyy-MM-dd HH:mm:ss
      if (uiDate.length == 19 && uiDate.contains('-') && uiDate.contains(' ')) {
        return uiDate;
      }
      // 2. Intentar parsear como ISO 8601
      else if (uiDate.contains('T')) {
        parsedDate = DateTime.parse(uiDate);
      }
      // 3. Intentar parsear como yyyy-MM-dd
      else if (uiDate.length == 10 && uiDate.contains('-')) {
        parsedDate = DateFormat('yyyy-MM-dd').parse(uiDate);
      }
      // 4. Formatos con barra (UI)
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
