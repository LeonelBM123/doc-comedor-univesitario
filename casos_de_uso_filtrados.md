# Lista filtrada de casos de uso — Beca Comedor (DUBSS–UAGRM)

Filtrada a partir de las anotaciones hechas en [`CLAUDE.md`](CLAUDE.md) §6 y §8. Resultado: **26 casos de uso vigentes**, numerados de forma consecutiva. La columna _ID previo_ conserva la trazabilidad con `CLAUDE.md` y el diagrama actual (Fig. 18).

**Cómo interpreté las anotaciones**

| Anotación              | Tratamiento                                                                                    |
| ---------------------- | ---------------------------------------------------------------------------------------------- |
| (Descartado)           | Se elimina de la lista.                                                                        |
| (Separarlo)            | CU-13 original se separó del resto de subcasos; en esta lista solo queda el dashboard (CU-12). |
| (Observado)            | Se conserva, pero queda **pendiente de revisión** (no sé cuál fue la observación; confirmar).  |
| (preguntar)            | Se conserva, pero queda **pendiente de consulta** a la DUBSS/docente.                          |
| Texto añadido en CU-21 | "Notificar finalistas…" absorbe "comunicados/avisos".                                          |

---

## 1. Casos de uso vigentes

| ID    | ID previo       | Caso de uso                                                                                   | Actor                        | Relaciones                                    | RF    | Estado                      |
| ----- | --------------- | --------------------------------------------------------------------------------------------- | ---------------------------- | --------------------------------------------- | ----- | --------------------------- |
| CU-01 | CU-01           | Registrarse y autenticarse                                                                    | Postulante, Admin, Directivo | —                                             | RF-01 | OK                          |
| CU-02 | CU-02           | Enviar postulación a Beca Comedor                                                             | Postulante                   | «include» CU-03, CU-16, CU-18                 | RF-02 | OK                          |
| CU-03 | CU-03           | Precalificar postulación con Inteligencia Artificial                                          | Sistema                      | —                                             | RF-03 | OK                          |
| CU-04 | CU-04           | Consultar estado de postulación                                                               | Postulante                   | —                                             | RF-06 | OK                          |
| CU-05 | CU-06           | Auditar y adjudicar becas                                                                     | Admin                        | «include» CU-06, CU-07; «extend» CU-08, CU-22 | RF-04 | OK                          |
| CU-06 | CU-07           | Visualizar lista priorizada de postulantes                                                    | Admin                        | —                                             | RF-04 | OK                          |
| CU-07 | CU-08           | Auditar expediente finalista                                                                  | Admin                        | «include» CU-21; «extend» CU-19, CU-20        | RF-04 | OK                          |
| CU-08 | CU-09           | Generar acta de adjudicación                                                                  | Admin                        | —                                             | RF-04 | ❓ Preguntar                |
| CU-09 | CU-10           | Generar planilla de asistencia                                                                | Admin                        | —                                             | RF-05 | OK                          |
| CU-10 | CU-11           | Registrar asistencia digital                                                                  | Personal del Comedor         | «extend» CU-11                                | RF-05 | ⚠️ Observado                |
| CU-11 | CU-12           | Cotejar registro contra respaldo físico                                                       | Admin                        | —                                             | RF-05 | ❓ Preguntar                |
| CU-12 | CU-13 (parte 1) | Visualizar dashboard de indicadores BI                                                        | Directivo                    | —                                             | RF-07 | Separado                    |
| CU-13 | CU-17           | Gestionar convocatoria y gestión académica                                                    | Admin                        | —                                             | RF-09 | OK                          |
| CU-14 | CU-18           | Gestionar usuarios y roles                                                                    | Admin                        | —                                             | RF-10 | OK                          |
| CU-15 | CU-19           | Recuperar contraseña / gestionar perfil                                                       | Postulante, Admin, Directivo | «extend» CU-01                                | RF-11 | OK                          |
| CU-16 | CU-20           | Digitalizar y adjuntar documentos                                                             | Postulante                   | —                                             | RF-12 | OK                          |
| CU-17 | CU-21           | Guardar borrador de postulación                                                               | Postulante                   | «extend» CU-02                                | RF-13 | ⚠️ Observado                |
| CU-18 | CU-22           | Validar elegibilidad y duplicados                                                             | Sistema                      | —                                             | RF-14 | OK                          |
| CU-19 | CU-26           | Devolver postulación para corrección                                                          | Admin                        | «extend» CU-03                                | RF-15 | OK                          |
| CU-20 | CU-27           | Archivar o rechazar postulación                                                               | Admin                        | —                                             | RF-16 | OK                          |
| CU-21 | CU-28           | Notificar finalistas, registrar entrega de documentación física y publicar comunicados/avisos | Admin                        | —                                             | RF-17 | OK (fusionado con ex CU-37) |
| CU-22 | CU-30           | Publicar resultados de adjudicación                                                           | Admin                        | —                                             | RF-18 | OK                          |
| CU-23 | CU-31           | Gestionar padrón de becados (baja, suspensión, reemplazo)                                     | Admin                        | —                                             | RF-19 | OK                          |
| CU-24 | CU-32           | Consultar historial de asistencia y estado de beca                                            | Becado                       | —                                             | RF-20 | OK                          |
| CU-25 | CU-34           | Consultar bitácora de acciones                                                                | Admin                        | —                                             | RF-21 | OK                          |
| CU-26 | CU-35           | Parametrizar modelo de preselección y reprocesar puntajes                                     | Admin                        | «extend» CU-03                                | RF-22 | OK                          |

