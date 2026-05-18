import 'package:intl/intl.dart';

class SampleView {
  // 1. Hacemos el ID opcional con '?' porque una muestra NUEVA aún no tiene ID de Aiven MySQL
  final int? sampleId;
  final String sampleName;
  final int orderId;
  final String orderName;
  final String samplePhotoUrl;
  final String samplePhotoId;
  final String estimatedDeliveryDate;
  final String realDeliveryDate;

  SampleView({
    this.sampleId, // Al ser opcional, quitamos el 'required'
    required this.orderId,
    required this.sampleName,
    required this.orderName,
    required this.samplePhotoUrl,
    required this.samplePhotoId,
    required this.estimatedDeliveryDate,
    required this.realDeliveryDate,
  });

  // 2. Mapeo seguro contra nulos desde Spring Boot (Puerto 8082)
  factory SampleView.fromJson(Map<String, dynamic> json) {
    return SampleView(
      sampleId: json['sampleId'] as int?,
      orderId: json['orderId'] ?? 0,
      sampleName: json['sampleName'] ?? '',
      orderName:
          json['orderName'] ??
          'Sin Orden', // Captura el cruce de tu ViewModel en Java
      samplePhotoUrl: json['samplePhotoUrl'] ?? '',
      samplePhotoId: json['samplePhotoId'] ?? '',
      estimatedDeliveryDate: json['estimatedDeliveryDate']?.toString() ?? '',
      realDeliveryDate: json['realDeliveryDate']?.toString() ?? '',
    );
  }

  // 3. GETTERS DE FECHA CORREGIDOS
  // Como guardamos las fechas como String, primero debemos parsearlas a DateTime antes de darles formato
  String get formattedEstimatedDeliveryDate {
    if (estimatedDeliveryDate.isEmpty || estimatedDeliveryDate == "Sin fecha")
      return "Sin fecha";
    try {
      DateTime parsedDate = DateTime.parse(estimatedDeliveryDate);
      return DateFormat('dd/MM/yyyy HH:mm').format(parsedDate);
    } catch (e) {
      return estimatedDeliveryDate; // Si falla el parseo, regresa el String original sin romper la app
    }
  }

  String get formattedRealDeliveryDate {
    if (realDeliveryDate.isEmpty || realDeliveryDate == "Sin fecha")
      return "Sin entrega";
    try {
      DateTime parsedDate = DateTime.parse(realDeliveryDate);
      return DateFormat('dd/MM/yyyy HH:mm').format(parsedDate);
    } catch (e) {
      return realDeliveryDate;
    }
  }

  /// Convierte una fecha de formato UI (dd/MM/yyyy HH:mm) al formato de Spring Boot (yyyy-MM-dd HH:mm:ss)
  static String? formatToServer(String uiDate) {
    if (uiDate.isEmpty || uiDate == "Sin fecha" || uiDate == "Sin entrega") {
      return null; // <--- Retorna null real si no hay fecha válida
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

  Map<String, dynamic> toJson() => {
    'sampleId': sampleId,
    'orderId': orderId,
    'sampleName': sampleName,
    'samplePhotoUrl': samplePhotoUrl,
    'samplePhotoId': samplePhotoId,
    // Si la cadena está vacía o es la de respaldo, el JSON llevará un null nativo
    'estimatedDeliveryDate':
        estimatedDeliveryDate.isEmpty || estimatedDeliveryDate == "Sin fecha"
        ? null
        : estimatedDeliveryDate,
    'realDeliveryDate':
        realDeliveryDate.isEmpty ||
            realDeliveryDate == "Sin fecha" ||
            realDeliveryDate == "Sin entrega"
        ? null
        : realDeliveryDate,
  };
}
