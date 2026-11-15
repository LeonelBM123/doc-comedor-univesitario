# Regla: cómo avanzar los capítulos de la versión 2 (`secciones_v2/`)

## Convención de esqueleto
- Cada capítulo nuevo está en `secciones_v2/capNN_*/capituloN.tex` (caps. 1 a 12; Implementación y Pruebas (flujo PUDS) son `05_implementacion.tex` y `06_pruebas.tex` dentro de `cap03_procesos_puds/`, como secciones 3.5 y 3.6; el cap. 9 trata las pruebas del producto terminado): `\preportadacapitulo`, `\section{Capítulo N: …}` y los encabezados completos.
- Las secciones sin redactar tienen el comentario `% [PENDIENTE]: Redactar "…"`. **Al redactar una sección, reemplaza ese comentario por el texto** (no lo dejes).
- Niveles de encabezado (numeración manual en el título): `\subsection{N.M.}`, `\subsubsection{N.M.K.}`, `\paragraph{N.M.K.L. Título.}` (con punto final), `\subparagraph{N.M.K.L.P. Título.}`. Máximo 5 niveles (APA 7).
- Mantener los comentarios `[INSTRUCCIÓN]` y `[PENDIENTE]` que sigan vigentes.
- Para varios capítulos grandes, partir el archivo en `NN_tema.tex` dentro de su carpeta y `\input` desde `capituloN.tex` (como en el cap. 3 y el cap. 6), sin cambiar el orden ni la numeración.

## Estado y de dónde sacar el contenido

| Cap. | Sección | Estado (15-nov-2026) | Fuente sugerida (no inventar fuera de ella) |
|---|---|---|---|
| 1 | PAPS completo | Redactado; recalcular 64.5 KLDC y proyección al terminar el bloque B | — |
| 2 | SQAP | Redactado | — |
| 3 | 3.1.7.1 Contexto (DUBSS), 3.2–3.4 ERS, análisis, diseño | Redactado (3.2–3.4 con `[PENDIENTE]` menores: detalle 5.x, 6.3, 7.1) | Ver `CLAUDE.md` §5–§8 |
| 3 | 3.1 Definiciones iniciales (Inicio) | Pendiente, sin asignar | Reutilizar figuras de dominio (`018`), diagrama general CU (`019`); despliegue/arquitectura: diseño |
| 3 | 3.5 Implementación, 3.6 Pruebas (flujo PUDS), 3.7–3.9 iteraciones | Pendiente, sin asignar | 6 paquetes P1–P6 (`CLAUDE.md` §8) y `casos_de_uso_filtrados.md` §3; confirmar número de iteraciones; casos de prueba CU-02, CU-03, CU-05 (confirmar) |
| 4 | CASE | Redactado | — |
| 5, 7, 8, 10, 11 | Legal, sitio web, mercado, marketing, puesta en marcha | Pendiente (Leonel) | Datos comerciales: pedir al usuario; marcos legales: citar fuentes verificadas |
| 6 | Infraestructura (6.8, 6.9) | Redactado | — |
| 9 | Pruebas del producto | Pendiente (Leonel) | CU del cap. 5; RNF de rendimiento (carga ≤ 3 s, puntaje ≤ 5 s); resultados reales al final |
| 12 | Software como producto | Redactado; faltan capturas y definición del chatbot, y actualizar «13 de 26 CU» al terminar el bloque B | — |
| Anexos | Carátulas y códigos QR (`anexos_v2.tex`) | Pendiente (Leonel, DB-8) | — |

## Al redactar una sección
1. Seguir `AGENTS.md` y `.claude/rules/04-latex-apa7.md` (citas, tablas, figuras).
2. Todo caso de uso mencionado debe existir en `CLAUDE.md` §6 con su ID vigente; todo RF debe existir en `03_requisitos_especificos.tex`.
3. Figuras en `images/` con numeración continua (`0NN_Nombre.ext`); tablas con `booktabs`.
4. Compilar **ambos** documentos si se tocó `secciones/` o `config/`; solo `main_v2` si el cambio fue en `secciones_v2/`.
5. Si cambia el número de iteraciones o el orden de capítulos, actualizar `main_v2.tex`, `AGENTS.md`, `CLAUDE.md` y esta tabla.