**Notas sobre el cambio de numeración**

- La columna _Relaciones_ ya está reescrita con la numeración nueva (antes usaba los IDs previos).
- Al eliminar "Recibir notificación push" (ex CU-05) y "Proyecciones y tendencias" (ex CU-14) quedaron huérfanos: el «extend» de CU-04 hacia el push, el «include» de CU-21 hacia el push, y los RF-08 (proyecciones) y parte de RF-06 (notificaciones). Falta decidir dónde vive la notificación push (probablemente dentro de CU-21 y CU-22) y si RF-08 se descarta.
- CU-19 y CU-20 (devolver, archivar) quedan como «extend» de CU-07 (Auditar expediente finalista); confirmar.

---

## 2. Clasificación por paquetes

6 paquetes, 26 CU. Las relaciones entre paquetes aparecen en la columna _Relación_.

### Paquete 1 — Cuentas y acceso (3 CU)

| CU    | Caso de uso                             | Relación                |
| ----- | --------------------------------------- | ----------------------- |
| CU-01 | Registrarse y autenticarse              | Base de todo el sistema |
| CU-14 | Gestionar usuarios y roles              | —                       |
| CU-15 | Recuperar contraseña / gestionar perfil | «extend» CU-01          |

### Paquete 2 — Convocatoria y postulación (6 CU)

| CU    | Caso de uso                                | Relación                                                |
| ----- | ------------------------------------------ | ------------------------------------------------------- |
| CU-13 | Gestionar convocatoria y gestión académica | Habilita CU-02 (solo con convocatoria abierta)          |
| CU-02 | Enviar postulación a Beca Comedor          | «include» CU-03, CU-16, CU-18                           |
| CU-16 | Digitalizar y adjuntar documentos          | Incluido por CU-02                                      |
| CU-18 | Validar elegibilidad y duplicados          | Incluido por CU-02                                      |
| CU-17 | Guardar borrador de postulación            | «extend» CU-02                                          |
| CU-04 | Consultar estado de postulación            | Lee el estado generado por los CU de los paquetes 3 y 4 |

### Paquete 3 — Preselección con IA (2 CU)

| CU    | Caso de uso                                               | Relación           |
| ----- | --------------------------------------------------------- | ------------------ |
| CU-03 | Precalificar postulación con Inteligencia Artificial      | Incluido por CU-02 |
| CU-26 | Parametrizar modelo de preselección y reprocesar puntajes | «extend» CU-03     |

### Paquete 4 — Auditoría y adjudicación (8 CU)

