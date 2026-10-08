# TODO inicial

**Objetivo H0:** repositorio reproducible, infraestructura local, autenticación y registro de un paciente sintético desde Flutter web y Android.
**Objetivo H1:** completar agenda, atención, nota, cierre y auditoría.

Las tareas `INI` se gestionan aquí. Las filas del orden de ejecución enlazan tareas de los otros archivos y no duplican sus casillas. Los códigos H0 a H5 representan entregas, no fechas prometidas.

## Preparar el proyecto

- [ ] **INI-001 — Delimitar el piloto y las personas responsables** · H0
  - Dependencias: ninguna.
  - Terminado cuando: queden definidos una IPS, sede, servicio clínico inicial, profesional validador, responsable funcional, volumen esperado, plataformas y modalidad nube o servidor de la IPS.
  - Entrega: Ficha de alcance y lista de decisiones pendientes con responsable; usar datos ficticios mientras se resuelven.

- [ ] **INI-002 — Crear el repositorio y sus convenciones** · H0
  - Dependencias: ninguna.
  - Terminado cuando: existan las carpetas de arquitectura, política de ramas, revisión de cambios, `.gitignore`, `.env.example` sin secretos e instrucciones de arranque; elegir remoto sin publicar información clínica.
  - Entrega: Repositorio local y documentación. La creación o publicación del remoto se ejecuta en la fase de implementación con el destino acordado.

- [ ] **INI-003 — Fijar versiones compatibles de herramientas y librerías** · H0
  - Dependencias: [INI-002](00_TODO_INICIAL.md).
  - Terminado cuando: Flutter estable, Dart asociado, Java 21, Spring Boot/Modulith compatibles, Maven Wrapper, PostgreSQL, Keycloak, Redis y herramientas de contrato estén fijados con su fecha y soporte; descartar snapshots, tags `latest` y combinaciones sin verificar.
  - Entrega: `docs/runtime-contract.md`, archivos de bloqueo y versiones de imágenes. Añadir Python, FastAPI y RabbitMQ cuando se habiliten sus servicios.

- [ ] **INI-004 — Recopilar formularios y reglas del servicio inicial** · H0
  - Dependencias: [INI-001](00_TODO_INICIAL.md).
  - Terminado cuando: se disponga de formularios vacíos autorizados, campos obligatorios, estados de cita y atención, tipos de identificación, tratamiento de menores, perfiles y reglas para corregir una nota.
  - Entrega: Ejemplos sintéticos aprobados por el responsable clínico; no copiar historias reales al repositorio.

- [ ] **INI-005 — Estimar el desarrollo por capacidad y entregables** · H0
  - Dependencias: [INI-001](00_TODO_INICIAL.md), [INI-004](00_TODO_INICIAL.md).
  - Terminado cuando: se registren integrantes, horas disponibles, costos de infraestructura e integraciones, supuestos y estimación por hito; se actualice con el tiempo real de H0/H1.
  - Entrega: Estimación del producto separada del precio de venta de una licencia y del plazo de implantación de una IPS.

## Orden de ejecución de las primeras tareas

| Orden | Tareas | Resultado |
|---|---|---|
| 1 | INI-001, INI-004, SEC-001 | Alcance, formulario y roles del piloto |
| 2 | INI-002, INI-003 | Repositorio y herramientas fijadas |
| 3 | OPS-001, OPS-002 | PostgreSQL, identidad y entorno local |
| 4 | CON-001, CON-002, DAT-001, API-001, FE-001, FE-002 | Contrato, migración base y proyectos compilando |
| 5 | SEC-002, SEC-004, DAT-002, API-002, API-003 | Login y acceso limitado a la IPS autorizada |
| 6 | API-004, FE-003, FE-004, FE-005, FE-006 | Paciente creado y consultado desde ambos clientes |
| 7 | OPS-003, OPS-004 | Compilación y comprobación automática del contrato |
| 8 | DAT-003, DAT-004, SEC-003; API-005 a API-011; FE-007 a FE-012 | Primer flujo de atención completo H1 |
| 9 | OPS-005, FE-019 | Demostración y pruebas de permisos, aislamiento, concurrencia y accesibilidad |

Los rangos de códigos indican tareas consecutivas; siempre revisar las dependencias particulares antes de ejecutarlas.

## Verificar el equipo de desarrollo

Estos comandos son de diagnóstico y se ejecutarán en el equipo que usaremos para programar:

```bash
git --version
flutter doctor -v
java -version
docker version
docker compose version
```

Android requiere SDK/emulador o un dispositivo de pruebas. La compilación y firma de iOS requieren un entorno macOS con Xcode y las cuentas correspondientes. El trabajo inicial de web y Android puede avanzar desde Windows.

## Demostración de H0

Recepcionista ficticia → autenticación → organización autorizada → alta de paciente → búsqueda → resultado persistido después de recargar. Un segundo usuario de otra organización no debe poder leerlo cambiando la URL, el identificador o la cabecera de organización.

Al terminar, registrar evidencia en la incidencia de cada tarea y avanzar a H1. No marcar agenda, IA o facturación como completas por haber creado sus menús.
