# Plan de desarrollo — Lista de tareas de ejecución para dos personas

Plan de **implementación** del sistema (no del documento). Los 26 CU de [`CLAUDE.md`](CLAUDE.md) §6 son documentación; aquí se convierten en **tareas de ejecución**. Una tarea puede implementar un CU completo, una parte de un CU, o ser un trabajo técnico que no es un CU pero que el sistema necesita (marcadas como *extra*, p. ej. el servicio de notificaciones). Reemplaza la división de [`casos_de_uso_filtrados.md`](casos_de_uso_filtrados.md) §4.

**Criterios de la división**

1. **Mismo esfuerzo:** 58 puntos cada uno (escala 2/3/5/8 de `casos_de_uso_filtrados.md` §4).
2. **Quien hace login/autenticación no hace la IA.**
3. **Cortes verticales:** cada persona es dueña de sus tareas de punta a punta (BD, API, pantallas, pruebas).
4. **Dueño de tablas:** cada tabla la escribe un solo dueño; el otro solo la lee (§3).
5. **Clausura de relaciones UML:** todos los «include»/«extend» quedan dentro de una misma persona (§4). Se logra repartiendo por bloques completos del diagrama.
6. **Todo se prueba en local** (sin despliegue en la nube ni pruebas de rendimiento).

| | Persona A — Cuentas + lado DUBSS | Persona B — Postulación + IA + becados |
|---|---|---|
| Bloques | Cuentas y acceso · Auditoría y adjudicación · BI · Notificaciones · Estado de la postulación (CU-04) | Convocatoria y postulación · Preselección con IA · Becados y asistencia · Bitácora (CU-25) |
| CU | 13 | 13 |
| Tareas extra (no CU) | 3 | 1 |
| **Puntos** | **58** | **58** |
| Plataformas | Web (React) + login/perfil móvil | Web + Móvil (Flutter) + módulo IA (Python) |

---

## 1. Fase 0 — Acuerdos conjuntos (los dos, ~2–3 días, antes de separarse)

No es implementación; es lo que evita los cuellos de botella. Se hace una vez y se congela.

| ID | Entregable | Resultado |
|---|---|---|
| F0-1 | Esquema de BD inicial (migraciones) | Todas las tablas creadas, aunque vacías, según el diseño de datos del Cap. 7.3 |
| F0-2 | Enum `EstadoPostulacion` único | Ver recomendación en §6 |
| F0-3 | Contratos OpenAPI de los puntos de integración (§3) | Cada lado mockea el contrato del otro |
| F0-4 | Estructura del repo, ramas y commits | Un módulo/paquete por dueño para no pisarse archivos |
| F0-5 | Usuarios de desarrollo con JWT firmado de prueba (uno por rol) | B prueba con roles sin esperar a A2 |
| F0-6 | Contrato de la interfaz de IA: entrada (variables del formulario) y salida (puntaje + fecha de cálculo) | Fija lo que B produce y A solo lee |

> Pendiente de la DUBSS (no inventar): umbral mínimo de puntaje, número de cupos, pesos del modelo. Se parametrizan por configuración.

---

## 2. Listas de tareas

Cada tarea de CU lleva su **definición de terminado**: BD + API + pantallas + pruebas + criterios de aceptación del RF. El detalle funcional de cada CU es el de Cap. 5.4 (flujos) y Cap. 7.4/7.5 (secuencia y mockups).

### Persona A — Cuentas, auditoría/adjudicación, BI y notificaciones · 58 pts

