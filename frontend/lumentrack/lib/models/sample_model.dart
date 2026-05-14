import 'package:intl/intl.dart';

class Sample {
  final int sampleId;
  final int projectId;
  final String sampleName;
  final DateTime estimatedDeliveryDate;
  final DateTime realDeliveryDate;
  final String samplePhotoUrl;
  final String samplePhotoId;

  Sample({
    required this.sampleId,
    required this.projectId,
    required this.sampleName,
    required this.estimatedDeliveryDate,
    required this.realDeliveryDate,
    required this.samplePhotoUrl,
    required this.samplePhotoId,
  });

  factory Sample.fromJson(Map<String, dynamic> json) {
    return Sample(
      sampleId: json['sampleId'],
      projectId: json['projectId'],
      sampleName: json['sampleName'],
      estimatedDeliveryDate: json['estimatedDeliveryDate'],
      realDeliveryDate: json['realDeliveryDate'],
      samplePhotoUrl: json['samplePhotoUrl'],
      samplePhotoId: json['samplePhotoId'],
    );
  }

  String get formattedEstimatedDeliveryDate {
    return DateFormat('dd/MM/yyyy HH:mm').format(estimatedDeliveryDate);
  }

  String get formattedRealDeliveryDate {
    return DateFormat('dd/MM/yyyy HH:mm').format(realDeliveryDate);
  }
}
