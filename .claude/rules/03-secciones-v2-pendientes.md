# Regla: cómo avanzar los capítulos de la versión 2 (`secciones_v2/`)

## Convención de esqueleto
- Cada capítulo nuevo está en `secciones_v2/capNN_*/capituloN.tex` (caps. 1 a 12; Implementación y Pruebas (flujo PUDS) son `05_implementacion.tex` y `06_pruebas.tex` dentro de `cap03_procesos_puds/`, como secciones 3.5 y 3.6; el cap. 9 trata las pruebas del producto terminado): `\preportadacapitulo`, `\section{Capítulo N: …}` y los encabezados completos.
- Las secciones sin redactar tienen el comentario `% [PENDIENTE]: Redactar "…"`. **Al redactar una sección, reemplaza ese comentario por el texto** (no lo dejes).
- Niveles de encabezado (numeración manual en el título): `\subsection{N.M.}`, `\subsubsection{N.M.K.}`, `\paragraph{N.M.K.L. Título.}` (con punto final), `\subparagraph{N.M.K.L.P. Título.}`. Máximo 5 niveles (APA 7).
- Mantener los comentarios `[INSTRUCCIÓN]` y `[PENDIENTE]` que sigan vigentes.
- Para varios capítulos grandes, partir el archivo en `NN_tema.tex` dentro de su carpeta y `\input` desde `capituloN.tex` (como en el cap. 3 y el cap. 6), sin cambiar el orden ni la numeración.

## Estado y de dónde sacar el contenido

| Cap. | Sección | Estado | Fuente sugerida (no inventar fuera de ella) |
|---|---|---|---|
| 1 | 1.1, 1.2, 1.7, 1.8 | Redactado (reutilizado de `secciones/02_capitulo1_perfil/`; 1.2, 1.7 y 1.8 con título propio de la v2 y cuerpo en `*_cuerpo.tex`) | — |
| 1 | 1.3–1.6, 1.9–1.12 PAPS (índice alineado con el índice de referencia; 1.4 y 1.12 usan 3 software de referencia) | Pendiente (esqueleto listo) | Los 3 software de referencia los define el equipo (cloc real, sin inventar cifras); estimaciones: `casos_de_uso_filtrados.md` y `plan_desarrollo_tareas.md`; riesgos y organización: preguntar. Justificación, Metodología y Alcances del perfil ya no se incluyen en el cap. 1 de la v2 (siguen en `main.pdf`) |
| 2 | SQAP | Pendiente (2.8.1 y 2.11.1.1/2.11.2.1 con referencia) | PUDS (cap. 3), IEEE 830 (3.2.1–3.2.3), diseño (3.4); misión/visión/políticas del equipo: preguntar |
| 3 | 3.1.7.1 Contexto (DUBSS) | Redactado (reutilizado; 3.1.7.1.1 a 3.1.7.1.5) | — |
| 3 | 3.1 Definiciones iniciales (Inicio) | Pendiente (3.1.2, 3.1.3, 3.1.9 con referencia) | Modelos iniciales: reutilizar figuras de dominio (`018`), diagrama general CU (`019`); despliegue/arquitectura: cap. 7 |
| 3 | 3.7–3.9 iteraciones | Pendiente | Agrupar CU por los **6 paquetes** (P1–P6, `CLAUDE.md` §8) y el orden de `casos_de_uso_filtrados.md` §3; confirmar número de iteraciones con el usuario |
| 3.2–3.4 | ERS y requisitos (3.2), análisis (3.3), diseño (3.4) | Redactado (varias partes con `[PENDIENTE]`: 5.x detalle, 6.3, 7.1) | Ver `CLAUDE.md` §5–§8 |
| 3.5 | Implementación | Pendiente | Código del sistema + 6 paquetes; stack `CLAUDE.md` §4 |
| 3.6, 9 | Pruebas (flujo PUDS) y pruebas del producto | Pendiente | CU de cap. 5; RNF de rendimiento (carga ≤ 3 s, puntaje ≤ 5 s); casos propuestos CU-02, CU-03, CU-05 (confirmar) |
| 4, 6 (6.8+) | CASE, gestión de infraestructura | Pendiente | Confirmar herramientas reales con el usuario |
| 5, 7, 8, 10–12 | Legal, sitio web, mercado, marketing, puesta en marcha, producto | Pendiente | Datos comerciales: pedir al usuario; marcos legales: citar fuentes verificadas |

## Al redactar una sección
1. Seguir `AGENTS.md` y `.claude/rules/04-latex-apa7.md` (citas, tablas, figuras).
2. Todo caso de uso mencionado debe existir en `CLAUDE.md` §6 con su ID vigente; todo RF debe existir en `03_requisitos_especificos.tex`.
3. Figuras en `images/` con numeración continua (`0NN_Nombre.ext`); tablas con `booktabs`.
4. Compilar **ambos** documentos si se tocó `secciones/` o `config/`; solo `main_v2` si el cambio fue en `secciones_v2/`.
5. Si cambia el número de iteraciones o el orden de capítulos, actualizar `main_v2.tex`, `AGENTS.md`, `CLAUDE.md` y esta tabla.
