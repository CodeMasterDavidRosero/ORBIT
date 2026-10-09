import 'package:flutter/material.dart';

import '../../core/theme/orbit_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool largeText = false;
  bool highContrast = false;
  String organization = 'Clínica ORBIT · Sede Norte';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Perfil y configuración',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: OrbitColors.navy,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Sesión, organización activa y preferencias de accesibilidad',
            style: TextStyle(color: OrbitColors.muted),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sesión demo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: OrbitColors.navy,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: OrbitColors.blueSoft,
                      child: Text('RD'),
                    ),
                    title: Text(
                      'Dra. Rivera',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text('Profesional · Sesión activa'),
                  ),
                  DropdownButtonFormField<String>(
                    value: organization,
                    decoration: const InputDecoration(
                      labelText: 'Organización activa',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Clínica ORBIT · Sede Norte',
                        child: Text('Clínica ORBIT · Sede Norte'),
                      ),
                      DropdownMenuItem(
                        value: 'Centro ORBIT · Sede Centro',
                        child: Text('Centro ORBIT · Sede Centro'),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => organization = value ?? organization),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'El cambio de organización invalida la caché de trabajo y las peticiones pendientes.',
                    style: TextStyle(fontSize: 12, color: OrbitColors.muted),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Accesibilidad',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: OrbitColors.navy,
                    ),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Texto ampliado'),
                    subtitle: const Text(
                      'Aumenta el tamaño de lectura en formularios',
                    ),
                    value: largeText,
                    onChanged: (value) => setState(() => largeText = value),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Contraste reforzado'),
                    subtitle: const Text(
                      'Mejora la diferenciación de controles y estados',
                    ),
                    value: highContrast,
                    onChanged: (value) => setState(() => highContrast = value),
                  ),
                  const SizedBox(height: 12),
                  Semantics(
                    button: true,
                    label: 'Cerrar sesión',
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.logout),
                      label: const Text('Cerrar sesión'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline, color: OrbitColors.blue),
              title: const Text('Modo de demostración'),
              subtitle: Text(
                'Los datos mostrados son sintéticos. Organización: $organization',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