| CU    | Caso de uso                                                                                   | Relación                                                   |
| ----- | --------------------------------------------------------------------------------------------- | ---------------------------------------------------------- |
| CU-05 | Auditar y adjudicar becas                                                                     | «include» CU-06, CU-07; «extend» CU-08, CU-22              |
| CU-06 | Visualizar lista priorizada de postulantes                                                    | Incluido por CU-05; usa el puntaje de CU-03                |
| CU-07 | Auditar expediente finalista                                                                  | Incluido por CU-05; «include» CU-21; «extend» CU-19, CU-20 |
| CU-19 | Devolver postulación para corrección                                                          | «extend» CU-07                                             |
| CU-20 | Archivar o rechazar postulación                                                               | «extend» CU-07                                             |
| CU-21 | Notificar finalistas, registrar entrega de documentación física y publicar comunicados/avisos | Incluido por CU-07                                         |
| CU-08 | Generar acta de adjudicación                                                                  | «extend» CU-05                                             |
| CU-22 | Publicar resultados de adjudicación                                                           | «extend» CU-05                                             |

### Paquete 5 — Becados y asistencia (5 CU)

| CU    | Caso de uso                                               | Relación                                                                   |
| ----- | --------------------------------------------------------- | -------------------------------------------------------------------------- |
| CU-23 | Gestionar padrón de becados (baja, suspensión, reemplazo) | Parte de los adjudicados de CU-05                                          |
| CU-09 | Generar planilla de asistencia                            | Usa el padrón de CU-23                                                     |
| CU-10 | Registrar asistencia digital                              | «extend» CU-11 (la relación se mantiene como está en el diagrama original) |
| CU-11 | Cotejar registro contra respaldo físico                   | Extiende a CU-10                                                           |
| CU-24 | Consultar historial de asistencia y estado de beca        | Lee lo registrado por CU-10                                                |

### Paquete 6 — Reportes y trazabilidad (2 CU)

| CU    | Caso de uso                            | Relación                                   |
| ----- | -------------------------------------- | ------------------------------------------ |
| CU-12 | Visualizar dashboard de indicadores BI | Consume datos de los paquetes 2, 4 y 5     |
| CU-25 | Consultar bitácora de acciones         | Registra acciones de los paquetes 1, 4 y 5 |

> Nota sobre CU-10/CU-11: en el diagrama original, "Registrar asistencia digital" tiene una flecha «extend» hacia "Cotejar registro contra respaldo físico" (el cotejo es una ampliación opcional del registro). Esa es la dirección que respeto.

---

## 3. Lista de priorización

**Prioridad** (qué tan indispensable es para el objetivo del proyecto): **Alta** (sin él el sistema no cumple su función), **Media** (necesario para operar completo) y **Baja** (complementario).
**Orden** es la secuencia de implementación sugerida, respetando dependencias.

