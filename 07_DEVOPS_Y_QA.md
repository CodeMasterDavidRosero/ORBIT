# Entornos, operación y calidad

Separar desarrollo local, staging y producción. Cada entorno tendrá identidad, datos, claves, almacenamiento y configuración propios. Los pipelines se diseñan para el proveedor Git que se elija; este TODO no presupone una cuenta, un servidor contratado ni una publicación autorizada.

## Entorno y automatización

- [ ] **OPS-001 — Preparar infraestructura local reproducible** · H0
  - Dependencias: [INI-002](00_TODO_INICIAL.md), [INI-003](00_TODO_INICIAL.md).
  - Terminado cuando: Compose levante PostgreSQL, Keycloak, Redis y proxy local con healthchecks, volúmenes y seed sintético; existan perfiles posteriores para objetos, broker y workers.
  - Entrega: Archivos Compose fijados, límites de recursos y comandos de arranque/parada documentados.

- [ ] **OPS-002 — Documentar configuración y arranque del equipo** · H0
  - Dependencias: [OPS-001](07_DEVOPS_Y_QA.md).
  - Terminado cuando: un equipo limpio pueda iniciar servicios sin secretos del autor, con rutas de emulador/localhost, puertos, certificados de desarrollo y configuración por entorno resueltos.
  - Entrega: Guía Windows/PowerShell y alternativa shell; `.env.example` validado.

- [ ] **OPS-003 — Crear pipeline de backend y contratos** · H0
  - Dependencias: [API-001](03_BACKEND_API.md), [CON-001](09_CONTRATOS_API.md).
  - Terminado cuando: se compilen módulos, validen dependencias arquitectónicas y contrato, ejecuten pruebas relevantes y analicen secretos, dependencias e imágenes.
  - Entrega: Pipeline con evidencia y fallos accionables; no exigir cobertura artificial de getters.

- [ ] **OPS-004 — Crear pipeline Flutter y generación de cliente** · H0
  - Dependencias: [FE-001](02_FRONTEND_FLUTTER.md), [CON-001](09_CONTRATOS_API.md).
  - Terminado cuando: se ejecuten formato, análisis, pruebas de estado críticas y build web/Android; regenerar cliente no deje diferencias no versionadas.
  - Entrega: Pipeline reproducible con artefactos de prueba privados.

- [ ] **OPS-005 — Probar permisos, aislamiento y concurrencia** · H1
  - Dependencias: [API-009](03_BACKEND_API.md), [API-010](03_BACKEND_API.md), [DAT-002](05_DATOS_Y_SEGURIDAD.md), [FE-011](02_FRONTEND_FLUTTER.md).
  - Terminado cuando: base PostgreSQL real de pruebas verifique doble reserva, dos editores, doble confirmación, ID de otra IPS, sesión vencida y auditoría sin pérdida.
  - Entrega: Suite de integración y recorrido web/Android, ejecutada antes de aceptar H1.

- [ ] **OPS-006 — Probar fallos externos y contratos asíncronos** · H3
  - Dependencias: [SVC-009](04_SERVICIOS_E_INTEGRACIONES.md), [AI-009](06_IA_CLINICA.md), [CON-003](09_CONTRATOS_API.md).
  - Terminado cuando: se simulen duplicación, desconexión, respuesta tardía, cuotas concurrentes y callbacks fuera de orden sin duplicar efectos.
  - Entrega: Pruebas con simuladores y evidencia separada de las pruebas oficiales de integraciones.

## Preparación de operación real

