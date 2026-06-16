import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/orders_model.dart';
import '../core/api_config.dart';
import '../core/session_manager.dart';

class OrdersService {
  // Centralizado usando la configuración unificada que creamos
  static const String _baseUrl = ApiConfig.orders;

  // 🟢 Getter dinámico para incluir el token JWT en cada petición
  Map<String, String> get _headers {
    final token = SessionManager().token;
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  /// 1. Mapea a: getAllProjects() -> GET /api/orders/list
  Future<List<Order>> fetchOrders() async {
    try {
      print("DEBUG: [Request] GET a Proyectos: $_baseUrl/list");
      final response = await http.get(
        Uri.parse("$_baseUrl/list"),
        headers: _headers,
      );

      print(
        "DEBUG: [Response] Proyectos [Status ${response.statusCode}]: ${response.body}",
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
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

  /// 🟢 Nuevo: Listar órdenes asignadas a un usuario (GET /orders/list/user/{userId})
  /// Requerido para el rol DESIGN
  Future<List<Order>> fetchOrdersByUserId(int userId) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/list/user/$userId"),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body.map((dynamic item) => Order.fromJson(item)).toList();
      }
      throw Exception(
        'Error al cargar órdenes del usuario: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception('Error de red al listar órdenes por usuario: $e');
    }
  }

  /// 🟢 Nuevo: Listar órdenes con detalles por userId (GET /orders/list/details/user/{userId})
  Future<List<Order>> fetchOrdersDetailsByUserId(int userId) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/list/details/user/$userId"),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body.map((dynamic item) => Order.fromJson(item)).toList();
      }
      throw Exception('Error al cargar detalles de órdenes del usuario');
    } catch (e) {
      throw Exception('Error de red al listar detalles por usuario: $e');
    }
  }

  /// 🟢 Nuevo: Búsqueda básica de orden por ID (GET /orders/search/{id})
  Future<Order?> searchOrderById(int id) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/search/$id"),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return Order.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == 404) {
      return null;
    }
    throw Exception('Error al buscar orden por ID: ${response.statusCode}');
  }

  /// 2. Mapea a: getOrderDetails(Integer orderId) -> GET /api/orders/details/{id}
  /// Devuelve la orden enriquecida con su 'sampleList' usando el OrdersViewModel
  Future<Order> fetchOrderDetails(int orderId) async {
    try {
      print(
        "DEBUG: [Request] GET Detalle Proyecto: $_baseUrl/getOrderDetails/$orderId",
      );
      final response = await http.get(
        Uri.parse("$_baseUrl/getOrderDetails/$orderId"),
        headers: _headers,
      );

      print(
        "DEBUG: [Response] Detalle Proyecto [Status ${response.statusCode}]: ${response.body}",
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
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
      final url = "$_baseUrl/save";
      final requestBody = jsonEncode(order.toJson());
      print(
        "DEBUG: [Request] POST Crear Proyecto a $url con body: $requestBody",
      );

      final response = await http.post(
        Uri.parse(url),
        headers: _headers,
        body: requestBody,
      );
      print(
        "DEBUG: [Response] Crear Proyecto [Status ${response.statusCode}]: ${response.body}",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> body = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
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
      final url = "$_baseUrl/update";
      final requestBody = jsonEncode(order.toJson());
      print(
        "DEBUG: [Request] POST Actualizar Proyecto a $url con body: $requestBody",
      );

      final response = await http.post(
        Uri.parse(url),
        headers: _headers,
        body: requestBody,
      );
      print(
        "DEBUG: [Response] Actualizar Proyecto [Status ${response.statusCode}]: ${response.body}",
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
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
      print("DEBUG: [Request] DELETE Proyecto: $_baseUrl/delete/$orderId");
      final response = await http.delete(
        Uri.parse("$_baseUrl/delete/$orderId"),
        headers: _headers,
      );

      print(
        "DEBUG: [Response] Borrar Proyecto [Status ${response.statusCode}]",
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('El servidor rechazó la eliminación del proyecto.');
      }
    } catch (e) {
      throw Exception('Error de red al eliminar el proyecto: $e');
    }
  }
}
