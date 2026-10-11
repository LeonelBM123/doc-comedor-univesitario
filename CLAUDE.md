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

| Actor | Rol en el sistema | Fuente |
|---|---|---|
| **Postulante** | Estudiante UAGRM; se registra, postula, consulta estado, recibe notificaciones. | Cap. 4.2.3 |
| **Administrador DUBSS** | Personal administrativo; prioriza, audita, adjudica, genera actas/planillas, gestiona convocatorias. | Cap. 4.2.3 |
| **Directivo DUBSS (Gerente)** | Consume dashboards y proyecciones BI. | Cap. 4.2.3 |
| **Personal del Comedor Universitario** | Verifica identidad física del becado y registra asistencia diaria. | Diagrama CU, RF-05 |
| **Sistema / Módulo IA (Python)** | Actor secundario: precalifica y calcula puntaje. | RF-03 |
| **Firebase** (Auth, FCM, Storage) | Actor secundario externo. | Cap. 4.2.4 |
| *Auditor institucional* | Fiscalizador interno/externo; coteja registro digital vs. respaldo físico. Aparece en §6.2 pero **no** está en el diagrama de CU ni en los RF. | Cap. 1 §6.2 |
| *Trabajo Social* / *Encargada de Sistemas* | Roles del proceso actual (modelo de dominio y flujo operativo): revisión documental/calificación y cálculo del puntaje total. Hoy colapsados en "Administrador DUBSS". | Cap. 3.5, 4.2.6 |

> ⚠️ **Inconsistencia a resolver:** el RF habla de 3 roles autenticables, el diagrama de CU incluye 4 actores y el dominio usa `TrabajoSocial`/`EncargadaSistemas`. Decidir si se mantienen como subroles de "Administrador DUBSS" o roles propios, y si "Auditor" y "Personal del Comedor" se autentican en el sistema.

---

## 3. Dominio y reglas de negocio

**Entidades** (Fig. 17, modelo de dominio): `Postulante` (nombre, CI, carrera, perfil UAGRM) 1—* `Postulacion` ◆— 1..* `DocumentoAdjunto` (tipo, archivo); `Funcionario` (abstracta) ← `TrabajoSocial`, `EncargadaSistemas`; `NotaAcademica` (periodo, promedio); `Postulacion` 0..1 → `BecaComedor` (fecha de adjudicación).

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
| Requisitos funcionales / no funcionales (RF-01…07, RNF-01…05) | [`secciones/05_capitulo4_ieee830/03_requisitos_especificos.tex`](secciones/05_capitulo4_ieee830/03_requisitos_especificos.tex) |
| Diagrama de CU actual | `images/18_Diagrama_CU.png` (referenciado en [`02_descripcion_general.tex`](secciones/05_capitulo4_ieee830/02_descripcion_general.tex)) |
| Modelo de dominio / actores / restricciones | [`02_descripcion_general.tex`](secciones/05_capitulo4_ieee830/02_descripcion_general.tex) |
| Funciones principales y alcance | [`secciones/02_capitulo1_perfil/06_alcances_limitaciones.tex`](secciones/02_capitulo1_perfil/06_alcances_limitaciones.tex) |
| Flujo operativo actual (actividades) | [`secciones/04_capitulo3_empresa/05_flujo_operativo.tex`](secciones/04_capitulo3_empresa/05_flujo_operativo.tex) |
| Borrador de RF/RNF en texto plano (buzón, solo lectura) | `texto_formatter/rf_y_rnf.txt` |

---

## 6. Casos de uso actuales (diagrama, Fig. 18)

| ID | Caso de uso | Actor | Relaciones | RF |
|---|---|---|---|---|
| CU-01 | Registrarse y autenticarse | Postulante, Admin, Directivo | — | RF-01 |
| CU-02 | Enviar postulación a Beca Comedor | Postulante | «include» CU-03 | RF-02 |
| CU-03 | Precalificar postulación con IA | Sistema | — | RF-03 |
| CU-04 | Consultar estado de postulación | Postulante | «extend» CU-05 | RF-06 |
| CU-05 | Recibir notificación push | Postulante | — | RF-06 |
| CU-06 | Auditar y adjudicar becas | Admin | «include» CU-07, CU-08; «extend» CU-09 | RF-04 |
| CU-07 | Visualizar lista priorizada de postulantes | Admin | — | RF-04 |
| CU-08 | Auditar expediente finalista | Admin | — | RF-04 |
| CU-09 | Generar acta de adjudicación | Admin | — | RF-04 | (preguntar)
| CU-10 | Generar planilla de asistencia | Admin | — | RF-05 |
| CU-11 | Registrar asistencia digital | Personal Comedor | «extend» CU-12 | RF-05 |(Observado)
| CU-12 | Cotejar registro contra respaldo físico | Admin | — | RF-05 | (preguntar)
| CU-13 | Generar reportes y dashboards BI | Directivo | «include» CU-14, CU-15; «extend» CU-16 | RF-07 |(Separarlo)
| CU-14 | Visualizar indicadores clave | Directivo | — | RF-07 | (Descartado)
| CU-15 | Filtrar por gestión académica | Directivo | — | RF-07 | (Descartado)
| CU-16 | Generar proyecciones y tendencias | Directivo | — | RF-07 | (Descartado)

