# Indicaciones para los diagramas de análisis (Sección 6.2) — CU de la Persona A

Insumo para dibujar en Enterprise Architect (o la herramienta que se use) los **13 diagramas de análisis**, uno por cada CU de la Persona A. Siguen el mismo estilo de los ejemplos de referencia («sd CU01 Gestionar Usuario», «sd CU02 Autenticación»): un diagrama de **colaboración/robustez** con el actor a la izquierda y la cadena **Actor → Vista → Controlador → Entidad(es)**, con mensajes numerados y coloreados.

---

## 1. Estilo general (copiar de los ejemplos)

### Elementos
| Elemento | Estereotipo UML | Nombre | Posición |
|---|---|---|---|
| Actor | Actor | Según la tabla de cada CU | Izquierda |
| Vista | `«boundary»` (círculo con barra a la izquierda) | `<Nombre>View` | Segunda columna |
| Controlador | `«control»` (círculo con flecha) | `<Nombre>Controller` | Tercera columna |
| Entidad | `«entity»` (círculo con línea inferior) | Nombre de la entidad en singular, `PascalCase` | Cuarta columna (varias entidades: apiladas verticalmente) |

### Conectores
- Una línea de asociación simple une: Actor — Vista — Controlador — Entidad. No se dibujan flechas en las líneas; el sentido lo dan los mensajes.
- No hay conexión directa Actor–Controlador ni Vista–Entidad.
- Si hay varias entidades, el Controlador se une a cada una.

### Marco y título
- Marco tipo `sd CUxx <Nombre del CU>` (igual que los ejemplos).
- Título de figura en el documento: «Analizar CUxx» (lo pone el `.tex`, no el diagrama).

### Mensajes numerados (convención de los ejemplos)
Cada **operación** del actor es un número entero y sus mensajes hijos usan sub-numeración:

| Tramo | Numeración | Ejemplo |
|---|---|---|
| Actor → Vista | `N: operacion()` | `1: registrar()` |
| Vista → Controlador | `N.1: operacionController(parametros)` | `1.1: registrarUsuario(usuario)` |
| Controlador → Entidad | `N.2`, `N.3`… `: create/find/update/delete(entidad)` | `1.2: create(usuario)` |

Colores de las flechas (mismos que los ejemplos):

| Tipo de operación | Color | Verbos típicos |
|---|---|---|
| Crear / registrar / enviar | **Negro** | `registrar`, `crear`, `enviar`, `adjuntar` |
| Consultar / listar | **Rojo** | `listar`, `consultar`, `ver`, `find` |
| Eliminar / dar de baja | **Verde** | `eliminar`, `confirmarBaja`, `desactivar` |
| Actualizar / modificar | **Azul** | `actualizar`, `update`, `cambiar` |

Las flechas son pequeñas y van **sobre** la línea, con el texto del mensaje encima (como en los ejemplos). Alinear los mensajes de cada tramo en columnas.

### Cuando el actor es «Usuario del Sistema»
Igual que el ejemplo «sd CU02 Autenticación»: dibujar el actor **Usuario del Sistema** conectado a la vista y, debajo, los **4 roles** (Postulante, Administrador DUBSS, Directivo, Personal del Comedor Universitario) con **flechas de generalización** (punta triangular vacía) hacia «Usuario del Sistema». Aplica a CU-01 y CU-15.

### Reglas
- **No** dibujar Firebase, el módulo de IA, servicios de correo ni otros sistemas externos como actores ni como objetos.
- Usar los mismos nombres de actor que en `actores_por_cu.md`.
- Los nombres de las entidades salen de `diseno_base_de_datos.md` (`postulacion`, `convocatoria`, etc.), escritos en `PascalCase`: `Postulacion`, `Convocatoria`, `PuntajePostulacion`…
- Mantener las operaciones del actor (nivel 1, 2, 3…) en el orden en que aparecen abajo. Cada operación genera sus propias flechas hasta la entidad.
- Si un CU incluye a otro (p. ej. CU-02 incluye CU-03, CU-16 y CU-18), el diagrama de CU-02 **no** repite las entidades del CU incluido: solo se muestra lo propio del CU.

