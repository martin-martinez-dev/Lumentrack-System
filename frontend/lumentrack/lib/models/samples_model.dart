import 'package:intl/intl.dart';
import 'component_model.dart'; // 🟢 Importamos el modelo de componentes que creamos previamente

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
  final List<Component> componentList; // 🟢 Integración de la jerarquía modular

  Sample({
    this.sampleId,
    required this.orderId,
    required this.sampleName,
    this.samplePhotoUrl = '',
    this.samplePhotoId = '',
    required this.estimatedDeliveryDate,
    required this.realDeliveryDate,
    this.orderName = 'Sin Orden',
    this.componentList = const [],
  });

  /// 3. Mapeo seguro contra nulos desde Spring Boot
  factory Sample.fromJson(Map<String, dynamic> json) {
    // Parseo de la lista de componentes de forma segura
    var list = json['componentList'] as List?;
    List<Component> components = list != null
        ? list.map((i) => Component.fromJson(i)).toList()
        : [];

    return Sample(
      sampleId: json['sampleId'] as int?,
      orderId: json['orderId'] ?? 0,
      sampleName: json['sampleName'] ?? '',
      samplePhotoUrl: json['samplePhotoUrl'] ?? '',
      samplePhotoId: json['samplePhotoId'] ?? '',
      estimatedDeliveryDate: json['estimatedDeliveryDate']?.toString() ?? '',
      realDeliveryDate: json['realDeliveryDate']?.toString() ?? '',
      orderName: json['orderName'] ?? 'Sin Orden',
      componentList: components,
    );
  }

  /// 4. Conversión a JSON para enviar a los endpoints POST / PUT en Spring Boot
  Map<String, dynamic> toJson() => {
    'sampleId': sampleId,
    'orderId': orderId,
    'sampleName': sampleName,
    'samplePhotoUrl': samplePhotoUrl,
    'samplePhotoId': samplePhotoId,
    // Formateo correcto para nulos nativos si están vacíos
    'estimatedDeliveryDate':
        (estimatedDeliveryDate.isEmpty || estimatedDeliveryDate == "Sin fecha")
        ? null
        : Sample.formatToServer(estimatedDeliveryDate),
    'realDeliveryDate':
        (realDeliveryDate.isEmpty ||
            realDeliveryDate == "Sin fecha" ||
            realDeliveryDate == "Sin entrega")
        ? null
        : Sample.formatToServer(realDeliveryDate),
    // Nota: 'orderName' y 'componentList' no se envían al guardar si el backend mapea crudo,
    // pero si usas cascada en Spring Boot puedes descomentar la siguiente línea:
    // 'componentList': componentList.map((e) => e.toJson()).toList(),
  };

  // =========================================================================
  // 5. GETTERS Y FORMATEADORES DE FECHA UNIFICADOS
  // =========================================================================

  String get formattedEstimatedDeliveryDate {
    if (estimatedDeliveryDate.isEmpty || estimatedDeliveryDate == "Sin fecha") {
      return "Sin fecha";
    }
    try {
      DateTime parsedDate = DateTime.parse(estimatedDeliveryDate);
      return DateFormat('dd/MM/yyyy HH:mm').format(parsedDate);
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
      DateTime parsedDate = DateTime.parse(realDeliveryDate);
      return DateFormat('dd/MM/yyyy HH:mm').format(parsedDate);
    } catch (e) {
      return realDeliveryDate;
    }
  }

  /// Convierte la fecha al formato simple yyyy-MM-dd para LocalDate en el Backend
  static String? formatToServer(String uiDate) {
    if (uiDate.isEmpty || uiDate == "Sin fecha" || uiDate == "Sin entrega") {
      return null;
    }

    try {
      DateTime parsedDate;

      // 1. Intentar parsear como yyyy-MM-dd HH:mm:ss
      if (uiDate.length == 19 && uiDate.contains('-') && uiDate.contains(' ')) {
        return uiDate;
      }
      // 2. Intentar parsear como ISO 8601
      else if (uiDate.contains('T')) {
        parsedDate = DateTime.parse(uiDate);
      }
      // 3. Intentar parsear como yyyy-MM-dd
      else if (uiDate.length == 10 && uiDate.contains('-')) {
        parsedDate = DateFormat('yyyy-MM-dd').parse(uiDate);
      }
      // 4. Intentar parsear formatos con barra (UI)
      else if (uiDate.contains('/')) {
        String pattern = uiDate.contains(' ')
            ? 'dd/MM/yyyy HH:mm'
            : 'dd/MM/yyyy';
        parsedDate = DateFormat(pattern).parse(uiDate);
      } else {
        parsedDate = DateTime.parse(uiDate);
      }

      // Retornamos solo la fecha para coincidir con LocalDate
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return null;
    }
  }
}
