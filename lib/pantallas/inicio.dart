// lib/pantallas/inicio.dart

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:prueba_proyecto_01/servicios/conexion_internet.dart';
import 'package:prueba_proyecto_01/servicios/sincronizacion.dart';
// IMPORTANTE: Asegúrate de que esta ruta sea correcta para tu nuevo archivo
import 'package:prueba_proyecto_01/servicios/conexion_postgres.dart'; // <--- CAMBIO AQUÍ

import '../modelos/itinerario.dart';

import 'agregar_itinerario.dart';
import '/widgets/tarjeta_itinerario.dart';
import 'package:table_calendar/table_calendar.dart';


class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  // CAMBIO 1: El tipo de la variable ahora es PostgresDatabaseManager
  late final PostgresDatabaseManager _baseDatos;

  late SincronizacionService _syncService;
  late ConexionInternet _conexion;

  DateTime _fechaSeleccionada = DateTime.now();
  List<Itinerario> _itinerariosDelDia = [];


@override
void initState() {
  super.initState();
  // CAMBIO 2: Obtener la instancia del Singleton
  _baseDatos = PostgresDatabaseManager();

  _syncService = SincronizacionService();
  _conexion = ConexionInternet();

  // CAMBIO 3: Llamar al método openConnection() de la nueva clase
  _baseDatos.openConnection().then((_) {
    _cargarItinerariosDelDia(_fechaSeleccionada);

    // Sincronizar al iniciar si ya hay internet
    _syncService.sincronizarTodos().then((_) {
      _cargarItinerariosDelDia(_fechaSeleccionada);
    });
  }).catchError((error) { // ES BUENO AÑADIR UN CATCHERROR PARA ERRORES DE CONEXIÓN AL INICIO
    // Manejar el error de conexión aquí, por ejemplo, mostrar un mensaje al usuario
    if (kDebugMode) {
      print('Error al abrir la conexión a la base de datos al iniciar: $error');
    }
    // Considera mostrar un SnackBar o AlertDialog al usuario
  });


  // Escuchar cambios en la conexión
  _conexion.conexionStream.listen((result) {
    if (result != ConnectivityResult.none) {
      _syncService.sincronizarTodos().then((_) {
        _cargarItinerariosDelDia(_fechaSeleccionada);
      });
    }
  });
}

// Opcional pero recomendado: Sobrescribir dispose para cerrar la conexión
@override
void dispose() {
  _baseDatos.closeConnection(); // Cierra la conexión cuando el widget se destruye
  super.dispose();
}


  Future<void> _cargarItinerariosDelDia(DateTime fecha) async {
    // El resto de tu lógica para interactuar con _baseDatos debería funcionar
    // igual, ya que los nombres de los métodos (obtenerItinerarios, agregarItinerario)
    // son los mismos.
    final todos = await _baseDatos.obtenerItinerarios();
    final filtrados = todos.where((it) =>
        it.fecha.year == fecha.year &&
        it.fecha.month == fecha.month &&
        it.fecha.day == fecha.day).toList();

    setState(() {
      _fechaSeleccionada = fecha;
      _itinerariosDelDia = filtrados;
    });
  }

  void _abrirAgregarItinerario() async {
    // Abrir pantalla para agregar nuevo itinerario
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AgregarItinerario()),
    );

    if (resultado == true) {
      _cargarItinerariosDelDia(_fechaSeleccionada);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda de Itinerarios'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _fechaSeleccionada,
            selectedDayPredicate: (day) {
              return isSameDay(_fechaSeleccionada, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              _cargarItinerariosDelDia(selectedDay);
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _itinerariosDelDia.isEmpty
                ? const Center(child: Text('No hay itinerarios para este día'))
                : ListView.builder(
                    itemCount: _itinerariosDelDia.length,
                    itemBuilder: (context, index) {
                      final it = _itinerariosDelDia[index];

                      return TarjetaItinerario(itinerario: it);



                    },
                  ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirAgregarItinerario,
        child: const Icon(Icons.add),
      ),
    );
  }
}