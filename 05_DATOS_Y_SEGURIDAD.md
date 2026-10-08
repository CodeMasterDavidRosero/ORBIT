# Datos y seguridad

## Modelo mínimo

| Grupo | Entidades iniciales | Regla principal |
|---|---|---|
| Organización | organization, site, membership, professional | Membresía y permiso se validan en cada acceso |
| Paciente | patient, patient_identifier, contact, guardian | Identificadores únicos cuando corresponda dentro de la IPS |
| Agenda | service, availability, appointment | Prohibir franjas incompatibles por recurso |
| Atención | encounter, observation, diagnosis, allergy, order | Todas las referencias pertenecen a la misma IPS |
| Documentación | note, note_version, attestation, addendum | Versiones confirmadas inmutables |
| Formularios | template, template_version, response | Respuestas ligadas a una versión publicada |
| Archivos | attachment, export_job | Objeto privado y acceso autorizado temporal |
| Automatización | ai_job, quota_reservation, usage_ledger | Cuota e idempotencia por IPS y período |
| Facturación | invoice, invoice_line, adjustment, submission | Precisión decimal, referencia externa y trazabilidad |
| Control | audit_event, outbox_event, idempotency_record | Evidencia transaccional y retención definida |

Usar UUID para identidad interna, `timestamptz` en UTC para instantes y `date` para fecha de nacimiento. Conservar zona de la sede para agenda. Mantener unidad y código junto a observaciones. Los datos demográficos, texto clínico y contexto no deben terminar en logs de aplicación.

## Datos y aislamiento

- [ ] **DAT-001 — Crear modelo relacional inicial** · H0
  - Dependencias: [INI-004](00_TODO_INICIAL.md), [CON-001](09_CONTRATOS_API.md).
  - Terminado cuando: existan claves y restricciones por organización, versión optimista y estados; las referencias compuestas impidan vincular paciente o sede de otra IPS.
  - Entrega: Diagrama de entidades, diccionario y migración Flyway inicial.

