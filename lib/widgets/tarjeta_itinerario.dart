import 'package:flutter/material.dart';
import '../modelos/itinerario.dart';

class TarjetaItinerario extends StatelessWidget {
  final Itinerario itinerario;

  const TarjetaItinerario({super.key, required this.itinerario});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(
            itinerario.sincronizado ? Icons.cloud_done : Icons.cloud_off,
            color: itinerario.sincronizado ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itinerario.titulo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  itinerario.descripcion,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
