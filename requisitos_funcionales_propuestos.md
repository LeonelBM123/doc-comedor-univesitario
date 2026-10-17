> ⚠️ **Superado.** Los RF ya se redactaron en `secciones/05_capitulo4_ieee830/03_requisitos_especificos.tex` con numeración definitiva: se eliminó RF-08 (proyecciones) y RF-09…RF-22 pasaron a RF-08…RF-21 (21 RF en total). Este archivo conserva la numeración antigua solo como histórico.

# Requisitos funcionales — Beca Comedor (DUBSS–UAGRM)

Derivados de la lista filtrada de casos de uso ([`casos_de_uso_filtrados.md`](casos_de_uso_filtrados.md)).
**Total: 22 RF** (7 existentes + 15 nuevos). Cada RF sigue el esquema del documento: *¿Quién? / ¿Qué? / ¿Por qué?* + criterios de aceptación.

> Borrador. Los datos institucionales no confirmados se marcan **[por definir con la DUBSS]**. Aún no están en `secciones/`.

---

## 1. Matriz de trazabilidad RF ↔ CU

| RF | Requisito | CU | Origen |
|---|---|---|---|
| RF-01 | Registro y autenticación de usuarios | CU-01 | Existente |
| RF-02 | Envío de postulación a la Beca Comedor | CU-02 | Existente |
| RF-03 | Preselección automatizada con IA | CU-03 | Existente |
| RF-04 | Panel de monitoreo y toma de decisiones (auditoría y adjudicación) | CU-06, 07, 08, 09 | Existente |
| RF-05 | Registro e impresión de planillas de asistencia | CU-10, 11, 12 | Existente |
| RF-06 | Consultas y notificaciones al postulante | CU-04, 05 | Existente |
| RF-07 | Dashboards de Business Intelligence | CU-13 | Existente (**ajustado**) |
| RF-08 | Proyecciones y tendencias | CU-14 | Nuevo (separado de RF-07) |
| RF-09 | Gestión de convocatorias y gestiones académicas | CU-15 | Nuevo |
| RF-10 | Gestión de usuarios y roles | CU-16 | Nuevo |
| RF-11 | Recuperación de contraseña y gestión de perfil | CU-17 | Nuevo |
| RF-12 | Digitalización y carga de documentos de respaldo | CU-18 | Nuevo |
| RF-13 | Guardado de borrador de postulación | CU-19 | Nuevo |
| RF-14 | Validación de elegibilidad y unicidad de postulaciones | CU-20 | Nuevo |
| RF-15 | Devolución de postulación para corrección | CU-21 | Nuevo |
| RF-16 | Archivo o rechazo de postulación | CU-22 | Nuevo |
| RF-17 | Notificación a finalistas, entrega de documentación física y comunicados | CU-23 | Nuevo |
| RF-18 | Publicación de resultados de adjudicación | CU-24 | Nuevo |
| RF-19 | Gestión del padrón de becados | CU-25 | Nuevo |
| RF-20 | Historial de asistencia y estado de la beca | CU-26 | Nuevo |
| RF-21 | Bitácora de acciones | CU-27 | Nuevo |
| RF-22 | Parametrización del modelo de preselección y reprocesamiento | CU-28 | Nuevo |

---

## 2. Requisitos existentes (RF-01 a RF-07)

Su texto completo ya está en [`03_requisitos_especificos.tex`](secciones/05_capitulo4_ieee830/03_requisitos_especificos.tex) y no se modifica, salvo por lo siguiente:

- **RF-04 (CU-09 pendiente de consulta):** si se decide que el acta de adjudicación no va en el sistema, eliminar el último criterio de aceptación ("El sistema genera un acta o comprobante digital…").
- **RF-05 (CU-11 observado, CU-12 pendiente de consulta):** revisar los criterios 2 y 3 según lo que se resuelva.
- **RF-07 (ajustado por la separación de CU-13):** se retira de este RF la proyección de tendencias, que pasa a RF-08. Queda así:
  - *¿Qué?* Visualizar un dashboard interactivo con indicadores clave del comportamiento histórico de las postulaciones y del uso del beneficio.
  - Criterios: (1) el Directivo visualiza indicadores clave (postulaciones recibidas, becas adjudicadas, asistencia) en un dashboard interactivo; (2) el sistema permite filtrar por gestión académica.

