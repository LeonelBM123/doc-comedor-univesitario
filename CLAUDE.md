# CLAUDE.md — Contexto del proyecto (Beca Comedor UAGRM)

> Complementa a [`AGENTS.md`](AGENTS.md), que rige **todo lo relativo a LaTeX/APA 7** (citas, encabezados, tablas, estructura modular, compilación). Este archivo describe el **dominio del sistema** y sirve de insumo para **generar casos de uso** y **ampliar los requisitos funcionales (RF)**. Si hay conflicto sobre formato de documento, manda `AGENTS.md`.

---

## 1. ¿Qué es este proyecto?

Documento académico (LaTeX, APA 7, español) del **Taller de Grado I (INF511-SS)**, FICCT–UAGRM. Autores: Carlos Leonel Barrios Mayorga y Mauro Boris Gutierrez Primintela. Docente: Ing. José Junior Villagómez Melgar. Metodología: **PUDS** (dirigido por casos de uso), modelado **UML**, especificación **IEEE 830**.

El documento describe (y especifica) el **Sistema de Información Web y Móvil para la Postulación y Preselección Automatizada de la Beca Comedor mediante IA, con reportes de Business Intelligence** para la **DUBSS** (Dirección Universitaria de Bienestar Social y Salud) de la **UAGRM**.

Periodo de desarrollo: 24-ago-2026 a 30-nov-2026.

### Problema
- ~20,000 carpetas físicas de postulantes por gestión; solo se revisan ~8,000 (≈40 %), ~12,000 (60 %) nunca se abren.
- Solo ~900 becas (varía según presupuesto) → revisión por orden de llegada/azar, sesgos, extravío de documentos, lentitud, falta de transparencia.

### Solución
Postulación 100 % en línea → **puntaje de vulnerabilidad calculado con IA** para todas las solicitudes → la DUBSS audita **solo los finalistas mejor puntuados** → adjudicación + acta → control de asistencia (digital + planillas físicas) → dashboards BI con proyecciones.

---

## 2. Actores

Fuente de verdad: diagrama vigente `images/18_Diagrama_General_CU.jpg` (Fig. 24, §5.5 del documento; también en §4.2.2 como Fig. 22).

| Actor | Rol en el sistema | Notas |
|---|---|---|
| **Usuario del Sistema** | Actor abstracto (generalización). Hereda de él Personal del Comedor, Directivo, Postulante y Administrador. Se asocia a CU-01 y CU-15. | Aparece solo en el diagrama general. |
| **Postulante** | Estudiante UAGRM; se registra, postula, consulta estado y, una vez becado, su historial de asistencia (CU-24). | El diagrama ya no incluye al actor «Becado»: el becado es el Postulante adjudicado. |
| **Administrador DUBSS** | Prioriza, audita, adjudica, publica resultados, gestiona convocatorias, usuarios, padrón, bitácora y parámetros del modelo. | Agrupa a Trabajo Social y Encargada de Sistemas del modelo de dominio. |
| **Directivo** | Consume el dashboard de indicadores BI (CU-12). | Antes «Directivo DUBSS (Gerente)». |
| **Personal del Comedor Universitario** | Registra la asistencia digital diaria (CU-10). | Se autentica vía Usuario del Sistema. |
| **Sistema / Módulo IA (Python)** | Actor secundario: precalifica (CU-03) y valida elegibilidad (CU-18). | No dibujado como actor en el diagrama; CU-03 y CU-18 son incluidos por CU-02. |
| **Firebase** (Auth, FCM, Storage) | Actor secundario externo. | Cap. 4.2.4. |
| *Auditor institucional* | Fiscalizador; coteja registro digital vs. respaldo físico. | La consulta de auditoría para este actor (ex CU-33) fue **descartada**; no es actor del diagrama. |

> ⚠️ Pendiente: confirmar si «Administrador DUBSS» se divide en subroles (Trabajo Social / Encargada de Sistemas) y qué actor ejecuta CU-11 (en el diagrama no tiene asociación directa; solo extiende CU-10).

