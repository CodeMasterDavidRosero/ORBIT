# Servicios e integraciones

## Límites de despliegue

`clinical-api` mantiene los estados de negocio. `clinical-worker` maneja documentos y comunicaciones. `ai-service` se define en su propio TODO. `integration-worker` mantiene los intercambios con terceros de salud. Cada proceso usa credenciales y almacenamiento lógico propios.

Los workers obtienen únicamente el snapshot autorizado para el trabajo. Los eventos transportan referencias y metadatos mínimos; los payloads clínicos se conservan cifrados en almacenamiento controlado y no se copian a la cola, logs o cola de errores. Los snapshots tienen hash, versión, vencimiento y permisos de servicio.

## Trabajo asíncrono

- [ ] **SVC-001 — Implementar outbox, publicación y consumo durable** · H2
  - Dependencias: [API-001](03_BACKEND_API.md), [DAT-004](05_DATOS_Y_SEGURIDAD.md), [CON-003](09_CONTRATOS_API.md), [OPS-001](07_DEVOPS_Y_QA.md).
  - Terminado cuando: la transacción de negocio no dependa del broker, se recuperen eventos no publicados y el consumidor confirme solo después de persistir su efecto.
  - Entrega: Workers con publisher confirms, inbox de deduplicación, reintentos acotados y cola de errores.

- [ ] **SVC-002 — Aislar credenciales y datos de los servicios** · H2
  - Dependencias: [SVC-001](04_SERVICIOS_E_INTEGRACIONES.md), [SEC-004](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: cada servicio tenga identidad, scopes, permisos de cola y base propia; un job solo permita leer su snapshot y registrar su resultado.
  - Entrega: Políticas de acceso interno, sin acceso SQL a la base clínica.

- [ ] **SVC-003 — Construir el manejador de notificaciones** · H2
  - Dependencias: [SVC-002](04_SERVICIOS_E_INTEGRACIONES.md), [API-006](03_BACKEND_API.md).
  - Terminado cuando: se envíe correo de prueba sin diagnóstico ni información clínica, con deduplicación, preferencias y estados; se disponga de simulador de fallos.
  - Entrega: Canal de correo inicial y puertos para SMS/WhatsApp con tarifas y autorización pendientes.

- [ ] **SVC-004 — Construir generación asíncrona de documentos** · H2
  - Dependencias: [SVC-002](04_SERVICIOS_E_INTEGRACIONES.md), [API-014](03_BACKEND_API.md).
  - Terminado cuando: el PDF refleje el snapshot exacto y su condición de borrador o confirmado, registre versión de plantilla y conserve permisos de descarga.
  - Entrega: Worker PDF y reporte de fallos con reejecución idempotente.

## Conectores de salud

- [ ] **SVC-005 — Implementar adaptador de facturación y FEV RIPS** · H3
  - Dependencias: [SVC-002](04_SERVICIOS_E_INTEGRACIONES.md), [API-015](03_BACKEND_API.md), [SEC-005](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: se seleccione proveedor o ruta autorizada, se documenten credenciales de pruebas y versiones de formatos, y se demuestre envío y validación en el ambiente que corresponda.
  - Entrega: Adaptador real, simulador y matriz de casos RIPS/FEV/CUV con evidencia; nunca marcar mock como integración aprobada.

- [ ] **SVC-006 — Gestionar respuestas, reintentos y conciliación** · H3
  - Dependencias: [SVC-005](04_SERVICIOS_E_INTEGRACIONES.md).
  - Terminado cuando: callbacks autenticados, duplicados y fuera de orden no corrompan estados; un timeout se investigue con la referencia del proveedor antes de reenviar.
  - Entrega: Bandeja técnica, estados pendientes de conciliación y operación manual autorizada.

- [ ] **SVC-007 — Evaluar e implementar IHCE y RDA aplicables** · H3
  - Dependencias: [SVC-002](04_SERVICIOS_E_INTEGRACIONES.md), [API-013](03_BACKEND_API.md), [SEC-005](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: se determine alcance vigente de la IPS, perfiles, catálogos, mecanismos de conexión y plazos; si aplica al piloto real, se complete prueba con evidencia antes de H4.
  - Entrega: Adaptador a perfiles oficiales o decisión documentada de no aplicabilidad; una decisión pendiente bloquea producción real.

- [ ] **SVC-008 — Configurar terceros por organización** · H3
  - Dependencias: [SVC-002](04_SERVICIOS_E_INTEGRACIONES.md), [SEC-004](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: cada IPS tenga credenciales cifradas y configuración versionada de proveedor, sede, numeración y canal; se verifique aislamiento y rotación.
  - Entrega: Configuración segura y pruebas sin credenciales de producción.

- [ ] **SVC-009 — Probar fallos de servicios y recuperación** · H3
  - Dependencias: [SVC-003](04_SERVICIOS_E_INTEGRACIONES.md), [SVC-004](04_SERVICIOS_E_INTEGRACIONES.md), [SVC-006](04_SERVICIOS_E_INTEGRACIONES.md).
  - Terminado cuando: duplicación, pérdida de conexión, caída del broker y eventos antiguos tengan resultados deterministas; la consulta manual siga disponible.
  - Entrega: Matriz de fallos y runbook de reenvío con autorización.

- [ ] **SVC-010 — Planear el módulo comercial del proveedor** · H5
  - Dependencias: [INI-005](00_TODO_INICIAL.md), [API-016](03_BACKEND_API.md).
  - Terminado cuando: licencias, recaudos y bonificaciones de asesores estén separados de la facturación asistencial y de los permisos clínicos; las tasas sean configurables.
  - Entrega: Backlog de portal comercial, renovaciones, cuotas y liquidación sobre recaudo neto; no bloquea H0 a H4.

## Contrato de responsabilidad

| Operación | Autoridad de negocio | Ejecutor externo |
|---|---|---|
| Confirmar una nota | Núcleo y profesional autorizado | Ninguno |
| Generar borrador de IA | Núcleo autoriza contexto y cuota | Servicio de IA |
| Aplicar sugerencias | Profesional, mediante núcleo | Ninguno |
| Emitir y validar factura | Núcleo conserva estado y referencia | Integración/proveedor habilitado |
| Obtener CUV | Respuesta del mecanismo oficial | Adaptador de integración |
| Enviar recordatorio | Núcleo autoriza destinatario y propósito | Worker de notificaciones |
| Exportar documento | Núcleo controla alcance y permiso | Worker de documentos |

La prevalidación local ayuda a detectar errores; no sustituye una respuesta oficial de validación. El procesamiento tiene límites, reintentos con espera creciente y una vía de revisión humana. Los errores no deben incluir contenido clínico en mensajes al operador comercial.