---

## 3. Requisitos nuevos (RF-08 a RF-22)

### RF-08: Proyecciones y tendencias
| | |
|---|---|
| **¿Quién?** | Directivo DUBSS. |
| **¿Qué?** | Quiere consultar proyecciones y tendencias futuras de postulaciones, adjudicaciones y asistencia a partir del histórico de gestiones anteriores. |
| **¿Por qué?** | Para apoyar la planificación institucional (presupuesto y cupos) y la rendición de cuentas. |

Criterios de aceptación:
- El sistema genera proyecciones de postulaciones y de asistencia a partir del histórico almacenado.
- El Directivo puede seleccionar el indicador y el periodo a proyectar.
- El sistema indica qué gestiones del histórico se usaron para generar la proyección.
- El sistema advierte cuando el histórico disponible es insuficiente para proyectar.

### RF-09: Gestión de convocatorias y gestiones académicas
| | |
|---|---|
| **¿Quién?** | Administrador DUBSS. |
| **¿Qué?** | Quiere crear, editar, abrir y cerrar convocatorias de la Beca Comedor, definiendo la gestión académica, las fechas, el número de cupos y los documentos requeridos. |
| **¿Por qué?** | Para controlar el periodo en que se reciben postulaciones y asociar cada postulación a la gestión vigente. |

Criterios de aceptación:
- El Administrador puede registrar una convocatoria con gestión académica, fecha de apertura, fecha de cierre y cupos **[por definir con la DUBSS]**.
- El Administrador puede definir la lista de documentos obligatorios de cada convocatoria.
- El sistema solo permite enviar postulaciones mientras la convocatoria esté abierta.
- Solo puede existir una convocatoria vigente por gestión académica.

### RF-10: Gestión de usuarios y roles
| | |
|---|---|
| **¿Quién?** | Administrador DUBSS. |
| **¿Qué?** | Quiere crear, editar, desactivar y asignar roles (Administrador, Directivo, Personal del Comedor) a las cuentas del personal. |
| **¿Por qué?** | Para garantizar que cada persona acceda únicamente a las funciones de su rol, conforme al control de acceso exigido por el sistema. |

Criterios de aceptación:
- El Administrador puede crear y desactivar cuentas de personal y asignarles un rol.
- El sistema impide que un usuario acceda a funciones de un rol distinto al asignado.
- El sistema conserva el registro de los cambios de rol realizados.
- El sistema rechaza el alta de una cuenta con CI o correo electrónico ya registrados.

### RF-11: Recuperación de contraseña y gestión de perfil
| | |
|---|---|
| **¿Quién?** | Postulante, Administrador DUBSS y Directivo DUBSS. |
| **¿Qué?** | Quiere recuperar su contraseña en caso de olvido y actualizar sus datos de contacto desde su perfil. |
| **¿Por qué?** | Para recuperar el acceso a su cuenta sin intervención del personal y mantener actualizados los datos con que se le notifica. |

Criterios de aceptación:
- El usuario puede solicitar el restablecimiento de contraseña mediante su correo registrado, a través del servicio de autenticación de Firebase.
- El usuario puede modificar sus datos de contacto y su contraseña desde el perfil.
- El sistema no permite modificar el CI desde el perfil.

### RF-12: Digitalización y carga de documentos de respaldo
| | |
|---|---|
| **¿Quién?** | Postulante. |
| **¿Qué?** | Quiere digitalizar sus documentos con la cámara del teléfono, o cargarlos desde un archivo en la web, y asociarlos a su postulación. |
| **¿Por qué?** | Para respaldar los datos declarados en el formulario socioeconómico sin presentar carpetas físicas en la etapa inicial. |

Criterios de aceptación:
- El Postulante puede capturar un documento con la cámara del dispositivo móvil o adjuntar un archivo desde la web.
- El sistema valida el formato y el tamaño del archivo **[formatos y tamaño máximo por definir]** y rechaza los no permitidos con un mensaje de error.
- El sistema muestra una vista previa y permite reemplazar o eliminar un documento antes de enviar la postulación.
- El sistema almacena los archivos en Firebase Storage asociados a la postulación.