---

## 7. Requisitos funcionales: situación y ampliación

Hoy hay **7 RF** (RF-01…07). La meta es **≥ 20**. Los RF-08…RF-25 siguientes están **propuestos**, derivados de lo que ya afirman los capítulos 1, 3 y 4 (funciones principales §6.1, flujo operativo, modelo de dominio) y de huecos evidentes del proceso. **Requieren validación con la DUBSS** antes de pasar a LaTeX. Formato obligatorio al llevarlos al documento: tabla *¿Quién? / ¿Qué? / ¿Por qué?* + criterios de aceptación (ver los existentes).

### 7.1 Existentes (no modificar sin pedido expreso)
RF-01 Registro y autenticación · RF-02 Envío de postulación · RF-03 Preselección con IA · RF-04 Panel de auditoría y adjudicación · RF-05 Planillas y asistencia · RF-06 Consultas y notificaciones · RF-07 Reportes y dashboards BI.

### 7.2 Propuestos

| ID | Requisito (resumen) | Actor | Origen / justificación |
|---|---|---|---|
| RF-08 | **Gestión de convocatorias y gestiones académicas:** abrir/cerrar convocatoria, definir fechas, cupos (~900) y requisitos documentales. | Admin | §6.1 "gestionan las convocatorias"; RF-02 "gestión vigente" |
| RF-09 | **Gestión de usuarios y roles:** alta/baja/edición de cuentas administrativas, directivas y de comedor; asignación de roles. | Admin | RNF-01 control de acceso por rol |
| RF-10 | **Recuperación de contraseña y gestión de perfil** (datos de contacto, cambio de clave). | Todos | Complementa RF-01 (Firebase Auth) |
| RF-11 | **Digitalización de documentos con la cámara móvil** y carga desde web; validación de formato, tamaño y legibilidad. | Postulante | Interfaz de hardware (4.3.3) |
| RF-12 | **Guardar borrador y editar la postulación** antes del cierre de la convocatoria. | Postulante | Formulario extenso (RF-02); usabilidad RNF-04 |
| RF-13 | **Validación de elegibilidad y unicidad:** verificar matrícula/CI, impedir postulaciones duplicadas en la misma gestión. | Sistema | Reglas de BD (CI único) y 4.3.4 |
| RF-14 | **Registro/consulta del rendimiento académico** del postulante (`NotaAcademica`: periodo y promedio). | Admin / Sistema | Dominio: Encargada de Sistemas consulta NotaAcademica |
| RF-15 | **Revisión documental y calificación (1–70 pts)** de la postulación. | Admin (Trabajo Social) | Dominio y flujo operativo (Fig. 16/17) |
| RF-16 | **Cálculo del puntaje total** (documental + académico ≤ 30) y verificación del mínimo requerido. | Sistema / Admin | Dominio: puntaje total determina adjudicación |
| RF-17 | **Devolver postulación para corrección** con observaciones; el postulante reenvía documentos. | Admin / Postulante | Estado `devuelta`; §6.1 "devolver" |
| RF-18 | **Archivar o rechazar postulación** registrando el motivo. | Admin | Estados `archivada`/`no adjudicada`; §6.1 |
| RF-19 | **Notificar a finalistas y registrar la entrega de documentación física** (fecha de entrega, expediente recibido). | Admin / Postulante | §6.1 "solicitud de documentación física"; atributo `fechaEntrega` |
| RF-20 | **Consulta del puntaje y detalle de la calificación** por el propio postulante. | Postulante | §2.2 y §6.1 (transparencia) |
| RF-21 | **Publicación de resultados:** lista oficial de adjudicados y no adjudicados por gestión, con aviso masivo. | Admin | Situación deseada: publicar listas definitivas |
| RF-22 | **Gestión del padrón de becados:** altas, bajas, suspensión y reemplazo (lista de espera) durante la gestión. | Admin | `BecaComedor`; cupos limitados |
| RF-23 | **Historial de asistencia y estado de la beca** consultable por el becado. | Becado (Postulante) | §6.2 "gestionan sus requisitos de asistencia" |
| RF-24 | **Consulta de auditoría (solo lectura)** para auditores institucionales: cotejo asistencia digital vs. planillas/respaldos. | Auditor | §6.2 Auditores institucionales |
| RF-25 | **Bitácora de acciones** (quién auditó/adjudicó/modificó qué y cuándo) y consulta por el Administrador. | Admin | RNF-01 (log de accesos), trazabilidad RF-03 |
| RF-26 | **Parametrización del modelo de preselección:** criterios y ponderaciones de vulnerabilidad, y recálculo/reproceso de puntajes. | Admin | Supuesto: DUBSS aporta criterios para calibrar el modelo |
| RF-27 | **Exportación de reportes** (PDF/Excel) de postulaciones, adjudicaciones y asistencia. | Admin / Directivo | RF-07 "rendición de cuentas" |
| RF-28 | **Publicación de avisos y comunicados** a postulantes/becados (convocatoria, plazos, cambios). | Admin | §6.1 alertas sobre la convocatoria |

