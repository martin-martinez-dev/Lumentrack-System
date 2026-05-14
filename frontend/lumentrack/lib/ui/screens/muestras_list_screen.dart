import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/api_config.dart';
import '../../models/sample_model.dart';

class MuestrasListScreen extends StatefulWidget {
  const MuestrasListScreen({super.key});

  @override
  State<MuestrasListScreen> createState() => _MuestrasListScreenState();
}

class _MuestrasListScreenState extends State<MuestrasListScreen> {
  String _query = "";

  Future<List<Sample>> _fetch() async {
    final res = await http.get(Uri.parse("${ApiConfig.samples}list"));
    if (res.statusCode == 200) {
      List data = json.decode(res.body);
      return data.map((item) => Sample.fromJson(item)).toList();
    }
    throw Exception("Error");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Muestras')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar...',
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/nueva-muestra'),
              child: const Text("+ Nueva Muestra"),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Sample>>(
              future: _fetch(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final filtered = snap.data!
                    .where((s) => s.sampleName.contains(_query))
                    .toList();
                return ListView(
                  children: [
                    ExpansionTile(
                      title: const Text("En Progreso"),
                      initiallyExpanded: true,
                      children: filtered.map((s) => _item(s, theme)).toList(),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(Sample s, ThemeData theme) {
    return ListTile(
      title: Text(
        s.sampleName,
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: 0.6,
            color: const Color(0xFFD9B44A),
          ), // Dorado
          Text("Entrega: ${s.formattedEstimatedDeliveryDate}"),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
