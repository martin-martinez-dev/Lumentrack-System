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
  final List<Sample> sampleList;

  Order({
    this.orderId,
    required this.orderNumber,
    required this.orderName,
    required this.clientId,
    this.clientName, // 🟢 Al no llevar 'required', es completamente opcional al instanciar
    required this.estimatedDeliveryDate,
    this.realDeliveryDate,
    this.sampleList = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var list = json['sampleList'] as List?;
    List<Sample> samples = list != null
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
      sampleList: samples,
    );
  }

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'orderNumber': orderNumber,
    'orderName': orderName,
    'clientId':
        clientId, // 🟢 Este es el ID relacional real que Hibernate usará para mapear
    'clientName':
        clientName, // Viajará null o el String si existía en la UI, sin provocar crashes
    'estimatedDeliveryDate': estimatedDeliveryDate,
    'realDeliveryDate': realDeliveryDate,
  };
}
