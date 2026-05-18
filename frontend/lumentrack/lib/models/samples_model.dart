//import 'package:intl/intl.dart';

class Sample {
  final int sampleId;
  final int orderId;
  final String sampleName;
  final String estimatedDeliveryDate;
  final String realDeliveryDate;
  final String samplePhotoUrl;
  final String samplePhotoId;

  Sample({
    required this.sampleId,
    required this.orderId,
    required this.sampleName,
    required this.estimatedDeliveryDate,
    required this.realDeliveryDate,
    required this.samplePhotoUrl,
    required this.samplePhotoId,
  });

  factory Sample.fromJson(Map<String, dynamic> json) {
    return Sample(
      sampleId: json['sampleId'],
      orderId: json['orderId'],
      sampleName: json['sampleName'],
      estimatedDeliveryDate:
          json['estimatedDeliveryDate']?.toString() ?? "Sin fecha",
      realDeliveryDate: json['realDeliveryDate']?.toString() ?? "Sin fecha",
      samplePhotoUrl: json['samplePhotoUrl'],
      samplePhotoId: json['samplePhotoId'],
    );
  }

  //String get formattedEstimatedDeliveryDate {
  //  return DateFormat('dd/MM/yyyy HH:mm').format(estimatedDeliveryDate);
  //}

  //String get formattedRealDeliveryDate {
  //  return DateFormat('dd/MM/yyyy HH:mm').format(realDeliveryDate);
  //}

  Map<String, dynamic> toJson() => {
    'sampleId': sampleId,
    'orderId': orderId,
    'sampleName': sampleName,
    'samplePhotoUrl': samplePhotoUrl,
    'samplePhotoId': samplePhotoId,
    'estimatedDeliveryDate': estimatedDeliveryDate,
    'realDeliveryDate': realDeliveryDate,
  };
}