---

## 2. Diagramas

### 6.2.1 — CU-01 Registrarse y autenticarse
- **Actor:** Usuario del Sistema (generalizado por Postulante, Administrador DUBSS, Directivo y Personal del Comedor Universitario).
- **Vista:** `AuthView` · **Controlador:** `AuthController`
- **Entidades:** `Usuario`, `Postulante`

| # | Actor → Vista | Vista → Controlador | Controlador → Entidad |
|---|---|---|---|
| 1 (negro) | `1: registrar()` | `1.1: registrarUsuario(usuario)` | `1.2: find(ci, correo)` → Usuario · `1.3: create(usuario)` → Usuario · `1.4: create(postulante)` → Postulante |
| 2 (rojo) | `2: iniciarSesion()` | `2.1: login(correo, contrasena)` | `2.2: find(correo)` → Usuario |

---

### 6.2.2 — CU-02 Enviar postulación a Beca Comedor
- **Actor:** Postulante.
- **Vista:** `PostulacionView` · **Controlador:** `PostulacionController`
- **Entidades:** `Convocatoria`, `Postulacion`, `RespuestaSocioeconomica`

| # | Actor → Vista | Vista → Controlador | Controlador → Entidad |
|---|---|---|---|
| 1 (rojo) | `1: nuevaPostulacion()` | `1.1: iniciarPostulacion()` | `1.2: find(convocatoriaAbierta)` → Convocatoria |
| 2 (negro) | `2: enviarPostulacion(formulario)` | `2.1: registrarPostulacion(postulacion)` | `2.2: create(postulacion)` → Postulacion · `2.3: create(respuesta)` → RespuestaSocioeconomica |
| 3 (azul) | `3: corregirYReenviar(formulario)` | `3.1: reenviarPostulacion(postulacion)` | `3.2: update(postulacion)` → Postulacion · `3.3: update(respuesta)` → RespuestaSocioeconomica |

> Las llamadas a CU-03, CU-16 y CU-18 (incluidos) no se dibujan aquí; cada uno tiene su propio diagrama.

---

### 6.2.3 — CU-03 Precalificar postulación con Inteligencia Artificial
- **Actor:** Postulante (dispara el proceso al enviar la postulación desde CU-02).
- **Vista:** `PostulacionView` · **Controlador:** `PrecalificacionController`
- **Entidades:** `Postulacion`, `ModeloPreseleccion`, `ParametroModelo`, `PuntajePostulacion`
- El módulo de IA **no** se dibuja como objeto: el cálculo es un **mensaje a sí mismo** (autollamada) del controlador.

| # | Actor → Vista | Vista → Controlador | Controlador → Entidad |
|---|---|---|---|
| 1 (negro) | `1: enviarPostulacion()` | `1.1: precalificar(postulacionId)` | `1.2: find(postulacion)` → Postulacion · `1.3: find(modeloActivo)` → ModeloPreseleccion · `1.4: list(parametros)` → ParametroModelo · `1.5: calcularPuntaje(postulacion, parametros)` (autollamada) · `1.6: create(puntaje)` → PuntajePostulacion · `1.7: update(estado)` → Postulacion |

---

### 6.2.4 — CU-04 Consultar estado de postulación
- **Actor:** Postulante.
- **Vista:** `EstadoPostulacionView` · **Controlador:** `EstadoPostulacionController`
- **Entidades:** `Postulacion`, `PostulacionHistorial`

| # | Actor → Vista | Vista → Controlador | Controlador → Entidad |
|---|---|---|---|
| 1 (rojo) | `1: listarMisPostulaciones()` | `1.1: listarPostulaciones(postulanteId)` | `1.2: list(postulaciones)` → Postulacion |
| 2 (rojo) | `2: verDetalle(postulacionId)` | `2.1: obtenerEstado(postulacionId)` | `2.2: find(postulacion)` → Postulacion · `2.3: list(historial)` → PostulacionHistorial |
| 3 (rojo) | `3: filtrarPorGestion(gestion)` | `3.1: listarPostulaciones(postulanteId, gestion)` | `3.2: list(postulaciones)` → Postulacion |

