# Casos de uso y actores — Beca Comedor (DUBSS–UAGRM)

Insumo para dibujar el **diagrama de contexto** de cada uno de los 13 casos de uso listados abajo (un diagrama por CU: el CU en el centro y solo los actores que interactúan con él, unidos por una línea de asociación).

## Reglas para los diagramas

- Dibujar **únicamente los actores indicados** en la columna «Actores». No dibujar Firebase, el módulo de IA, «Sistema» ni otros sistemas externos como actores.
- Un diagrama por CU, titulado `ucd CUxx <Nombre>`, con el nombre del CU dentro del óvalo.
- Usar exactamente los nombres de actor de la tabla.
- «Usuario del Sistema» es un actor abstracto que **representa a todos los roles del sistema**: Postulante, Administrador DUBSS, Directivo y Personal del Comedor Universitario. Cualquiera de ellos puede ejecutar CU-01 y CU-15.
- En los diagramas de CU-01 y CU-15 dibujar a «Usuario del Sistema» como actor asociado al CU y, junto a él, los cuatro roles como actores que lo **generalizan** (flecha de generalización con punta triangular vacía, de cada rol hacia «Usuario del Sistema»).
- CU-03 (precalificación con IA) y CU-18 (validación de elegibilidad y duplicados) son ejecutados por el sistema, pero en el diagrama general solo figuran como «include» de CU-02. Por coherencia con ese diagrama, su actor en el diagrama de contexto es el **Postulante**, que los dispara al enviar su postulación.
- En CU-21 el Postulante aparece como receptor de las notificaciones.

## Casos de uso y actores

| CU | Caso de uso | Actores |
|---|---|---|
| CU-01 | Registrarse y autenticarse | Usuario del Sistema (todos los roles: Postulante, Administrador DUBSS, Directivo, Personal del Comedor Universitario) |
| CU-02 | Enviar postulación a Beca Comedor | Postulante |
| CU-03 | Precalificar postulación con Inteligencia Artificial | Postulante |
| CU-04 | Consultar estado de postulación | Postulante |
| CU-13 | Gestionar convocatoria y gestión académica | Administrador DUBSS |
| CU-14 | Gestionar usuarios y roles | Administrador DUBSS |
| CU-15 | Recuperar contraseña / gestionar perfil | Usuario del Sistema (todos los roles: Postulante, Administrador DUBSS, Directivo, Personal del Comedor Universitario) |
| CU-16 | Digitalizar y adjuntar documentos | Postulante |
| CU-17 | Guardar borrador de postulación | Postulante |
| CU-18 | Validar elegibilidad y duplicados | Postulante |
| CU-21 | Notificar finalistas, registrar entrega de documentación física y publicar comunicados/avisos | Administrador DUBSS; Postulante (receptor de las notificaciones) |
| CU-24 | Consultar historial de asistencia y estado de beca | Postulante (becado) |
| CU-26 | Parametrizar modelo de preselección y reprocesar puntajes | Administrador DUBSS |

## Diagramas que se deben corregir

Si ya se generaron diagramas de contexto con versiones anteriores de esta lista, revisar y corregir los siguientes:

| Diagrama | Corrección |
|---|---|
| CU-03 Precalificar postulación con IA | Quitar el actor «Sistema» (o «Módulo de IA») y dibujar al **Postulante** |
| CU-18 Validar elegibilidad y duplicados | Quitar el actor «Sistema» y dibujar al **Postulante** |
| CU-01 Registrarse y autenticarse | Quitar «Firebase Authentication» si aparece; dejar «Usuario del Sistema» con los 4 roles que lo generalizan |
| CU-15 Recuperar contraseña / gestionar perfil | Quitar «Firebase Authentication» si aparece; dejar «Usuario del Sistema» con los 4 roles que lo generalizan |
| CU-14 Gestionar usuarios y roles | Quitar «Firebase Authentication»; dejar solo **Administrador DUBSS** |
| CU-02 Enviar postulación a Beca Comedor | Quitar «Módulo de IA» y «Firebase Storage»; dejar solo **Postulante** |
| CU-16 Digitalizar y adjuntar documentos | Quitar «Firebase Storage»; dejar solo **Postulante** |
| CU-04 Consultar estado de postulación | Quitar «Firebase Cloud Messaging»; dejar solo **Postulante** |
| CU-21 Notificar finalistas… | Quitar «Firebase Cloud Messaging»; dejar **Administrador DUBSS** y **Postulante** |
| CU-26 Parametrizar modelo… | Quitar «Módulo de IA»; dejar solo **Administrador DUBSS** |

Los diagramas de CU-13, CU-17 y CU-24 no requieren cambios respecto a esta lista.
