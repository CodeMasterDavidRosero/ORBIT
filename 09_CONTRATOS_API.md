# Contratos de API y eventos

Este documento define el contrato inicial que se convertirá a OpenAPI. No representa endpoints ya implementados.

## Convenciones

- Base pública `/api/v1`, JSON UTF-8, UUID como identificadores, instantes ISO 8601 en UTC y fechas sin hora para nacimiento.
- `X-Organization-Id` se valida contra membresía y recurso. Nunca concede autoridad por sí sola.
- `X-Correlation-Id` se genera/valida para trazas, sin nombres ni documentos de identidad.
- Web usa cookie de sesión BFF y CSRF en escrituras. Móvil usa bearer token OIDC. Son clientes distintos del mismo contrato de negocio.
- Respuestas con datos clínicos llevan `Cache-Control: no-store`. No incluir datos sensibles en URL, errores o logs; la búsqueda de identificación usa cuerpo POST.
- Listados con cursor opaco y límite acotado. La API valida tamaño, filtros y orden; el cliente no envía SQL ni nombres libres de columna.
- Borradores y recursos editables exponen ETag. PUT/PATCH/confirmación requieren If-Match; falta de precondición produce 428 y versión diferente 412.
- Las operaciones sensibles a duplicados exigen `Idempotency-Key`. El servidor conserva organización, actor, operación, hash de solicitud y resultado. Reusar clave con otro contenido produce 409.
- Retención inicial de idempotencia operativa: 48 horas, a validar según reintentos. Facturación conserva además claves y referencias de negocio por el período aplicable, sin depender de ese TTL.
- Estados HTTP: 200/201 completado, 202 trabajo aceptado, 400 sintaxis, 401 autenticación, 403 falta de permiso, 404 recurso no visible, 409 conflicto de negocio, 412 concurrencia, 422 validación, 428 precondición, 429 límite. No revelar la existencia de recursos de otra IPS.

## Recursos iniciales

| Método y ruta | Función | Hito |
|---|---|---|
| `GET /api/v1/me` | Identidad, membresías y permisos efectivos | H0 |
| `POST /api/v1/patients/search` | Búsqueda demográfica autorizada y paginada | H0 |
| `POST /api/v1/patients` | Alta idempotente | H0 |
| `GET /api/v1/patients/{id}` | Ficha mínima autorizada | H0 |
| `PATCH /api/v1/patients/{id}` | Edición demográfica con If-Match | H0 |
| `GET /api/v1/professionals` | Profesionales y servicios permitidos | H1 |
| `GET /api/v1/appointments` | Agenda por rango y profesional | H1 |
| `POST /api/v1/appointments` | Reserva con control de franja | H1 |
| `POST /api/v1/appointments/{id}/reschedule` | Reprogramación auditada | H1 |
| `POST /api/v1/appointments/{id}/cancel` | Cancelación con motivo | H1 |
| `POST /api/v1/encounters` | Abrir atención autorizada | H1 |
| `POST /api/v1/encounters/{id}/notes` | Crear borrador ligado a plantilla | H1 |
| `GET /api/v1/notes/{id}` | Leer versión autorizada y ETag | H1 |
| `PATCH /api/v1/notes/{id}` | Guardar borrador | H1 |
| `POST /api/v1/notes/{id}/sign` | Confirmación explícita e inmutable | H1 |
| `POST /api/v1/notes/{id}/addenda` | Crear adenda separada | H1 |
| `POST /api/v1/notes/{id}/ai-jobs` | Solicitar borrador asistido y reservar cuota | H2 |
| `GET /api/v1/ai-jobs/{id}` | Estado y resultado autorizado | H2 |
| `POST /api/v1/notes/{id}/apply-ai-suggestions` | Aplicar campos seleccionados con If-Match | H2 |
| `POST /api/v1/exports` | Pedir exportación con alcance autorizado | H2 |
| `GET /api/v1/exports/{id}` | Consultar estado y descarga temporal | H2 |
| `POST /api/v1/invoices` | Crear documento de negocio | H3 |
| `POST /api/v1/invoices/{id}/submissions` | Enviar a integración | H3 |
| `GET /api/v1/invoices/{id}/submissions/{submissionId}` | Estado, rechazo y conciliación | H3 |

El contrato detallado añadirá endpoints de catálogos, plantillas, adjuntos y reportes al implementar sus tareas. No es obligatorio construir todos los recursos en H0.

## Ejemplo de borrador

