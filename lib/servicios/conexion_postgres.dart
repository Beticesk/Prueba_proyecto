import 'package:postgres/postgres.dart';
import '../modelos/itinerario.dart';
import 'package:flutter/foundation.dart'; // Para kDebugMode

class PostgresDatabaseManager {
  // Patrón Singleton para asegurar una única instancia de la conexión
  static final PostgresDatabaseManager _instance = PostgresDatabaseManager._internal();
  factory PostgresDatabaseManager() {
    return _instance;
  }
  PostgresDatabaseManager._internal();

  PostgreSQLConnection? _connection; // Puede ser nulo si no está conectado

  Future<void> openConnection() async {
    if (_connection == null || _connection!.isClosed) {
      _connection = PostgreSQLConnection(
        'localhost', // IP o hostname del servidor PostgreSQL
        5432, // Puerto por defecto
        'agenda_flutter', // Nombre de tu base de datos
        username: 'postgres', // Usuario por defecto de PostgreSQL
        password: '159753', // Tu contraseña
      );
      try {
        await _connection!.open();
        if (kDebugMode) {
          print('Conectado a PostgreSQL');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error al conectar a PostgreSQL: $e');
        }
        _connection = null; // Resetear la conexión si falla
        rethrow; // Relanzar la excepción para que el llamador la maneje
      }
    }
  }

  Future<void> closeConnection() async {
    if (_connection != null && !_connection!.isClosed) {
      await _connection!.close();
      if (kDebugMode) {
        print('Conexión a PostgreSQL cerrada');
      }
      _connection = null;
    }
  }

  Future<List<Itinerario>> obtenerItinerarios() async {
    await openConnection(); // Asegura que la conexión esté abierta
    if (_connection == null) {
      throw Exception('No hay conexión a la base de datos.');
    }
    final resultados = await _connection!.query('SELECT * FROM itinerarios');

    return resultados.map((fila) {
      return Itinerario(
        id: fila[0],
        titulo: fila[1],
        descripcion: fila[2],
        fecha: fila[3],
        sincronizado: true,
      );
    }).toList();
  }

  Future<void> agregarItinerario(Itinerario it) async {
    await openConnection(); // Asegura que la conexión esté abierta
    if (_connection == null) {
      throw Exception('No hay conexión a la base de datos.');
    }
    await _connection!.query(
      'INSERT INTO itinerarios (titulo, descripcion, fecha) VALUES (@titulo, @descripcion, @fecha)',
      substitutionValues: {
        'titulo': it.titulo,
        'descripcion': it.descripcion,
        'fecha': it.fecha.toIso8601String(),
      },
    );
  }

  // Si necesitas el método de mappedResultsQuery, también agrégalo aquí
  Future<List<Map<String, dynamic>>> obtenerItinerariosMapped() async {
    await openConnection();
    if (_connection == null) {
      throw Exception('No hay conexión a la base de datos.');
    }
    final resultados = await _connection!.mappedResultsQuery('SELECT * FROM itinerarios');
    return resultados.map((row) => row.values.first).toList();
  }
}