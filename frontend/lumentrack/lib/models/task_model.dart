import 'package:intl/intl.dart';

class Task {
  final int? taskId;
  final String taskName;
  final String taskDescription;
  final DateTime taskEstimatedDate;
  final DateTime? taskRealDateTime;

  Task({
    this.taskId,
    required this.taskName,
    required this.taskDescription,
    required this.taskEstimatedDate,
    this.taskRealDateTime,
  });

  Map<String, dynamic> toJson() => {
    'taskName': taskName,
    'taskDescription': taskDescription,
    'taskEstimatedDate': DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(taskEstimatedDate),
  };
}