---

## 3. Dominio y reglas de negocio

**Entidades** (Fig. 23, modelo de dominio): `Postulante` (nombre, CI, carrera, perfil UAGRM) 1—* `Postulacion` ◆— 1..* `DocumentoAdjunto` (tipo, archivo); `Funcionario` (abstracta) ← `TrabajoSocial`, `EncargadaSistemas`; `NotaAcademica` (periodo, promedio); `Postulacion` 0..1 → `BecaComedor` (fecha de adjudicación).

**Estados de `Postulacion` (enum `EstadoPostulacion`):** `pendiente`, `devuelta`, `archivada`, `calificada`, `adjudicada`, `no adjudicada`.
> ⚠️ RF-06 lista otros estados (recibida, en evaluación, finalista, adjudicada, rechazada). Unificar nomenclatura antes de redactar CU.

**Puntaje:** revisión documental **1–70** + rendimiento académico **hasta 30** = **total (máx. 100)**. Se adjudica si el total alcanza el **mínimo requerido** (valor por definir con la DUBSS). El puntaje de vulnerabilidad por IA ordena los expedientes para auditoría.

**Variables socioeconómicas del formulario:** ingresos familiares, dependientes, procedencia, carrera, patrimonio, estado de vulnerabilidad, promedio académico.

**Reglas clave**
- CI y correo únicos por usuario; una postulación vigente por postulante y gestión (varias a lo largo del tiempo si es devuelta).
- No se envía postulación con campos/documentos obligatorios faltantes.
- El puntaje se registra con fecha de cálculo (trazabilidad).
- La auditoría física solo aplica a **finalistas**; la verificación presencial/visitas domiciliarias siguen en manos de Trabajo Social.
- Aprobar / **devolver** / **archivar** una postulación (Cap. 1 §6.1).
- Asistencia: el sistema **no** tiene biometría propia; solo registra el resultado de la verificación del comedor y genera planillas imprimibles (firma + fotocopia de carnet) exigidas por auditorías.
- Peticiones duplicadas deben ser idempotentes (RNF-03).

**Fuera de alcance:** inventarios/compras/contabilidad de la concesionaria, venta de almuerzos a no becados, eliminación total del papel, visitas domiciliarias.

---

## 4. Stack y restricciones técnicas

- **Backend:** Java + Spring Boot (REST, JWT, HTTPS). **Web:** React + TypeScript. **Móvil:** Flutter/Dart (prioridad Android; cámara para digitalizar documentos).
- **IA:** módulo independiente en Python, consumido vía API. **BD:** PostgreSQL. **Firebase:** Auth, FCM (push), Storage. **Infra:** AWS, Docker, GitHub.
- Rendimiento: carga ≤ 3 s; puntaje individual ≤ 5 s; 20,000 postulaciones/gestión; ≥ 50 administrativos concurrentes; uptime ≥ 99 % en periodos de postulación/evaluación; BI en lote.

---

## 5. Dónde está cada cosa en el repositorio

