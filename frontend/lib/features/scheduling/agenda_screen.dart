import 'package:flutter/material.dart';

import '../../core/theme/orbit_colors.dart';
import 'appointment.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});
  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  String filter = 'Todas';
  final filters = const ['Todas', 'Confirmada', 'Pendiente', 'Cancelada'];
  late List<Appointment> appointments = [...mockAppointments];

  @override
  Widget build(BuildContext context) {
    final visibleAppointments = appointments
        .where((item) => filter == 'Todas' || item.status == filter)
        .toList();
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
                    'Agenda',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: OrbitColors.navy,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Martes, 13 de octubre de 2026',
                    style: TextStyle(color: OrbitColors.muted),
                  ),
                ],
              ),
              FilledButton.icon(
                onPressed: _scheduleAppointment,
                icon: const Icon(Icons.add),
                label: const Text('Agendar cita'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chevron_left),
                label: const Text('Anterior'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.today_outlined),
                label: const Text('Hoy'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chevron_right),
                label: const Text('Siguiente'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            children: filters
                .map(
                  (item) => ChoiceChip(
                    label: Text(item),
                    selected: filter == item,
                    onSelected: (_) => setState(() => filter = item),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Icon(Icons.person_outline, color: OrbitColors.blue),
                      const SizedBox(width: 10),
                      const Text(
                        'Dra. Rivera · Medicina general',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Text(
                        '${visibleAppointments.length} citas',
                        style: const TextStyle(color: OrbitColors.muted),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                if (visibleAppointments.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(48),
                    child: Text('No hay citas con este filtro.'),
                  )
                else
                  ...visibleAppointments.map(_appointmentTile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _appointmentTile(Appointment item) {
    final color = item.status == 'Confirmada'
        ? OrbitColors.success
        : item.status == 'Pendiente'
        ? OrbitColors.warning
        : OrbitColors.muted;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: SizedBox(
        width: 56,
        child: Text(
          item.time,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: OrbitColors.navy,
          ),
        ),
      ),
      title: Text(
        item.patient,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(item.type),
      trailing: PopupMenuButton<String>(
        tooltip: 'Acciones de cita',
        onSelected: (action) => _appointmentAction(item, action),
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'reschedule', child: Text('Reprogramar')),
          PopupMenuItem(value: 'cancel', child: Text('Cancelar')),
        ],
        child: Chip(
          label: Text(item.status),
          side: BorderSide.none,
          backgroundColor: color.withValues(alpha: 0.12),
          labelStyle: TextStyle(color: color, fontSize: 12),
        ),
      ),
    );
  }

  void _appointmentAction(Appointment item, String action) {
    setState(() {
      appointments = appointments.map((current) {
        if (current != item) return current;
        if (action == 'cancel') {
          return Appointment(
            current.time,
            current.patient,
            current.type,
            'Cancelada',
          );
        }
        return Appointment('15:30', current.patient, current.type, 'Pendiente');
      }).toList();
    });
  }

  void _scheduleAppointment() {
    final patient = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Agendar cita'),
        content: TextField(
          controller: patient,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Paciente'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (patient.text.trim().isEmpty) return;
              setState(
                () => appointments = [
                  ...appointments,
                  Appointment(
                    '16:00',
                    patient.text.trim(),
                    'Consulta general',
                    'Pendiente',
                  ),
                ],
              );
              Navigator.pop(context);
            },
            child: const Text('Agendar'),
          ),
        ],
      ),
    );
  }
}