---

### 6.2.13 — CU-13 Gestionar convocatoria y gestión académica
- **Actor:** Administrador DUBSS.
- **Vista:** `ConvocatoriaView` · **Controlador:** `ConvocatoriaController`
- **Entidades:** `Convocatoria`, `GestionAcademica`, `ConvocatoriaDocumento`

| # | Actor → Vista | Vista → Controlador | Controlador → Entidad |
|---|---|---|---|
| 1 (negro) | `1: registrar()` | `1.1: registrarConvocatoria(convocatoria)` | `1.2: find(gestion)` → GestionAcademica · `1.3: create(convocatoria)` → Convocatoria · `1.4: create(documentosRequeridos)` → ConvocatoriaDocumento |
| 2 (rojo) | `2: listar()` | `2.1: listarConvocatorias()` | `2.2: list(convocatorias)` → Convocatoria |
| 3 (azul) | `3: actualizar()` | `3.1: update(convocatoria)` | `3.2: update(convocatoria)` → Convocatoria · `3.3: update(documentosRequeridos)` → ConvocatoriaDocumento |
| 4 (azul) | `4: abrirOCerrar()` | `4.1: cambiarEstado(convocatoriaId, estado)` | `4.2: update(estado)` → Convocatoria |

> Una convocatoria con postulaciones **no se elimina** (solo se cierra), por eso no hay flecha verde.

---

### 6.2.14 — CU-14 Gestionar usuarios y roles
- **Actor:** Administrador DUBSS.
- **Vista:** `UsuarioView` · **Controlador:** `UsuarioController`
- **Entidades:** `Usuario`, `Rol`

| # | Actor → Vista | Vista → Controlador | Controlador → Entidad |
|---|---|---|---|
| 1 (negro) | `1: registrar()` | `1.1: registrarUsuario(usuario)` | `1.2: find(ci, correo)` → Usuario · `1.3: find(rol)` → Rol · `1.4: create(usuario)` → Usuario |
| 2 (rojo) | `2: listar()` | `2.1: listarUsuarios(filtros)` | `2.2: list(usuarios)` → Usuario |
| 3 (verde) | `3: confirmarBaja()` | `3.1: desactivar(usuarioId)` | `3.2: update(activo=false)` → Usuario |
| 4 (azul) | `4: actualizar()` | `4.1: update(usuario)` | `4.2: update(usuario)` → Usuario · `4.3: find(rol)` → Rol |

> «Baja» = desactivar la cuenta; el usuario no se elimina.

---

### 6.2.15 — CU-15 Recuperar contraseña / gestionar perfil
- **Actor:** Usuario del Sistema (generalizado por los 4 roles, como en CU-01).
- **Vista:** `PerfilView` · **Controlador:** `PerfilController`
- **Entidades:** `Usuario`, `Postulante`, `TokenRestablecimiento`
- Nota: `TokenRestablecimiento` es una entidad **nueva** (sin Firebase, el backend genera el token de un solo uso con vigencia limitada); no está aún en `diseno_base_de_datos.md`.

| # | Actor → Vista | Vista → Controlador | Controlador → Entidad |
|---|---|---|---|
| 1 (negro) | `1: solicitarRecuperacion(correo)` | `1.1: recuperarContrasena(correo)` | `1.2: find(correo)` → Usuario · `1.3: create(token)` → TokenRestablecimiento |
| 2 (azul) | `2: restablecerContrasena(token, nueva)` | `2.1: restablecer(token, nueva)` | `2.2: find(token)` → TokenRestablecimiento · `2.3: update(contrasena)` → Usuario |
| 3 (rojo) | `3: verPerfil()` | `3.1: consultarPerfil(usuarioId)` | `3.2: find(usuario)` → Usuario |
| 4 (azul) | `4: actualizarPerfil(datos)` | `4.1: actualizarPerfil(usuarioId, datos)` | `4.2: update(usuario)` → Usuario · `4.3: update(contacto)` → Postulante |

---