| Orden | CU    | Caso de uso                                        | Prioridad | Depende de    | Justificación                                         |
| ----- | ----- | -------------------------------------------------- | --------- | ------------- | ----------------------------------------------------- |
| 1     | CU-01 | Registrarse y autenticarse                         | Alta      | —             | Base de seguridad y roles de todo el sistema          |
| 2     | CU-14 | Gestionar usuarios y roles                         | Alta      | CU-01         | Habilita las cuentas del personal DUBSS               |
| 3     | CU-13 | Gestionar convocatoria y gestión académica         | Alta      | CU-14         | Sin convocatoria abierta no hay postulaciones         |
| 4     | CU-16 | Digitalizar y adjuntar documentos                  | Alta      | CU-01         | Parte esencial de la postulación (cámara, Storage)    |
| 5     | CU-18 | Validar elegibilidad y duplicados                  | Alta      | CU-13         | Garantiza integridad de las postulaciones             |
| 6     | CU-02 | Enviar postulación a Beca Comedor                  | Alta      | CU-13, 16, 18 | Entrada principal de datos del sistema                |
| 7     | CU-03 | Precalificar con Inteligencia Artificial           | Alta      | CU-02         | Núcleo diferenciador del proyecto                     |
| 8     | CU-04 | Consultar estado de postulación                    | Alta      | CU-02         | Transparencia para el postulante                      |
| 9     | CU-06 | Visualizar lista priorizada de postulantes         | Alta      | CU-03         | Resuelve el problema central (revisión al azar)       |
| 10    | CU-05 | Auditar y adjudicar becas                          | Alta      | CU-06         | Decisión final del proceso                            |
| 11    | CU-07 | Auditar expediente finalista                       | Alta      | CU-06         | Validación física de los finalistas                   |
| 12    | CU-19 | Devolver postulación para corrección               | Alta      | CU-07         | Evita descartar expedientes subsanables               |
| 13    | CU-20 | Archivar o rechazar postulación                    | Alta      | CU-07         | Cierra formalmente los expedientes                    |
| 14    | CU-21 | Notificar finalistas y registrar entrega física    | Alta      | CU-07         | Coordina la auditoría física                          |
| 15    | CU-22 | Publicar resultados de adjudicación                | Alta      | CU-05         | Cierra el proceso de selección                        |
| 16    | CU-23 | Gestionar padrón de becados                        | Media     | CU-05         | Base del control de asistencia                        |
| 17    | CU-09 | Generar planilla de asistencia                     | Media     | CU-23         | Exigida por las auditorías externas                   |
| 18    | CU-10 | Registrar asistencia digital                       | Media     | CU-23         | Pendiente de observación                              |
| 19    | CU-24 | Consultar historial de asistencia y estado de beca | Media     | CU-10         | Vista del becado                                      |
| 20    | CU-12 | Visualizar dashboard de indicadores BI             | Alta      | CU-02, 05, 10 | Objetivo del proyecto, pero requiere datos acumulados |
| 21    | CU-08 | Generar acta de adjudicación                       | Media     | CU-05         | Pendiente de consulta                                 |
| 22    | CU-11 | Cotejar registro contra respaldo físico            | Media     | CU-10         | Pendiente de consulta                                 |
| 23    | CU-25 | Consultar bitácora de acciones                     | Media     | CU-01         | Trazabilidad transversal                              |
| 24    | CU-15 | Recuperar contraseña / gestionar perfil            | Baja      | CU-01         | Comodidad, no bloquea el flujo                        |
| 25    | CU-17 | Guardar borrador de postulación                    | Baja      | CU-02         | Pendiente de observación                              |
| 26    | CU-26 | Parametrizar modelo y reprocesar puntajes          | Baja      | CU-03         | Ajuste fino posterior                                 |

Resumen: **Alta** 16 CU · **Media** 7 CU · **Baja** 3 CU.

---

## 4. División del trabajo en dos personas (13 CU cada una)

**Criterio:** equilibrar la dificultad estimada (puntos 1–8) y el número de CU, y agrupar por afinidad temática para reducir dependencias entre ambos.

**Dificultad estimada de cada CU** (estimación mía, ajustable):

| Pts | Criterio                                                               |
| --- | ---------------------------------------------------------------------- |
| 2   | CRUD o lectura simple                                                  |
| 3   | Lógica moderada o generación de documento                              |
| 5   | Varias pantallas, integración con servicio externo o flujo con estados |
| 8   | Alta complejidad: múltiples componentes, volumen o IA                  |

### Persona A — Cuentas, postulación, IA y notificaciones · **54 puntos**

