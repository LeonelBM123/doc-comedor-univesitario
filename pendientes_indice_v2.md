# Pendientes del índice de la versión 2 (`main_v2.tex`)

Estado al 13-nov-2026 (numeración nueva: 12 capítulos; Pruebas es el cap. 9, Marketing el 10, Puesta en marcha el 11 y Producto el 12; Implementación es 3.5, Pruebas (flujo PUDS) 3.6 y las Iteraciones 3.7 a 3.9; CASE es el cap. 4; Legal el 5; Infraestructura el 6 … Producto el 11; los números de los capítulos 8 a 17 que aparecen abajo son los antiguos). El índice completo está armado y compila (404 páginas). Lo que falta es **redactar el contenido** de las secciones marcadas `[PENDIENTE]` en `secciones_v2/` y completar unos pocos huecos de capítulos reutilizados.

Leyenda: ✅ redactado (reutilizado de `secciones/`) · 🔗 solo tiene una línea de referencia a otro capítulo (falta desarrollar) · ⬜ vacío, por redactar · ❓ requiere un dato o decisión del equipo antes de redactar.

## Resumen por capítulo

| Cap. | Título | Estado | Secciones por redactar |
|---|---|---|---|
| 1 | Plan de Administración de Proyectos (PAPS) | Parcial | 23 (1.9 a 1.16) |
| 2 | Manual de Calidad SQAP | ⬜ completo | 40 |
| 3 | Procesos de Desarrollo (PUDS) | Parcial | 29 (3.6 a 3.9) |
| 4 | ERS IEEE 830 | ✅ | 0 |
| 5 | Captura de Requisitos | ✅ | 0 |
| 6 | Análisis | ✅ casi | 3 introducciones/análisis |
| 7 | Diseño | ✅ casi | 1 introducción |
| 8 | Implementación | ⬜ | 12 |
| 9 | Pruebas | ⬜ | 12 |
| 10 | Herramientas CASE | ⬜ ❓ | 16 |
| 11 | Aspectos Legales | ⬜ | 15 |
| 12 | Infraestructura | Parcial | 16 (12.8 y 12.9) |
| 13 | Sitio Web de la Empresa | ⬜ ❓ | 18 |
| 14 | Estudio de Mercado | ⬜ ❓ | 30 |
| 15 | Marketing | ⬜ ❓ | 22 |
| 16 | Puesta en Marcha | ⬜ | 13 |
| 17 | Software como Producto | ⬜ | 3 |
| — | Conclusiones y Recomendaciones | Texto temporal | 2 |
| — | Anexos nuevos | ⬜ | 2 |

Total: unas **250 secciones** por redactar en `secciones_v2/`, más los 6 huecos de los capítulos 6, 7 y conclusiones.

---

## Detalle por capítulo

### Capítulo 1: PAPS (secciones 1.9 a 1.16; la 1.1 a 1.8 está ✅)

- [ ] 1.9 Desafíos de la ingeniería de software: 1.9.1 Calidad · 1.9.2 Productividad · 1.9.3 Innovación
- [ ] 1.10 Métricas del proyecto: 1.10.1 Funcionalidades importantes · 1.10.2 Captura de interfaces · 1.10.3 Características del desarrollador · 1.10.4 Métrica orientada al tamaño · 1.10.5 Aplicación de las métricas orientadas a la función (puntos de función)
- [ ] 1.11 Estimaciones
  - [ ] 1.11.1 Dimensiones: Tamaño · Complejidad · Estructuración del cliente
  - [ ] 1.11.2 Ámbito: 🔗 Objetivos del proyecto · 🔗 Objetivos específicos · 🔗 Requerimientos principales · ⬜ Rendimiento · ⬜ Fiabilidad · 🔗 Restricciones · ⬜ Infraestructura externa
  - [ ] 1.11.3 Estimaciones: Valor esperado · COCOMO II · Ecuación del software · Planning póker
