import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../db/db_helper.dart';
import '../models/denuncia_model.dart';

class NewDenunciaScreen extends StatefulWidget {
  const NewDenunciaScreen({super.key});

  @override
  State<NewDenunciaScreen> createState() => _NewDenunciaScreenState();
}

class _NewDenunciaScreenState extends State<NewDenunciaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  DateTime? _dataSelecionada;
  String? _tipoSelecionado;
  File? _imagem;

  LatLng? _localizacaoSelecionada;
  // ignore: unused_field
  GoogleMapController? _mapController;

  final List<String> _tipos = [
    'Poluição',
    'Violência',
    'Abandono',
    'Outros',
  ];

  void _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (data != null) {
      setState(() => _dataSelecionada = data);
    }
  }

  Future<void> _selecionarImagem(ImageSource origem) async {
    final picker = ImagePicker();
    final imagem = await picker.pickImage(source: origem);
    if (imagem != null) {
      final dir = await getApplicationDocumentsDirectory();
      final nome = p.basename(imagem.path);
      final destino = File('${dir.path}/$nome');
      await File(imagem.path).copy(destino.path);
      setState(() => _imagem = destino);
    }
  }

  Future<void> _salvarDenuncia() async {
    if (!_formKey.currentState!.validate() ||
        _dataSelecionada == null ||
        _tipoSelecionado == null ||
        _imagem == null ||
        _localizacaoSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Preencha todos os campos e selecione a localização e imagem.')),
      );
      return;
    }

    final denuncia = Denuncia(
      titulo: _tituloController.text,
      descricao: _descricaoController.text,
      data: _dataSelecionada!.toIso8601String(),
      tipo: _tipoSelecionado!,
      imagemPath: _imagem!.path,
      latitude: _localizacaoSelecionada!.latitude,
      longitude: _localizacaoSelecionada!.longitude,
      dataHora: DateTime.now(),
    );

    await DBHelper.instance.inserirDenuncia(denuncia);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Denúncia salva com sucesso!')),
    );

    Navigator.pop(context);
  }

  void _aoTocarNoMapa(LatLng posicao) {
    setState(() => _localizacaoSelecionada = posicao);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Denúncia')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) => v!.isEmpty ? 'Informe o título' : null,
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (v) => v!.isEmpty ? 'Informe a descrição' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(_dataSelecionada == null
                      ? 'Data não selecionada'
                      : 'Data: ${_dataSelecionada!.day}/${_dataSelecionada!.month}/${_dataSelecionada!.year}'),
                  const Spacer(),
                  TextButton(
                    onPressed: _selecionarData,
                    child: const Text('Selecionar Data'),
                  ),
                ],
              ),
              DropdownButtonFormField<String>(
                value: _tipoSelecionado,
                items: _tipos.map((tipo) {
                  return DropdownMenuItem(value: tipo, child: Text(tipo));
                }).toList(),
                onChanged: (v) => setState(() => _tipoSelecionado = v),
                decoration:
                    const InputDecoration(labelText: 'Tipo de denúncia'),
                validator: (v) => v == null ? 'Selecione um tipo' : null,
              ),
              const SizedBox(height: 16),
              _imagem == null
                  ? const Text('Nenhuma imagem selecionada')
                  : Image.file(_imagem!, height: 200),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () => _selecionarImagem(ImageSource.camera),
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo),
                    onPressed: () => _selecionarImagem(ImageSource.gallery),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Toque no mapa para escolher a localização:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 250,
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(-15.793889, -47.882778), // Brasília
                    zoom: 14,
                  ),
                  onMapCreated: (controller) => _mapController = controller,
                  onTap: _aoTocarNoMapa,
                  markers: _localizacaoSelecionada == null
                      ? {}
                      : {
                          Marker(
                            markerId: const MarkerId('local'),
                            position: _localizacaoSelecionada!,
                          ),
                        },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _salvarDenuncia,
                child: const Text('Salvar Denúncia'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
