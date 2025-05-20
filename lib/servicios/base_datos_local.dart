// lib/servicios/base_datos_local.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../modelos/itinerario.dart';

class BaseDatosLocal {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _inicializarDB();
    return _db!;
  }

  Future<Database> _inicializarDB() async {
    final rutaDB = await getDatabasesPath();
    final path = join(rutaDB, 'itinerarios.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _crearTablas,
    );
  }

  Future<void> _crearTablas(Database db, int version) async {
    await db.execute('''
      CREATE TABLE itinerarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT,
        descripcion TEXT,
        fecha TEXT,
        sincronizado INTEGER
      )
    ''');
  }

  Future<int> insertarItinerario(Itinerario itinerario) async {
    final dbClient = await db;
    return await dbClient.insert(
      'itinerarios',
      itinerario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Itinerario>> obtenerItinerarios() async {
    final dbClient = await db;
    final maps = await dbClient.query('itinerarios');

    return maps.map((mapa) => Itinerario.fromMap(mapa)).toList();
  }

  Future<List<Itinerario>> obtenerNoSincronizados() async {
    final dbClient = await db;
    final maps = await dbClient.query(
      'itinerarios',
      where: 'sincronizado = ?',
      whereArgs: [0],
    );

    return maps.map((mapa) => Itinerario.fromMap(mapa)).toList();
  }

  Future<void> marcarComoSincronizado(int id) async {
    final dbClient = await db;
    await dbClient.update(
      'itinerarios',
      {'sincronizado': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> eliminarItinerario(int id) async {
    final dbClient = await db;
    await dbClient.delete(
      'itinerarios',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> cerrarDB() async {
    final dbClient = await db;
    await dbClient.close();
  }
}
