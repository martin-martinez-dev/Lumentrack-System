import 'package:intl/intl.dart';

class DateFormatter {
  static const String serverFormat = 'yyyy-MM-dd';
  static const String uiFormat = 'dd/MM/yyyy';
  static const String uiDateTimeFormat = 'dd/MM/yyyy HH:mm';

  /// Convierte cualquier string de fecha del UI al formato que espera el Backend (LocalDate: yyyy-MM-dd)
  static String? toServer(String? uiDate) {
    if (uiDate == null ||
        uiDate.isEmpty ||
        uiDate.toLowerCase().contains('sin') ||
        uiDate.toLowerCase().contains('pendiente')) {
      return null;
    }

    try {
      DateTime parsedDate;
      // 1. Si ya viene en formato ISO (yyyy-MM-ddTHH:mm:ss)
      if (uiDate.contains('T')) {
        parsedDate = DateTime.parse(uiDate);
      }
      // 2. Si viene del UI con formato dd/MM/yyyy o dd/MM/yyyy HH:mm
      else if (uiDate.contains('/')) {
        String pattern = uiDate.contains(' ') ? uiDateTimeFormat : uiFormat;
        parsedDate = DateFormat(pattern).parse(uiDate);
      }
      // 3. Fallback para parseo estándar
      else {
        parsedDate = DateTime.parse(uiDate);
      }
      return DateFormat(serverFormat).format(parsedDate);
    } catch (e) {
      return null;
    }
  }

  /// Convierte fecha del servidor a formato amigable para la UI (dd/MM/yyyy)
  static String toUi(String? serverDate, {bool includeTime = false}) {
    if (serverDate == null ||
        serverDate.isEmpty ||
        serverDate.toLowerCase().contains('sin') ||
        serverDate.toLowerCase().contains('pendiente')) {
      return includeTime ? "Sin fecha" : "Sin entrega";
    }
    try {
      DateTime parsed = DateTime.parse(serverDate);
      return DateFormat(
        includeTime ? uiDateTimeFormat : uiFormat,
      ).format(parsed);
    } catch (e) {
      return serverDate;
    }
  }
}
