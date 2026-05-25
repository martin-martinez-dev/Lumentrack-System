import 'package:flutter/material.dart';
import '../../core/api_config.dart';

class CargaComponenteScreen extends StatefulWidget {
  const CargaComponenteScreen({super.key});

  @override
  State<CargaComponenteScreen> createState() => _CargaComponenteScreenState();
}

class _CargaComponenteScreenState extends State<CargaComponenteScreen> {
  bool _isExternal = false;
  String? _material;
  String? _employee;

  void _save() {
    // Al usar ApiConfig y las variables, los warnings 1, 2 y 3 desaparecen
    final url = "${ApiConfig.components}save";
    print("Enviando a $url: $_material, $_employee, $_isExternal");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Carga de Componentes",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFFD9B44A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ... (otros campos)
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(value: "1", child: Text("Aluminio")),
              ],
              onChanged: (v) =>
                  setState(() => _material = v), // Sin cast (Warning 4)
              decoration: const InputDecoration(labelText: "Tipo de Material"),
            ),
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(value: "1", child: Text("Luis Salazar")),
              ],
              onChanged: (v) =>
                  setState(() => _employee = v), // Sin cast (Warning 5)
              decoration: const InputDecoration(labelText: "Empleado de Ula"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD9B44A),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Guardar Componente"),
            ),
          ],
        ),
      ),
    );
  }
}
