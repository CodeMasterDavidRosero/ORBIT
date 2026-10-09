import 'package:flutter/material.dart';

import '../../core/theme/orbit_colors.dart';

class UiStatesScreen extends StatefulWidget {
  const UiStatesScreen({super.key});
  @override
  State<UiStatesScreen> createState() => _UiStatesScreenState();
}

class _UiStatesScreenState extends State<UiStatesScreen> {
  int active = 0;
  final states = const [
    'Cargando',
    'Vacío',
    'Error',
    'Sin permiso',
    'Sesión expirada',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estados UI',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: OrbitColors.navy,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Patrones comunes para una experiencia clara y segura',
            style: TextStyle(color: OrbitColors.muted),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              states.length,
              (index) => ChoiceChip(
                label: Text(states[index]),
                selected: active == index,
                onSelected: (_) => setState(() => active = index),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: _stateContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stateContent() {
    return switch (active) {
      0 => const Column(
        children: [
          CircularProgressIndicator(color: OrbitColors.blue),
          SizedBox(height: 20),
          Text(
            'Cargando información segura...',
            style: TextStyle(color: OrbitColors.muted),
          ),
        ],
      ),
      1 => _message(
        Icons.people_outline,
        'No hay pacientes para mostrar',
        'Prueba con otra búsqueda o registra un paciente nuevo.',
        'Crear paciente',
      ),
      2 => _message(
        Icons.cloud_off_outlined,
        'No pudimos cargar la información',
        'Revisa tu conexión y vuelve a intentarlo.',
        'Reintentar',
      ),
      3 => _message(
        Icons.lock_outline,
        'No tienes permisos para esta acción',
        'Solicita acceso al administrador de tu organización.',
        'Volver',
      ),
      _ => _message(
        Icons.timer_off_outlined,
        'Tu sesión terminó',
        'Inicia sesión nuevamente para continuar trabajando.',
        'Iniciar sesión',
      ),
    };
  }

  Widget _message(IconData icon, String title, String detail, String action) {
    return Column(
      children: [
        Icon(icon, size: 52, color: OrbitColors.blue),
        const SizedBox(height: 18),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: OrbitColors.navy,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          detail,
          textAlign: TextAlign.center,
          style: const TextStyle(color: OrbitColors.muted),
        ),
        const SizedBox(height: 24),
        FilledButton(onPressed: () {}, child: Text(action)),
      ],
    );
  }
}
