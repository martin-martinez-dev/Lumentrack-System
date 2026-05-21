import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/orders_model.dart';
import '../core/api_config.dart';

class OrdersService {
  // Centralizado usando la configuración unificada que creamos
  static const String _baseUrl = ApiConfig.orders;

  // Cabecera estándar para enviar y recibir payloads JSON en Spring Boot
  final Map<String, String> _headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  /// 1. Mapea a: getAllProjects() -> GET /api/orders/list
  Future<List<Order>> fetchOrders() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/list"));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Order.fromJson(item)).toList();
      } else {
        throw Exception(
          'Error al cargar la lista de proyectos: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión al listar proyectos: $e');
    }
  }

  /// 2. Mapea a: getOrderDetails(Integer orderId) -> GET /api/orders/details/{id}
  /// Devuelve la orden enriquecida con su 'sampleList' usando el OrdersViewModel
  Future<Order> fetchOrderDetails(int orderId) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/getOrderDetails/$orderId"),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return Order.fromJson(
          body,
        ); // El factory de Order ya procesa internamente la 'sampleList'
      } else if (response.statusCode == 404) {
        throw Exception('El proyecto solicitado no existe en el sistema.');
      } else {
        throw Exception('Error al obtener los detalles del proyecto.');
      }
    } catch (e) {
      throw Exception('Error de red al consultar el detalle: $e');
    }
  }

  /// 3. Mapea a: saveProject(Orders project) -> POST /api/orders/save (o tu ruta de creación)
  Future<Order> createOrder(Order order) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/save"),
        headers: _headers,
        body: jsonEncode(order.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return Order.fromJson(body);
      } else {
        throw Exception('No se pudo registrar el proyecto en el servidor.');
      }
    } catch (e) {
      throw Exception('Error de red al registrar proyecto: $e');
    }
  }

  /// 4. Mapea a: updateProject(Orders updatedProject) -> PUT /api/orders/update
  Future<Order> updateOrder(Order order) async {
    try {
      final response = await http.put(
        Uri.parse("$_baseUrl/update"),
        headers: _headers,
        body: jsonEncode(order.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return Order.fromJson(body);
      } else {
        throw Exception('Error al actualizar la información del proyecto.');
      }
    } catch (e) {
      throw Exception('Error de red al actualizar proyecto: $e');
    }
  }

  /// 5. Mapea a: deleteProjectById(Integer id) -> DELETE /api/orders/delete/{id}
  Future<void> deleteOrder(int orderId) async {
    try {
      final response = await http.delete(
        Uri.parse("$_baseUrl/delete/$orderId"),
        headers: _headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('El servidor rechazó la eliminación del proyecto.');
      }
    } catch (e) {
      throw Exception('Error de red al eliminar el proyecto: $e');
    }
  }
}
