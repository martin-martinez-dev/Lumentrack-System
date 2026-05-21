import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/cloudinary_response_model.dart';
import '../core/api_config.dart';

class ImagesService {
  /// Sube cualquier archivo de imagen al servidor de Spring Boot de forma genérica
  /// [imageFile] es el archivo File binario de la cámara o galería
  /// [folderName] es la carpeta de destino en Cloudinary (ej: "samples", "users", "fixtures")

  // Escritorio
  static const String _baseUrl = ApiConfig.images;

  Future<CloudinaryResponse> uploadImage(
    File imageFile,
    String folderName,
  ) async {
    // Creamos la petición Multipart POST
    final request = http.MultipartRequest(
      'POST',
      Uri.parse("$_baseUrl/upload"),
    );

    // Adjuntamos el parámetro de la carpeta destino que espera tu @RequestParam
    request.fields['folder'] = folderName;

    // Abrimos el stream del archivo físico
    final stream = http.ByteStream(imageFile.openRead());
    final length = await imageFile.length();

    final multipartFile = http.MultipartFile(
      'file', // Debe coincidir con @RequestParam("file") en tu Java Controller
      stream,
      length,
      filename: imageFile.path.split('/').last,
    );

    request.files.add(multipartFile);

    // Enviamos el stream HTTP al puerto 8082
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return CloudinaryResponse.fromJson(responseData);
    } else {
      throw Exception(
        'Error al subir imagen a Cloudinary. Status: ${response.statusCode}',
      );
    }
  }
}
