# ORBIT

Aplicación clínica ORBIT.

Plan técnico inicial · 8 de octubre de 2026 · Versión 0.1

Este paquete convierte la propuesta comercial en trabajo de desarrollo para ORBIT: una aplicación clínica Flutter web y móvil, una API y sus servicios auxiliares. Contiene arquitectura y tareas pendientes; todavía no contiene el código de la aplicación.

**Primer resultado buscado:** una recepcionista inicia sesión, registra un paciente ficticio y agenda una cita; un profesional abre la atención, guarda una nota, la confirma y consulta la auditoría. El mismo backend atiende Flutter web y Android. El diseño contempla iOS y su verificación con macOS/Xcode antes de publicarlo.

## Cómo empezar

1. Abrir [00_TODO_INICIAL.md](00_TODO_INICIAL.md) y seguir su orden de ejecución.
2. Leer [01_ARQUITECTURA.md](01_ARQUITECTURA.md) antes de crear el repositorio.
3. Convertir cada identificador de tarea en una incidencia o tarjeta. Su casilla original es la fuente del estado.
4. Marcar `[x]` solo al cumplir su criterio de aceptación y enlazar evidencia: commit, prueba o demostración. Las decisiones y los documentos no equivalen a código implementado.
5. Trabajar por entregas completas; una pantalla conectada a datos ficticios locales no demuestra que su API esté lista.

## Archivos y responsabilidades

| Archivo | Contenido |
|---|---|
| [00_TODO_INICIAL.md](00_TODO_INICIAL.md) | Arranque y secuencia de las primeras tareas |
| [01_ARQUITECTURA.md](01_ARQUITECTURA.md) | Stack, límites, despliegues y decisiones iniciales |
| [02_FRONTEND_FLUTTER.md](02_FRONTEND_FLUTTER.md) | Pantallas, estados, navegación y adaptación web/móvil |
| [03_BACKEND_API.md](03_BACKEND_API.md) | Casos de uso, reglas clínicas y persistencia |
| [04_SERVICIOS_E_INTEGRACIONES.md](04_SERVICIOS_E_INTEGRACIONES.md) | Procesamiento asíncrono, notificaciones, documentos y FEV/RIPS |
| [05_DATOS_Y_SEGURIDAD.md](05_DATOS_Y_SEGURIDAD.md) | Modelo inicial, aislamiento, permisos, trazabilidad y privacidad |
| [06_IA_CLINICA.md](06_IA_CLINICA.md) | Borradores, dictado, cuotas, revisión y evaluación |
| [07_DEVOPS_Y_QA.md](07_DEVOPS_Y_QA.md) | Entornos, automatización, pruebas y operación |
| [08_ROADMAP_Y_ENTREGAS.md](08_ROADMAP_Y_ENTREGAS.md) | Hitos, dependencias y condiciones de salida |
| [09_CONTRATOS_API.md](09_CONTRATOS_API.md) | Recursos HTTP, ejemplos, errores y contratos de eventos |

## Base de trabajo

- **Frontend:** Flutter y Dart, organización por funcionalidad, Riverpod y `go_router`.
- **Backend principal:** Java 21 y Spring Boot, módulos de dominio verificables con Spring Modulith, PostgreSQL y Flyway.
- **Identidad:** Keycloak/OIDC. Sesión de servidor para web y Authorization Code con PKCE para móvil.
- **Servicios:** worker Java para trabajos e integraciones; servicio Python/FastAPI para IA cuando llegue el hito H2.
- **Infraestructura:** Docker Compose, Redis para sesiones web, almacenamiento compatible con S3; RabbitMQ al habilitar trabajos externos.
- **Contrato:** REST/JSON y OpenAPI 3.1, con cliente Dart generado y versiones fijadas.

La elección de Spring Boot prioriza un núcleo tipado, transacciones consistentes y límites verificables entre módulos. Se plantea una sola IPS y sede para el piloto, con aislamiento por organización desde el modelo de datos. La arquitectura es una propuesta técnica inicial; se confirmará su ajuste a la experiencia del equipo antes de fijar las herramientas.

## Alcance comercial y desarrollo

El documento base es `Propuesta_Mejorada_IPS_PLUSSANAR.docx`. Los seis módulos ofertados se mantienen en el roadmap. Los 30 días y el precio de licencia de esa propuesta correspondían a implantación de una plataforma existente. **El esfuerzo y presupuesto de construir el producto se estimarán como desarrollo propio**, después del primer flujo medido. Las bolsas de IA y demás beneficios se implementarán como configuración de plan.

La primera fase será de desarrollo con datos sintéticos. La operación con pacientes reales exige completar los controles, validaciones clínicas e integraciones obligatorias aplicables a la IPS. Una demostración interna no sustituye esa aceptación.

## Fuentes técnicas consultadas

Referencias oficiales consultadas el 8 de octubre de 2026. Las decisiones del proyecto se distinguen de las capacidades documentadas por cada proveedor. Las versiones exactas se fijan en INI-003 y se revisan antes de cada publicación.

- [Arquitectura Flutter](https://docs.flutter.dev/app-architecture/recommendations): separación entre vistas, lógica y acceso a datos.
- [Riverpod](https://riverpod.dev/docs/introduction/getting_started) y [go_router](https://pub.dev/packages/go_router): estado e integración de rutas.
- [Spring Boot](https://docs.spring.io/spring-boot/system-requirements.html) y [Spring Modulith](https://docs.spring.io/spring-modulith/reference/fundamentals.html): compatibilidad y límites entre módulos.
- [PostgreSQL RLS](https://www.postgresql.org/docs/current/ddl-rowsecurity.html): políticas por fila; el propietario y roles privilegiados requieren especial cuidado.
- [Keycloak OIDC](https://www.keycloak.org/securing-apps/oidc-layers): identidad e intercambio de credenciales mediante protocolos estándar.
- [OpenAPI 3.1.1](https://spec.openapis.org/oas/v3.1.1.html): contratos HTTP; [RabbitMQ](https://www.rabbitmq.com/docs/reliability): confirmaciones, fallos y redelivery.
- [FastAPI](https://fastapi.tiangolo.com/deployment/concepts/): despliegue del servicio de IA.
- [OWASP API Security](https://api-security.owasp.org/editions/2023/en/0xa1-broken-object-level-authorization/): autorización de acceso a cada objeto.
- [Minsalud FEV/RIPS](https://www.minsalud.gov.co/sites/rid/Lists/BibliotecaDigital/RIDE/DE/DIJ/resolucion-0948-de-2026.pdf), [documento técnico RIPS](https://www.minsalud.gov.co/sites/rid/Lists/BibliotecaDigital/RIDE/DE/OT/anexo-tecnico1-resolucion-948-de-2026.pdf) e [IHCE](https://www.minsalud.gov.co/ihce/Paginas/default.aspx): insumos para la matriz normativa que debe mantenerse vigente.
