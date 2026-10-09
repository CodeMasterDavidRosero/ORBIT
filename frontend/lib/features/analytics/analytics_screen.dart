import 'package:flutter/material.dart';

import '../../core/theme/orbit_colors.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});
  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String period = 'Esta semana';
  bool showDetails = true;

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
                    'Indicadores',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: OrbitColors.navy,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Resumen operativo de la organización activa',
                    style: TextStyle(color: OrbitColors.muted),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_outlined),
                label: const Text('Exportar'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    'Período',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: period,
                    items: const [
                      DropdownMenuItem(value: 'Hoy', child: Text('Hoy')),
                      DropdownMenuItem(
                        value: 'Esta semana',
                        child: Text('Esta semana'),
                      ),
                      DropdownMenuItem(
                        value: 'Este mes',
                        child: Text('Este mes'),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => period = value ?? period),
                  ),
                  const Spacer(),
                  Switch(
                    value: showDetails,
                    onChanged: (value) => setState(() => showDetails = value),
                  ),
                  const Text('Ver detalles'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: MediaQuery.sizeOf(context).width > 900 ? 4 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.7,
            children: const [
              _Indicator(
                'Citas programadas',
                '48',
                '+12%',
                Icons.calendar_today_outlined,
                OrbitColors.blue,
              ),
              _Indicator(
                'Atenciones cerradas',
                '36',
                '+8%',
                Icons.task_alt_outlined,
                OrbitColors.success,
              ),
              _Indicator(
                'Notas pendientes',
                '07',
                'Revisar',
                Icons.description_outlined,
                OrbitColors.warning,
              ),
              _Indicator(
                'Tiempo promedio',
                '24 min',
                '-4%',
                Icons.timelapse_outlined,
                Color(0xFF7C5CBA),
              ),
            ],
          ),
          if (showDetails) ...[
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detalle · $period',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: OrbitColors.navy,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const LinearProgressIndicator(
                      value: 0.72,
                      color: OrbitColors.blue,
                      backgroundColor: OrbitColors.blueSoft,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '72% de las citas del período ya fueron atendidas.',
                      style: TextStyle(color: OrbitColors.muted),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator(this.title, this.value, this.trend, this.icon, this.color);
  final String title;
  final String value;
  final String trend;
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
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: OrbitColors.muted),
              ),
              Icon(icon, color: color),
            ],
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: OrbitColors.navy,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                trend,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
