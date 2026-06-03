import 'samples_model.dart';

class Order {
  final int? orderId;
  final String orderNumber;
  final String orderName;
  final int clientId;
  final String?
  clientName; // 🟢 Permite nulos de forma nativa para el Null Safety de Dart
  final String estimatedDeliveryDate;
  final String? realDeliveryDate;
  final List<Sample> samples;

  Order({
    this.orderId,
    required this.orderNumber,
    required this.orderName,
    required this.clientId,
    this.clientName, // 🟢 Al no llevar 'required', es completamente opcional al instanciar
    required this.estimatedDeliveryDate,
    this.realDeliveryDate,
    this.samples = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var list = json['samples'] as List?;
    List<Sample> samplesList = list != null
        ? list.map((i) => Sample.fromJson(i)).toList()
        : [];

    return Order(
      orderId: json['orderId'],
      orderNumber: (json['orderNumber']?.toString()) ?? '',
      orderName: json['orderName'] ?? '',
      clientId: json['clientId'] ?? 0,
      clientName:
          json['clientName'], // Si el JSON no trae el campo, se setea como null automáticamente
      estimatedDeliveryDate: json['estimatedDeliveryDate'] ?? '',
      realDeliveryDate: json['realDeliveryDate'],
      samples: samplesList,
    );
  }

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'orderNumber': orderNumber,
    'orderName': orderName,
    'clientId':
        clientId, // 🟢 Este es el ID relacional real que Hibernate usará para mapear
    'clientName': clientName,
    'estimatedDeliveryDate': estimatedDeliveryDate,
    'realDeliveryDate': realDeliveryDate,
    // 🟢 Agregamos la serialización de muestras para soporte de cascada en el backend
    if (samples.isNotEmpty) 'samples': samples.map((e) => e.toJson()).toList(),
  };
}
