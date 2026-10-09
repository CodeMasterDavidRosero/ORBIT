class Appointment {
  const Appointment(this.time, this.patient, this.type, this.status);
  final String time;
  final String patient;
  final String type;
  final String status;
}

const mockAppointments = [
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
