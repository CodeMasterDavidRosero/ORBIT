class Appointment {
  Appointment(
    this.time,
    this.patient,
    this.type,
    this.status, {
    DateTime? date,
    this.durationMinutes = 30,
    this.professional = 'Dra. Rivera',
    this.site = 'Sede principal',
  }) : date = date ?? defaultDate;
  final String time;
  final String patient;
  final String type;
  final String status;
  final DateTime date;
  final int durationMinutes;
  final String professional;
  final String site;
}

final defaultDate = DateTime(2026, 10, 13);

final mockAppointments = [
  Appointment(
    '08:30',
    'María Fernanda López',
    'Consulta de control',
    'Confirmada',
  ),
  Appointment(
    '09:15',
    'Carlos Andrés Gómez',
    'Valoración inicial',
    'Pendiente',
  ),
  Appointment('10:00', 'Ana Sofía Martínez', 'Seguimiento', 'Confirmada'),
  Appointment(
    '11:30',
    'Jorge Eliécer Rodríguez',
    'Consulta general',
    'Cancelada',
  ),
  Appointment(
    '14:00',
    'Laura Camila Torres',
    'Consulta de control',
    'Confirmada',
  ),
];
