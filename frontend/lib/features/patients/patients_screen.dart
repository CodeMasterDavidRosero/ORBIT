import 'package:flutter/material.dart';

import '../../core/theme/orbit_colors.dart';
import 'patient.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});
  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final search = TextEditingController();
  late List<Patient> patients = [...mockPatients];
  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = search.text.toLowerCase();
    final visible = patients
        .where(
          (p) =>
              p.name.toLowerCase().contains(query) ||
              p.document.toLowerCase().contains(query),
        )
        .toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pacientes',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: OrbitColors.navy,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Consulta y gestiona los registros de tu IPS',
            style: TextStyle(color: OrbitColors.muted),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: search,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre o documento',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              FilledButton.icon(
                onPressed: () => _patientForm(),
                icon: const Icon(Icons.person_add_outlined),
                label: const Text('Nuevo paciente'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            child: visible.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(48),
                    child: Center(
                      child: Text('No encontramos pacientes con esos datos.'),
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            visible.length.toString() + ' registros',
                            style: const TextStyle(color: OrbitColors.muted),
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      ...visible.map(
                        (patient) => ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: OrbitColors.blueSoft,
                            child: Text(
                              patient.name.substring(0, 1),
                              style: const TextStyle(color: OrbitColors.blue),
                            ),
                          ),
                          title: Text(
                            patient.name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            patient.document + '  •  ' + patient.phone,
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _details(patient),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void _details(Patient patient) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(patient.name),
        content: Text(
          'Documento: ' +
              patient.document +
              '\nFecha de nacimiento: ' +
              patient.birthDate +
              '\nTeléfono: ' +
              patient.phone,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _patientForm(patient: patient);
            },
            child: const Text('Editar'),
          ),
        ],
      ),
    );
  }

  void _patientForm({Patient? patient}) {
    final formKey = GlobalKey<FormState>();
    final name = TextEditingController(text: patient?.name);
    final document = TextEditingController(text: patient?.document);
    final phone = TextEditingController(text: patient?.phone);
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(patient == null ? 'Nuevo paciente' : 'Editar paciente'),
        content: SizedBox(
          width: 420,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: name,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                  ),
                  validator: (value) => value == null || value.trim().length < 3
                      ? 'Escribe el nombre completo'
                      : null,
                ),
                TextFormField(
                  controller: document,
                  decoration: const InputDecoration(labelText: 'Documento'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'El documento es obligatorio'
                      : null,
                ),
                TextFormField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                  validator: (value) => value == null || value.trim().length < 7
                      ? 'Escribe un teléfono válido'
                      : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              final updated = Patient(
                name.text.trim(),
                document.text.trim(),
                phone.text.trim(),
                patient?.birthDate ?? 'Pendiente',
              );
              setState(() {
                if (patient == null) {
                  patients = [...patients, updated];
                } else {
                  patients = patients
                      .map((item) => item == patient ? updated : item)
                      .toList();
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
