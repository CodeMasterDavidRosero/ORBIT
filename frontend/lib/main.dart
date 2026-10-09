import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'core/design/orbit_breakpoints.dart';
import 'shared/widgets/orbit_status_chip.dart';
import 'features/patients/patients_screen.dart';
import 'features/scheduling/agenda_screen.dart';
import 'features/encounters/encounters_screen.dart';
import 'features/modules/modules_screen.dart';
import 'features/settings/settings_screen.dart';

void main() => runApp(const ProviderScope(child: OrbitApp()));

final _router = GoRouter(
  routes: [GoRoute(path: '/', builder: (context, state) => const OrbitShell())],
);

class OrbitApp extends StatelessWidget {
  const OrbitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp.router(
      title: 'ORBIT',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadBlueColorScheme.light(
          background: Color(0xFFF7FAFC),
          foreground: Color(0xFF102A43),
          card: Color(0xFFFFFFFF),
          cardForeground: Color(0xFF102A43),
          primary: Color(0xFF2F6FBE),
          primaryForeground: Color(0xFFFFFFFF),
          secondary: Color(0xFFEAF2FA),
          secondaryForeground: Color(0xFF234E70),
          muted: Color(0xFFF0F4F8),
          mutedForeground: Color(0xFF627D98),
          accent: Color(0xFFE7F0FA),
          accentForeground: Color(0xFF234E70),
          border: Color(0xFFD9E2EC),
          input: Color(0xFFD9E2EC),
          ring: Color(0xFF5B8CC9),
          selection: Color(0xFFCFE2F5),
        ),
        radius: BorderRadius.circular(12),
      ),
    );
  }
}

class OrbitShell extends StatefulWidget {
  const OrbitShell({super.key});

  @override
  State<OrbitShell> createState() => _OrbitShellState();
}

class _OrbitShellState extends State<OrbitShell> {
  int selectedIndex = 0;
  static const destinations = [
    ('Inicio', Icons.dashboard_outlined),
    ('Pacientes', Icons.people_outline),
    ('Agenda', Icons.calendar_month_outlined),
    ('Atenciones', Icons.medical_services_outlined),
    ('Más módulos', Icons.widgets_outlined),
    ('Perfil', Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context) {
    final compact = context.isOrbitCompact;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ORBIT',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.5),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20, left: 8),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFDCEBFF),
              child: Text('RD', style: TextStyle(color: Color(0xFF185ABC))),
            ),
          ),
        ],
      ),
      drawer: compact ? _drawer() : null,
      body: Row(
        children: [
          if (!compact) _rail(),
          Expanded(child: SafeArea(child: _content(compact))),
        ],
      ),
    );
  }

  Widget _rail() => NavigationRail(
    selectedIndex: selectedIndex,
    onDestinationSelected: (index) => setState(() => selectedIndex = index),
    labelType: NavigationRailLabelType.all,
    backgroundColor: Colors.white,
    leading: const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Icon(Icons.blur_circular, color: Color(0xFF2F80ED), size: 30),
    ),
    destinations: destinations
        .map(
          (item) => NavigationRailDestination(
            icon: Icon(item.$2),
            selectedIcon: Icon(item.$2),
            label: Text(item.$1),
          ),
        )
        .toList(),
  );

  Widget _drawer() => NavigationDrawer(
    selectedIndex: selectedIndex,
    onDestinationSelected: (index) {
      setState(() => selectedIndex = index);
      Navigator.pop(context);
    },
    children: [
      const Padding(
        padding: EdgeInsets.fromLTRB(28, 28, 28, 20),
        child: Text(
          'ORBIT',
          style: TextStyle(
            color: Color(0xFF185ABC),
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
      ),
      ...destinations.map(
        (item) => NavigationDrawerDestination(
          icon: Icon(item.$2),
          label: Text(item.$1),
        ),
      ),
    ],
  );

  Widget _content(bool compact) {
    if (selectedIndex == 1) return const PatientsScreen();
    if (selectedIndex == 2) return const AgendaScreen();
    if (selectedIndex == 3) return const EncountersScreen();
    if (selectedIndex == 4) return const ModulesScreen();
    if (selectedIndex == 5) return const SettingsScreen();
    if (selectedIndex != 0) {
      return Center(
        child: Text(
          '${destinations[selectedIndex].$1}\nPróximamente',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      );
    }
    return SingleChildScrollView(
      padding: EdgeInsets.all(compact ? 20 : 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Buenos días, Dra. Rivera',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF102A43),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Resumen de actividad de tu IPS',
            style: TextStyle(color: Color(0xFF627D98), fontSize: 16),
          ),
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (_, constraints) {
              final columns = constraints.maxWidth > 900 ? 4 : 2;
              return GridView.count(
                crossAxisCount: columns,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: compact ? 1.45 : 1.8,
                children: const [
                  _MetricCard(
                    'Citas de hoy',
                    '12',
                    '3 pendientes',
                    Icons.calendar_today_outlined,
                    Color(0xFF2F80ED),
                  ),
                  _MetricCard(
                    'Pacientes atendidos',
                    '08',
                    'Esta semana',
                    Icons.people_outline,
                    Color(0xFF27AE60),
                  ),
                  _MetricCard(
                    'Notas pendientes',
                    '04',
                    'Requieren revisión',
                    Icons.description_outlined,
                    Color(0xFFF2994A),
                  ),
                  _MetricCard(
                    'Tiempo promedio',
                    '24 min',
                    'Últimas 10 citas',
                    Icons.timelapse_outlined,
                    Color(0xFF9B51E0),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 28),
          const _AppointmentsCard(),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard(
    this.label,
    this.value,
    this.caption,
    this.icon,
    this.color,
  );
  final String label;
  final String value;
  final String caption;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF627D98)),
                ),
              ),
              Icon(icon, color: color),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF102A43),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  caption,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF829AB1),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _AppointmentsCard extends StatelessWidget {
  const _AppointmentsCard();

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Próximas citas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF102A43),
                ),
              ),
              TextButton(onPressed: () {}, child: const Text('Ver agenda')),
            ],
          ),
          const Divider(height: 24),
          const _AppointmentRow(
            '09:00',
            'María Fernanda López',
            'Consulta de control',
            'Confirmada',
          ),
          const _AppointmentRow(
            '10:30',
            'Carlos Andrés Gómez',
            'Valoración inicial',
            'Pendiente',
          ),
          const _AppointmentRow(
            '11:15',
            'Ana Sofía Martínez',
            'Seguimiento',
            'Confirmada',
          ),
        ],
      ),
    ),
  );
}

class _AppointmentRow extends StatelessWidget {
  const _AppointmentRow(this.time, this.patient, this.type, this.status);
  final String time;
  final String patient;
  final String type;
  final String status;

  @override
  Widget build(BuildContext context) {
    final confirmed = status == 'Confirmada';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: SizedBox(
        width: 56,
        child: Text(time, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
      title: Text(patient, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(type),
      trailing: OrbitStatusChip(label: status, positive: confirmed),
    );
  }
}