### RF-13: Guardado de borrador de postulación
| | |
|---|---|
| **¿Quién?** | Postulante. |
| **¿Qué?** | Quiere guardar su postulación incompleta como borrador y retomarla después. |
| **¿Por qué?** | Para completar el formulario socioeconómico y reunir los documentos sin perder lo ya ingresado. |

> ⚠️ CU-19 está *observado*: revisar alcance antes de formalizar.

Criterios de aceptación:
- El Postulante puede guardar el formulario con campos obligatorios sin completar.
- El Postulante puede retomar y editar el borrador mientras la convocatoria esté abierta.
- Un borrador no se considera enviado ni es procesado por el módulo de preselección.
- El sistema descarta o bloquea los borradores no enviados al cerrar la convocatoria.

### RF-14: Validación de elegibilidad y unicidad de postulaciones
| | |
|---|---|
| **¿Quién?** | Sistema. |
| **¿Qué?** | Quiere verificar, al recibir una postulación, que el postulante cumple las condiciones de elegibilidad y que no existe otra postulación suya en la misma gestión. |
| **¿Por qué?** | Para evitar registros duplicados o inválidos que distorsionen la priorización y la adjudicación. |

Criterios de aceptación:
- El sistema impide enviar más de una postulación vigente por postulante y por convocatoria.
- El sistema verifica las condiciones de elegibilidad **[por definir con la DUBSS: p. ej., matrícula vigente]** antes de aceptar el envío.
- El sistema informa al Postulante el motivo cuando su postulación es rechazada por esta validación.
- Una postulación devuelta (RF-15) y reenviada no se considera duplicada.

### RF-15: Devolución de postulación para corrección
| | |
|---|---|
| **¿Quién?** | Administrador DUBSS (y Postulante, como receptor). |
| **¿Qué?** | Quiere devolver una postulación con observaciones para que el Postulante corrija o complete su documentación y la reenvíe. |
| **¿Por qué?** | Para evitar descartar postulaciones por defectos subsanables y mantener la trazabilidad de las correcciones. |

Criterios de aceptación:
- El Administrador puede devolver una postulación registrando las observaciones.
- La postulación cambia al estado *devuelta* y el Postulante es notificado.
- El Postulante puede corregir y reenviar dentro de un plazo **[por definir con la DUBSS]**.
- El sistema conserva el historial de devoluciones y reenvíos de la postulación.

### RF-16: Archivo o rechazo de postulación
| | |
|---|---|
| **¿Quién?** | Administrador DUBSS. |
| **¿Qué?** | Quiere archivar o rechazar una postulación indicando el motivo. |
| **¿Por qué?** | Para cerrar formalmente los expedientes que no proceden y dejar constancia de la decisión. |

Criterios de aceptación:
- El Administrador debe registrar un motivo para archivar o rechazar.
- La postulación pasa al estado correspondiente (*archivada* o *no adjudicada*) y deja de aparecer en la lista priorizada activa.
- El Postulante puede ver el estado y el motivo registrado.
- El sistema conserva la postulación archivada para consulta histórica y reportes.

### RF-17: Notificación a finalistas, entrega de documentación física y comunicados
| | |
|---|---|
| **¿Quién?** | Administrador DUBSS (y Postulante, como receptor). |
| **¿Qué?** | Quiere notificar a los finalistas para que presenten su documentación física, registrar la fecha en que se recibe, y publicar comunicados y avisos generales dirigidos a postulantes. |
| **¿Por qué?** | Para coordinar la auditoría física de los finalistas, dejar constancia de su entrega y mantener informada a la población postulante. |

Criterios de aceptación:
- El sistema envía una notificación push a cada finalista indicando el plazo y los documentos que debe presentar.
- El Administrador puede registrar la recepción de la documentación física de un finalista con su fecha.
- El Administrador puede publicar un comunicado dirigido a todos los postulantes o a un grupo (p. ej., finalistas).
- Los comunicados se notifican mediante push y quedan consultables desde la aplicación.

### RF-18: Publicación de resultados de adjudicación
| | |
|---|---|
| **¿Quién?** | Administrador DUBSS. |
| **¿Qué?** | Quiere publicar la lista oficial de adjudicados de la gestión. |
| **¿Por qué?** | Para dar a conocer los resultados de forma transparente y oficial y poner fin al proceso de selección. |

