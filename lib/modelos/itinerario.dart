// lib/modelos/itinerario.dart

class Itinerario {
  int? id; // Puede ser nulo si aún no se guarda en la BD
  String titulo;
  String descripcion;
  DateTime fecha;
  bool sincronizado; // Para saber si ya fue enviado al servidor

  Itinerario({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    this.sincronizado = false,
  });

  // Convertir a mapa para guardar en SQLite o enviar a servidor
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'fecha': fecha.toIso8601String(),
      'sincronizado': sincronizado ? 1 : 0,
    };
  }

  // Crear objeto desde mapa (por ejemplo al leer de SQLite)
  factory Itinerario.fromMap(Map<String, dynamic> map) {
    return Itinerario(
      id: map['id'],
      titulo: map['titulo'],
      descripcion: map['descripcion'],
      fecha: DateTime.parse(map['fecha']),
      sincronizado: map['sincronizado'] == 1,
    );
  }
}
