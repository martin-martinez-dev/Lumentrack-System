class ApiConfig {
  static const String baseUrl =
      //"http://10.0.2.2:8080/lumentrack"; // IP de emulador
      //"http://192.168.100.15"; // IP en casa
      "http://192.168.1.99"; // IP en Ula
  //"http://192.168.100.16"; // IP en casa de Mex

  static const String dashboard = "$baseUrl:8081/lumentrack/dashboard/getData";
  static const String samples = "$baseUrl:8082/lumentrack/samples/samples";
  static const String images = "$baseUrl:8082/lumentrack/samples/images";
  static const String orders = "$baseUrl:8082/lumentrack/samples/orders";
  static const String components =
      "$baseUrl:8082/lumentrack/samples/components";
  static const String clients = "$baseUrl:8082/lumentrack/samples/clients";
  static const String tasks = "$baseUrl:8082/lumentrack/samples/tasks";
  static const String users = "$baseUrl:8082/lumentrack/samples/users";
  static const String materials = "$baseUrl:8082/lumentrack/samples/materials";
}