### 6.2.16 — CU-16 Digitalizar y adjuntar documentos
- **Actor:** Postulante.
- **Vista:** `DocumentoView` · **Controlador:** `DocumentoController`
- **Entidades:** `ConvocatoriaDocumento`, `DocumentoAdjunto`

| # | Actor → Vista | Vista → Controlador | Controlador → Entidad |
|---|---|---|---|
| 1 (rojo) | `1: listarRequeridos()` | `1.1: listarRequeridos(convocatoriaId)` | `1.2: list(requeridos)` → ConvocatoriaDocumento · `1.3: list(adjuntos)` → DocumentoAdjunto |
| 2 (negro) | `2: adjuntar(archivo)` | `2.1: adjuntarDocumento(postulacionId, tipo, archivo)` | `2.2: validarFormato(archivo)` (autollamada) · `2.3: create(documento)` → DocumentoAdjunto |
| 3 (azul) | `3: reemplazar(archivo)` | `3.1: reemplazarDocumento(documentoId, archivo)` | `3.2: update(documento)` → DocumentoAdjunto |
| 4 (verde) | `4: eliminar()` | `4.1: eliminarDocumento(documentoId)` | `4.2: delete(documento)` → DocumentoAdjunto |

---

### 6.2.17 — CU-17 Guardar borrador de postulación
- **Actor:** Postulante.
- **Vista:** `BorradorView` · **Controlador:** `BorradorController`
- **Entidades:** `Postulacion` (estado borrador), `RespuestaSocioeconomica`

| # | Actor → Vista | Vista → Controlador | Controlador → Entidad |
|---|---|---|---|
| 1 (negro) | `1: guardarBorrador(formulario)` | `1.1: guardarBorrador(postulanteId, formulario)` | `1.2: find(convocatoriaAbierta)` → Convocatoria* · `1.3: create(borrador)` → Postulacion · `1.4: create(respuesta)` → RespuestaSocioeconomica |
| 2 (rojo) | `2: retomarBorrador()` | `2.1: obtenerBorrador(postulanteId)` | `2.2: find(borrador)` → Postulacion · `2.3: find(respuesta)` → RespuestaSocioeconomica |
| 3 (azul) | `3: actualizarBorrador(formulario)` | `3.1: actualizarBorrador(borradorId, formulario)` | `3.2: update(borrador)` → Postulacion · `3.3: update(respuesta)` → RespuestaSocioeconomica |

\* Si se quiere evitar una quinta entidad en el diagrama, omitir el mensaje `1.2` y dejar la verificación de la convocatoria como autollamada del controlador.

---

### 6.2.18 — CU-18 Validar elegibilidad y duplicados
- **Actor:** Postulante (dispara la validación al enviar la postulación desde CU-02).
- **Vista:** `PostulacionView` · **Controlador:** `ValidacionController`
- **Entidades:** `Postulante`, `Postulacion`, `Convocatoria`

| # | Actor → Vista | Vista → Controlador | Controlador → Entidad |
|---|---|---|---|
| 1 (rojo) | `1: enviarPostulacion()` | `1.1: validarElegibilidad(postulanteId, convocatoriaId)` | `1.2: find(postulante)` → Postulante · `1.3: find(convocatoria)` → Convocatoria · `1.4: find(postulacionVigente)` → Postulacion · `1.5: verificarCondiciones(postulante)` (autollamada) |

---

### 6.2.21 — CU-21 Notificar finalistas, registrar entrega de documentación física y publicar comunicados/avisos
- **Actores:** Administrador DUBSS y Postulante (receptor de las notificaciones).
- **Vistas:** `FinalistaView` (Administrador) y `AvisoView` (Postulante) · **Controlador:** `NotificacionController` (único, conectado a ambas vistas)
- **Entidades:** `Finalista`, `Notificacion`, `Comunicado`
- Firebase Cloud Messaging **no** se dibuja; el envío del push es una **autollamada** del controlador.