| # | Tarea | CU / tipo | RF | Pts | Alcance | Depende de |
|---|---|---|---|---|---|---|
| A1 | Entorno local de desarrollo | extra | RNF | 3 | `docker-compose` (PostgreSQL, API, módulo IA), proyecto Firebase (solo FCM y Storage; la autenticación es propia del backend), README de arranque, migraciones aplicadas | F0 |
| A2 | Registrarse y autenticarse | CU-01 | RF-01 | 5 | Autenticación en el backend Spring Boot: contraseña con hash, emisión de JWT firmado con el rol y expiración, validación en cada petición, CI/correo únicos, token FCM del dispositivo; web y móvil; redirección por rol (según Cap. 5.4) | A1 |
| A3 | Gestionar usuarios y roles | CU-14 | RF-09 | 3 | CRUD de usuarios, asignación de rol, control de acceso | A2 |
| A4 | Recuperar contraseña / gestionar perfil | CU-15 | RF-10 | 2 | Recuperación de contraseña por el backend (token temporal por correo), edición de perfil; «extend» CU-01 | A2 |
| A5 | Interceptor de bitácora | extra | RF-20 | 2 | Aspecto que registra la acción, usuario y fecha en todos los controladores; escribe la tabla `bitacora` | A2 |
| A6 | Visualizar lista priorizada de postulantes | CU-06 | RF-04 | 3 | Orden por puntaje, filtros, paginación para 20,000 registros, selección de finalistas | datos semilla (B1) |
| A7 | Servicio de notificaciones | extra | RF-16, RF-17 | 5 | Envío FCM (push) y correo, plantillas por evento, reintentos, lectura del token de `dispositivo` | A2 |
| A8 | Registrar entrega física y publicar avisos | CU-21 | RF-16 | 3 | Registro de entrega de documentación, comunicados/avisos; dispara notificación vía A7 | A6, A7 |
| A9 | Auditar expediente finalista | CU-07 | RF-04 | 5 | Visor de expediente y documentos, checklist, puntaje documental 1–70 y académico hasta 30; «include» CU-21 | A6, A8 |
| A10 | Devolver postulación para corrección | CU-19 | RF-14 | 3 | Estado `devuelta` + observaciones; «extend» CU-07 | A9 |
| A11 | Archivar o rechazar postulación | CU-20 | RF-15 | 2 | Cambio de estado con motivo; «extend» CU-07 | A9 |
| A12 | Auditar y adjudicar becas | CU-05 | RF-04 | 5 | Flujo de adjudicación contra cupos y mínimo parametrizable; integra CU-06 y CU-07 | A6, A9 |
| A13 | Publicar resultados de adjudicación | CU-22 | RF-17 | 3 | Publicación de lista y aviso masivo vía A7; «extend» CU-05 | A12, A7 |
| A14 | Generar acta de adjudicación | CU-08 | RF-04 | 3 | PDF del acta; «extend» CU-05 | A12 |
| A15 | Consultar estado de postulación | CU-04 | RF-06 | 3 | Línea de estados y observaciones de devolución; web y móvil; solo lectura | datos semilla (B1) |
| A16 | Dashboard de indicadores BI | CU-12 | RF-07 | 8 | Agregaciones en lote, gráficos, filtros por gestión; consume postulaciones, adjudicaciones y asistencia | datos semilla (B1) |
| | **Total A** | 13 CU + 3 extra | | **58** | | |

### Persona B — Postulación, IA, becados y bitácora · 58 pts

| # | Tarea | CU / tipo | RF | Pts | Alcance | Depende de |
|---|---|---|---|---|---|---|
| B1 | Generador de datos semilla | extra | todos | 2 | Script que crea postulaciones con puntaje, adjudicados, becados y asistencias de prueba (volumen de 20,000). **Va primero**: A lo usa | F0-1 |
| B2 | IA: dataset y entrenamiento del modelo | CU-03 | RF-03 | 5 | Dataset de ajuste con las variables socioeconómicas, entrenamiento y validación del modelo en Python | F0-6 |
| B3 | IA: API del modelo y cálculo por lote | CU-03 | RF-03 | 3 | API consumida por el backend, puntaje ≤ 5 s con fecha de cálculo, procesamiento de 20,000 | B2 |
| B4 | Parametrizar modelo y reprocesar puntajes | CU-26 | RF-21 | 5 | Parámetros del modelo, recálculo masivo en segundo plano; «extend» CU-03 | B3 |
| B5 | Gestionar convocatoria y gestión académica | CU-13 | RF-08 | 3 | CRUD de convocatorias, validación de fechas, abierta/cerrada | F0-5 |
| B6 | Validar elegibilidad y duplicados | CU-18 | RF-13 | 2 | Reglas de elegibilidad, una postulación vigente por postulante y gestión | B5 |
| B7 | Digitalizar y adjuntar documentos | CU-16 | RF-11 | 5 | Cámara (Flutter), carga web, validación de tipo/tamaño, Firebase Storage | F0-5 |
| B8 | Enviar postulación a Beca Comedor | CU-02 | RF-02 | 8 | Formulario socioeconómico largo (web y móvil); «include» CU-03, CU-16, CU-18; bloqueo si faltan campos/documentos | B5, B6, B7; B3 por contrato |
| B9 | Guardar borrador de postulación | CU-17 | RF-12 | 3 | Persistencia parcial, recuperar borrador; «extend» CU-02 | B8 |
| B10 | Gestionar padrón de becados | CU-23 | RF-18 | 5 | Alta desde adjudicados, baja, suspensión, reemplazo | contrato C4 |
| B11 | Generar planilla de asistencia | CU-09 | RF-05 | 3 | Planilla imprimible (firma + fotocopia de carnet) | B10 |
| B12 | Registrar asistencia digital | CU-10 | RF-05 | 5 | **App móvil** del Personal del Comedor: ingresa CI del becado y confirma; idempotente (RNF-03) | B10 |
| B13 | Cotejar registro contra respaldo físico | CU-11 | RF-05 | 5 | Comparación digital vs planilla; «extend» CU-10 | B12 |
| B14 | Consultar historial de asistencia y estado de beca | CU-24 | RF-19 | 2 | Vista de solo lectura del becado; web y móvil | B12 |
| B15 | Consultar bitácora de acciones | CU-25 | RF-20 | 2 | Pantalla de consulta con filtros sobre la tabla `bitacora` (la escribe A5) | contrato C7; semilla |
| | **Total B** | 13 CU + 1 extra | | **58** | | |

