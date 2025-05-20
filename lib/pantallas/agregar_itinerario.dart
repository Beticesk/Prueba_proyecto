// lib/pantallas/agregar_itinerario.dart

import 'package:flutter/material.dart';
import '../modelos/itinerario.dart';
import '../servicios/base_datos_local.dart';

class AgregarItinerario extends StatefulWidget {
  const AgregarItinerario({super.key});

  @override
  State<AgregarItinerario> createState() => _AgregarItinerarioState();
}

class _AgregarItinerarioState extends State<AgregarItinerario> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  DateTime _fechaSeleccionada = DateTime.now();

  final BaseDatosLocal _baseDatos = BaseDatosLocal();

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = picked;
      });
    }
  }

  Future<void> _guardarItinerario() async {
    if (_formKey.currentState!.validate()) {
      final nuevoItinerario = Itinerario(
        titulo: _tituloController.text,
        descripcion: _descripcionController.text,
        fecha: _fechaSeleccionada,
      );

      await _baseDatos.insertarItinerario(nuevoItinerario);

      // ignore: use_build_context_synchronously
      Navigator.pop(context, true); // Regresa true para indicar éxito
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Itinerario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa una descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Fecha: '),
                  Text(
                    '${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => _seleccionarFecha(context),
                    child: const Text('Seleccionar fecha'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _guardarItinerario,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
