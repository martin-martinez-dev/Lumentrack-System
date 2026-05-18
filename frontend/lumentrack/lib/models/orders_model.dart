class Order {
  final int? orderId;
  final int orderNumber;
  final String orderName;
  final int clientId;
  final String estimatedDeliveryDate;
  final String? realDeliveryDate;

  Order({
    this.orderId,
    required this.orderNumber,
    required this.orderName,
    required this.clientId,
    required this.estimatedDeliveryDate,
    this.realDeliveryDate,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      orderNumber: json['orderNumber'] ?? 0,
      orderName: json['orderName'] ?? '',
      clientId: json['clientId'] ?? 0,
      estimatedDeliveryDate: json['estimatedDeliveryDate'] ?? '',
      realDeliveryDate: json['realDeliveryDate'],
    );
  }

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'orderNumber': orderNumber,
    'orderName': orderName,
    'clientId': clientId,
    'estimatedDeliveryDate': estimatedDeliveryDate,
    'realDeliveryDate': realDeliveryDate,
  };
}
