# Plan de pendientes del documento v2 — reparto entre dos personas

Inventario de lo que falta en `main_v2.tex` (numeración vigente de 12 capítulos), dividido entre **Persona A** y **Persona B**, más las dos tareas pedidas sobre el capítulo 3 (corregirlo según PUDS y dividir los casos de uso en ciclos). Estado al **13-nov-2026**.

- La implementación del sistema (código) ya está repartida en [`plan_desarrollo_tareas.md`](plan_desarrollo_tareas.md) con las mismas Personas A y B (58 puntos cada una). Este plan reparte **el documento** y usa el mismo criterio: cada persona documenta lo que construye.
- Quién es A y quién es B lo deciden ustedes; el reparto no depende de los nombres.
- Los conteos son aproximados: cuentan los marcadores `[PENDIENTE]` de cada archivo (≈ 281 en total: 144 para A y 137 para B). Una sección con `[PENDIENTE]` puede ser una línea o varias páginas.
- Según el cronograma del proyecto (24-ago a 30-nov-2026) quedan **17 días**. Por eso §5 da un orden de ataque y §4 lista lo que bloquea.

| | Persona A | Persona B |
|---|---|---|
| Código (plan_desarrollo_tareas.md) | Cuentas, auditoría y adjudicación, BI, notificaciones (58 pts) | Postulación, IA, becados y asistencia, bitácora (58 pts) |
| Documento (secciones pendientes) | ≈ 144 | ≈ 137 |
| Tema del documento | PAPS, SQAP, Inicio e iteraciones 1 y 3, CASE, infraestructura | Pruebas, iteración 2, paquetes de postulación/IA/becados, y los capítulos de la empresa de software |

---

## 1. Tareas compartidas (nuevas)

| ID | Tarea | Responsable | Detalle |
|---|---|---|---|
| DC-1 | **Corregir el capítulo 3 para que concuerde con PUDS** | A (B revisa) | Ver §2 |
| DC-2 | **Dividir los casos de uso en ciclos (iteraciones) según PUDS** | A y B juntos | Propuesta en §3; al aprobarla se llenan 3.7 a 3.9 |
| DC-3 | Cerrar los datos y decisiones que bloquean | A y B | §4 |
| DC-4 | Revisión final | A y B | Compilar `main` y `main_v2`, comparar el índice con el de referencia, revisar referencias cruzadas («sección 3.x», «Capítulo N») y reescribir Conclusiones y Recomendaciones (hoy son texto temporal) |

---

## 2. DC-1 — Corregir el capítulo 3 según PUDS

Fuente de PUDS del proyecto: sección «Metodología» del perfil (`secciones/02_capitulo1_perfil/05_metodologia.tex`, basada en Jacobson, Booch y Rumbaugh, 1999): dirigido por casos de uso, centrado en la arquitectura, iterativo e incremental; cuatro fases (Inicio, Elaboración, Construcción, Transición) y cinco flujos de trabajo que se ejecutan **dentro de cada iteración**. Todo lo que sigue es **por verificar con el docente**: son las diferencias que encontré entre el capítulo 3 actual y esa descripción.

| # | Qué revisar | Estado actual | Corrección propuesta |
|---|---|---|---|
| 1 | Los flujos de trabajo van dentro de cada iteración | 3.2 a 3.6 describen los flujos para los 26 CU de una vez y las iteraciones 3.7 a 3.9 quedan aparte | En cada iteración, listar sus CU y enlazar a sus secciones de requisitos (3.2.7.N), análisis (3.3.2.N), diseño (3.4.x) y a su implementación y pruebas |
| 2 | Fases del PUDS | El capítulo no dice a qué fase corresponde cada parte | Mapear: Inicio = 3.1; Elaboración = iteración 1 (arquitectura base y camino crítico); Construcción = iteraciones 2 y 3; Transición = pruebas de aceptación, despliegue y capacitación (caps. 9, 11 y 12) |
| 3 | Contenido de la fase de Inicio (3.1) | Copia el «Sprint 0» del índice de referencia: equipo, duración de iteración, infraestructura | Ajustar al PUDS: alcance y viabilidad, actores y CU más relevantes, riesgos críticos, arquitectura candidata y plan |
| 4 | Vocabulario | «Revisión» y «Retrospectiva» de iteración (equivalencias Scrum → PUDS de `.claude/rules/02-puds-y-dominio.md`) | Confirmar con el docente si se usa «evaluación de la iteración» |
| 5 | Casos de uso asignados | Vacío en las tres iteraciones | Llenar con la división de §3 |
| 6 | Diseño de BD y arquitectura por iteración | Vacío | Mostrar solo las tablas y componentes que cada iteración agrega |
| 7 | Cierre | No hay evidencia de que cada iteración termina en un incremento ejecutable | Agregar a cada iteración el incremento que entrega y su criterio de aceptación |

Archivos: `secciones_v2/cap03_procesos_puds/` (`01_definiciones_iniciales.tex`, `07_iteraciones.tex`, `capitulo3.tex`).

