import 'package:flutter/material.dart';

import '../../core/theme/orbit_colors.dart';

class ModulesScreen extends StatefulWidget {
  const ModulesScreen({super.key});
  @override
  State<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  int selected = 0;
  final modules = const [
    (
      'Formularios',
      'Plantillas versionadas por servicio',
      Icons.article_outlined,
    ),
    (
      'Revisión IA',
      'Sugerencias siempre revisables',
      Icons.auto_awesome_outlined,
    ),
    (
      'Documentos',
      'Adjuntos y exportaciones autorizadas',
      Icons.attach_file_outlined,
    ),
    (
      'Facturación',
      'Pendientes y estados de envío',
      Icons.receipt_long_outlined,
    ),
    ('Preadmisión', 'Confirmación segura de citas', Icons.how_to_reg_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Más módulos',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: OrbitColors.navy,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Funciones preparadas para las siguientes entregas de ORBIT',
            style: TextStyle(color: OrbitColors.muted),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(modules.length, (index) {
              final item = modules[index];
              return SizedBox(
                width: 205,
                child: InkWell(
                  onTap: () => setState(() => selected = index),
                  borderRadius: BorderRadius.circular(14),
                  child: Card(
                    color: selected == index
                        ? OrbitColors.blueSoft
                        : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(item.$3, color: OrbitColors.blue, size: 28),
                          const SizedBox(height: 18),
                          Text(
                            item.$1,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: OrbitColors.navy,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.$2,
                            style: const TextStyle(
                              fontSize: 12,
                              color: OrbitColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          _detail(),
        ],
      ),
    );
  }

  Widget _detail() {
    final item = modules[selected];
    final rows = switch (selected) {
      0 => [
        'Consulta general · v1.2 · Publicada',
        'Control de seguimiento · v1.0 · Borrador',
      ],
      1 => [
        'Sugerencia: resumir evolución favorable',
        'Fuente: nota clínica · Revisión pendiente',
      ],
      2 => [
        'Resultado-laboratorio.pdf · 2.4 MB',
        'Exportación de atención · Disponible',
      ],
      3 => [
        'Factura INV-00042 · En revisión',
        'Servicio de consulta · Pendiente de envío',
      ],
      _ => [
        'Cita de María Fernanda López · Confirmada',
        'Enlace de confirmación · Vigente 24 horas',
      ],
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.$1,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: OrbitColors.navy,
              ),
            ),
            const SizedBox(height: 8),
            Text(item.$2, style: const TextStyle(color: OrbitColors.muted)),
            const Divider(height: 28),
            ...rows.map(
              (row) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.check_circle_outline,
                  color: OrbitColors.success,
                ),
                title: Text(row),
                trailing: TextButton(
                  onPressed: () {},
                  child: const Text('Abrir'),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: Text(
                  selected == 0 ? 'Nueva plantilla' : 'Crear solicitud',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