- [ ] 1.12 Análisis de riesgos: 1.12.1 Identificación · 1.12.2 Probabilidad de presencia
- [ ] 1.13 Organización interna ❓
- [ ] 1.14 Mecanismos de seguimiento y control ❓
- [ ] 1.15 Tecnologías para el desarrollo 🔗 (apunta al cap. 12 y a 1.7.1; falta una síntesis propia)
- [ ] 1.16 Anexos del PAPS: 1.16.1 Líneas de código del sistema (se puede hacer al terminar la implementación)

### Capítulo 2: SQAP (todo ⬜)

- [ ] 2.1 Introducción · 2.2 Antecedentes · 2.3 Objetivos (2.3.1 General, 2.3.2 Específicos) · 2.4 Misión ❓ · 2.5 Visión ❓ · 2.6 Políticas de calidad ❓ · 2.7 Eslogan ❓
- [ ] 2.8 Patrón y metodología: 🔗 2.8.1 Metodología (PUDS) · ⬜ 2.8.2 Patrón de desarrollo, diseño y arquitectura
- [ ] 2.9 Plan de aseguramiento: 2.9.1 Propósito · 2.9.2 Objetivo · 2.9.3 Descripción · 2.9.4 Alcance (2.9.4.1 Cobertura por fase y flujo PUDS) · 2.9.5 Documentos de referencia
- [ ] 2.10 Gestión: 2.10.1 Organización (Organigrama) ❓ · 2.10.2 Tareas · 2.10.3 Responsabilidades (Equipo, SQA, Cliente, Gerencia de proyecto)
- [ ] 2.11 Documentación: 🔗 2.11.1.1 Modelo ERS (IEEE 830) · 🔗 2.11.2.1 Modelo DDS · ⬜ 2.11.3.1 Modelo del plan de V&V · ⬜ 2.11.4 (2.11.4.1 Reporte sumario, 2.11.4.2 Anomalías, 2.11.4.3 Final) · ⬜ 2.11.5 Documentación del usuario
- [ ] 2.12 Estándares: 2.12.1 Codificación · 2.12.2 Comentarios · 2.12.3 Responsables de verificar
- [ ] 2.13 Revisiones y auditorías: 2.13.1 Propósito · 2.13.2 Evaluación de productos (Objetivo, Procedimiento) · 2.13.3 Ajuste del proceso (Objetivo, Procedimiento) · 2.13.4 Revisión técnica formal (Objetivo, Procedimiento, Requerimientos mínimos)
- [ ] 2.14 Agenda · 2.15 Gestión de configuración · 2.16 Gestión de problemas y acciones correlativas · 2.17 Bibliografía

### Capítulo 3: Procesos de Desarrollo PUDS (3.1 a 3.5 ✅)

- [ ] 3.6 Definiciones iniciales (fase de Inicio)
  - [ ] 3.6.1 Equipo de desarrollo ❓ · 🔗 3.6.2 Objetivo del producto · 🔗 3.6.3 Requerimientos iniciales · 3.6.4 Duración de las iteraciones ❓ · 3.6.5 Infraestructura tecnológica (hardware y software) · 3.6.6 Flujo de trabajo inicial
  - [ ] 3.6.7 Modelos iniciales: Contexto · Datos · Arquitectura (Diagrama de despliegue)
  - [ ] 3.6.8 Criterios de calidad · 🔗 3.6.9 Lista priorizada de casos de uso
- [ ] 3.7, 3.8 y 3.9 Iteraciones 1, 2 y 3 ❓ (definir cuántas iteraciones y qué paquetes de CU lleva cada una). Cada una tiene: Planificación (casos de uso asignados, objetivo, proceso de desarrollo con diseño de BD y de arquitectura, lista de tareas) · Revisión · Retrospectiva

### Capítulos 6 y 7 (huecos en lo ya redactado)

- [ ] 6.1 Introducción del análisis de la arquitectura (`01_analisis_arquitectura.tex`)
- [ ] 6.1.3 Introducción del encapsulamiento de casos de uso por paquetes
- [ ] 6.3 Análisis de paquetes (solo tiene la figura; falta el análisis de cada paquete)
- [ ] 7.1 Introducción del diseño de la arquitectura
- [ ] Capítulo 6.2 y 5: la lista de casos de uso detallados está completa; revisar que todos los 26 CU tengan análisis y diseño antes del cierre