| CU    | Caso de uso                                           | Pts    | Por qué esa dificultad                             |
| ----- | ----------------------------------------------------- | ------ | -------------------------------------------------- |
| CU-01 | Registrarse y autenticarse                            | 5      | Firebase Auth, roles, web y móvil                  |
| CU-02 | Enviar postulación a Beca Comedor                     | 8      | Formulario largo, web y móvil, integra CU-03/16/18 |
| CU-03 | Precalificar postulación con IA                       | 8      | Módulo Python, API, 20,000 postulaciones           |
| CU-04 | Consultar estado de postulación                       | 3      | Consulta de estados, web y móvil                   |
| CU-13 | Gestionar convocatoria y gestión académica            | 3      | CRUD con reglas de fechas                          |
| CU-14 | Gestionar usuarios y roles                            | 3      | CRUD con control de acceso                         |
| CU-15 | Recuperar contraseña / gestionar perfil               | 2      | Flujo estándar de Firebase                         |
| CU-16 | Digitalizar y adjuntar documentos                     | 5      | Cámara, validación, Firebase Storage               |
| CU-17 | Guardar borrador de postulación                       | 3      | Persistencia parcial de datos                      |
| CU-18 | Validar elegibilidad y duplicados                     | 2      | Reglas de validación                               |
| CU-21 | Notificar finalistas, registrar entrega y comunicados | 5      | Push (FCM), registro de entrega, comunicados       |
| CU-24 | Consultar historial de asistencia y estado de beca    | 2      | Consulta de solo lectura                           |
| CU-26 | Parametrizar modelo y reprocesar puntajes             | 5      | Parámetros del modelo y recálculo                  |
|       | **Total**                                             | **54** | 13 CU                                              |

### Persona B — Auditoría, adjudicación, asistencia y reportes · **53 puntos**

| CU    | Caso de uso                                | Pts    | Por qué esa dificultad                           |
| ----- | ------------------------------------------ | ------ | ------------------------------------------------ |
| CU-05 | Auditar y adjudicar becas                  | 5      | Flujo con estados y decisión                     |
| CU-06 | Visualizar lista priorizada de postulantes | 3      | Ordenamiento y paginación sobre 20,000 registros |
| CU-07 | Auditar expediente finalista               | 5      | Revisión de expediente y documentos              |
| CU-08 | Generar acta de adjudicación               | 3      | Generación de documento PDF                      |
| CU-09 | Generar planilla de asistencia             | 3      | Generación de planilla imprimible                |
| CU-10 | Registrar asistencia digital               | 5      | Registro diario, idempotencia                    |
| CU-11 | Cotejar registro contra respaldo físico    | 5      | Alcance indefinido, comparación de registros     |
| CU-12 | Visualizar dashboard de indicadores BI     | 8      | Agregaciones, gráficos interactivos, filtros     |
| CU-19 | Devolver postulación para corrección       | 3      | Cambio de estado con observaciones               |
| CU-20 | Archivar o rechazar postulación            | 2      | Cambio de estado con motivo                      |
| CU-22 | Publicar resultados de adjudicación        | 3      | Publicación de lista y aviso masivo              |
| CU-23 | Gestionar padrón de becados                | 5      | Altas, bajas, suspensiones y reemplazos          |
| CU-25 | Consultar bitácora de acciones             | 3      | Registro transversal y filtros                   |
|       | **Total**                                  | **53** | 13 CU                                            |

### Cómo se reparte el riesgo y las dependencias

- **Diferencia total:** 1 punto (54 vs 53), 13 CU cada uno.
- **Persona A** construye la base (autenticación, roles, convocatorias, postulación, IA); **Persona B** consume esa base. Conviene que A entregue pronto la autenticación (CU-01), los roles (CU-14) y la API de postulaciones para que B no quede bloqueada.
- **Dependencias entre personas:**
  - CU-07 (B) incluye CU-21 (A).
  - CU-06 (B) depende del puntaje de CU-03 (A).
  - CU-12 (B) consume datos de ambos.
  - CU-19 (B) devuelve la postulación a CU-02 (A) para que se reenvíe.
- **Acordar desde el inicio:** el modelo de datos de `Postulacion`, los estados (`EstadoPostulacion`) y los contratos de la API.
- **CU con incertidumbre:** B tiene 3 pendientes (CU-08, CU-10, CU-11) y A tiene 1 (CU-17). Si se resuelven en sentido amplio, B podría subir de dificultad.
- Los 2 CU más complejos del sistema (CU-02 y CU-03, con 8 puntos cada uno) están en A y el de BI (CU-12, 8 puntos) en B, para que ambos tengan un CU de alta complejidad.
