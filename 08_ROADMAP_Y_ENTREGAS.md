# Roadmap de entregas

## Hitos y alcance

| Hito | Resultado utilizable | Incluye | Salida requerida |
|---|---|---|---|
| H0 | Base conectada | Repositorio, entornos locales, login, IPS y pacientes | Alta y consulta sintética desde web/Android, con acceso cruzado denegado |
| H1 | Consulta manual completa | Agenda, admisión, nota, datos clínicos, confirmación y adendas | Flujo íntegro y pruebas de permisos, concurrencia y auditoría |
| H2 | Documentación asistida | Formularios por servicio, dictado, IA revisable, documentos, notificaciones e iOS | Validación clínica de casos sintéticos, fallos controlados y costos medidos |
| H3 | Preparación institucional | FEV/RIPS, RDA si aplica, migración, reportes, privacidad y recuperación | Integraciones comprobadas y requisitos normativos aplicables trazados |
| H4 | Primera IPS en operación | Alcance y servicios aceptados, capacitación y soporte | Acta de salida de OPS-013 y seguimiento del piloto |
| H5 | Crecimiento comercial | Más sedes/IPS, licencias, recaudos, bonificaciones y capacidad | Costos medidos, seguridad y proceso de incorporación repetible |

Se trabaja en iteraciones cortas y se estima cada hito en INI-005. No se interpreta el plazo comercial de implantación como tiempo para desarrollar este producto desde cero. Un piloto asistencial real requiere H3/H4; H1 y H2 permiten demostración y validación con datos sintéticos.

## Trazabilidad de lo ofrecido

| Alcance comercial | Tareas principales | Entrega |
|---|---|---|
| Admisiones y citas | API-004 a API-007; FE-005 a FE-008 | H0/H1 |
| Historia clínica general | API-008 a API-011; FE-009 a FE-012 | H1 |
| Historia especializada y nutrición | API-012, API-013, FE-013 | H2 |
| Procedimientos y vacunación | API-011, API-013 | H2 |
| Facturación electrónica FEV/RIPS | API-015, SVC-005, SVC-006, FE-016 | H3 |
| IA documental y dictado | AI-001 a AI-009, FE-014 | H2 |
| Migración y acompañamiento | API-018, OPS-008, OPS-013 | H3/H4 |
| Beneficios y límites de plan | AI-005, SVC-010 | H2/H5 |

El servicio clínico exacto del primer piloto se elige en INI-001. Una plantilla genérica no acredita que ya estén implementadas todas las especialidades.

## Secuencia de demostraciones

1. **H0:** recepcionista registra a un paciente ficticio y lo encuentra; otra IPS no puede acceder a él.
2. **H1:** crea cita y admisión; el profesional guarda nota, resuelve un conflicto de edición, confirma y añade una adenda.
3. **H2:** dicta una atención sintética; revisa fuentes y descarta una sugerencia; agota una bolsa de prueba y continúa manualmente.
4. **H3:** genera cuenta, provoca rechazo de prueba, corrige, reenvía de forma idempotente y concilia su estado oficial cuando corresponda.
5. **H4:** restaura un respaldo, ejecuta los casos exigibles del servicio, forma a usuarios y completa aceptación institucional.

## Trabajo que puede avanzar en paralelo

- Después de CON-001 y la definición de roles, frontend puede usar un servidor simulado mientras backend implementa el mismo contrato.
- IA puede validarse con casos sintéticos una vez acordado su esquema y mecanismo de revisión; su ausencia no bloquea consulta manual.
- La evaluación normativa y de proveedores de H3 comienza desde H0, aunque su integración se entregue después.
- La interoperabilidad exigible, la seguridad y las copias no se postergan más allá de la salida de la IPS correspondiente.

## Fuera del primer alcance

Hospitalización, urgencias, farmacia/inventario, teleconsulta, facturación contable integral, diagnóstico autónomo, entrenamiento de modelos con pacientes, offline clínico completo y un marketplace se estiman como ampliaciones. Las bonificaciones de asesores se implementan en el sistema comercial del proveedor después de estabilizar la operación asistencial.

## Seguimiento semanal

Registrar tareas terminadas con evidencia, tareas bloqueadas, siguiente demostración, consumo real de horas, costos e incidentes. Al cambiar un criterio o alcance, actualizar su tarea original y el contrato que afecte. Evitar una segunda lista de casillas con los mismos identificadores.
