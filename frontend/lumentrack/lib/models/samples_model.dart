import 'component_model.dart'; // 🟢 Importamos el modelo de componentes que creamos previamente
import '../core/date_formatter.dart';

class Sample {
  // 1. Campos base de la tabla MySQL
  final int?
  sampleId; // Opcional porque una nueva muestra no tiene ID asignado aún
  final int orderId;
  final String sampleName;
  final String samplePhotoUrl;
  final String samplePhotoId;
  final String estimatedDeliveryDate;
  final String realDeliveryDate;

  // 2. Campos informativos (@Transient en Spring Boot)
  final String orderName;
  final List<Component> components; // 🟢 Integración de la jerarquía modular

  Sample({
    this.sampleId,
    required this.orderId,
    required this.sampleName,
    this.samplePhotoUrl = '',
    this.samplePhotoId = '',
    required this.estimatedDeliveryDate,
    required this.realDeliveryDate,
    this.orderName = 'Sin Orden',
    this.components = const [],
  });

  /// 3. Mapeo seguro contra nulos desde Spring Boot
  factory Sample.fromJson(Map<String, dynamic> json) {
    // Parseo de la lista de componentes de forma segura
    var list = json['components'] as List?;
    List<Component> componentList = list != null
        ? list.map((i) => Component.fromJson(i)).toList()
        : [];

    // Extraer datos del objeto relacional 'order' que viene del backend
    final orderMap = json['order'] as Map<String, dynamic>?;

    return Sample(
      sampleId: json['sampleId'] as int?,
      orderId:
          json['orderId'] ??
          (orderMap != null ? (orderMap['orderId'] ?? 0) : 0),
      sampleName: json['sampleName'] ?? '',
      samplePhotoUrl: json['samplePhotoUrl'] ?? '',
      samplePhotoId: json['samplePhotoId'] ?? '',
      estimatedDeliveryDate: json['estimatedDeliveryDate']?.toString() ?? '',
      realDeliveryDate: json['realDeliveryDate']?.toString() ?? '',
      orderName:
          json['orderName'] ??
          (orderMap != null
              ? (orderMap['orderName'] ?? 'Sin Orden')
              : 'Sin Orden'),
      components: componentList,
    );
  }

  /// 4. Conversión a JSON para enviar a los endpoints POST / PUT en Spring Boot
  Map<String, dynamic> toJson() => {
    'sampleId': sampleId,
    'orderId': orderId, // 🟢 Alineado con SampleRequest.orderId
    'sampleName': sampleName,
    'samplePhotoUrl': samplePhotoUrl,
    'samplePhotoId': samplePhotoId,
    'estimatedDeliveryDate': DateFormatter.toServer(estimatedDeliveryDate),
    'realDeliveryDate': DateFormatter.toServer(realDeliveryDate),
  };

  // =========================================================================
  // 5. GETTERS Y FORMATEADORES DE FECHA UNIFICADOS
  // =========================================================================

  String get formattedEstimatedDeliveryDate {
    if (estimatedDeliveryDate.isEmpty || estimatedDeliveryDate == "Sin fecha") {
      return "Sin fecha";
    }
    try {
      return DateFormatter.toUi(estimatedDeliveryDate, includeTime: true);
    } catch (e) {
      return estimatedDeliveryDate;
    }
  }

  String get formattedRealDeliveryDate {
    if (realDeliveryDate.isEmpty ||
        realDeliveryDate == "Sin fecha" ||
        realDeliveryDate == "Sin entrega") {
      return "Sin entrega";
    }
    try {
      return DateFormatter.toUi(realDeliveryDate, includeTime: true);
    } catch (e) {
      return realDeliveryDate;
    }
  }
}
