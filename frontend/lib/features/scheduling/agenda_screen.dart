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

  @override
  Widget build(BuildContext context) {
    final appointments = mockAppointments
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
                onPressed: () {},
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
                        '${appointments.length} citas',
                        style: const TextStyle(color: OrbitColors.muted),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                if (appointments.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(48),
                    child: Text('No hay citas con este filtro.'),
                  )
                else
                  ...appointments.map(_appointmentTile),
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
      trailing: Chip(
        label: Text(item.status),
        side: BorderSide.none,
        backgroundColor: color.withValues(alpha: 0.12),
        labelStyle: TextStyle(color: color, fontSize: 12),
      ),
    );
  }
}