### Capítulo 8: Implementación (todo ⬜)

- [ ] 8.1 Estrategia · 🔗 8.2 Estándares de codificación · 8.3 Modelo de implementación (componentes, despliegue)
- [ ] 8.4 Implementación por paquetes: Cuentas y Acceso · Convocatoria y Postulación · Preselección con IA · Auditoría y Adjudicación · Becados y Asistencia · Reportes y Trazabilidad
- [ ] 8.5 Integración y construcción · 8.6 Interfaces implementadas (web, móvil)

### Capítulo 9: Pruebas (todo ⬜)

- [ ] 9.1 Pruebas · 9.2 Flujo de trabajo de pruebas en PUDS
- [ ] 9.3.1 Caja blanca ❓ (casos propuestos: CU-02, CU-03, CU-05)
- [ ] 9.3.2 Caja negra ❓ (mismos casos)
- [ ] 9.3.3 Vulnerabilidad: OWASP ZAP · prueba manual
- [ ] 9.3.4 Lista de comprobación · 9.4 Tiempo de respuesta (contrastar con RNF: carga ≤ 3 s, puntaje ≤ 5 s) · 9.5 Herramientas

### Capítulo 10: Herramientas CASE (todo ⬜ ❓ confirmar herramientas)

- [ ] 10.1.1 Enterprise Architect (Propósito, Modelos elaborados, Cómo lo usamos)
- [ ] 10.1.2 Jira (Funcionalidades, Integración, Beneficios, Aplicación, Cómo lo usamos)
- [ ] 10.1.3 Git y GitHub (Git, GitHub, Beneficios, Cómo lo usamos)
- [ ] 10.1.4 Antigravity (Funcionalidades, Beneficios, Aplicación, Cómo lo usamos)

### Capítulo 11: Aspectos Legales (todo ⬜)

- [ ] 11.1.1 Licencias (Software libre, Software privado) · 11.1.2 Razón social · 11.1.3 Organización jurídica (Alternativas, Tipo de sociedad)
- [ ] 11.1.4 Apertura de empresa: Ciudadanía Digital · SEPREC · Impuestos Nacionales · Licencia de funcionamiento (GAM) · CNS · Gestora Pública · Ministerio de Trabajo
- [ ] 11.2 Producto y propiedad intelectual: SENAPI (requisitos de registro de software) · Registro de marca
- [ ] 11.3 Bibliografía del capítulo (fuentes verificadas en `referencias.bib`)

### Capítulo 12: Infraestructura (12.1 a 12.7 ✅)

- [ ] 12.8.1 Gestión de configuración · 12.8.2 Configuración del software: Spring Boot · React · Flutter · Python · PostgreSQL · VS Code · Docker · Antigravity ❓
- [ ] 12.8.3 Gestión de proyectos (Jira ❓) · 12.8.4 Gestión de versiones (Git, GitHub) · 12.8.5 Gestión de documentos (Google Docs, Drive, LaTeX)
- [ ] 12.9 Anexos

### Capítulo 13: Sitio Web de la Empresa (todo ⬜ ❓ nombre y datos de la empresa)

- [ ] 13.1.1 Información principal · 13.1.2 Planificación · 13.1.3 Chatbot · 13.1.4 Comunicación con clientes (información, productos y servicios, formulario, chatbot, diseño responsivo)
- [ ] 13.1.5 Diseño y prototipo: Inicio · Ingreso a los sistemas · Misión y Visión · Fortalezas tecnológicas · Flujo del proceso · Chatbot · Muro de comentarios · Pie de página
- [ ] 13.2 Acceso: URL · QR

### Capítulo 14: Estudio de Mercado (todo ⬜ ❓ no inventar cifras)

