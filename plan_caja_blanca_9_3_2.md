# Plan: 9.3.2 Pruebas de Caja Blanca (estilo SW2, camino básico con grafos)

Estado: **solo plan, nada implementado.** Pendiente de la revisión de Mau (versión 2, con las respuestas de Mau del 25/11).
Fuente del estilo: rama `doc-sw2`, `secciones_v2/cap09_pruebas/capitulo9.tex` (9.3.1 Caja Blanca, CU-02, CU-03 y CU-05).
Código analizado: `D:\DesarrolloSoftware\ComedorUAGRM\projects\backend\comedor-uagrm-core\src\main\java\com\comedoruagrm\backend\features\` (en adelante `F/`).

## 0. Formato DEFINITIVO (25/11, tras el piloto) — reemplaza las plantillas de la sección 3

- Alcance elegido: **Mínimo** (14 funciones). Solo backend.
- Por función: (1) figura de **código numerado por nodos**, (2) figura del **grafo de flujo** (con nodo «Inicio» y nodo final «F», V/F en las aristas, decisiones sombreadas), (3) **una sola tabla** «Camino / Entrada / Salida» (camino como secuencia de nodos terminada en F; en Entrada las variables con V/F/«?»; en Salida el resultado esperado).
- Se **quitan** la matriz de conexiones y el diagrama de flujo. V(G) va en la línea introductoria y en la nota del grafo (A−N+2 y P+1).
- «Resultado obtenido» no va en la tabla (pendiente de ejecutar JUnit/Mockito).
- Páginas medidas en el piloto: CU-08 `validar` (V=3) ≈ 2 páginas; CU-19 `devolver` (V=5) ≈ 3. Estimación del Mínimo completo: ≈ 45 a 60 páginas.
- Plantilla: `secciones/11_capitulo9_pruebas/03b_caja_blanca.tex` (CU-08 y CU-19) y `config/grafos_cb.tex`.

## 1. Alcance y reglas acordadas con Mau

- **Solo backend (Java).** Frontend y móvil quedan fuera.
- **CU a cubrir:** los 13 de caja negra: CU-01, 04, 05, 06, 07, 08, 12, 14, 15, 19, 20, 21 y 22.
- **Funciones principales de cada CU, no una sola.** Se toman los métodos de servicio que implementan los flujos del CU (los que llaman sus controladores) y los auxiliares donde está la lógica de ramas.
- **Funciones sin decisiones** (V(G)=1): no se omiten; se documentan con **solo el recorrido normal** (un único camino), sin ramas obligatorias. Esto resuelve el caso de CU sin lógica de ramas (CU-08 `generar`, CU-04 `listar`, etc.). Ya no es una decisión pendiente.
- **Dos plantillas:**
  - **Completa** (V(G) ≥ 3): las seis piezas de SW2 (ver sección 3).
  - **Corta** (V(G) 1 o 2): código numerado + diagrama de flujo + una sola tabla con camino, entrada y salida esperada. Sin matriz de conexiones ni grafo de flujo aparte.
- **Criterio de métodos que delegan:** si un método solo llama a otro (p. ej. `AuthService.iniciarSesion` → `UsuarioService.validarCredenciales`, `CierrePostulacionService.archivar/rechazar` → `cerrar`, `AdjudicacionService.adjudicar/noAdjudicar` → `decidir`), se analiza el método que tiene la lógica y no el que delega.
- **Estructura del capítulo:** 9.3.2 con una subsección por CU, `\paragraph{9.3.2.N. Caso de uso: <nombre> (CU-XX).}` (igual que SW2 y nuestro 9.3.1), y dentro una sección por función `9.3.2.N.k`, en orden numérico de CU. 9.3.3 no se toca.

## 2. Funciones principales por CU

V(G) estimada con un contador automático (decisiones: `if`, `for`, `while`, `case`, `catch`, `&&`, `||`, ternario, + 1; `orElseThrow` no cuenta, igual que en SW2). Es una **estimación ±1**: SW2 contó 9 para `seleccionar` y el contador da 8. El valor definitivo sale de contar a mano al armar el grafo. «Rec.» marca lo que entra en la opción **Recomendada** (sección 6). «C» = plantilla completa, «K» = plantilla corta.

| CU | Función (archivo bajo `F/`) | V(G) est. | Líneas | Plantilla | Rec. | Por qué |
| --- | --- | --- | --- | --- | --- | --- |
| CU-01 | `UsuarioService.registrarPostulante` (`usuarios/service/`) | 8 | 38 | C | Sí | Registro: unicidad, idempotencia. |
| CU-01 | `UsuarioService.validarCredenciales` | 6 | 27 | C | Sí | Inicio de sesión: credenciales, bloqueo, cuenta desactivada. |
| CU-01 | `SesionService.renovar` (`auth/service/`) | 2 | 12 | K | No | Renovación del refresh token. |
| CU-01 | `SesionService.cerrar` | 1 | 4 | K | No | Cierre de sesión (recorrido normal). |
| CU-04 | `MisPostulacionesService.pasosPendientes` (`postulaciones/service/`) | 5 | 8 | C | Sí | Recorrido: pasos que faltan según estado. |
| CU-04 | `MisPostulacionesService.lineaDeTiempo` | 4 | 11 | C | Sí | Recorrido de la postulación. |
| CU-04 | `MisPostulacionesService.detalle` | 3 | 20 | C | No | Detalle: acceso y armado de la respuesta. |
| CU-04 | `MisPostulacionesService.listar` | 1 | — | K | No | Lista (recorrido normal). |
| CU-05 | `AdjudicacionService.decidir` (`postulaciones/service/`) | 8 | 65 | C | Sí | Adjudicar / no adjudicar (lo probado en caja negra). |
| CU-05 | `AdjudicacionService.validarAdjudicacion` | 7 | 16 | C | Sí | Cupos, puntaje mínimo, estado. |
| CU-05 | `SeleccionFinalistasService.seleccionar` (`finalistas/service/`) | 8–9 | 45 | C | Sí | Ya analizado en `doc-sw2` (V=9): se adapta. |
| CU-05 | `AdjudicacionService.panel` | 2 | 13 | K | No | Panel de adjudicación. |
| CU-06 | `ListaPriorizadaService.listarPriorizados` (`postulaciones/service/`) | 5 | 18 | C | Sí | Búsqueda, filtro y orden por puntaje. |
| CU-06 | Exportación a PDF (`ListaPriorizadaPdfService.exportar`) | por medir | — | K | No | Generación del PDF. |
| CU-07 | `ExpedienteService.registrarAuditoria` (`expedientes/service/`) | **17** | 67 | C | Sí* | Corazón de la auditoría. *V(G) alto: ver R1. |
| CU-07 | `ExpedienteService.avisar` | 8 | 26 | C | Sí | Notificación al postulante tras la auditoría. |
| CU-07 | `ExpedienteService.obtener` | 5 | 16 | C | Sí | Consulta del expediente. |
| CU-07 | `ExpedienteService.accesoDocumento` | 1 | — | K | No | Acceso a un documento adjunto. |
| CU-08 | `ActaAdjudicacionService.validar` (`actas/service/`) | 3 | 8 | C | Sí | Convocatoria publicada, sin acta, con adjudicados. |
| CU-08 | `ActaAdjudicacionService.guardar` | 3 | 10 | C | Sí | Unicidad de la convocatoria, numeración. |
| CU-08 | `ActaAdjudicacionService.generar` | 1 | 33 | K | Sí | Flujo principal (lineal): recorrido normal. |
| CU-08 | `ActaAdjudicacionService.vistaPrevia` | 1 | 8 | K | No | Vista previa del acta. |
| CU-12 | `IndicadoresService.serieSinHuecos` (`dashboard/service/`) | 8 | 30 | C | Sí | Serie de indicadores sin huecos. |
| CU-12 | `IndicadoresService.obtener` | 6 | 19 | C | Sí | Indicadores de una gestión, caso sin datos. |
| CU-12 | `IndicadoresService.resolver` | 5 | 16 | C | Sí | Resuelve la gestión elegida o por defecto. |
| CU-12 | `BiService.obtener` | 5 | 25 | C | No | Análisis BI. |
| CU-12 | `FiltrosDashboardService.obtener` | 3 | 13 | C | No | Filtros del dashboard. |
| CU-14 | `UsuarioPersonalService.editar` (`usuarios/service/`) | 12 | 41 | C | Sí* | *V(G) alto: ver R1. |
| CU-14 | `UsuarioPersonalService.cambiarRol` | 5 | 27 | C | Sí | Cambio de rol. |
| CU-14 | `UsuarioPersonalService.crear` | 4 | 31 | C | Sí | Alta de personal (contraseña temporal). |
| CU-14 | `UsuarioPersonalService.desactivar` | 4 | 23 | C | Sí | Desactivación (probado en caja negra). |
| CU-14 | `UsuarioPersonalService.listar` | 4 | 14 | C | No | Listado con búsqueda y orden. |
| CU-15 | `PerfilService.actualizar` (`usuarios/service/`) | 10 | 43 | C | Sí | Edición del perfil. |
| CU-15 | `RestablecimientoContrasenaService.solicitar` (`auth/service/`) | 2 | 15 | K | Sí | Solicitud del enlace (respuesta neutra). |
| CU-15 | `UsuarioService.verificarContrasenaActual` | 4 | 8 | C | No | Cambio de contraseña desde el perfil. |
| CU-15 | `RestablecimientoContrasenaService.restablecer` | 1 | 15 | K | No | Restablecer con el enlace. |
| CU-19 | `DevolucionService.devolver` (`postulaciones/service/`) | 5 | 38 | C | Sí | Estado válido, motivo obligatorio. |
| CU-19 | `DevolucionService.avisar` | 3 | 14 | C | No | Aviso al postulante. |
| CU-20 | `CierrePostulacionService.cerrar` (`postulaciones/service/`) | 4 | 35 | C | Sí | Archivar o rechazar con motivo. |
| CU-20 | `CierrePostulacionService.avisar` | 3 | 13 | C | No | Aviso al postulante. |
| CU-21 | `FinalistaService.registrarEntrega` (`finalistas/service/`) | 6 | 31 | C | Sí | Fecha pasada, documentos. |
| CU-21 | `FinalistaService.notificar` | 5 | 48 | C | Sí | Notificación a finalistas. |
| CU-21 | `ComunicadoService.publicar` (`comunicados/service/`) | 6 | 37 | C | Sí | Publicación de comunicados. |
| CU-21 | `FinalistaService.listar` | 4 | 15 | C | No | Listado de finalistas. |
| CU-22 | `PublicacionResultadosService.publicar` (`resultados/service/`) | 4 | 40 | C | Sí | Estado, ya publicada, sin adjudicados, fallo de envío. |
| CU-22 | `ResultadosAdminService.resumen` | 5 | — | C | Sí | Resumen de la adjudicación. |
| CU-22 | `PublicacionResultadosService.guardar` | 2 | 7 | K | No | Persistencia de la publicación. |
| CU-22 | `ResultadosPostulanteService.miResultado` | 1 | 7 | K | No | Consulta del postulante. |

Otras funciones de apoyo (p. ej. `patronDeBusqueda`, `traducirConflicto`, `ultimaFila`) se dejan fuera: son auxiliares de formato, no flujos del CU.

## 3. Plantillas

### 3.1 Plantilla completa (V(G) ≥ 3, tomada de SW2)

Con los mismos `\label` de SW2, cambiando el sufijo por la función:

1. **Texto introductorio breve** (qué hace el método y sus decisiones numeradas).
2. **Figura de código** (`fig:cod_*`): `lstlisting` Java (`language=Java, columns=fixed, basicstyle=\ttfamily\scriptsize, breaklines=false`), con las dos primeras líneas de ruta y el nodo al final de cada línea.
3. **Figura de diagrama de flujo** (`fig:df_*`): TikZ con `\fcp`, `\fcd`, `\fcs`, `\fct`; aristas `V/F`.
4. **Figura de grafo de flujo** (`fig:gf_*`): TikZ con `\cgn`; decisiones sombreadas y final con doble borde.
5. **Tabla de matriz de conexiones** (`tab:mat_*`) con «Conexiones −1» y `V(G)=Σ+1`.
6. **Tabla de caminos básicos** (`tab:cam_*`): C1…Cn, no factibles marcados.
7. **Tabla de diseño de casos de prueba** (`tab:dcp_*`): una columna por variable que decide el camino + «Resultado esperado».
8. «Resultado obtenido»: ver R5.

Los tres cálculos de V(G) deben coincidir (A−N+2, P+1, suma de la matriz + 1).

### 3.2 Plantilla corta (V(G) 1 o 2)

1. Una línea de texto.
2. **Figura de código** con nodo por línea.
3. **Figura de diagrama de flujo** (recorrido normal; si V(G)=2, las dos salidas).
4. **Una tabla** «Camino / Entrada / Salida esperada» (C1, o C1 y C2).

## 4. Reutilización de macros y estilos de SW2

- Hoy las macros están **dentro de `capitulo9.tex`** de SW2 (`\fcp`, `\fcs`, `\fcd`, `\fct`, `\cgn`, `\fcpitch` y el `\tikzset` con `fcp`, `fcs`, `fcd`, `fct`, `cgs`, `cgp`, `cgf`, `fca`).
- Propuesta: llevarlas a `config/grafos_cb.tex` (cargado desde `paquetes.tex`) y no repetirlas por sección.
- Falta en `config/paquetes.tex`: la librería `shapes.geometric` (rombos). `tikz` y `listings` ya están cargados; el `\lstset` global es SQL, por eso cada listado lleva `language=Java` local.
- Para grafos largos: `\renewcommand{\fcpitch}{1.2}` dentro de la figura, como hace SW2 en CU-05.

## 5. Numeración y formato

- **Figuras:** contador automático. La última figura del documento es la 156 (cap. 8); el cap. 9 hoy no tiene figuras, así que 9.3.2 empieza en la **157**.
- **Tablas:** caja negra termina en la 179; 9.3.2 empieza en la **180**.
- Caminos y diseño de casos (pueden pasar de una página) con el **patrón de longtable manual** de nuestro documento (`\refstepcounter{table}`, «Tabla N» en negrita y título en cursiva arriba, `\addtocounter{table}{-1}` al cerrar). Se evita el `\caption` dentro de `longtable` de SW2 para respetar APA 7 y mantener el estilo de 9.3.1. La matriz es una `table[H]` normal.
- Notas bajo cada figura y tabla: «Nota. Elaboración propia a partir del código del backend…».
- Compilar siempre en copia temporal; el `main.aux` del repo está viejo.

## 6. Tres alcances posibles (decide Mau)

Cada función completa ≈ 3 figuras, 3 tablas y 5–7 páginas; cada corta ≈ 2 figuras, 1 tabla y ~2 páginas.

| Opción | Qué incluye | Funciones | Figuras | Tablas | Páginas aprox. |
| --- | --- | --- | --- | --- | --- |
| **Mínima** | 1 principal por CU (+ `validarCredenciales` en CU-01) | 14 | 42 | 42 | **≈100** |
| **Recomendada** | Las marcadas «Sí» en la tabla: 27 completas + 3 cortas (`generar`, `solicitar`, y la corta que se decida) | 30 | ~85 | ~85 | **≈200** |
| **Completa** | Las 48 de la tabla (36 completas + 12 cortas) | 48 | ~120 | ~120 | **230–260** |

Calibración medida: compilando el CU-02 de SW2 (V=6) en nuestra plantilla ocupa ≈6,5 páginas y el CU-05 (V=9) ≈8,5; modelo: completa ≈ 3,5 + 0,55·V páginas, corta ≈ 1,5. Con eso, la Mínima da ≈100 páginas y la Recomendada ≈200 (documento de ≈550 y ≈650 páginas).

Para tener en cuenta: nuestro documento ya tiene 450 páginas; la Completa lo llevaría a unas 700. **Mi recomendación: «Recomendada».** Pero Mau dijo que no cree que sea solo una por CU; la Recomendada cumple con 2 a 4 por CU.

## 7. Riesgos

- **R1. V(G) muy alto:** CU-07 `registrarAuditoria` (≈17) y CU-14 `editar` (≈12), y en menor medida CU-15 `actualizar` (≈10). Con 17 caminos, la tabla y el grafo son enormes. Opciones: (a) tratarlos igual y aceptar 3–5 páginas de tablas, o (b) acotar a los caminos de mayor valor y decirlo en la nota, o (c) omitirlos y quedarse con sus métodos auxiliares (`avisar`, `obtener` en CU-07). **Recomiendo (a) para CU-15 y (b) para CU-07 y CU-14**, a decidir con Mau.
- **R2. Funciones sin decisiones** (V(G)=1): ya resuelto, se documentan con recorrido normal (plantilla corta).
- **R3. V(G) justo en 3 o 4** (CU-08, CU-14, CU-19, CU-20, CU-22): grafos chicos, queda corto frente a CU-05/07, pero cumple el criterio.
- **R4. Caminos no factibles:** hay que marcarlos y explicarlos (SW2 marca C6 en CU-02 y C9 en CU-05). Se detectan al armar la tabla de casos.
- **R5. «Resultado obtenido»:** para llenarlo hay que **ejecutar** los casos (JUnit/Mockito) o apoyarse en pruebas ya existentes en `src/test`. Sin ejecución no se inventa: queda como diseño y «Resultado obtenido: por registrar». Decisión de Mau: ¿incluimos esa columna? ¿Quién corre las pruebas?
- **R6. Código cambiante:** el backend evoluciona; cada análisis fija el commit del repo ComedorUAGRM y copia el método abreviado, como hace SW2.
- **R7. Listados largos:** `decidir` (65 líneas), `registrarAuditoria` (67) y `notificar` (48) no caben en una figura; se abrevian con `...` (SW2 abrevia las llamadas) mostrando solo el flujo de control.
- **R8. Volumen:** incluso la opción Recomendada es el punto más grande del capítulo; el plan es hacerlo por tandas (ver tareas) para revisar el estilo antes de seguir.
- **R9. Correspondencia con caja negra:** las funciones elegidas coinciden con los casos de 9.3.1 (registro, login, adjudicar, lista, auditoría, acta, indicadores, usuarios, perfil, devolver, archivar, entrega y comunicados, publicar). Las no marcadas «Sí» cubren flujos secundarios.

## 8. Tareas ordenadas (cuando Mau apruebe)

1. Mau decide: alcance (Mínima / Recomendada / Completa), tratamiento de R1 y si habrá «resultado obtenido» (R5).
2. Agregar `shapes.geometric` y crear `config/grafos_cb.tex` con las macros de SW2; compilar con un grafo de prueba.
3. Crear `secciones/11_capitulo9_pruebas/03b_caja_blanca.tex` (generado en tandas) e incluirlo dentro de 9.3.2; 9.3.3 intacto.
4. **Tanda piloto:** CU-19 `devolver` (completa) y CU-08 `generar` (corta). Revisión de Mau del estilo antes de seguir.
5. Por tandas, en orden numérico: CU-01, 04, 05, 06, 07, 08, 12, 14, 15, 19, 20, 21, 22. Por función: contar V(G) a mano (tres formas), numerar nodos, dibujar, armar tablas, marcar no factibles.
6. Si se incluye resultado obtenido: ejecutar las pruebas de cada camino y registrar el resultado real.
7. Compilar en copia temporal (pdflatex, biber, pdflatex ×2), revisar referencias, numeración y páginas.
8. Reportar a Mau tras cada tanda; sin commit ni push.