---

## 3. DC-2 — División de los 26 CU en ciclos

**Criterios (PUDS):** se priorizan los CU por valor y riesgo; cada ciclo termina en un incremento ejecutable; los «include» van en el mismo ciclo que su CU base y los «extend» pueden ir después; ambos integrantes trabajan en cada ciclo. Se usan las prioridades y dependencias de `casos_de_uso_filtrados.md` §3 y los puntos y dueños de `plan_desarrollo_tareas.md`. **Propuesta, por aprobar.**

| Ciclo | Fase PUDS | CU | Persona A | Persona B | Incremento que entrega |
|---|---|---|---|---|---|
| **1** | Elaboración | CU-01, 14, 13, 16, 18, 02, 03, 04 (+ tareas extra: entorno local, interceptor de bitácora, servicio de notificaciones, datos semilla) | A1, A2, A3, A5, A7, A15 = **21 pts** | B1, B5, B6, B7, B8, B2, B3 = **28 pts** | Un postulante se registra, adjunta documentos, envía su postulación y recibe su puntaje de IA; consulta su estado. Deja la arquitectura base (API, JWT, Storage, módulo Python) |
| **2** | Construcción | CU-06, 05, 07, 19, 20, 21, 22, 23, 09, 17, 26 | A6, A12, A9, A10, A11, A8, A13 = **24 pts** | B10, B11, B9, B4 = **16 pts** | La DUBSS prioriza, audita y adjudica; se publican resultados; se crea el padrón y la planilla de asistencia |
| **3** | Construcción | CU-10, 11, 24, 12, 08, 25, 15 | A16, A14, A4 = **13 pts** | B12, B13, B14, B15 = **14 pts** | Asistencia digital con cotejo, historial del becado, bitácora, dashboard BI, acta y perfil |
| — | Transición | Sin CU nuevos | Los dos | Los dos | Pruebas de aceptación de punta a punta, correcciones, manual de usuario, despliegue (caps. 9, 11, 12) |

- Puntos por ciclo: **49 / 40 / 27** (total 116 = 58 + 58, igual que `plan_desarrollo_tareas.md`). Ninguna relación UML cruza entre personas.
- Los 15 CU de prioridad Alta, salvo el dashboard (CU-12), quedan en los ciclos 1 y 2; el ciclo 3 reúne Media, Baja y el BI, que necesita datos acumulados de CU-02, 05 y 10.
- **Include en el mismo ciclo:** CU-02 con 03, 16 y 18 (ciclo 1); CU-05 con 06 y 07, y CU-07 con 21 (ciclo 2); CU-10 con CU-11, que lo extiende (ciclo 3).
- **Extend en un ciclo posterior:** CU-17 (de CU-02) y CU-26 (de CU-03) en el 2; CU-15 (de CU-01) y CU-08 (de CU-05) en el 3.
- En el ciclo 2, B trabaja con datos semilla de adjudicados (contrato C4 de `plan_desarrollo_tareas.md`) hasta que A12 esté listo.
- CU-08, 10, 11 y 17 siguen pendientes de consulta u observación; no cambian el reparto.

---

## 4. Datos y decisiones que bloquean (DC-3)

| # | Falta | Bloquea | Quién lo resuelve |
|---|---|---|---|
| 1 | **3 software de referencia** para métricas y puntos de función (con repositorio público para medir con `cloc`) | 1.4 y 1.12 (DA-1) | A y B eligen; A mide |
| 2 | Herramientas reales del equipo (Jira, Antigravity, Enterprise Architect, Docs/Drive) | Cap. 4, 6.8 | A y B |
| 3 | Datos de la empresa de software: nombre, misión, visión, eslogan, organigrama, políticas de calidad, servicios y precios | Cap. 2 (2.4 a 2.7, 2.10), 5, 7, 8, 10, 11 | A y B; **no se inventan** |
| 4 | Casos de uso a probar en el cap. 9 (propuestos: CU-02, 03 y 05) | Cap. 9 | B |
| 5 | ¿Se aplicará la encuesta del cap. 8 (8.9)? | 8.9 | B |
| 6 | Confirmar con el docente: ciclos de §3, títulos del flujo de pruebas (3.6) y vocabulario de §2 | 3.1, 3.6, 3.7 a 3.9 | A |
| 7 | Pendientes con la DUBSS: umbral mínimo de puntaje, número de cupos, apelación del postulante | Cap. 3 y requisitos | A y B |
| 8 | Alinear el texto de las secciones 3.2 y 3.4 con la decisión de autenticación propia (JWT) y con los estados de la postulación (`plan_desarrollo_tareas.md` §6, puntos 1 y 5) | 3.2.3, 3.4 | A |

---

## 5. Persona A — ≈ 144 secciones

