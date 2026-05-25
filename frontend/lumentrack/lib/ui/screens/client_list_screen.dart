import 'package:flutter/material.dart';
import '../../models/client_model.dart';
import '../../services/client_service.dart';
import 'client_form_screen.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  final ClientService _clientService = ClientService();
  List<Client> _clients = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    try {
      final data = await _clientService.fetchClients();
      setState(() {
        _clients = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al cargar clientes: $e")));
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "??";
    List<String> parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Administración de Clientes",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFFA8BCB1),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFA8BCB1)),
            )
          : RefreshIndicator(
              onRefresh: _loadClients,
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: _clients.length,
                itemBuilder: (context, index) {
                  final client = _clients[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFA8BCB1).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFA8BCB1),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _getInitials(client.clientName),
                            style: const TextStyle(
                              color: Color(0xFFA8BCB1),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        client.clientName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(client.companyName),
                      trailing: const Icon(
                        Icons.edit_note,
                        color: Color(0xFFA8BCB1),
                      ),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ClientFormScreen(client: client),
                          ),
                        );
                        if (result == true) _loadClients();
                      },
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFA8BCB1),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ClientFormScreen()),
          );
          if (result == true) _loadClients();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