> Total propuesto: 7 existentes + 21 nuevos = **28** (margen sobre el mínimo de 20; se pueden descartar los de menor prioridad: RF-10, RF-12, RF-27, RF-28).
> Posible **apelación/reclamo del postulante** no figura en ningún capítulo: consultarlo con la DUBSS antes de agregarlo.

---

## 8. Casos de uso propuestos (nuevos)

Cada CU nuevo se mapea a su RF. Añadirlos al diagrama (Fig. 18) con `include`/`extend` cuando aplique.

| ID | Caso de uso | Actor | RF | Relación sugerida |
|---|---|---|---|---|
| CU-17 | Gestionar convocatoria y gestión académica | Admin | RF-08 | — |
| CU-18 | Gestionar usuarios y roles | Admin | RF-09 | — |
| CU-19 | Recuperar contraseña / gestionar perfil | Todos | RF-10 | «extend» CU-01 |
| CU-20 | Digitalizar y adjuntar documentos | Postulante | RF-11 | «include» en CU-02 |
| CU-21 | Guardar borrador de postulación | Postulante | RF-12 | «extend» CU-02 | (Observado)
| CU-22 | Validar elegibilidad y duplicados | Sistema | RF-13 | «include» en CU-02 |
| CU-23 | Registrar/consultar rendimiento académico | Admin / Sistema | RF-14 | «include» en CU-24 | (Descartado)
| CU-24 | Revisar documentos y calificar postulación | Admin | RF-15 | — | (Descartado)
| CU-25 | Calcular puntaje total | Sistema | RF-16 | «include» en CU-24 | (Descartado)
| CU-26 | Devolver postulación para corrección | Admin | RF-17 | «extend» CU-24 |
| CU-27 | Archivar o rechazar postulación | Admin | RF-18 | «extend» CU-24 |
| CU-28 | Notificar finalistas y registrar entrega de documentación física y comunicados/avisos| Admin | RF-19 | «include» en CU-08 |
| CU-29 | Consultar puntaje y detalle de calificación | Postulante | RF-20 | «extend» CU-04 | (Descartado)
| CU-30 | Publicar resultados de adjudicación | Admin | RF-21 | «extend» CU-06 |
| CU-31 | Gestionar padrón de becados (baja/suspensión/reemplazo) | Admin | RF-22 | — |
| CU-32 | Consultar historial de asistencia y estado de beca | Becado | RF-23 | — |
| CU-33 | Consultar auditoría de asistencia (solo lectura) | Auditor | RF-24 | «include» CU-12 | (Descartado)
| CU-34 | Consultar bitácora de acciones | Admin | RF-25 | — |
| CU-35 | Parametrizar modelo de preselección y reprocesar puntajes | Admin | RF-26 | «extend» CU-03 |
| CU-36 | Exportar reportes (PDF/Excel) | Admin / Directivo | RF-27 | «extend» CU-13 | (Descartado)
| CU-37 | Publicar avisos y comunicados | Admin | RF-28 | «include» CU-05 | (Descartado)

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
3. Los RF propuestos son **borrador**: no escribirlos en `secciones/` ni en el diagrama hasta que el usuario los apruebe. Al aprobarlos, editar solo `03_requisitos_especificos.tex` (y actualizar el rango de referencias `\ref{tab:rf01}`–`\ref{tab:rfNN}`), respetando `AGENTS.md`.
4. `texto_formatter/` es de solo lectura.
5. Idioma: español académico formal; tercera persona o primera del plural.