---

## 3. Puntos de integración y cómo evitar que bloqueen

Son **todas** las dependencias entre personas. Son contratos de datos, nunca construcción simultánea del mismo código.

| # | Contrato | Productor (escribe) | Consumidor (lee) | Cómo se desacopla |
|---|---|---|---|---|
| C1 | `postulacion` + `EstadoPostulacion` + `puntaje_ia` | B (B3, B8) | A (A6, A9, A15, A16) | A usa los datos semilla de B1 |
| C2 | Devolución / rechazo / archivo | A (A10, A11 cambian estado y escriben `observaciones`) | B (B8 reenvío) | Transición `devuelta → pendiente` fijada en F0-2; B prueba con un registro semilla ya devuelto |
| C3 | Documentos adjuntos (Storage) | B (B7 sube) | A (A9 visualiza) | Contrato: ruta y metadatos en `documento_adjunto`; A usa archivos de ejemplo |
| C4 | Adjudicados → padrón de becados | A (A12 marca `adjudicada`) | B (B10 crea becados) | B10 consume adjudicados semilla; el contrato es el estado `adjudicada` + fecha de adjudicación |
| C5 | Autenticación y roles | A (A2, A3) | B (todas sus pantallas) | B usa los JWT de F0-5 hasta integrar A2 |
| C6 | Asistencia y becados (lectura para BI) | B (B10, B12) | A (A16) | A16 lee tablas con semilla |
| C7 | Tabla `bitacora` | A (A5) | B (B15) | B15 lee registros semilla de `bitacora`; solo lectura con filtros |

Además:

- **IA:** B8 invoca la API de B3 (ambos de B). A solo lee el puntaje guardado; A y la IA no se tocan.
- **Notificaciones:** A7 es dueño del envío; B no envía nada. El token del dispositivo lo guarda A2 en la tabla `dispositivo`.
- **Estado de la postulación:** A15 (CU-04) solo lee el estado y las observaciones; no modifica nada.

### Tablas por dueño

| Dueño A | Dueño B |
|---|---|
| `usuario`, `rol`, `dispositivo`, `bitacora`, `finalista`, `evaluacion_expediente`, `adjudicacion`, `acta`, `aviso`, `notificacion` | `postulante`, `convocatoria`, `gestion_academica`, `postulacion`, `documento_adjunto`, `borrador`, `puntaje_ia`, `lote_puntaje`, `parametro_modelo`, `becado`, `planilla_asistencia`, `registro_asistencia`, `cotejo` |

> Nombres orientativos: se ajustan a las tablas reales del Cap. 7.3. A10/A11/A12 modifican el *estado* de `postulacion` (tabla de B) con una operación acordada en F0-2, no escribiendo libremente en ella.

---

## 4. Verificación: relaciones UML cerradas por persona