Criterios de aceptación:
- El Administrador puede publicar los resultados solo cuando todas las adjudicaciones estén decididas.
- La lista publicada incluye a los adjudicados de la gestión y es consultable por los postulantes.
- Al publicar, el sistema notifica a cada postulante su resultado.
- Una vez publicada, la lista no se modifica sin dejar registro en la bitácora (RF-21).

### RF-19: Gestión del padrón de becados
| | |
|---|---|
| **¿Quién?** | Administrador DUBSS. |
| **¿Qué?** | Quiere mantener el padrón de becados vigentes, registrando bajas, suspensiones y reemplazos durante la gestión. |
| **¿Por qué?** | Para mantener actualizada la lista de beneficiarios activos, de la cual dependen las planillas de asistencia, y reasignar los cupos liberados. |

Criterios de aceptación:
- El Administrador puede consultar el padrón de becados vigentes de la gestión.
- El Administrador puede dar de baja o suspender a un becado registrando el motivo.
- El Administrador puede reemplazar un cupo liberado con el siguiente postulante priorizado.
- Los cambios en el padrón se reflejan en las planillas de asistencia generadas posteriormente.

### RF-20: Historial de asistencia y estado de la beca
| | |
|---|---|
| **¿Quién?** | Becado (Postulante adjudicado). |
| **¿Qué?** | Quiere consultar su historial de asistencia al comedor y el estado vigente de su beca. |
| **¿Por qué?** | Para verificar su cumplimiento de los requisitos de asistencia y conservar su beneficio. |

Criterios de aceptación:
- El Becado visualiza las fechas de asistencia registradas en la gestión vigente.
- El Becado visualiza el estado de su beca (vigente, suspendida o dada de baja) y el motivo, si corresponde.
- El Becado solo accede a su propia información.

### RF-21: Bitácora de acciones
| | |
|---|---|
| **¿Quién?** | Administrador DUBSS. |
| **¿Qué?** | Quiere consultar un registro de las acciones relevantes realizadas en el sistema (auditoría, devolución, adjudicación, cambios en el padrón, cambios de roles). |
| **¿Por qué?** | Para garantizar la trazabilidad de las decisiones y facilitar las auditorías sobre el proceso. |

Criterios de aceptación:
- El sistema registra automáticamente usuario, acción, expediente afectado, fecha y hora.
- El Administrador puede filtrar la bitácora por usuario, tipo de acción y rango de fechas.
- Los registros de la bitácora no pueden ser editados ni eliminados desde la interfaz.

### RF-22: Parametrización del modelo de preselección y reprocesamiento
| | |
|---|---|
| **¿Quién?** | Administrador DUBSS. |
| **¿Qué?** | Quiere ajustar los criterios y ponderaciones que usa el modelo de preselección y reprocesar los puntajes de las postulaciones de una convocatoria. |
| **¿Por qué?** | Para calibrar la priorización según los criterios institucionales de vulnerabilidad y corregir puntajes cuando éstos cambien. |

Criterios de aceptación:
- El Administrador puede consultar y modificar los criterios y ponderaciones **[por definir con la DUBSS]** del modelo.
- El Administrador puede solicitar el reprocesamiento de los puntajes de una convocatoria.
- El sistema registra la fecha de cada recálculo y conserva el puntaje anterior para trazabilidad (ver RF-03).
- El sistema muestra la lista priorizada actualizada tras el reprocesamiento.

---

## 4. Observaciones

- **Calificación documental y puntaje total:** al descartarse los CU de calificación (ex CU-24), cálculo del puntaje total (ex CU-25) y rendimiento académico (ex CU-23), ningún RF cubre el puntaje 1–70 + 30 del modelo de dominio. RF-03 y RF-22 asumen que el puntaje es generado por la IA. Confirmar y ajustar el modelo de dominio.
- **Actor Auditor:** al descartarse ex CU-33, ningún RF lo menciona; el cotejo (CU-12) lo hace el Administrador.
- **RF-13** (CU-19 observado), **RF-04/RF-05** (CU-09, CU-11, CU-12 observados o a consultar) pueden cambiar según las respuestas.
- Si se desea reducir carga, los RF de menor prioridad son RF-11, RF-13 y RF-22; se pueden descartar como máximo 2 de los 22 para mantener el mínimo de 20.