| ID | Tarea | Archivos | ≈ Sec. | Notas |
|---|---|---|---|---|
| DA-1 | **Cap. 1 PAPS completo**: 1.3 Desafíos, 1.4 Métricas (3 software), 1.5 Estimaciones, 1.6 Riesgos, 1.9 a 1.12 | `secciones_v2/cap01_paps/` | 36 | 1.5 se puede escribir ya con los 26 CU y `plan_desarrollo_tareas.md`; 1.4 y 1.12 esperan el dato 1 de §4 |
| DA-2 | **Cap. 2 SQAP** completo | `secciones_v2/cap02_sqap/capitulo2.tex` | 40 | Misión, visión, políticas y organigrama esperan el dato 3 |
| DA-3 | **Cap. 3**: DC-1; 3.1 Inicio; 3.7 Iteración 1 y 3.9 Iteración 3 (casos de uso, objetivo, diseño de BD y arquitectura, tareas, revisión, retrospectiva); 3.5 Implementación: estrategia, modelo, integración y paquetes Cuentas y Acceso, Auditoría y Adjudicación, Reportes y Trazabilidad | `secciones_v2/cap03_procesos_puds/` | 9 + 14 + 7 = 30 | Depende de DC-2 |
| DA-4 | Introducciones que faltan en Análisis (3.3.1 arquitectura, 3.3.1.3 encapsulamiento, 3.3.3 análisis de paquetes) y en Diseño (introducción de 3.4.1) | `secciones/08_capitulo6_analisis/`, `secciones/09_capitulo7_diseno/` | 4 | Son archivos compartidos con `main.tex`: escribir sin números de capítulo fijos |
| DA-5 | **Cap. 4 Herramientas CASE** | `secciones_v2/cap04_herramientas_case/` | 17 | Esperan el dato 2 |
| DA-6 | **Cap. 6**: 6.8 Gestión de infraestructura y 6.9 Anexos | `secciones_v2/cap06_infraestructura/` | 17 | Esperan el dato 2 |

## 6. Persona B — ≈ 137 secciones

| ID | Tarea | Archivos | ≈ Sec. | Notas |
|---|---|---|---|---|
| DB-1 | **Cap. 3**: 3.6 Pruebas (flujo PUDS); 3.8 Iteración 2; 3.5 Implementación: paquetes Convocatoria y Postulación, Preselección con IA, Becados y Asistencia, e interfaces web y móvil | `secciones_v2/cap03_procesos_puds/` | 7 + 7 + 5 = 19 | Depende de DC-2 |
| DB-2 | **Cap. 9 Pruebas en el software**: técnicas, caja blanca y negra, vulnerabilidad, lista de comprobación, tiempo de respuesta (RNF: 3 s y 5 s), herramientas | `secciones_v2/cap09_pruebas/` | 15 | Espera el dato 4; los resultados reales llegan al final |
| DB-3 | **Cap. 5 Aspectos legales** | `secciones_v2/cap05_legal/` | 15 | Citar solo fuentes verificadas en `referencias.bib` |
| DB-4 | **Cap. 7 Sitio web de la empresa** | `secciones_v2/cap07_sitio_web/` | 18 | Espera el dato 3 |
| DB-5 | **Cap. 8 Estudio de mercado** | `secciones_v2/cap08_mercado/` | 30 | Sin cifras inventadas; espera los datos 3 y 5 |
| DB-6 | **Cap. 10 Marketing** | `secciones_v2/cap10_marketing/` | 22 | Espera el dato 3 |
| DB-7 | **Cap. 11 Puesta en marcha** | `secciones_v2/cap11_puesta_marcha/` | 13 | Despliegue, licencias y políticas de privacidad |
| DB-8 | **Cap. 12 Software como producto** y anexos (carátula de la propuesta y PAPS, códigos QR) | `secciones_v2/cap12_producto/`, `secciones_v2/anexos_v2.tex` | 3 + 2 = 5 | El manual de usuario se escribe al terminar la implementación |

---

## 7. Orden de ataque sugerido

1. **Primero (desbloquea a todos):** DC-2 (aprobar los ciclos) y los datos de §4. Mientras tanto, cada persona avanza en lo que no depende de ellos: A en 1.5, 1.6, 1.3 y 1.9 a 1.11; B en el cap. 5 (legal) y el cap. 11 (puesta en marcha).
2. **Después:** DC-1 y las iteraciones (DA-3, DB-1), junto con DA-2 (SQAP) y DB-3 a DB-5.
3. **Con el código avanzado:** 3.5 Implementación por paquetes, cap. 9 con resultados reales, 3.6 Pruebas, 3.7 a 3.9 (revisión y retrospectiva), manual de usuario.
4. **Al final:** DC-4 (revisión conjunta, Conclusiones y compilación de ambos documentos).

Reglas de edición (de `.claude/rules/`): no inventar datos institucionales, de mercado ni fuentes; los capítulos 3 a 7 de `main.tex` se comparten con la v2 mediante macros (`\wfa`, `\wn`…), así que al editar `secciones/` hay que compilar **ambos** documentos.