| Relación | Persona |
|---|---|
| CU-15 «extend» CU-01 | A |
| CU-05 «include» CU-06, CU-07 · CU-05 «extend» CU-08, CU-22 · CU-07 «include» CU-21 · CU-07 «extend» CU-19, CU-20 | A |
| CU-02 «include» CU-03, CU-16, CU-18 · CU-17 «extend» CU-02 · CU-26 «extend» CU-03 · CU-11 «extend» CU-10 | B |

CU-04 y CU-25 no tienen relaciones UML, por eso se pudieron colocar donde equilibraban la carga. Cero relaciones UML cruzan entre personas; lo único que cruza son los contratos C1–C7.

---

## 5. Hitos de integración (fechas por definir por el equipo)

| Hito | Contenido | Quién integra |
|---|---|---|
| H1 | A2 y A3 listos → B cambia del JWT de prueba al login real del backend | B |
| H2 | B8 y B3 listos → A reemplaza datos semilla por postulaciones reales en A6, A9, A15, A16 | A |
| H3 | A12 listo → B10 consume adjudicados reales | B |
| H4 | B12 listo → A16 usa asistencia real | A |
| H5 | A5 listo → B15 muestra bitácora real | B |
| H6 | Ambas listas terminadas → prueba end-to-end local: postular → puntuar → priorizar → auditar → adjudicar → asistencia → BI | Los dos |

---

## 6. Decisiones y pendientes

1. **Estados de la postulación (F0-2).** Hoy hay dos listas distintas: el modelo de dominio (`pendiente`, `devuelta`, `archivada`, `calificada`, `adjudicada`, `no adjudicada`) y RF-06 (recibida, en evaluación, finalista, adjudicada, rechazada). **Recomendación:** usar el enum del modelo de dominio y agregarle solo `borrador`, que CU-17 necesita. Razones:
   - El diseño de datos ya separa lo demás en tablas propias: ser *finalista* es la tabla `finalista`, y el resultado de la decisión es la tabla `adjudicacion`. No hace falta un estado extra.
   - `rechazada` de RF-06 equivale a `archivada` o `no adjudicada`.
   - Queda un flujo lineal: `borrador → pendiente → calificada → (devuelta | archivada | adjudicada | no adjudicada)`. `devuelta` vuelve a `pendiente` al reenviarse.
   - Después hay que ajustar el texto de RF-06 para que use estos nombres. No verifiqué los valores exactos del tipo `estado_postulacion` en el Cap. 7.3; revísalos al cerrar F0-2.
2. **Notificaciones push.** Son una tarea propia (A7), usada por A8 (CU-21) y A13 (CU-22).
3. **Alcance de CU-08, CU-10, CU-11 y CU-17.** Se implementa lo que dice su especificación en Cap. 5.4; si la DUBSS pide más, esa parte se suma después y se compensa moviendo un CU pequeño completo de una lista a la otra.
4. **Asistencia (B12):** según la documentación (Cap. 5.4 CU-10 y Cap. 6.2), el Personal del Comedor la registra en la **aplicación móvil**, ingresando el CI del becado. Por eso B12 es Flutter, y A2 debe permitir iniciar sesión con ese rol en el móvil.
5. **Autenticación (decidido):** propia del backend con JWT por rol; Firebase se usa solo para FCM y Storage. Esto contradice el Cap. 7.3 ([03_diseno_datos.tex:8](secciones/09_capitulo7_diseno/03_diseno_datos.tex#L8) dice que Firebase Authentication gestiona las contraseñas, y `usuario` tiene la columna `firebase_uid` en [03b_volumen.tex:52](secciones/09_capitulo7_diseno/03b_volumen.tex#L52)), y también Cap. 4 ([02_descripcion_general.tex:66](secciones/05_capitulo4_ieee830/02_descripcion_general.tex#L66), [03_requisitos_especificos.tex:705](secciones/05_capitulo4_ieee830/03_requisitos_especificos.tex#L705)). Al implementar, `usuario` necesitará una columna de hash de contraseña en lugar de `firebase_uid`. Falta alinear esos textos del documento.
6. **Despliegue y pruebas de rendimiento:** no se contemplan. A1 es solo entorno local.
7. Las estimaciones en puntos son mías y ajustables; si se reajustan, mantener la regla de que ninguna relación UML cruce entre personas.
