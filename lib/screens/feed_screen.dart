import 'package:flutter/material.dart';
import 'dart:io';
import '../db/db_helper.dart';
import 'new_denuncia.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Map<String, dynamic>> _reports = [];

  void _loadReports() async {
    final data = await DBHelper.instance.getReports();
    setState(() {
      _reports = data;
    });
  }

  void _logout() {
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Denúncias'),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Sair'),
                  content: const Text('Deseja realmente sair da conta?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: _logout,
                      child: const Text('Sair'),
                    ),
                  ],
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage:
                    AssetImage('assets/user.png'), // Adicione esse arquivo
              ),
            ),
          ),
        ),
        body: _reports.isEmpty
            ? const Center(child: Text('Nenhuma denúncia cadastrada.'))
            : ListView.builder(
                itemCount: _reports.length,
                itemBuilder: (context, index) {
                  final report = _reports[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: report['imagePath'] != null
                          ? Image.file(
                              File(report['imagePath']),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.report),
                      title: Text(report['title'] ?? 'Sem título'),
                      subtitle: Text(report['description'] ?? 'Sem descrição'),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NewDenunciaScreen()),
            );
            _loadReports(); // Recarrega após voltar
          },
          child: const Icon(Icons.add),
        ));
  }
}
