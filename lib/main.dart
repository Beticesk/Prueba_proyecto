import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'pantallas/inicio.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// IMPORTANTE: Asegúrate de que esta ruta sea correcta para tu nuevo archivo
import 'package:prueba_proyecto_01/servicios/conexion_postgres.dart'; // <--- CAMBIO AQUÍ

Future<void> main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  WidgetsFlutterBinding.ensureInitialized();

  // CAMBIO: Obtener la instancia del Singleton y abrir la conexión
  final dbManager = PostgresDatabaseManager();
  try {
    await dbManager.openConnection();
    if (kDebugMode) {
      print('Conexión a PostgreSQL establecida en main.dart');
    }
  } catch (e) {
    if (kDebugMode) {
      print('ERROR: No se pudo conectar a PostgreSQL en main.dart: $e');
    }
    // Considera qué hacer si la conexión falla al inicio crítico de la app.
    // Podrías mostrar una pantalla de error o intentar reconectar.
  }


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Itinerarios',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const Inicio(),
    );
  }
}