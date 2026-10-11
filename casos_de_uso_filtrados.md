# Lista filtrada de casos de uso — Beca Comedor (DUBSS–UAGRM)

Filtrada a partir de las anotaciones hechas en [`CLAUDE.md`](CLAUDE.md) §6 y §8. Resultado: **28 casos de uso vigentes** (de 37 originales; 10 descartados, 1 separado en dos).
Se renumeraron de forma consecutiva; la columna *ID previo* conserva la trazabilidad con `CLAUDE.md` y el diagrama actual (Fig. 18).

**Cómo interpreté las anotaciones**

| Anotación | Tratamiento |
|---|---|
| (Descartado) | Se elimina de la lista. |
| (Separarlo) | CU-13 original se divide en dos CU independientes (CU-13 y CU-14). |
| (Observado) | Se conserva, pero queda **pendiente de revisión** (no sé cuál fue la observación; confirmar). |
| (preguntar) | Se conserva, pero queda **pendiente de consulta** a la DUBSS/docente. |
| Texto añadido en CU-28 | CU "Notificar finalistas…" absorbe "comunicados/avisos" (por eso CU-37 se descartó). |

---

## 1. Casos de uso vigentes

| ID | ID previo | Caso de uso | Actor | Relaciones | RF | Estado |
|---|---|---|---|---|---|---|
| CU-01 | CU-01 | Registrarse y autenticarse | Postulante, Admin, Directivo | — | RF-01 | OK |
| CU-02 | CU-02 | Enviar postulación a Beca Comedor | Postulante | «include» CU-03, CU-18, CU-20 | RF-02 | OK |
| CU-03 | CU-03 | Precalificar postulación con Inteligencia Artificial | Sistema | — | RF-03 | OK |
| CU-04 | CU-04 | Consultar estado de postulación | Postulante | «extend» CU-05 | RF-06 | OK |
| CU-05 | CU-06 | Auditar y adjudicar becas | Admin | «include» CU-07, CU-08; «extend» CU-09, CU-24 | RF-04 | OK |
| CU-06 | CU-07 | Visualizar lista priorizada de postulantes | Admin | — | RF-04 | OK |
| CU-07 | CU-08 | Auditar expediente finalista | Admin | «include» CU-23; «extend» CU-21, CU-22 | RF-04 | OK |
| CU-08 | CU-09 | Generar acta de adjudicación | Admin | — | RF-04 | ❓ Preguntar |
| CU-09 | CU-10 | Generar planilla de asistencia | Admin | — | RF-05 | OK |
| CU-10 | CU-11 | Registrar asistencia digital | Personal del Comedor | «extend» CU-12 | RF-05 | ⚠️ Observado |
| CU-11 | CU-12 | Cotejar registro contra respaldo físico | Admin | — | RF-05 | ❓ Preguntar |
| CU-12 | CU-13 (parte 1) | Visualizar dashboard de indicadores BI | Directivo | — | RF-07 | Separado |
| CU-13 | CU-17 | Gestionar convocatoria y gestión académica | Admin | — | RF-09 | OK |
| CU-14 | CU-18 | Gestionar usuarios y roles | Admin | — | RF-10 | OK |
| CU-15 | CU-19 | Recuperar contraseña / gestionar perfil | Postulante, Admin, Directivo | «extend» CU-01 | RF-11 | OK |
| CU-16 | CU-20 | Digitalizar y adjuntar documentos | Postulante | — | RF-12 | OK |
| CU-17 | CU-21 | Guardar borrador de postulación | Postulante | «extend» CU-02 | RF-13 | ⚠️ Observado |
| CU-18 | CU-22 | Validar elegibilidad y duplicados | Sistema | — | RF-14 | OK |
| CU-19 | CU-26 | Devolver postulación para corrección | Admin | — | RF-15 | OK |
| CU-20 | CU-27 | Archivar o rechazar postulación | Admin | — | RF-16 | OK |
| CU-21 | CU-28 | Notificar finalistas, registrar entrega de documentación física y publicar comunicados/avisos | Admin | «include» CU-05 | RF-17 | OK (fusionado con ex CU-37) |
| CU-22 | CU-30 | Publicar resultados de adjudicación | Admin | — | RF-18 | OK |
| CU-23 | CU-31 | Gestionar padrón de becados (baja, suspensión, reemplazo) | Admin | — | RF-19 | OK |
| CU-24 | CU-32 | Consultar historial de asistencia y estado de beca | Becado | — | RF-20 | OK |
| CU-25 | CU-34 | Consultar bitácora de acciones | Admin | — | RF-21 | OK |
| CU-26 | CU-35 | Parametrizar modelo de preselección y reprocesar puntajes | Admin | «extend» CU-03 | RF-22 | OK |

**Cambios de relaciones por efecto del filtrado**
- CU-21 (devolver) y CU-22 (archivar/rechazar) antes extendían al CU-24 original "Revisar documentos y calificar" (descartado). Los **reanclé a CU-08 (Auditar expediente finalista)**; confirmar que es lo correcto.
- CU-23 antes aparecía como «include» en CU-08; se mantiene (CU-08 incluye CU-23).
- CU-02 incluye ahora CU-18 (digitalizar) y CU-20 (validar), que antes eran «include en CU-02».

---

## 2. Casos de uso descartados

| ID previo | Caso de uso | Motivo |
|---|---|---|
| CU-14 | Visualizar indicadores clave | Descartado (absorbido en el nuevo CU-13) |
| CU-15 | Filtrar por gestión académica | Descartado (criterio del dashboard CU-13) |
| CU-16 | Generar proyecciones y tendencias | Descartado como subcaso; reemplazado por el CU-14 separado |
| CU-23 | Registrar/consultar rendimiento académico | Descartado |
| CU-24 | Revisar documentos y calificar postulación | Descartado |
| CU-25 | Calcular puntaje total | Descartado |
| CU-29 | Consultar puntaje y detalle de calificación | Descartado |
| CU-33 | Consultar auditoría de asistencia (solo lectura) | Descartado → el actor **Auditor institucional** deja de modelarse |
| CU-36 | Exportar reportes (PDF/Excel) | Descartado |
| CU-37 | Publicar avisos y comunicados | Descartado (fusionado en CU-23) |

> Nota: el descarte de CU-24/25/23 deja **sin soporte en el sistema la calificación documental (1–70) y el cálculo del puntaje total (+30 académico)** descritos en el modelo de dominio (Fig. 17). Si la calificación la hace solo la IA, habrá que ajustar el modelo de dominio y los atributos de `Postulacion` en el documento.

---

## 3. Pendientes antes de pasar al documento

1. **CU-09 y CU-12 (preguntar):** ¿quién decide? Definir con la DUBSS/docente si el acta de adjudicación y el cotejo contra respaldo físico se mantienen dentro del sistema.
2. **CU-11 y CU-19 (observado):** indicar cuál es la observación para corregir el alcance.
3. Actualizar la **Fig. 18** (diagrama de CU) con esta lista y las nuevas relaciones.
4. Resolver la inconsistencia de roles y estados señalada en `CLAUDE.md` §2–§3.
