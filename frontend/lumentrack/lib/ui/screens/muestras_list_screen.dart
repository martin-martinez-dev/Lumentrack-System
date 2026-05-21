import 'package:flutter/material.dart';
import '../../models/samples_model.dart';
import '../../services/samples_service.dart';
import 'sample_form_screen.dart';

class MuestrasListScreen extends StatefulWidget {
  const MuestrasListScreen({super.key});

  @override
  State<MuestrasListScreen> createState() => _MuestrasListScreenState();
}

class _MuestrasListScreenState extends State<MuestrasListScreen> {
  final SamplesService _samplesService = SamplesService();
  late Future<List<Sample>> _futureSamples;

  @override
  void initState() {
    super.initState();
    _refrescarListado();
  }

  void _refrescarListado() {
    setState(() {
      _futureSamples = _samplesService.fetchSampleDetails();
    });
  }

  void _nuevaMuestra() async {
    final seGuardo = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const SampleFormScreen()),
    );
    if (seGuardo == true) {
      _refrescarListado();
    }
  }

  void _editarMuestra(Sample sample) async {
    final seActualizo = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => SampleFormScreen(sample: sample)),
    );
    if (seActualizo == true) {
      _refrescarListado();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Listado de Muestras",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF3E5B42),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF934B3D),
        tooltip: 'Registrar Nueva Muestra',
        onPressed: _nuevaMuestra,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: FutureBuilder<List<Sample>>(
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
            child: ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: samples.length,
              itemBuilder: (context, index) {
                final sample = samples[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: sample.samplePhotoUrl.isNotEmpty
                            ? Image.network(
                                sample.samplePhotoUrl,
                                fit: BoxFit.cover,
                              )
                            : const Icon(
                                Icons.broken_image_outlined,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                    title: Text(
                      sample.sampleName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("Orden: ${sample.orderName}"),
                        Text("Entrega Real: ${sample.realDeliveryDate}"),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Color(0xFF3E5B42),
                    ),
                    onTap: () => _editarMuestra(sample),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
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
              'Error de comunicación',
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
      child: Text(
        "No hay muestras registradas en el sistema.",
        style: TextStyle(color: Colors.grey, fontSize: 16),
      ),
    );
  }
}