- [ ] 14.1 Resumen ejecutivo · 14.2 Producto (Propuesta de valor, 🔗 Funcionalidades, Beneficios) · 🔗 14.3 Causas y consecuencias del problema
- [ ] 14.4 Competencia: Tendencias · Competidores · Público objetivo
- [ ] 14.5 Segmentación: geográfica · institucional · por necesidad · mercado inicial · mercado potencial · análisis de precios
- [ ] 14.6 Tecnologías y tendencias
- [ ] 14.7 Monetización y viabilidad: modelo · fuentes de ingresos (licenciamiento, implementación, capacitación, soporte, desarrollo personalizado) · licenciamiento · proyección de clientes e ingresos · punto de equilibrio · viabilidad
- [ ] 14.8 Modelo de negocio: modelo · ingresos · comercialización · expansión · sostenibilidad
- [ ] 14.9 Encuesta y resultados (requiere aplicar la encuesta)

### Capítulo 15: Marketing (todo ⬜ ❓)

- [ ] 15.1.1 Situación (fortalezas, público, posicionamiento) · 15.1.2 Contenidos (educativo, informativo, institucional, casos de uso)
- [ ] 15.1.3 Canales (Facebook, Instagram, LinkedIn, TikTok, web) · 15.1.4 Publicidad (Meta, LinkedIn, TikTok Ads, objetivos)
- [ ] 15.1.5 Presupuesto (redes, publicidad, mensual, anual, justificación) · 15.1.6 Anexos

### Capítulo 16: Puesta en Marcha (todo ⬜)

- [ ] 16.1 Despliegue: AWS · Azure · GCP · Play Store · 16.2 Planes y cotización · 16.3 Tipos de licencia
- [ ] 16.4 Términos y condiciones (normas bolivianas, suscripciones digitales) · 16.5 Políticas de seguridad y privacidad (leyes de datos personales, redacción)
- [ ] 16.6 Anexos: proyección de infraestructura · marco legal · recursos y evidencia

### Capítulo 17: Software como Producto (todo ⬜)

- [ ] 17.1.1 Manual de usuario · 17.1.2 Chatbots · 17.1.3 Tutoriales

### Final del documento

- [ ] Conclusiones y recomendaciones (hoy son texto temporal; redactar al terminar implementación y pruebas)
- [ ] Anexo: Carátula de la Propuesta y PAPS · Anexo: Códigos QR

---

## Decisiones y datos que bloquean la redacción

1. **Número de iteraciones** y qué paquetes (P1 a P6) entran en cada una (3.7 a 3.9).
2. **Herramientas reales del equipo** (Jira, Antigravity, Enterprise Architect, Docs/Drive) para los caps. 10 y 12.
3. **Datos de la empresa desarrolladora**: nombre, misión, visión, eslogan, organigrama, políticas de calidad, servicios y precios (caps. 2, 13, 14, 15, 16).
4. **Casos de uso a probar** en el cap. 9 (propuestos: CU-02, CU-03 y CU-05).
5. **Encuesta** del cap. 14.9: ¿se aplicará?
6. **Pendientes de la DUBSS** (ya conocidos): umbral mínimo de puntaje, número exacto de cupos, apelación del postulante.

## Qué se cambió respecto al índice original en PDF

| Índice original | En la versión 2 |
|---|---|
| Sprint 0, Sprints 1 a 3, historias de usuario (Scrum) | Definiciones iniciales e iteraciones con casos de uso (PUDS), cap. 3 |
| Métricas por 3 proyectos (Contrac_AR, K Activos Fijos, GIA) | Un solo bloque de métricas del sistema (1.10) |
| 1.3 a 1.6 (Desafíos, Métricas, Estimaciones, Riesgo) antes de Recursos | El perfil (1.1 a 1.8) va primero y la gestión (1.9 a 1.16) después, para reutilizar sin copiar |
| Anexos 1.12.1 a 1.12.3 (líneas de código de 3 proyectos) | 1.16.1 Líneas de código del sistema |
| Backend con Express | Spring Boot (stack real) |
| Pruebas en el cap. 9 y CASE en el cap. 4 | Pruebas sigue a Implementación (flujos PUDS); CASE pasa al cap. 10 |
| Sin capítulos de Requisitos, Análisis y Diseño | Caps. 4 a 7 reutilizados tal cual |
| Sitio Web, Marketing, etc. (caps. 7, 10…) | Caps. 13 y 15, mismo contenido |

Para avanzar sin confundirse, ver las reglas en `.claude/rules/` (en especial `03-secciones-v2-pendientes.md`).
