import 'dart:io';
import 'package:flutter/material.dart';

class ImageViewerScreen extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
  final String title;

  const ImageViewerScreen({
    super.key,
    this.imageUrl,
    this.imageFile,
    this.title = "Visualizador de Imagen",
  }) : assert(
         imageUrl != null || imageFile != null,
         'Se debe proporcionar una URL o un archivo de imagen.',
       );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black, // Fondo negro para la app bar
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // El fondo del cuerpo es negro para una mejor experiencia de visualización
      backgroundColor: Colors.black,
      body: Center(
        child: InteractiveViewer(
          boundaryMargin: const EdgeInsets.all(20.0),
          minScale: 0.1,
          maxScale: 4.0,
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit
                      .contain, // Asegura que la imagen se ajuste y permita zoom
                )
              : (imageFile != null
                    ? Image.file(imageFile!, fit: BoxFit.contain)
                    : const Center(
                        child: Text(
                          "Imagen no disponible",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )),
        ),
      ),
    );
  }
}