| Contenido | Archivo |
|---|---|
| Requisitos funcionales / no funcionales (RF-01…07 redactados, RNF-01…05) | [`secciones/05_capitulo4_ieee830/03_requisitos_especificos.tex`](secciones/05_capitulo4_ieee830/03_requisitos_especificos.tex) |
| Diagrama general de CU (Fig. 22 en §4.2.2 y Fig. 24 en §5.5) | `images/18_Diagrama_General_CU.jpg` (referenciado en [`02_descripcion_general.tex`](secciones/05_capitulo4_ieee830/02_descripcion_general.tex) y [`05_diagrama_general_casos_uso.tex`](secciones/07_capitulo5_requisitos/05_diagrama_general_casos_uso.tex)) |
| Modelo de dominio / actores / restricciones | [`02_descripcion_general.tex`](secciones/05_capitulo4_ieee830/02_descripcion_general.tex) |
| Funciones principales y alcance | [`secciones/02_capitulo1_perfil/06_alcances_limitaciones.tex`](secciones/02_capitulo1_perfil/06_alcances_limitaciones.tex) |
| Flujo operativo actual (actividades) | [`secciones/04_capitulo3_empresa/05_flujo_operativo.tex`](secciones/04_capitulo3_empresa/05_flujo_operativo.tex) |
| **Cap. 5 Captura de Requisitos** (5.1 Actores · 5.2 Identificación CU · 5.3 Priorización · 5.4 Detalle CU · 5.5 Diagrama general). Solo títulos y `[PENDIENTE]`; 5.5 ya tiene la figura | `secciones/07_capitulo5_requisitos/` |
| **Cap. 6 Análisis** (6.1 Arquitectura: 6.1.1 Identificación, 6.1.2 Relación, 6.1.3 Encapsulamiento de CU por paquetes · 6.2 Análisis de CU · 6.3 Análisis de paquetes). Solo títulos y `[PENDIENTE]` | `secciones/08_capitulo6_analisis/` |
| **Lista vigente de 26 CU, paquetes, priorización y reparto del trabajo** (fuente de verdad de la numeración) | [`casos_de_uso_filtrados.md`](casos_de_uso_filtrados.md) |
| Borrador de RF-08…RF-22 (⚠️ usa numeración de CU **antigua**; ver §7) | [`requisitos_funcionales_propuestos.md`](requisitos_funcionales_propuestos.md) |
| Borrador de RF/RNF en texto plano (buzón, solo lectura) | `texto_formatter/rf_y_rnf.txt` |

---

## 6. Casos de uso vigentes (diagrama, Fig. 24)

26 CU, numeración consecutiva CU-01…CU-26, tal como figura en el diagrama general. «ID previo» conserva la trazabilidad con la versión anterior de este archivo.

| ID | ID previo | Caso de uso | Actor | Relaciones (según lista filtrada) | RF | Estado |
|---|---|---|---|---|---|---|
| CU-01 | CU-01 | Registrarse y autenticarse | Usuario del Sistema | — | RF-01 | OK |
| CU-02 | CU-02 | Enviar postulación a Beca Comedor | Postulante | «include» CU-03, CU-16, CU-18 | RF-02 | OK |
| CU-03 | CU-03 | Precalificar postulación con Inteligencia Artificial | Sistema | — | RF-03 | OK |
| CU-04 | CU-04 | Consultar estado de postulación | Postulante | — | RF-06 | OK |
| CU-05 | CU-06 | Auditar y adjudicar becas | Admin | «include» CU-06, CU-07; «extend» CU-08, CU-22 | RF-04 | OK |
| CU-06 | CU-07 | Visualizar lista priorizada de postulantes | Admin | — | RF-04 | OK |
| CU-07 | CU-08 | Auditar expediente finalista | Admin | «include» CU-21; «extend» CU-19, CU-20 | RF-04 | OK |
| CU-08 | CU-09 | Generar acta de adjudicación | Admin | — | RF-04 | ❓ Preguntar |
| CU-09 | CU-10 | Generar planilla de asistencia | Admin | — | RF-05 | OK |
| CU-10 | CU-11 | Registrar asistencia digital | Personal del Comedor | ver nota de inconsistencias | RF-05 | ⚠️ Observado |
| CU-11 | CU-12 | Cotejar registro contra respaldo físico | Admin | ver nota de inconsistencias | RF-05 | ❓ Preguntar |
| CU-12 | CU-13 (parte 1) | Visualizar dashboard de indicadores BI | Directivo | — | RF-07 | Separado |
| CU-13 | CU-17 | Gestionar convocatoria y gestión académica | Admin | — | RF-09 | OK |
| CU-14 | CU-18 | Gestionar usuarios y roles | Admin | — | RF-10 | OK |
| CU-15 | CU-19 | Recuperar contraseña / gestionar perfil | Usuario del Sistema | «extend» CU-01 (no dibujado) | RF-11 | OK |
| CU-16 | CU-20 | Digitalizar y adjuntar documentos | Postulante | incluido por CU-02 | RF-12 | OK |
| CU-17 | CU-21 | Guardar borrador de postulación | Postulante | «extend» CU-02 | RF-13 | ⚠️ Observado |
| CU-18 | CU-22 | Validar elegibilidad y duplicados | Sistema | incluido por CU-02 | RF-14 | OK |
| CU-19 | CU-26 | Devolver postulación para corrección | Admin | «extend» CU-07 | RF-15 | OK |
| CU-20 | CU-27 | Archivar o rechazar postulación | Admin | «extend» CU-07 | RF-16 | OK |
| CU-21 | CU-28 | Notificar finalistas, registrar entrega de documentación física y publicar comunicados/avisos | Admin | incluido por CU-07 | RF-17 | OK (fusiona ex CU-37) |
| CU-22 | CU-30 | Publicar resultados de adjudicación | Admin | «extend» CU-05 | RF-18 | OK |
| CU-23 | CU-31 | Gestionar padrón de becados (baja, suspensión, reemplazo) | Admin | — | RF-19 | OK |
| CU-24 | CU-32 | Consultar historial de asistencia y estado de beca | Postulante (becado) | — | RF-20 | OK |
| CU-25 | CU-34 | Consultar bitácora de acciones | Admin | — | RF-21 | OK |
| CU-26 | CU-35 | Parametrizar modelo de preselección y reprocesar puntajes | Admin | «extend» CU-03 | RF-22 | OK |

