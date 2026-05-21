class Client {
  final int?
  clientId; // Nullable por si se usa en un flujo de creación antes de persistir en base de datos
  final String clientName;
  final String companyName;
  final String clientContactName;
  final String clientPhoneNumber;
  final String clientMail;
  final String ulaLightEmployee;

  Client({
    this.clientId,
    required this.clientName,
    required this.companyName,
    required this.clientContactName,
    required this.clientPhoneNumber,
    required this.clientMail,
    required this.ulaLightEmployee,
  });

  // Factory para deserealizar las respuestas del ClientController de Spring Boot
  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      clientId: json['clientId'],
      clientName: json['clientName'] ?? '',
      companyName: json['companyName'] ?? '',
      clientContactName: json['clientContactName'] ?? '',
      clientPhoneNumber: json['clientPhoneNumber'] ?? '',
      clientMail: json['clientMail'] ?? '',
      ulaLightEmployee: json['ulaLightEmployee'] ?? '',
    );
  }

  // Método para serializar a JSON en peticiones POST/PUT como /clients/save
  Map<String, dynamic> toJson() => {
    'clientId': clientId,
    'clientName': clientName,
    'companyName': companyName,
    'clientContactName': clientContactName,
    'clientPhoneNumber': clientPhoneNumber,
    'clientMail': clientMail,
    'ulaLightEmployee': ulaLightEmployee,
  };
}
