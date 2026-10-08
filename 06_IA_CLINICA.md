# Asistencia de IA para documentación clínica

El servicio recibe notas o dictado del profesional y devuelve un borrador estructurado con fuente por sugerencia. La selección clínica, la confirmación del diagnóstico, las órdenes y el cierre del registro permanecen a cargo del profesional. El primer alcance no incluye diagnóstico autónomo, prescripción automática ni conversación clínica directa con pacientes.

## Flujo

1. La API comprueba usuario, IPS, episodio, permisos, consentimiento aplicable y cuota.
2. Reserva consumo y crea un trabajo ligado a la versión de la nota y a un snapshot autorizado.
3. El worker procesa el trabajo y valida la salida contra un esquema estricto.
4. El resultado conserva origen, modelo, versión de instrucciones y campos pendientes.
5. El profesional revisa y selecciona sugerencias. La API las incorpora a un borrador con If-Match.
6. La confirmación clínica utiliza el flujo habitual del núcleo y una acción explícita independiente.

## Tareas

- [ ] **AI-001 — Crear servicio y worker de IA** · H2
  - Dependencias: [SVC-001](04_SERVICIOS_E_INTEGRACIONES.md), [SVC-002](04_SERVICIOS_E_INTEGRACIONES.md), [INI-003](00_TODO_INICIAL.md).
  - Terminado cuando: FastAPI exponga solo endpoints internos necesarios y el trabajo pesado se ejecute fuera de la petición HTTP, con dependencias fijadas y proveedor simulado.
  - Entrega: Servicio Python, worker y pruebas del contrato de trabajo.

- [ ] **AI-002 — Elegir proveedor bajo requisitos de privacidad y costo** · H2
  - Dependencias: [SEC-004](05_DATOS_Y_SEGURIDAD.md), [INI-005](00_TODO_INICIAL.md).
  - Terminado cuando: se comparen retención, uso para entrenamiento, localización, contrato, precisión de español, latencia y costo real; el contrato permita el tratamiento previsto.
  - Entrega: ADR de proveedor y configuración reemplazable; ningún compromiso de costo sin medición.

- [ ] **AI-003 — Implementar generación estructurada con fuentes** · H2
  - Dependencias: [AI-001](06_IA_CLINICA.md), [AI-002](06_IA_CLINICA.md), [API-008](03_BACKEND_API.md).
  - Terminado cuando: la respuesta incluya sección, sugerencia, referencia exacta al origen y campos no soportados; preserve negaciones y sospechas, sin completar hechos ausentes.
  - Entrega: Esquema de salida validado y corpus sintético de regresión.

- [ ] **AI-004 — Añadir transcripción del dictado profesional** · H2
  - Dependencias: [AI-003](06_IA_CLINICA.md), [DAT-005](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: se manejen ruido, segmentos dudosos y términos clínicos; usuario confirme transcripción antes de usarla y audio temporal tenga eliminación verificable.
  - Entrega: Carga/transcripción con límite de duración, acceso privado y política de retención.

- [ ] **AI-005 — Aplicar cuotas y registro de consumo** · H2
  - Dependencias: [AI-001](06_IA_CLINICA.md), [DAT-001](05_DATOS_Y_SEGURIDAD.md), [CON-002](09_CONTRATOS_API.md).
  - Terminado cuando: la reserva sea atómica, dos trabajos no superen la cuota, fallos se reconcilien y reintentos no se cobren dos veces; períodos sean explícitos.
  - Entrega: Planes configurables: propuesta inicial de 500 operaciones y 120 minutos por sede/mes, alertas 80% y 100%, sin recarga automática.

- [ ] **AI-006 — Aislar entradas y controlar fallos del modelo** · H2
  - Dependencias: [AI-003](06_IA_CLINICA.md).
  - Terminado cuando: texto y documentos se traten como datos no confiables, se bloqueen instrucciones insertadas, y la IA no tenga credenciales ni herramientas para cambiar registros.
  - Entrega: Pruebas de prompt injection, respuesta inválida, timeout y caída del proveedor; edición manual siempre disponible.

- [ ] **AI-007 — Exponer resultado y aplicar selecciones con revisión** · H2
  - Dependencias: [AI-003](06_IA_CLINICA.md), [AI-005](06_IA_CLINICA.md), [API-008](03_BACKEND_API.md).
  - Terminado cuando: GET del trabajo compruebe permisos; aplicar una sugerencia sea una acción del profesional con versión vigente y rechazo de contexto obsoleto.
  - Entrega: Endpoints públicos mediados por la API clínica; el servicio IA nunca confirma ni escribe notas clínicas.

- [ ] **AI-008 — Evaluar utilidad y errores con revisión clínica** · H2
  - Dependencias: [AI-004](06_IA_CLINICA.md), [AI-006](06_IA_CLINICA.md), [AI-007](06_IA_CLINICA.md).
  - Terminado cuando: se evalúen al menos 30 casos comparables por servicio, tiempo de documentación, omisiones, negaciones y datos inventados; el clínico autorice el alcance demostrado.
  - Entrega: Informe del piloto. Reducir 25% el tiempo es una meta a medir, no una capacidad ya probada; un error material bloquea la función afectada hasta corregirla.

- [ ] **AI-009 — Medir costo y habilitar desconexión por función** · H2
  - Dependencias: [AI-005](06_IA_CLINICA.md), [AI-008](06_IA_CLINICA.md).
  - Terminado cuando: haya costo por operación/minuto y por IPS, límites de gasto, métricas sin contenido clínico y un interruptor que desactive IA sin afectar la consulta.
  - Entrega: Panel de consumo, alarmas y procedimiento de contingencia.

- [ ] **AI-010 — Preparar extracción de formularios desde documentos** · H3
  - Dependencias: [AI-008](06_IA_CLINICA.md), [DAT-005](05_DATOS_Y_SEGURIDAD.md), [API-012](03_BACKEND_API.md).
  - Terminado cuando: OCR o extracción conserve documento/página/campo fuente, señale dudas y requiera revisión antes de actualizar un dato.
  - Entrega: Extensión opcional después del borrador por texto y voz; costo y cuota definidos por separado.

## Casos de rechazo mínimos

Paciente equivocado; nota modificada durante el trabajo; síntoma negado que el modelo vuelve positivo; dosis inexistente; diagnóstico solo sugerido convertido en confirmado; mezcla de dos pacientes; cuota agotada; consentimiento ausente cuando sea necesario; credencial vencida; respuesta incompleta; instrucción maliciosa incrustada en un documento.

La IA debe dejar vacío o marcar pendiente el dato sin respaldo. La confianza que declare un modelo no constituye una garantía; se usarán indicadores de procedencia y revisión efectiva.