**Descartados** (no reintroducir al redactar): consultar puntaje y detalle (ex CU-29), recibir notificación push como CU propio (ex CU-05), filtrar por gestión (ex CU-15), indicadores clave (ex CU-14), proyecciones y tendencias (ex CU-16), registrar/consultar rendimiento académico, revisar/calificar documentos y calcular puntaje total (ex CU-23/24/25), consulta de auditoría para Auditor (ex CU-33), exportar reportes (ex CU-36), avisos como CU separado (ex CU-37, fusionado en CU-21).

> ⚠️ **Inconsistencias entre el diagrama y `casos_de_uso_filtrados.md` (resolver antes de redactar 5.4):**
> - **CU-10 ↔ CU-11:** el diagrama dibuja «extend» de CU-11 hacia CU-10 (sentido UML correcto: el cotejo amplía el registro); la lista filtrada lo escribe al revés («CU-10 extend CU-11»).
> - **CU-17 ↔ CU-02:** en el diagrama la flecha «extend» apunta de CU-02 hacia CU-17 (invertida); en la lista el sentido es CU-17 → CU-02.
> - **CU-19:** la tabla de relaciones del `.md` dice «extend» CU-03, pero la clasificación por paquetes y CU-07 dicen «extend» CU-07. Se asume CU-07.
> - **Relaciones no dibujadas:** el diagrama no muestra «include» CU-07→CU-21, «extend» de CU-19/CU-20 hacia CU-07, ni «extend» de CU-08/CU-22 hacia CU-05 (solo asociaciones directas con el Administrador); tampoco «extend» CU-15→CU-01 ni CU-26→CU-03. Actualizar el diagrama o la lista.
> - **Notificación push:** al descartarse el CU propio, queda por definir que viva dentro de CU-21 y CU-22 (y de CU-04, antes «extend» del push).

---

## 7. Requisitos funcionales: situación

