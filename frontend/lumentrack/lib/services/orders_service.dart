import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/orders_model.dart';

class OrdersService {
  //static const String _baseUrl =
  //    "http://10.0.2.2:8082/lumentrack/samples/orders";
  static const String _baseUrl =
      "http://192.168.100.15:8082/lumentrack/samples/orders";

  Future<List<Order>> fetchOrders() async {
    final response = await http.get(Uri.parse("$_baseUrl/list"));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Order.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar las órdenes de producción');
    }
  }
}
