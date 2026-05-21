class CloudinaryResponse {
  final String url;
  final String publicId;

  CloudinaryResponse({required this.url, required this.publicId});

  // Mapeo seguro para transformar el JSON del puerto 8082 a un objeto Dart
  factory CloudinaryResponse.fromJson(Map<String, dynamic> json) {
    return CloudinaryResponse(
      url: json['url'] ?? '',
      publicId: json['publicId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'url': url, 'publicId': publicId};
}
