# Backend clínico y API

Implementar casos de uso separados de controladores HTTP y persistencia. Usar DTO del contrato, validación explícita, consultas paginadas y servicios de dominio. PostgreSQL conserva la autoridad sobre estados, versiones e invariantes; los clientes nunca deciden por sí solos qué se puede modificar.

## Base y primer paciente

- [ ] **API-001 — Crear la API modular y migraciones base** · H0
  - Dependencias: [INI-002](00_TODO_INICIAL.md), [INI-003](00_TODO_INICIAL.md), [OPS-001](07_DEVOPS_Y_QA.md), [CON-001](09_CONTRATOS_API.md).
  - Terminado cuando: compile con Maven Wrapper, tenga health/readiness internos y límites verificables entre módulos; el esquema se cree mediante migraciones.
  - Entrega: Proyecto Spring Boot, paquetes de dominio y prueba de estructura modular.

- [ ] **API-002 — Configurar autenticación web y móvil** · H0
  - Dependencias: [API-001](03_BACKEND_API.md), [SEC-001](05_DATOS_Y_SEGURIDAD.md), [SEC-002](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: se validen issuer, audience, firma, expiración y scopes; funcionen BFF y resource server con rutas de seguridad diferenciadas.
  - Entrega: Integración OIDC y pruebas de tokens inválidos, CSRF y logout.

- [ ] **API-003 — Implementar contexto de organización y permisos** · H0
  - Dependencias: [API-002](03_BACKEND_API.md), [DAT-001](05_DATOS_Y_SEGURIDAD.md), [DAT-002](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: `/me` liste membresías válidas y cada acceso compruebe rol, sede y recurso; un cambio de cabecera no eleve privilegios.
  - Entrega: Resolución de contexto y autorizaciones reutilizables.

- [ ] **API-004 — Implementar pacientes y búsqueda demográfica** · H0
  - Dependencias: [API-003](03_BACKEND_API.md), [CON-002](09_CONTRATOS_API.md).
  - Terminado cuando: crear, leer y actualizar funcionen con validaciones de identidad, restricciones por IPS, idempotencia y concurrencia; búsqueda limite campos y resultados.
  - Entrega: API de pacientes, índices y pruebas de duplicidad.

## Agenda e historia clínica

- [ ] **API-005 — Administrar profesionales y disponibilidad** · H1
  - Dependencias: [API-003](03_BACKEND_API.md), [INI-004](00_TODO_INICIAL.md).
  - Terminado cuando: cada profesional tenga servicios, sede y horarios; se validen relaciones dentro de la misma organización.
  - Entrega: Endpoints y reglas de disponibilidad.

- [ ] **API-006 — Gestionar citas y evitar sobreocupación** · H1
  - Dependencias: [API-004](03_BACKEND_API.md), [API-005](03_BACKEND_API.md), [DAT-004](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: dos peticiones simultáneas no ocupen el mismo recurso y franja; cancelar o reprogramar genere evidencia y evento transaccional.
  - Entrega: Agenda con control de concurrencia en base de datos.

- [ ] **API-007 — Modelar admisión y episodio de atención** · H1
  - Dependencias: [API-006](03_BACKEND_API.md), [DAT-004](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: se admitan atenciones con cita y el caso directo autorizado; paciente, profesional y sede queden ligados y se respeten los estados definidos.
  - Entrega: Agregado Encounter y máquina de estados.

- [ ] **API-008 — Persistir notas en borrador con control de versión** · H1
  - Dependencias: [API-007](03_BACKEND_API.md), [CON-002](09_CONTRATOS_API.md).
  - Terminado cuando: un guardado incremente versión; If-Match incorrecto produzca 412, contenido inválido 422 y usuario sin permiso 403/404 según política.
  - Entrega: Notas estructuradas y snapshot del formulario utilizado.

- [ ] **API-009 — Confirmar la nota en una transacción** · H1
  - Dependencias: [API-008](03_BACKEND_API.md), [API-011](03_BACKEND_API.md), [DAT-004](05_DATOS_Y_SEGURIDAD.md), [SEC-003](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: la confirmación valide campos, autor y versión, congele el contenido y guarde auditoría y outbox atómicamente; repetir una petición no cree otra confirmación.
  - Entrega: Confirmación con evidencia de identidad para el prototipo sintético; su adecuación al mecanismo jurídico de firma se valida en SEC-005 antes de H4.

- [ ] **API-010 — Crear adendas y correcciones trazables** · H1
  - Dependencias: [API-009](03_BACKEND_API.md).
  - Terminado cuando: una nota confirmada no se sobrescriba; la adenda conserve autor, motivo, fecha, vínculo y su propia confirmación.
  - Entrega: API de adendas y lectura histórica.

- [ ] **API-011 — Registrar información clínica estructurada** · H1
  - Dependencias: [API-007](03_BACKEND_API.md), [DAT-003](05_DATOS_Y_SEGURIDAD.md), [INI-004](00_TODO_INICIAL.md).
  - Terminado cuando: diagnósticos, observaciones, alergias y antecedentes conserven código, texto, unidad cuando aplique y procedencia; la sospecha no se convierta en diagnóstico confirmado.
  - Entrega: Modelo clínico mínimo validado por el profesional responsable.

- [ ] **API-012 — Publicar formularios por especialidad** · H2
  - Dependencias: [API-008](03_BACKEND_API.md), [INI-004](00_TODO_INICIAL.md).
  - Terminado cuando: existan borrador, publicado y retirado; se impida modificar una versión publicada y se mantenga representación histórica.
  - Entrega: Plantillas iniciales para general, especializada, nutrición y procedimientos según priorización.

- [ ] **API-013 — Completar procedimientos y seguimiento** · H2
  - Dependencias: [API-011](03_BACKEND_API.md), [API-012](03_BACKEND_API.md).
  - Terminado cuando: los formularios aprobados capturen vacunación, procedimientos, nutrición y planes; órdenes/remisiones identifiquen al profesional autorizante.
  - Entrega: Flujos de procedimientos, vacunación, especialidades y nutrición, con ejemplos validados; facturación se completa en API-015.

## Servicios administrativos y adopción

- [ ] **API-014 — Controlar metadatos y permisos de documentos** · H2
  - Dependencias: [API-009](03_BACKEND_API.md), [DAT-005](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: todo archivo se vincule a paciente/episodio de la IPS, esté validado antes de leerse y tenga descarga autorizada y auditada.
  - Entrega: API de adjuntos y solicitudes de exportación.

- [ ] **API-015 — Implementar dominio de facturación asistencial** · H3
  - Dependencias: [API-009](03_BACKEND_API.md), [API-013](03_BACKEND_API.md), [CON-003](09_CONTRATOS_API.md).
  - Terminado cuando: los importes usen precisión decimal, se conserven tarifas aplicadas y la máquina de estados permita rechazo, corrección y conciliación sin duplicar documentos fiscales.
  - Entrega: Cuentas, facturas, notas relacionadas y puertos de integración.

- [ ] **API-016 — Crear consultas e indicadores operativos** · H3
  - Dependencias: [API-006](03_BACKEND_API.md), [API-009](03_BACKEND_API.md), [API-015](03_BACKEND_API.md).
  - Terminado cuando: las cifras concilien con operaciones del período, la paginación sea estable y los permisos restrinjan detalles clínicos.
  - Entrega: Consultas de producción, citas, pendientes y facturación.

- [ ] **API-017 — Recibir preadmisiones mediante enlaces limitados** · H3
  - Dependencias: [API-004](03_BACKEND_API.md), [API-006](03_BACKEND_API.md), [SEC-007](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: los tokens caduquen, no revelen historia y las entradas se mantengan pendientes hasta validación por personal autorizado.
  - Entrega: API de enlaces y conciliación de datos.

- [ ] **API-018 — Crear importación de maestros con vista previa** · H3
  - Dependencias: [API-004](03_BACKEND_API.md), [SVC-001](04_SERVICIOS_E_INTEGRACIONES.md), [SEC-004](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: una carga sintética de hasta 5.000 pacientes muestre errores, duplicados y conciliación; reejecutarla no duplique registros.
  - Entrega: Proceso de carga, reporte, reversión controlada y registro de origen.

- [ ] **API-019 — Resolver duplicados sin perder historia** · H3
  - Dependencias: [API-004](03_BACKEND_API.md), [API-010](03_BACKEND_API.md), [SEC-003](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: una conciliación autorizada conserve identificadores previos y referencias clínicas; no se borren documentos confirmados ni se mezclen IPS.
  - Entrega: Caso de uso de unificación con simulación y auditoría.

## Reglas que deben conservarse

- Ningún endpoint público acepta `authorId`, `signedAt`, `role` o `organizationId` para confiar en ellos como autorización. La identidad efectiva proviene del contexto validado.
- Una atención referencia la versión del formulario usada. Una nota confirmada solo admite nuevas adendas y documentos relacionados.
- Los procesos externos no actualizan tablas clínicas. Sus resultados pasan por casos de uso autorizados del núcleo.
- El estado comercial de la licencia no concede acceso a datos clínicos y no elimina información por falta de pago.
- Los totales, cuotas, límites de IA y tarifas tienen vigencia y configuración; no se dispersan como constantes en controladores.
