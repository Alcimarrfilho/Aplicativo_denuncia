import 'package:meu_app/models/denuncia_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/user_model.dart';

class DBHelper {
  DBHelper._privateConstructor(); // construtor privado
  static final DBHelper instance = DBHelper._privateConstructor(); // singleton

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> get database async => await db;

  Future<Database> initDb() async {
    final path = join(await getDatabasesPath(), 'usuarios.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            senha TEXT
          )
        ''');
        await db.execute('''

          CREATE TABLE denuncias (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          titulo TEXT NOT NULL,
          descricao TEXT NOT NULL,
          imagemPath TEXT NOT NULL,
          latitude REAL NOT NULL,
          longitude REAL NOT NULL,
          dataHora TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> cadastrarUsuario(User user) async {
    final banco = await db;
    return await banco.insert('usuarios', user.toMap());
  }

  Future<User?> autenticar(String email, String senha) async {
    final banco = await db;
    final result = await banco.query(
      'usuarios',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<User?> buscarPorEmail(String email) async {
    final banco = await db;
    final result = await banco.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getReports() async {
    final banco = await db;
    return await banco.query('denuncias'); // Substitua pelo nome real da tabela
  }

  // INSERIR denúncia
  Future<int> inserirDenuncia(Denuncia denuncia) async {
    final db = await this.db;
    return await db.insert('denuncias', denuncia.toMap());
  }

// LISTAR todas as denúncias
  Future<List<Denuncia>> listarDenuncias() async {
    final db = await this.db;
    final maps = await db.query('denuncias', orderBy: 'dataHora DESC');

    return maps.map((map) => Denuncia.fromMap(map)).toList();
  }

// DELETAR denúncia
  Future<int> deletarDenuncia(int id) async {
    final db = await database;
    return await db.delete('denuncias', where: 'id = ?', whereArgs: [id]);
  }
}
