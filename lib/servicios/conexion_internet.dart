// lib/servicios/conexion_internet.dart

import 'package:connectivity_plus/connectivity_plus.dart';

class ConexionInternet {
  final Connectivity _connectivity = Connectivity();

  Future<bool> hayConexion() async {
    final resultado = await _connectivity.checkConnectivity();
    return resultado != ConnectivityResult.none;
  }

  Stream<ConnectivityResult> get conexionStream {
    return _connectivity.onConnectivityChanged;
  }
}
