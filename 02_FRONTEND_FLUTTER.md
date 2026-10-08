# Frontend Flutter

Organizar `lib/features/<funcionalidad>/` con vistas, controladores de estado, modelos y repositorios. La UI accede al backend mediante interfaces de repositorio. El contrato OpenAPI genera DTO y cliente HTTP; las reglas clínicas definitivas se aplican en el servidor.

Estados obligatorios de pantalla: cargando, vacío, disponible, error, permiso insuficiente, sesión expirada y cambios sin guardar. Diseño adaptable para escritorio, tableta y teléfono; textos en español, fechas locales y cantidades con formato colombiano.

## Base y pacientes

- [ ] **FE-001 — Crear la aplicación y su estructura** · H0
  - Dependencias: [INI-002](00_TODO_INICIAL.md), [INI-003](00_TODO_INICIAL.md).
  - Terminado cuando: el proyecto compile para web y Android, tenga entornos separados y una pantalla inicial sin datos reales.
  - Entrega: Proyecto Flutter con configuración por entorno y lints.

- [ ] **FE-002 — Definir componentes y diseño adaptable** · H0
  - Dependencias: [FE-001](02_FRONTEND_FLUTTER.md).
  - Terminado cuando: haya navegación lateral en escritorio, navegación compacta en móvil, formularios legibles y estados comunes probados a 360, 768 y 1280 píxeles.
  - Entrega: Tema, componentes de formulario, mensajes y catálogo visual básico.

