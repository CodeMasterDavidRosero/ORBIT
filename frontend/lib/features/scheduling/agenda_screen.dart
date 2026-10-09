import 'package:flutter/material.dart';

import '../../core/theme/orbit_colors.dart';
import 'appointment.dart';

enum AgendaView { month, week, day }

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});
  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  static const workStart = 7;
  static const workEnd = 19;
  static const pauseStart = 12;
  static const pauseEnd = 13;
  static const serviceDurations = <String, int>{
    'Consulta general': 30,
    'Consulta de control': 60,
    'Valoración inicial': 90,
    'Procedimiento': 120,
  };
  AgendaView view = AgendaView.week;
  DateTime selectedDate = defaultDate;
  String professional = 'Dra. Rivera';
  String site = 'Sede principal';
  TimeOfDay workStartTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay workEndTime = const TimeOfDay(hour: 19, minute: 0);
  String filter = 'Todas';
  final filters = const ['Todas', 'Confirmada', 'Pendiente', 'Cancelada'];
  late List<Appointment> appointments = [...mockAppointments];
  List<Appointment> get visible => appointments
      .where((a) => filter == 'Todas' || a.status == filter)
      .toList();
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(32),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Agenda',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: OrbitColors.navy,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _label(),
                  style: const TextStyle(color: OrbitColors.muted),
                ),
              ],
            ),
            FilledButton.icon(
              onPressed: _add,
              icon: const Icon(Icons.add),
              label: const Text('Agendar cita'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _toolbar(),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: filters
              .map(
                (f) => ChoiceChip(
                  label: Text(f),
                  selected: filter == f,
                  onSelected: (_) => setState(() => filter = f),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 20),
        if (view == AgendaView.month)
          _month()
        else if (view == AgendaView.week)
          _week()
        else
          _day(),
      ],
    ),
  );
  Widget _toolbar() => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      OutlinedButton.icon(
        onPressed: () => _move(-1),
        icon: const Icon(Icons.chevron_left),
        label: const Text('Anterior'),
      ),
      OutlinedButton.icon(
        onPressed: () => setState(() => selectedDate = defaultDate),
        icon: const Icon(Icons.today_outlined),
        label: const Text('Hoy'),
      ),
      OutlinedButton.icon(
        onPressed: () => _move(1),
        icon: const Icon(Icons.chevron_right),
        label: const Text('Siguiente'),
      ),
      SegmentedButton<AgendaView>(
        segments: const [
          ButtonSegment(value: AgendaView.month, label: Text('Mes')),
          ButtonSegment(value: AgendaView.week, label: Text('Semana')),
          ButtonSegment(value: AgendaView.day, label: Text('Día')),
        ],
        selected: {view},
        onSelectionChanged: (s) => setState(() => view = s.first),
      ),
      OutlinedButton.icon(
        onPressed: _configureSchedule,
        icon: const Icon(Icons.tune),
        label: const Text('Configurar jornada'),
      ),
    ],
  );
  Widget _month() {
    final first = DateTime(selectedDate.year, selectedDate.month, 1);
    final days = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    final offset = first.weekday - 1;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: const ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom']
                  .map(
                    (x) => Expanded(
                      child: Center(
                        child: Text(
                          x,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const Divider(),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: offset + days,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.3,
              ),
              itemBuilder: (_, i) {
                if (i < offset) return const SizedBox();
                final day = i - offset + 1;
                final date = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  day,
                );
                final count = appointments
                    .where(
                      (a) =>
                          a.date.day == day &&
                          a.date.month == selectedDate.month,
                    )
                    .length;
                return InkWell(
                  onTap: () => setState(() {
                    selectedDate = date;
                    view = AgendaView.day;
                  }),
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: date.day == selectedDate.day
                            ? OrbitColors.blue
                            : Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$day',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (count > 0)
                          Text(
                            '$count cita${count == 1 ? '' : 's'}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: OrbitColors.blue,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _week() {
    final monday = selectedDate.subtract(
      Duration(days: selectedDate.weekday - 1),
    );
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 64),
              ...List.generate(7, (i) {
                final d = monday.add(Duration(days: i));
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      '${_short(d.weekday)}\n${d.day}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }),
            ],
          ),
          const Divider(height: 1),
          ...List.generate(20, (i) {
            final hour = i + 7;
            return SizedBox(
              height: 54,
              child: Row(
                children: [
                  SizedBox(
                    width: 64,
                    child: Text('${hour.toString().padLeft(2, '0')}:00'),
                  ),
                  ...List.generate(
                    7,
                    (j) => Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.grey.shade200),
                            top: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                        child: _slot(monday.add(Duration(days: j)), hour),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _slot(DateTime d, int hour) {
    final item = visible
        .where(
          (a) =>
              a.date.day == d.day &&
              a.time.startsWith(hour.toString().padLeft(2, '0')),
        )
        .firstOrNull;
    return item == null
        ? const SizedBox()
        : Container(
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.all(4),
            color: OrbitColors.blue.withValues(alpha: .12),
            child: Text(
              item.patient,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11),
            ),
          );
  }

  Widget _day() => Card(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.person_outline, color: OrbitColors.blue),
              const SizedBox(width: 10),
              Text(
                '$professional · $site',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                '${visible.length} citas',
                style: const TextStyle(color: OrbitColors.muted),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        ...List.generate(20, (i) {
          final hour = i + 7;
          final item = visible
              .where(
                (a) =>
                    a.date.day == selectedDate.day &&
                    a.time.startsWith(hour.toString().padLeft(2, '0')),
              )
              .firstOrNull;
          return ListTile(
            leading: SizedBox(
              width: 56,
              child: Text('${hour.toString().padLeft(2, '0')}:00'),
            ),
            title: Text(
              item?.patient ?? 'Franja disponible',
              style: TextStyle(
                color: item == null ? OrbitColors.success : OrbitColors.navy,
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: item == null
                ? const Text('Seleccionar franja')
                : Text(item.type),
            onTap: item == null ? _add : null,
            trailing: item == null
                ? const Icon(Icons.add_circle_outline)
                : Chip(label: Text(item.status)),
          );
        }),
      ],
    ),
  );
  String _short(int n) =>
      const ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'][n - 1];
  String _label() =>
      '${_short(selectedDate.weekday)}, ${selectedDate.day} de octubre de ${selectedDate.year}';
  void _move(int n) => setState(
    () => selectedDate = view == AgendaView.month
        ? DateTime(selectedDate.year, selectedDate.month + n, 1)
        : selectedDate.add(Duration(days: view == AgendaView.week ? n * 7 : n)),
  );
  bool _isAvailable(DateTime date, String time, int duration) {
    final parts = time.split(':').map(int.parse).toList();
    final start = parts[0] * 60 + parts[1];
    final end = start + duration;
    if (parts[1] % 30 != 0 || parts[0] < workStart || end > workEnd * 60) {
      return false;
    }
    if (start < pauseEnd * 60 && end > pauseStart * 60) {
      return false;
    }
    return !appointments.any((a) {
      if (a.date.year != date.year ||
          a.date.month != date.month ||
          a.date.day != date.day) {
        return false;
      }
      final p = a.time.split(':').map(int.parse).toList();
      final otherStart = p[0] * 60 + p[1];
      final otherEnd = otherStart + a.durationMinutes;
      return start < otherEnd && end > otherStart && a.status != 'Cancelada';
    });
  }

  void _add() {
    final c = TextEditingController();
    String service = serviceDurations.keys.first;
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Agendar cita'),
        content: StatefulBuilder(
          builder: (context, dialogSetState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: c,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Paciente'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: service,
                decoration: const InputDecoration(labelText: 'Servicio'),
                items: serviceDurations.keys
                    .map(
                      (s) => DropdownMenuItem(
                        value: s,
                        child: Text('$s (${serviceDurations[s]} min)'),
                      ),
                    )
                    .toList(),
                onChanged: (value) => dialogSetState(() => service = value!),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (c.text.trim().isEmpty) return;
              final duration = serviceDurations[service]!;
              if (!_isAvailable(selectedDate, '16:00', duration)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'La franja está fuera de horario o en conflicto.',
                    ),
                  ),
                );
                return;
              }
              setState(
                () => appointments.add(
                  Appointment(
                    '16:00',
                    c.text.trim(),
                    service,
                    'Pendiente',
                    date: selectedDate,
                    durationMinutes: duration,
                  ),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Agendar'),
          ),
        ],
      ),
    );
  }

  void _configureSchedule() {
    var selectedProfessional = professional;
    var selectedSite = site;
    showDialog<void>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, dialogSetState) => AlertDialog(
          title: const Text('Configuración rápida de jornada'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            DropdownButtonFormField<String>(
              initialValue: selectedProfessional,
              decoration: const InputDecoration(labelText: 'Profesional'),
              items: ['Dra. Rivera', 'Dr. Salazar', 'Dra. Méndez'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
              onChanged: (value) => dialogSetState(() => selectedProfessional = value!),
            ),
            DropdownButtonFormField<String>(
              initialValue: selectedSite,
              decoration: const InputDecoration(labelText: 'Sede'),
              items: ['Sede principal', 'Sede norte'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
              onChanged: (value) => dialogSetState(() => selectedSite = value!),
            ),
            const SizedBox(height: 12),
            const Align(alignment: Alignment.centerLeft, child: Text('Jornada activa: 07:00–19:00 · pausa 12:00–13:00')),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            FilledButton(onPressed: () { setState(() { professional = selectedProfessional; site = selectedSite; }); Navigator.pop(context); }, child: const Text('Guardar')),
          ],
        ),
      ),
    );
  }
}
