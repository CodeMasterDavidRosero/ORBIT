import 'package:flutter/material.dart';

import '../../core/theme/orbit_colors.dart';

class EncountersScreen extends StatefulWidget {
  const EncountersScreen({super.key});
  @override
  State<EncountersScreen> createState() => _EncountersScreenState();
}

class _EncountersScreenState extends State<EncountersScreen> {
  int step = 0;
  bool saved = true;
  bool signed = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Atenciones',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: OrbitColors.navy,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Flujo clínico de demostración con datos sintéticos',
                    style: TextStyle(color: OrbitColors.muted),
                  ),
                ],
              ),
              Chip(
                label: Text(saved ? 'Guardado' : 'Cambios sin guardar'),
                avatar: Icon(
                  saved ? Icons.cloud_done : Icons.cloud_off,
                  size: 18,
                ),
                backgroundColor: saved
                    ? OrbitColors.successSoft
                    : OrbitColors.warningSoft,
                side: BorderSide.none,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  _step('1', 'Admisión', step >= 0),
                  _line(),
                  _step('2', 'Nota', step >= 1),
                  _line(),
                  _step('3', 'Datos clínicos', step >= 2),
                  _line(),
                  _step('4', 'Cierre', step >= 3),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (step == 0)
            _admission()
          else if (step == 1)
            _note()
          else if (step == 2)
            _clinicalData()
          else
            _closing(),
        ],
      ),
    );
  }

  Widget _step(String number, String label, bool active) => Expanded(
    child: Column(
      children: [
        CircleAvatar(
          radius: 17,
          backgroundColor: active ? OrbitColors.blue : OrbitColors.border,
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: active ? OrbitColors.navy : OrbitColors.muted,
            fontWeight: active ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      ],
    ),
  );

  Widget _line() => Container(width: 24, height: 1, color: OrbitColors.border);

  Widget _admission() => _panel('Admisión e inicio de atención', [
    const ListTile(
      leading: CircleAvatar(
        backgroundColor: OrbitColors.blueSoft,
        child: Text('M'),
      ),
      title: Text(
        'María Fernanda López',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text('CC 52.381.902 · Consulta de control'),
    ),
    const Divider(),
    const Text(
      'Confirma la identidad del paciente y los datos de la cita antes de abrir el episodio.',
      style: TextStyle(color: OrbitColors.muted),
    ),
    const SizedBox(height: 20),
    Align(
      alignment: Alignment.centerRight,
      child: FilledButton.icon(
        onPressed: () => setState(() => step = 1),
        icon: const Icon(Icons.play_arrow),
        label: const Text('Iniciar atención'),
      ),
    ),
  ]);

  Widget _note() => _panel('Nota clínica', [
    const Text(
      'Paciente, profesional y cita permanecen vinculados a esta atención.',
      style: TextStyle(color: OrbitColors.muted),
    ),
    const SizedBox(height: 16),
    TextFormField(
      initialValue: 'Motivo de consulta: control de seguimiento.',
      maxLines: 3,
      onChanged: (_) => setState(() => saved = false),
      decoration: const InputDecoration(
        labelText: 'Motivo de consulta',
        border: OutlineInputBorder(),
      ),
    ),
    const SizedBox(height: 14),
    TextFormField(
      initialValue:
          'Paciente refiere evolución favorable. Se revisan recomendaciones.',
      maxLines: 5,
      onChanged: (_) => setState(() => saved = false),
      decoration: const InputDecoration(
        labelText: 'Observaciones',
        border: OutlineInputBorder(),
      ),
    ),
    const SizedBox(height: 16),
    Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () => setState(() => saved = true),
          child: const Text('Guardar borrador'),
        ),
        const SizedBox(width: 12),
        FilledButton(
          onPressed: () => setState(() => step = 2),
          child: const Text('Continuar'),
        ),
      ],
    ),
  ]);

  Widget _clinicalData() => _panel('Datos clínicos estructurados', [
    const Text(
      'Registra información con unidad, procedencia y fecha.',
      style: TextStyle(color: OrbitColors.muted),
    ),
    const SizedBox(height: 16),
    Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _dataCard(
          'Presión arterial',
          '120/80 mmHg',
          Icons.monitor_heart_outlined,
        ),
        _dataCard('Frecuencia cardíaca', '72 lpm', Icons.favorite_border),
        _dataCard('Alergias', 'No refiere', Icons.warning_amber_outlined),
      ],
    ),
    const SizedBox(height: 20),
    Align(
      alignment: Alignment.centerRight,
      child: FilledButton(
        onPressed: () => setState(() => step = 3),
        child: const Text('Revisar y cerrar'),
      ),
    ),
  ]);

  Widget _dataCard(String title, String value, IconData icon) => SizedBox(
    width: 220,
    child: Card(
      color: OrbitColors.canvas,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: OrbitColors.blue),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: OrbitColors.muted,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  Widget _closing() =>
      _panel(signed ? 'Atención confirmada' : 'Confirmar atención', [
        const ListTile(
          leading: Icon(Icons.verified_outlined, color: OrbitColors.success),
          title: Text('Resumen listo para confirmación'),
          subtitle: Text(
            'La nota quedará en solo lectura y cualquier corrección posterior será una adenda.',
          ),
        ),
        const SizedBox(height: 16),
        if (!signed)
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: () => setState(() => signed = true),
              icon: const Icon(Icons.lock_outline),
              label: const Text('Confirmar nota'),
            ),
          )
        else
          const Text(
            'Nota confirmada. Puede consultarse el historial de versiones.',
            style: TextStyle(
              color: OrbitColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
      ]);

  Widget _panel(String title, List<Widget> children) => Card(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: OrbitColors.navy,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    ),
  );
}