- [ ] **FE-003 — Integrar cliente HTTP tipado y control de sesión** · H0
  - Dependencias: [FE-001](02_FRONTEND_FLUTTER.md), [CON-001](09_CONTRATOS_API.md), [API-002](03_BACKEND_API.md), [SEC-002](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: web use sesión BFF y móvil token; existan timeout, cancelación y manejo de 401/403/409/412/422/429 sin reintentar escrituras a ciegas.
  - Entrega: Repositorio HTTP y generación reproducible del cliente Dart.

- [ ] **FE-004 — Implementar login y contexto de IPS** · H0
  - Dependencias: [FE-002](02_FRONTEND_FLUTTER.md), [FE-003](02_FRONTEND_FLUTTER.md), [API-003](03_BACKEND_API.md).
  - Terminado cuando: solo se muestren organizaciones autorizadas; logout limpie memoria y cambios de IPS invaliden cachés y peticiones pendientes.
  - Entrega: Acceso, selección de organización y navegación por permisos.

- [ ] **FE-005 — Crear búsqueda y ficha de paciente** · H0
  - Dependencias: [FE-004](02_FRONTEND_FLUTTER.md), [API-004](03_BACKEND_API.md).
  - Terminado cuando: la búsqueda paginada identifique claramente al paciente y maneje homónimos, falta de documento y ausencia de resultados.
  - Entrega: Listado y ficha demográfica con datos sintéticos.

- [ ] **FE-006 — Crear alta y edición demográfica** · H0
  - Dependencias: [FE-005](02_FRONTEND_FLUTTER.md), [API-004](03_BACKEND_API.md).
  - Terminado cuando: se validen tipos de documento, responsables y errores por campo; doble clic no duplique un alta y una edición concurrente no se sobrescriba.
  - Entrega: Formulario conectado y confirmación del registro persistido.

## Flujo clínico de la primera entrega

- [ ] **FE-007 — Implementar agenda por profesional** · H1
  - Dependencias: [FE-004](02_FRONTEND_FLUTTER.md), [API-005](03_BACKEND_API.md), [API-006](03_BACKEND_API.md).
  - Terminado cuando: puedan agendarse, cancelarse y reprogramarse citas; horarios ocupados y conflictos devueltos por el servidor se expliquen sin perder la selección.
  - Entrega: Vista semanal/diaria y lista móvil.

- [ ] **FE-008 — Implementar admisión e inicio de atención** · H1
  - Dependencias: [FE-005](02_FRONTEND_FLUTTER.md), [FE-007](02_FRONTEND_FLUTTER.md), [API-007](03_BACKEND_API.md).
  - Terminado cuando: la atención conserve paciente, profesional, sede y cita; se confirme identidad antes de abrir un episodio.
  - Entrega: Bandeja de pacientes citados y apertura de atención.

- [ ] **FE-009 — Construir el editor de nota y guardado de borrador** · H1
  - Dependencias: [FE-008](02_FRONTEND_FLUTTER.md), [API-008](03_BACKEND_API.md).
  - Terminado cuando: se vea un encabezado persistente de identidad, versión y estado de guardado; un 412 muestre conflicto y la navegación advierta cambios no guardados.
  - Entrega: Editor manual con autoguardado controlado y recuperación desde el servidor.

- [ ] **FE-010 — Mostrar diagnósticos y datos clínicos estructurados** · H1
  - Dependencias: [FE-009](02_FRONTEND_FLUTTER.md), [API-011](03_BACKEND_API.md), [DAT-003](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: el profesional seleccione términos y registre valores con unidades, procedencia y fecha; no se calculen hallazgos ausentes.
  - Entrega: Componentes de diagnósticos, alergias, antecedentes y observaciones.

- [ ] **FE-011 — Implementar confirmación y adendas** · H1
  - Dependencias: [FE-009](02_FRONTEND_FLUTTER.md), [FE-010](02_FRONTEND_FLUTTER.md), [API-009](03_BACKEND_API.md), [API-010](03_BACKEND_API.md).
  - Terminado cuando: la confirmación muestre resumen y versión; una nota confirmada sea de solo lectura y toda corrección se incorpore como adenda vinculada.
  - Entrega: Flujo de cierre, reautenticación cuando aplique y consulta del historial.

- [ ] **FE-012 — Gestionar conectividad y privacidad del cliente** · H1
  - Dependencias: [FE-009](02_FRONTEND_FLUTTER.md), [SEC-002](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: una caída conserve temporalmente el texto en memoria y avise que aún no está guardado; no haya historias en localStorage, caché HTTP o service worker.
  - Entrega: Pruebas de corte de red, caducidad de sesión y dispositivo compartido.

## Evolución del producto

- [ ] **FE-013 — Renderizar formularios versionados por servicio** · H2
  - Dependencias: [FE-009](02_FRONTEND_FLUTTER.md), [API-012](03_BACKEND_API.md).
  - Terminado cuando: se abran plantillas publicadas y sus validaciones; una actualización no cambie la representación de una atención histórica.
  - Entrega: Motor de formularios limitado a los tipos de campo aprobados.

- [ ] **FE-014 — Integrar revisión de borradores de IA** · H2
  - Dependencias: [FE-009](02_FRONTEND_FLUTTER.md), [AI-007](06_IA_CLINICA.md).
  - Terminado cuando: se comparen original, sugerencias y fuentes; puedan aceptarse campos individuales y descartar el resultado sin alterar la nota.
  - Entrega: Panel lateral en web y vista dedicada en móvil, sin autoaceptación.

- [ ] **FE-015 — Implementar adjuntos y exportación autorizada** · H2
  - Dependencias: [API-014](03_BACKEND_API.md), [SVC-004](04_SERVICIOS_E_INTEGRACIONES.md), [DAT-005](05_DATOS_Y_SEGURIDAD.md).
  - Terminado cuando: subidas muestren estado, errores y límites; descargas requieran permisos y enlaces temporales; el usuario vea si el documento es borrador.
  - Entrega: Gestión de archivos y descarga de PDF.

- [ ] **FE-016 — Construir pantalla de facturación y pendientes** · H3
  - Dependencias: [API-015](03_BACKEND_API.md), [SVC-005](04_SERVICIOS_E_INTEGRACIONES.md).
  - Terminado cuando: se distingan borrador, envío, rechazo, validación y conciliación; los reintentos no creen otra factura y el rechazo indique una acción.
  - Entrega: Bandeja FEV/RIPS y detalle de validaciones.

- [ ] **FE-017 — Añadir preadmisión y confirmación de citas** · H3
  - Dependencias: [API-017](03_BACKEND_API.md), [SVC-003](04_SERVICIOS_E_INTEGRACIONES.md).
  - Terminado cuando: los enlaces sean de uso acotado y los datos recibidos se revisen antes de actualizar el registro maestro.
  - Entrega: Flujo de preadmisión con caducidad y protección contra abuso.

- [ ] **FE-018 — Entregar indicadores operativos autorizados** · H3
  - Dependencias: [API-016](03_BACKEND_API.md).
  - Terminado cuando: cada rol vea solo cifras y detalles permitidos de citas, producción y pendientes; los filtros respeten sede y organización.
  - Entrega: Panel con exportación controlada y estados vacíos.

- [ ] **FE-019 — Comprobar accesibilidad y flujo multiplataforma** · H1
  - Dependencias: [FE-011](02_FRONTEND_FLUTTER.md), [FE-012](02_FRONTEND_FLUTTER.md).
  - Terminado cuando: se complete el flujo con teclado, foco visible, lector de pantalla y fuente ampliada; se pruebe en web y Android con usuarios reales del equipo clínico y datos ficticios.
  - Entrega: Evidencia de accesibilidad y prueba funcional por plataforma; ampliar a iOS en OPS-010.
