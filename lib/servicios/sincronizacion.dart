// lib/servicios/sincronizacion.dart

import 'dart:async';

import 'base_datos_local.dart';
import '../modelos/itinerario.dart';
import 'conexion_internet.dart';

class SincronizacionService {
  final BaseDatosLocal _baseDatos = BaseDatosLocal();
  final ConexionInternet _conexion = ConexionInternet();

  // Simula enviar datos a servidor (aquí pones tu llamada HTTP real)
  Future<bool> sincronizarItinerario(Itinerario it) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula retardo
    // Aquí iría lógica real, ej: http.post(...)

    // Por ahora, siempre exitoso:
    return true;
  }

  Future<void> sincronizarTodos() async {
    final hayInternet = await _conexion.hayConexion();

    if (!hayInternet) return;

    final noSincronizados = await _baseDatos.obtenerNoSincronizados();

    for (var itinerario in noSincronizados) {
      final exito = await sincronizarItinerario(itinerario);

      if (exito && itinerario.id != null) {
        await _baseDatos.marcarComoSincronizado(itinerario.id!);
      }
    }
  }
}
