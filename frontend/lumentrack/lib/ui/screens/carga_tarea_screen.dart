import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/api_config.dart';
import '../../models/task_model.dart';

class CargaTareaScreen extends StatefulWidget {
  const CargaTareaScreen({super.key});

  @override
  State<CargaTareaScreen> createState() => _CargaTareaScreenState();
}

class _CargaTareaScreenState extends State<CargaTareaScreen> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _save() async {
    if (_selectedDate == null) return;

    //final task = Task(
    //  taskName: _nameCtrl.text,
    //  taskDescription: _descCtrl.text,
    //  taskEstimatedDate: _selectedDate!,
    //);

    //final res = await http.post(
    //  Uri.parse("${ApiConfig.tasks}save"),
    //  headers: {'Content-Type': 'application/json'},
    //  body: jsonEncode(task.toJson()),
    //);

    //if (res.statusCode == 200 && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Carga de Tareas",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFFD9B44A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: "Nombre de Tarea"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Descripción"),
            ),
            const SizedBox(height: 15),
            ListTile(
              title: Text(
                _selectedDate == null
                    ? "Seleccionar Fecha"
                    : _selectedDate.toString(),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9B44A),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Guardar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