Datos completamente ficticios. Los identificadores y códigos de catálogos del proyecto se validan en servidor.

```http
PATCH /api/v1/notes/00000000-0000-4000-8000-000000000020
X-Organization-Id: 00000000-0000-4000-8000-000000000001
If-Match: "7"
Idempotency-Key: 00000000-0000-4000-8000-000000000091
Content-Type: application/json
```

```json
{
  "sections": {
    "reasonForVisit": "Ejemplo ficticio para probar el formulario",
    "assessment": "Texto registrado por el profesional de pruebas"
  }
}
```

Respuesta 200 con `ETag: "8"` y una nota en `DRAFT`. El paciente, autor, organización, plantilla y estado no se reasignan mediante este PATCH. La ausencia de información obligatoria puede permitirse en borrador; la confirmación exige validación completa del servicio.

## Error de concurrencia

```json
{
  "type": "urn:clinical:problem:version-conflict",
  "title": "El registro cambió",
  "status": 412,
  "code": "NOTE_VERSION_CONFLICT",
  "detail": "Vuelve a cargar la versión vigente y revisa tus cambios.",
  "correlationId": "req-demo-001"
}
```

El cliente no resuelve el conflicto enviando la última versión automáticamente. Debe presentar la comparación y obtener una decisión del usuario.

## Trabajo asíncrono

Una solicitud de IA o exportación devuelve 202 con `jobId`, `status` y `statusUrl`. Estados: `QUEUED`, `RUNNING`, `SUCCEEDED`, `FAILED`, `CANCELLED`, `EXPIRED`. El resultado de IA incluye `sourceNoteVersion`; solo se aplica si corresponde al borrador vigente.

Para un timeout incierto de envío fiscal se utiliza el estado de integración `PENDING_RECONCILIATION`, independiente del estado del job técnico. Un trabajo fallido no significa que el tercero no haya emitido un documento.

Sobre mínimo de evento:

```json
{
  "eventId": "00000000-0000-4000-8000-000000000092",
  "eventType": "clinical.note.signed.v1",
  "occurredAt": "2026-10-08T17:00:00Z",
  "organizationId": "00000000-0000-4000-8000-000000000001",
  "aggregateId": "00000000-0000-4000-8000-000000000020",
  "aggregateVersion": 9,
  "correlationId": "req-demo-001",
  "payloadRef": "snapshot-demo-001"
}
```

`payloadRef` es una referencia interna autorizada, no una URL pública. El consumidor verifica contrato, versión, organización y duplicado. El broker y la cola de errores no contienen texto clínico, nombre ni documento del paciente. El servicio autorizado recupera un snapshot mínimo con su credencial y permiso de trabajo.

## Tareas de contrato

- [ ] **CON-001 — Crear OpenAPI canónico y ejemplos sintéticos** · H0
  - Dependencias: [INI-004](00_TODO_INICIAL.md), [SEC-001](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: se definan recursos H0/H1, seguridad, esquemas, errores y ejemplos válidos; la generación de interfaces y cliente Dart sea compatible con las herramientas fijadas.
  - Entrega: `contracts/openapi/clinical-v1.yaml` y validación; no mantener dos especificaciones divergentes.

- [ ] **CON-002 — Especificar concurrencia e idempotencia** · H0
  - Dependencias: [CON-001](09_CONTRATOS_API.md).
  - Terminado cuando: se documenten alcance de claves, hash, resultado almacenado, expiración y orden de evaluación; se prueben reenvío, cambio de payload y edición obsoleta.
  - Entrega: Casos de contrato. Tras autorizar al actor, una repetición válida recupera el resultado sin volver a ejecutar el efecto.

- [ ] **CON-003 — Versionar trabajos, eventos y adaptadores** · H2
  - Dependencias: [CON-001](09_CONTRATOS_API.md).
  - Terminado cuando: cada evento tenga esquema, propietario, versión y política de compatibilidad; se definan autenticación interna, reintentos y conciliación.
  - Entrega: Esquemas JSON y pruebas consumidor/productor con ejemplos sin información clínica.

- [ ] **CON-004 — Validar compatibilidad de releases** · H3
  - Dependencias: [CON-003](09_CONTRATOS_API.md), [OPS-003](07_DEVOPS_Y_QA.md), [OPS-004](07_DEVOPS_Y_QA.md).
  - Terminado cuando: un cambio incompatible falle el pipeline o tenga nueva versión y plan de migración de clientes; queden documentados deprecación y rollback.
  - Entrega: Reporte de diferencias de contrato y política de publicación.