- [ ] **OPS-007 — Preparar staging privado con HTTPS** · H2
  - Dependencias: [OPS-003](07_DEVOPS_Y_QA.md), [OPS-004](07_DEVOPS_Y_QA.md), [SEC-004](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: se replique la topología mínima sin exposición pública de bases, broker o consola de administración; exista acceso controlado y datos sintéticos.
  - Entrega: Despliegue automatizado a infraestructura elegida, con DNS y costos documentados antes de provisionar.

- [ ] **OPS-008 — Probar copia, restauración y recuperación** · H3
  - Dependencias: [DAT-005](05_DATOS_Y_SEGURIDAD.md), [DAT-006](05_DATOS_Y_SEGURIDAD.md), [OPS-007](07_DEVOPS_Y_QA.md).
  - Terminado cuando: se restaure una IPS de prueba y sus objetos en un entorno aislado con sus claves; se midan pérdida recuperable y tiempo real de recuperación.
  - Entrega: Runbook y prueba. Objetivos iniciales a validar con la IPS: RPO de 15 minutos y RTO de 4 horas, sin tratarlos como SLA demostrado.

- [ ] **OPS-009 — Implementar observabilidad sin datos clínicos** · H2
  - Dependencias: [OPS-007](07_DEVOPS_Y_QA.md), [SEC-003](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: logs, métricas y trazas usen correlación y datos minimizados; se disparen alertas de outbox atascado, backup, colas, cuota y disponibilidad ante fallos simulados.
  - Entrega: Paneles, alertas y acceso restringido a telemetría; sin cuerpos clínicos en trazas.

- [ ] **OPS-010 — Verificar iOS en macOS y dispositivo de prueba** · H2
  - Dependencias: [FE-019](02_FRONTEND_FLUTTER.md), [SEC-002](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: compilen los plugins elegidos, funcione OIDC/retorno, grabación y almacenamiento seguro; los permisos se expliquen y las credenciales de firma no entren al repo.
  - Entrega: Build y prueba de iOS; publicación en tiendas es una acción posterior con cuentas y autorización correspondientes.

- [ ] **OPS-011 — Medir rendimiento y costos del piloto** · H3
  - Dependencias: [OPS-006](07_DEVOPS_Y_QA.md), [OPS-009](07_DEVOPS_Y_QA.md), [API-016](03_BACKEND_API.md).
  - Terminado cuando: se acuerden usuarios concurrentes y volumen; se mida p95 de operaciones, latencia de trabajos, consumo y costo por IPS bajo una carga representativa.
  - Entrega: Informe contra objetivos acordados y presupuesto; dimensionamiento antes de comprometer SLA.

- [ ] **OPS-012 — Gestionar actualizaciones y reversión de versiones** · H3
  - Dependencias: [OPS-007](07_DEVOPS_Y_QA.md), [OPS-008](07_DEVOPS_Y_QA.md).
  - Terminado cuando: cada release tenga versiones fijadas, inventario de componentes y migraciones compatibles; se ensaye volver a la app anterior o corregir hacia adelante sin perder registros.
  - Entrega: Proceso de actualización, revisión de vulnerabilidades y recuperación de base.

- [ ] **OPS-013 — Aceptar el piloto de producción** · H4
  - Dependencias: [OPS-005](07_DEVOPS_Y_QA.md), [OPS-006](07_DEVOPS_Y_QA.md), [OPS-008](07_DEVOPS_Y_QA.md), [OPS-010](07_DEVOPS_Y_QA.md), [OPS-011](07_DEVOPS_Y_QA.md), [OPS-012](07_DEVOPS_Y_QA.md), [SEC-006](05_DATOS_Y_SEGURIDAD.md), [SEC-007](05_DATOS_Y_SEGURIDAD.md), [SEC-008](05_DATOS_Y_SEGURIDAD.md), [SVC-007](04_SERVICIOS_E_INTEGRACIONES.md), [SVC-008](04_SERVICIOS_E_INTEGRACIONES.md), [FE-016](02_FRONTEND_FLUTTER.md), [CON-004](09_CONTRATOS_API.md).
  - Terminado cuando: responsable clínico y operativo aprueben casos críticos, integraciones exigibles, restauración, formación, soporte y costos; todo bloqueo de seguridad o integridad esté resuelto.
  - Entrega: Acta de salida, versión publicada, responsables de soporte y plan de observación inicial.

## Criterio común de terminado

Una tarea de implementación se cierra con cambio revisado, documentación del comportamiento relevante, pruebas del riesgo que controla y evidencia ejecutada en el entorno indicado. Una dependencia externa inaccesible se registra como bloqueo; no se sustituye su validación real por un indicador verde del simulador.

Los accesos, costos y despliegues externos se concretan con los destinos del proyecto. El plan inicial puede elaborarse y el entorno local puede construirse sin contratar servicios por adelantado.