- **Redactados en LaTeX:** RF-01…RF-07 (`03_requisitos_especificos.tex`). RF-07 debe ajustarse a solo dashboard BI (la proyección de tendencias se descartó con ex CU-16).
- **Mapeo vigente CU → RF** (columna RF de §6): RF-01 CU-01 · RF-02 CU-02 · RF-03 CU-03 · RF-04 CU-05…08 · RF-05 CU-09…11 · RF-06 CU-04 · RF-07 CU-12 · RF-09 CU-13 · RF-10 CU-14 · RF-11 CU-15 · RF-12 CU-16 · RF-13 CU-17 · RF-14 CU-18 · RF-15 CU-19 · RF-16 CU-20 · RF-17 CU-21 · RF-18 CU-22 · RF-19 CU-23 · RF-20 CU-24 · RF-21 CU-25 · RF-22 CU-26.
- **RF-08 queda vacío** (era «Proyecciones y tendencias», descartado). Decidir si se renumera RF-09…22 → RF-08…21 o se deja el hueco. Con el hueco hay 21 RF efectivos (≥ 20 requeridos).
- **RF-06** perdió las notificaciones push como CU propio: revisar su redacción (¿notificar vive en CU-21/CU-22?).
- **Estado de los borradores:** `requisitos_funcionales_propuestos.md` aún usa la numeración de CU anterior (CU-13…28) e incluye RF-08; **no** copiarlo a `secciones/` sin reconciliarlo con §6.
- Pendiente de consulta con la DUBSS: apelación/reclamo del postulante (no figura en ningún capítulo), umbral mínimo de puntaje, número exacto de cupos.
- Formato obligatorio al llevarlos al documento: tabla *¿Quién? / ¿Qué? / ¿Por qué?* + criterios de aceptación.

---

## 8. Paquetes, priorización y reparto (insumo de Cap. 5.3 y Cap. 6)

Detalle completo en [`casos_de_uso_filtrados.md`](casos_de_uso_filtrados.md) §2–§4. Resumen:

| Paquete | CU | Cant. |
|---|---|---|
| P1 Cuentas y acceso | CU-01, 14, 15 | 3 |
| P2 Convocatoria y postulación | CU-13, 02, 16, 18, 17, 04 | 6 |
| P3 Preselección con IA | CU-03, 26 | 2 |
| P4 Auditoría y adjudicación | CU-05, 06, 07, 19, 20, 21, 08, 22 | 8 |
| P5 Becados y asistencia | CU-23, 09, 10, 11, 24 | 5 |
| P6 Reportes y trazabilidad | CU-12, 25 | 2 |

- **Prioridad:** Alta 16 CU · Media 7 · Baja 3 (Baja: CU-15, CU-17, CU-26). Orden de implementación sugerido en el `.md` §3.
- **Reparto** (13 CU c/u): Persona A = cuentas, postulación, IA y notificaciones (54 pts); Persona B = auditoría, adjudicación, asistencia y reportes (53 pts).
- Estos paquetes son el punto de partida para **6.1.1 Identificación de Paquetes** y **6.1.3 Encapsulamiento de CU por paquetes**; la relación entre paquetes (6.1.2) debe derivarse de la columna «Relación» del `.md`.

---

## 9. Plantilla para especificar un caso de uso

Al detallar un CU (formato PUDS/UML), usar siempre:

```
ID / Nombre:
Actor principal / secundarios:
RF asociados:
Descripción breve:
Precondiciones:
Disparador:
Flujo principal (pasos numerados, Actor → Sistema):
Flujos alternativos / excepciones (numerados con referencia al paso):
Postcondiciones:
Reglas de negocio aplicables:
Estados de Postulacion afectados:
RNF relacionados:
```

## 10. Instrucciones para agentes sobre este contexto

1. **No inventar** datos institucionales (umbral mínimo de puntaje, número exacto de cupos, formatos de documento). Marcarlos como "por definir con la DUBSS".
2. Mantener consistencia **RF ↔ CU ↔ actor ↔ estado** con las tablas de §6–§8; todo CU nuevo debe trazarse a ≥ 1 RF.
3. Los RF nuevos (RF-09…RF-22) son **borrador**: no escribirlos en `secciones/` hasta que el usuario los apruebe. Al aprobarlos, editar solo `03_requisitos_especificos.tex` (y actualizar el rango de referencias `\ref{tab:rf01}`–`\ref{tab:rfNN}`), respetando `AGENTS.md`.
3. bis. La numeración vigente de CU es la de §6 (26 CU). Si algún archivo (p. ej. `requisitos_funcionales_propuestos.md`) usa otra numeración, prevalece §6 y se avisa al usuario.
4. `texto_formatter/` es de solo lectura.
5. Idioma: español académico formal; tercera persona o primera del plural.
