class Denuncia {
  final int? id;
  final String titulo;
  final String descricao;
  final String imagemPath;
  final double latitude;
  final double longitude;
  final DateTime dataHora;

  Denuncia({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.imagemPath,
    required this.latitude,
    required this.longitude,
    required this.dataHora,
    required String data,
    required String tipo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'imagemPath': imagemPath,
      'latitude': latitude,
      'longitude': longitude,
      'dataHora': dataHora.toIso8601String(),
    };
  }

  factory Denuncia.fromMap(Map<String, dynamic> map) {
    return Denuncia(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      imagemPath: map['imagemPath'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      dataHora: DateTime.parse(map['dataHora']),
      data: '',
      tipo: '',
    );
  }
}
// TODO Implement this library.