- [ ] **DAT-002 — Aplicar aislamiento por organización en PostgreSQL** · H0
  - Dependencias: [DAT-001](05_DATOS_Y_SEGURIDAD.md), [SEC-001](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: se prueben filtros de aplicación y RLS con rol de ejecución sin BYPASSRLS ni privilegios de propietario, contexto local a transacción y limpieza del pool.
  - Entrega: Pruebas con dos IPS sobre lectura, edición, búsqueda, referencias y operaciones masivas.

- [ ] **DAT-003 — Versionar catálogos clínicos y unidades** · H1
  - Dependencias: [INI-004](00_TODO_INICIAL.md), [DAT-001](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: se registre fuente, edición, vigencia y licencia de catálogos; los registros históricos retengan el significado usado aunque cambie el catálogo.
  - Entrega: Carga versionada de diagnósticos, procedimientos y unidades del alcance; evitar inventar códigos.

- [ ] **DAT-004 — Diseñar versiones, auditoría y outbox** · H1
  - Dependencias: [DAT-001](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: negocio, evidencia de cambio y evento se confirmen juntos; audit_event no permita UPDATE/DELETE al rol habitual y versiones confirmadas no cambien.
  - Entrega: Migraciones, control de permisos e invariantes transaccionales.

- [ ] **DAT-005 — Preparar almacenamiento privado de objetos** · H1
  - Dependencias: [DAT-001](05_DATOS_Y_SEGURIDAD.md), [SEC-004](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: metadatos y rutas estén aislados por IPS, enlaces expiren, el archivo sea verificado y cifrado, y se diferencien documentos clínicos de temporales.
  - Entrega: Buckets/prefijos, credenciales por servicio, cuarentena y política de ciclo de vida.

- [ ] **DAT-006 — Definir conservación, exportación y eliminación** · H3
  - Dependencias: [DAT-004](05_DATOS_Y_SEGURIDAD.md), [SEC-005](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: se diferencien registros clínicos, auditorías, copias, temporales de IA y solicitudes del titular; los plazos tengan fundamento y responsable, sin borrado automático genérico.
  - Entrega: Matriz de retención aprobada y pruebas de exportación y eliminación de temporales.

## Permisos por rol

| Rol | Puede operar | Límite inicial |
|---|---|---|
| Recepción | Demografía, citas y admisión | No leer narrativa clínica completa |
| Profesional | Atenciones asignadas/autorizadas, notas y adendas | No confirmar como otro profesional |
| Enfermería | Formularios y procedimientos habilitados | Permisos según servicio y atribución profesional |
| Facturación | Cuenta, soportes mínimos y validaciones | Acceso clínico solo al mínimo autorizado |
| Auditor clínico | Lectura justificada y trazabilidad | Sin sobrescribir notas |
| Administrador de IPS | Cuentas, sedes y configuración | Sin acceso clínico automático por ser administrador |
| Soporte técnico | Diagnóstico operativo controlado | Sin historias reales por defecto |
| Asesor comercial | Clientes, licencias y recaudo del proveedor | Sin acceso a datos asistenciales |

Los permisos son acciones y alcances concretos, no solo nombres de rol. El profesional validador determina qué servicios y campos puede operar cada perfil.

## Controles de acceso y privacidad

- [ ] **SEC-001 — Definir acciones autorizadas y alcance por rol** · H0
  - Dependencias: [INI-001](00_TODO_INICIAL.md), [INI-004](00_TODO_INICIAL.md).
  - Terminado cuando: la matriz incluya leer, crear, editar borrador, confirmar, añadir adenda, exportar y administrar; las denegaciones estén definidas.
  - Entrega: Política RBAC y acceso por relación con paciente/episodio.

- [ ] **SEC-002 — Definir sesiones seguras para web y móvil** · H0
  - Dependencias: [INI-003](00_TODO_INICIAL.md), [SEC-001](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: queden resueltos OIDC, PKCE, callback, cookies, CSRF, expiración, renovación y almacenamiento; no existan secretos embebidos ni tokens en localStorage.
  - Entrega: Diseño de autenticación y pruebas de acceso cruzado, múltiples pestañas y revocación.

- [ ] **SEC-003 — Auditar lectura, cambios y exportaciones** · H1
  - Dependencias: [DAT-004](05_DATOS_Y_SEGURIDAD.md), [SEC-001](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: se registren actor, organización, acción, recurso, resultado, fecha, motivo cuando aplique y correlación; los eventos de lectura también tengan política de durabilidad.
  - Entrega: Consulta de auditoría restringida y alertas de acceso anómalo sin duplicar narrativa clínica.

- [ ] **SEC-004 — Proteger secretos y datos en tránsito y reposo** · H0
  - Dependencias: [INI-003](00_TODO_INICIAL.md), [SEC-001](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: TLS, credenciales mínimas, cifrado de datos/copias y gestión de claves estén definidos; volcados, logs y telemetría no expongan historias ni tokens.
  - Entrega: Configuración local segura y requisitos de claves/rotación para staging y producción.

- [ ] **SEC-005 — Construir matriz normativa vigente y requisitos de firma** · H3
  - Dependencias: [INI-001](00_TODO_INICIAL.md), [INI-004](00_TODO_INICIAL.md).
  - Terminado cuando: el responsable revise historia clínica, conservación, Ley 1581 y datos sensibles, FEV/RIPS, firma electrónica e IHCE/RDA; cada requisito se vincule a prueba, fuente y fecha.
  - Entrega: Revisión de Resolución 0948 de 2026 y sus documentos técnicos; para IHCE revisar 1888 de 2025 y modificaciones, incluida 1799 de 2026. Confirmar vigencia y aplicabilidad antes del piloto real.

- [ ] **SEC-006 — Autorizar el uso de datos reales y de IA** · H3
  - Dependencias: [SEC-005](05_DATOS_Y_SEGURIDAD.md), [AI-002](06_IA_CLINICA.md), [DAT-006](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: existan finalidades, contratos de tratamiento, evaluación de impacto, subencargados, retención y procedimiento de consentimiento aplicable.
  - Entrega: Acta de habilitación de datos reales; desarrollo y demostraciones previas continúan con datos sintéticos.

- [ ] **SEC-007 — Controlar abuso, archivos y acceso por objeto** · H2
  - Dependencias: [API-004](03_BACKEND_API.md), [API-014](03_BACKEND_API.md), [DAT-005](05_DATOS_Y_SEGURIDAD.md), [SEC-001](05_DATOS_Y_SEGURIDAD.md), [SEC-004](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: se prueben autorización de cada ID, límites de tamaño/frecuencia, contenido malicioso, URL temporal, fuerza bruta y ausencia de secretos en respuestas.
  - Entrega: Casos negativos ampliados a archivos y exportaciones; el aislamiento básico ya se verifica en DAT-002 y OPS-005.

- [ ] **SEC-008 — Definir contingencia e incidentes clínicos** · H3
  - Dependencias: [SEC-003](05_DATOS_Y_SEGURIDAD.md), [OPS-007](07_DEVOPS_Y_QA.md), [OPS-008](07_DEVOPS_Y_QA.md).
  - Terminado cuando: haya responsables, comunicación, recuperación y operación ante pérdida de conectividad; cualquier acceso de emergencia tenga motivo, duración y revisión.
  - Entrega: Procedimientos validados por la IPS. Activar acceso de emergencia solo si el servicio lo requiere y su control está probado.

## Regla de integridad clínica

`draft → signed` produce una versión congelada y evidencia de confirmación profesional. Una corrección posterior es una adenda nueva. El hash ayuda a comprobar integridad; no acredita por sí solo la identidad del autor ni reemplaza los requisitos jurídicos del mecanismo de firma. Las migraciones y accesos de administración deben preservar esta regla.
