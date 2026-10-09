class Patient {
  const Patient(this.name, this.document, this.phone, this.birthDate);
  final String name;
  final String document;
  final String phone;
  final String birthDate;
}

const mockPatients = [
  Patient(
    'María Fernanda López',
    'CC 52.381.902',
    '300 555 0182',
    '12 mar 1988',
  ),
  Patient(
    'Carlos Andrés Gómez',
    'CC 79.421.615',
    '310 555 2281',
    '04 jul 1979',
  ),
  Patient(
    'Ana Sofía Martínez',
    'TI 1.023.884.701',
    '315 555 3904',
    '28 nov 2005',
  ),
  Patient(
    'Jorge Eliécer Rodríguez',
    'CC 19.887.431',
    '320 555 7410',
    '19 ene 1967',
  ),
];
