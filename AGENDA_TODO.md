# TODO — Agenda ORBIT

## Objetivo

Construir una agenda clínica moderna, rápida y flexible para gestionar citas por mes, semana y día. La primera versión funcionará con datos sintéticos en el frontend y deberá quedar preparada para conectarse posteriormente al backend.

La agenda debe permitir visualizar disponibilidad, crear citas, moverlas, reprogramarlas y cancelarlas sin perder contexto ni información del paciente.

## Principios de experiencia

- La fecha y el profesional seleccionado siempre deben ser visibles.
- El usuario debe cambiar de vista sin perder filtros ni selección.
- Las citas deben poder moverse con arrastrar y soltar en escritorio.
- En móvil, el movimiento debe resolverse con una acción clara de reprogramar.
- Las franjas deben trabajar en intervalos de 30 minutos.
- Los conflictos deben explicarse antes de confirmar una acción.
- Cancelar nunca debe borrar silenciosamente una cita: debe solicitar motivo y confirmación.
- Los datos mostrados en esta etapa son completamente sintéticos.
- La agenda debe mostrar estados claros: disponible, reservada, confirmada, atendida, cancelada y bloqueada.

## Vistas requeridas

- [x] AGENDA-001 — Vista mensual: calendario completo, citas por día y navegación a vista diaria.
- [x] AGENDA-002 — Vista semanal: columnas por día, bloques de 30 minutos y varias duraciones.
- [x] AGENDA-003 — Vista diaria: agenda detallada del profesional y selección de franja libre.
- [x] AGENDA-004 — Selector de vista: Mes, Semana y Día; acciones anterior, siguiente y hoy.

## Bloques horarios

- [x] AGENDA-005 — Intervalos de 30 minutos y servicios de 30, 60, 90 y 120 minutos.
- [x] AGENDA-006 — Horarios laborales, pausas, vacaciones, reuniones y bloqueos.
- [x] AGENDA-007 — Configuración rápida de jornada por profesional, sede y servicio.
- [x] AGENDA-008 — Impedir citas fuera de horario o sobre franjas ocupadas.

## Crear y editar citas

- [x] AGENDA-009 — Crear cita desde una franja con paciente, servicio, profesional, sede y duración.
- [ ] AGENDA-010 — Crear cita desde botón global con sugerencia de horarios disponibles.
- [ ] AGENDA-011 — Editar motivo, servicio y observaciones autorizadas.
- [ ] AGENDA-012 — Mover cita con arrastrar y soltar en escritorio.
- [ ] AGENDA-013 — Reprogramar cita en móvil mediante fecha, hora, sede o profesional.
- [ ] AGENDA-014 — Solicitar motivo al reprogramar y conservar la trazabilidad.

## Cancelación y estados

- [ ] AGENDA-015 — Cancelar cita con confirmación y motivo obligatorio.
- [ ] AGENDA-016 — Mantener la cita cancelada en el historial sin borrar datos.
- [ ] AGENDA-017 — Estados: DISPONIBLE, RESERVADA, CONFIRMADA, EN_ESPERA, ATENDIDA, CANCELADA, NO_ASISTIO y BLOQUEADA.
- [ ] AGENDA-018 — Acciones y permisos distintos según estado y rol.

## Filtros y productividad

- [ ] AGENDA-019 — Filtros por profesional, sede, servicio, estado, paciente y duración.
- [ ] AGENDA-020 — Búsqueda rápida de pacientes con homónimos identificables.
- [ ] AGENDA-021 — Atajos: hoy, crear, reprogramar, cancelar y abrir ficha.

## Conflictos y estados de pantalla

- [ ] AGENDA-022 — Mostrar el conflicto y ofrecer horarios alternativos sin perder datos.
- [ ] AGENDA-023 — Estados de cargando, vacío, sin resultados, error, sin permisos, sesión expirada y cambios sin guardar.
- [ ] AGENDA-024 — Confirmaciones visibles para crear, mover, reprogramar y cancelar.

## Responsive y accesibilidad

- [ ] AGENDA-025 — Escritorio con vista semanal, arrastrar y soltar y menú contextual.
- [ ] AGENDA-026 — Tableta con vista compacta y panel lateral de detalle.
- [ ] AGENDA-027 — Móvil con vista diaria y reprogramación mediante formulario.
- [ ] AGENDA-028 — Foco visible, teclado, etiquetas semánticas, contraste y textos ampliables.

## Datos mock iniciales

- [ ] AGENDA-029 — Catálogo sintético con 3 profesionales, 2 sedes y 4 servicios.
- [ ] AGENDA-030 — Horarios laborales diferentes, pausas, bloqueos y citas en estados variados.
- [ ] AGENDA-031 — Crear, mover, reprogramar y cancelar en memoria.
- [ ] AGENDA-032 — Restaurar los datos demo al recargar.

## Verificación de terminado

- [ ] El usuario navega por mes, semana y día.
- [ ] Se trabaja con bloques de 30 minutos.
- [ ] Se crea una cita desde una franja libre.
- [ ] Se mueve o reprograma una cita.
- [ ] Se cancela una cita con motivo.
- [ ] Los conflictos se muestran sin perder información.
- [ ] La agenda funciona en escritorio, tableta y móvil.
- [ ] Todos los datos son sintéticos.
- [ ] flutter analyze no reporta errores.
- [ ] Las pruebas cubren creación, movimiento, cancelación y estados vacíos.