| # | Actor → Vista | Vista → Controlador | Controlador → Entidad |
|---|---|---|---|
| 1 (rojo) | Admin: `1: listarFinalistas()` | `1.1: listarFinalistas(convocatoriaId)` | `1.2: list(finalistas)` → Finalista |
| 2 (negro) | Admin: `2: notificarFinalistas(seleccion, plazo, documentos)` | `2.1: notificarFinalistas(...)` | `2.2: update(plazo, notificado)` → Finalista · `2.3: create(notificacion)` → Notificacion · `2.4: enviarPush(notificacion)` (autollamada) |
| 3 (azul) | Admin: `3: registrarEntrega(finalistaId, fecha)` | `3.1: registrarEntrega(finalistaId, fecha)` | `3.2: update(documentacionRecibida)` → Finalista |
| 4 (negro) | Admin: `4: publicarComunicado(comunicado)` | `4.1: publicarComunicado(comunicado)` | `4.2: create(comunicado)` → Comunicado · `4.3: create(notificaciones)` → Notificacion · `4.4: enviarPush(notificaciones)` (autollamada) |
| 5 (rojo) | Postulante: `5: consultarAvisos()` | `5.1: listarAvisos(usuarioId)` | `5.2: list(notificaciones)` → Notificacion · `5.3: list(comunicados)` → Comunicado |

---

### 6.2.24 — CU-24 Consultar historial de asistencia y estado de beca
- **Actor:** Postulante (becado).
- **Vista:** `MiBecaView` · **Controlador:** `MiBecaController`
- **Entidades:** `Beca`, `MovimientoBeca`, `Asistencia`

| # | Actor → Vista | Vista → Controlador | Controlador → Entidad |
|---|---|---|---|
| 1 (rojo) | `1: verEstadoBeca()` | `1.1: consultarEstadoBeca(postulanteId)` | `1.2: find(beca)` → Beca · `1.3: list(movimientos)` → MovimientoBeca |
| 2 (rojo) | `2: verHistorialAsistencia(rango)` | `2.1: listarAsistencias(becaId, rango)` | `2.2: list(asistencias)` → Asistencia |

---

### 6.2.26 — CU-26 Parametrizar modelo de preselección y reprocesar puntajes
- **Actor:** Administrador DUBSS.
- **Vista:** `ModeloPreseleccionView` · **Controlador:** `ModeloPreseleccionController`
- **Entidades:** `ModeloPreseleccion`, `ParametroModelo`, `LoteReprocesamiento`, `PuntajePostulacion`
- El módulo de IA **no** se dibuja; el recálculo es una **autollamada** del controlador.

| # | Actor → Vista | Vista → Controlador | Controlador → Entidad |
|---|---|---|---|
| 1 (rojo) | `1: consultarParametros()` | `1.1: listarParametros()` | `1.2: find(modeloActivo)` → ModeloPreseleccion · `1.3: list(parametros)` → ParametroModelo |
| 2 (azul) | `2: actualizarParametros(parametros)` | `2.1: guardarNuevaVersion(parametros)` | `2.2: create(modelo)` → ModeloPreseleccion · `2.3: create(parametros)` → ParametroModelo |
| 3 (negro) | `3: reprocesar(convocatoriaId)` | `3.1: reprocesarPuntajes(convocatoriaId)` | `3.2: create(lote)` → LoteReprocesamiento · `3.3: calcularPuntaje(postulacion)` (autollamada) · `3.4: create(puntaje)` → PuntajePostulacion · `3.5: update(lote)` → LoteReprocesamiento |

---

## 3. Lista de verificación por diagrama

- [ ] Marco `sd CUxx <Nombre>` con el mismo nombre que el CU.
- [ ] Solo los actores indicados (sin Firebase, IA ni «Sistema»).
- [ ] Cadena Actor → Vista → Controlador → Entidad(es), sin saltos.
- [ ] Mensajes numerados `N`, `N.1`, `N.2`… con los colores de la convención.
- [ ] Entidades con los nombres de `diseno_base_de_datos.md` (en `PascalCase`).
- [ ] Autollamadas del controlador (no objetos externos) para el módulo de IA, el envío push y las validaciones.
- [ ] Exportar como imagen y nombrar `images/NNN_Analisis_CUxx_<Nombre>.png`.
