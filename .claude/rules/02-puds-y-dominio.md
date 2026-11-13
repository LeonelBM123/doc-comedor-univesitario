# Regla: metodología PUDS (no Scrum) y fuente de verdad del dominio

## Metodología
- Ambos documentos usan **PUDS** (Proceso Unificado de Desarrollo de Software), UML e IEEE 830.
- El índice de referencia de la v2 venía de un proyecto con **Scrum**. Está adaptado: **no existen** sprints, Sprint Backlog, Planning/Retrospectiva de sprint ni historias de usuario (HU). Equivalencias:

| Scrum (índice original) | PUDS (esta documentación) |
|---|---|
| Sprint 0 / definiciones iniciales | Fase de **Inicio** (cap. 3, sección 3.6) |
| Sprint 1, 2, 3 | **Iteraciones** (cap. 3, 3.7–3.9; número por definir) |
| Historia de usuario (HU) | **Caso de uso** (CU) |
| Product Backlog | Lista priorizada de CU (cap. 5, sección 5.3) |
| Sprint Backlog | Lista de tareas de la iteración |
| Revisión / Retrospectiva de sprint | Revisión / Retrospectiva de la iteración |

- Flujos de trabajo PUDS = capítulos: Requisitos (5, con ERS en 4), Análisis (6), Diseño (7), Implementación (8), Pruebas (9). Fases: Inicio, Elaboración, Construcción, Transición.
- Nunca introducir terminología Scrum al redactar.

## Fuentes de verdad (en orden)
1. **Casos de uso y numeración:** `CLAUDE.md` §6 (26 CU, CU-01…CU-26). Si otro archivo usa otra numeración, prevalece §6 y se avisa al usuario.
2. **RF/RNF:** `secciones/05_capitulo4_ieee830/03_requisitos_especificos.tex`.
3. **Paquetes, priorización:** `casos_de_uso_filtrados.md`; **plan de implementación (no del documento):** `plan_desarrollo_tareas.md`.
4. **Diseño de BD y análisis:** `diseno_base_de_datos.md`, `diagramas_analisis_cu.md`, `actores_por_cu.md`.
5. El texto en bruto del usuario llega por `texto_formatter/` (solo lectura).

## No inventar
- No inventar datos institucionales (umbral de puntaje, número de cupos, formatos), cifras de mercado, precios, presupuestos, URLs, autores ni fuentes. Marcar como **«por definir»** / `[PENDIENTE]`.
- Las herramientas del equipo (Jira, Antigravity, Enterprise Architect…) están **sin confirmar**; preguntar antes de afirmar su uso.
- Misión, visión, eslogan y políticas de calidad del cap. 2 son del **equipo desarrollador** (la DUBSS es el *cliente*; su misión/visión ya están en 3.1).
- Los capítulos 11, 13, 14, 15 y 16 (legal, sitio web, mercado, marketing, puesta en marcha) son de empresa de software: pedir al usuario los datos (nombre de la empresa, servicios, precios) antes de redactarlos.
