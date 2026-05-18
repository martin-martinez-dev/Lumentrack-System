import 'package:flutter/material.dart';
import '../../models/samples_view_model.dart';
import '../../services/samples_service.dart';
import 'sample_form_screen.dart'; // <--- 1. IMPORTAMOS LA PANTALLA DE EDICIÓN Y DETALLE

class MuestrasListScreen extends StatefulWidget {
  const MuestrasListScreen({super.key});

  @override
  State<MuestrasListScreen> createState() => _MuestrasListScreenState();
}

class _MuestrasListScreenState extends State<MuestrasListScreen> {
  final SamplesService _samplesService = SamplesService();
  late Future<List<SampleView>> _futureSamples;

  @override
  void initState() {
    super.initState();
    _futureSamples = _samplesService.fetchSampleDetails();
  }

  // Función centralizada para refrescar el estado del FutureBuilder
  void _refrescarListado() {
    setState(() {
      _futureSamples = _samplesService.fetchSampleDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SampleView>>(
      future: _futureSamples,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error.toString());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyWidget();
        }

        final samples = snapshot.data!;

        return RefreshIndicator(
          color: const Color(0xFF934B3D),
          onRefresh: () async => _refrescarListado(),
          child: samples.isEmpty
              ? const Center(child: Text("No hay muestras disponibles"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: samples.length,
                  itemBuilder: (context, index) {
                    final sample = samples[index];
                    return _buildSampleCard(sample);
                  },
                ),
        );
      },
    );
  }

  Widget _buildSampleCard(SampleView sample) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Imagen de la luminaria (Corregida y centrada a todo lo ancho)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: sample.samplePhotoUrl.isNotEmpty
                ? Image.network(
                    sample.samplePhotoUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, e, s) => Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.lightbulb_outline,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
          ),

          // 2. Información Principal (Cuerpo del Card)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sample.sampleName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "Orden: ${sample.orderName}",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const Divider(height: 24),

                // 3. SECCIÓN INFERIOR: Acciones e Información de Entrega
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Entrega estimada:",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                          Text(
                            sample
                                .formattedEstimatedDeliveryDate, // <--- Usamos tu getter formateado dd/MM/yyyy
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF3E5B42),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Icono de acción que dispara la navegación integrada
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Color(0xFF934B3D),
                        size: 28,
                      ),
                      onPressed: () {
                        // 2. LLAMADA A LA FUNCIÓN DE NAVEGACIÓN REAL
                        _verDetallesMuestra(sample);
                      },
                      tooltip: 'Ver Detalles y Editar',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. LOGICA DE TRANSICIÓN INTERACTIVA CON RETORNO ASÍNCRONO
  void _verDetallesMuestra(SampleView sample) async {
    // Viaja a la pantalla enviando el objeto actual de la tarjeta
    final seModifico = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => SampleFormScreen(sample: sample)),
    );

    // Si al cerrar el formulario devolvió 'true' (exito en /update), refrescamos
    if (seModifico == true) {
      _refrescarListado();
    }
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
            const SizedBox(height: 16),
            const Text(
              'Error al cargar muestras',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _refrescarListado,
              child: const Text("Reintentar conexión"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return const Center(
      child: Text("No hay muestras registradas en la base de datos."),
    );
  }
}
