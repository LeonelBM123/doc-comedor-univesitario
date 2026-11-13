# Regla: este repositorio tiene DOS documentos LaTeX

Antes de editar o compilar, identifica **a cuál documento** se refiere la tarea. Si el usuario no lo dice y el cambio afecta a uno solo, pregunta o infiérelo por el capítulo.

| Documento | Maestro | PDF | Capítulos |
|---|---|---|---|
| **Principal** (Taller de Grado I, perfil + ERS + requisitos + análisis + diseño) | `main.tex` | `main.pdf` | 7 |
| **Versión 2** (PAPS, SQAP, PUDS, implementación, pruebas, CASE, legal, mercado, marketing…) | `main_v2.tex` | `main_v2.pdf` | 17 |

Ambos comparten `config/`, `images/`, `figuras/`, `tablas/` y `referencias.bib`.

## Dónde vive cada cosa

| Contenido | Carpeta | Lo usan |
|---|---|---|
| Perfil (cap. 1), tecnologías (cap. 2), DUBSS (cap. 3), ERS (cap. 4), requisitos (cap. 5), análisis (cap. 6), diseño (cap. 7), intro, conclusiones, bibliografía, anexo de la carta | `secciones/` | **Ambos** (en la v2, DUBSS/ERS/requisitos/análisis/diseño van dentro del cap. 3) |
| Capítulos propios de la v2 (PAPS 1.9+, SQAP, PUDS 3.6+, caps. 8–17, anexos extra) | `secciones_v2/` | Solo v2 |

**Regla de oro:** un cambio en `secciones/` se refleja en los dos PDF. Antes de editar ahí, piensa si el cambio tiene sentido en ambos documentos. Si es solo para la v2, escríbelo en `secciones_v2/`.

## Numeración reubicable (NO romper)

Los títulos llevan la numeración escrita a mano (`\subsection{6.1. Título}`), y `secnumdepth=0` (LaTeX no numera solo). Para reutilizar archivos en otra posición se usan dos macros de `config/paquetes.tex`:

- `\capnum{N}` — número con que se muestra el capítulo N del documento principal. En `main.tex` es la identidad; en `main_v2.tex` el cap. 2 (tecnologías) se muestra como **6**. Se usa en los encabezados de `secciones/03_capitulo2_tecnologias/`.
- `\pfxperfil` — vacío en `main.tex` (`3. Objetivos`); `1.` en `main_v2.tex` (`1.3. Objetivos`). Se usa en los encabezados de `secciones/02_capitulo1_perfil/`.

Reglas:
0. **Encabezados de DUBSS, ERS, requisitos, análisis y diseño** (`04_`, `05_`, `07_`, `08_`, `09_`): usar `\wfa{\wn{6}.1. Título}` (nivel: `\wfa` = subsection, `\wfb` = subsubsection, `\wfc` = paragraph; DUBSS: `\dbsa`, `\dbsb`). `\wn{clave}` da el prefijo numérico: identidad en `main.tex`; `main_v2.tex` lo mapea (4.1→3.2.1 … 6→3.3, 7→3.4, DUBSS 3.k→3.1.7.1.k). En prosa, `\wn{3.5}` y `\wfref{4}` en vez de «Sección 3.5» o «Capítulo 4» escritos a mano.
1. **Al agregar un encabezado nuevo** en `02_capitulo1_perfil/` escríbelo como `\subsection{\pfxperfil 9. Título}`; en `03_capitulo2_tecnologias/` como `\subsection{\capnum{2}.8. Título}`.
2. **Nunca** quites ni "limpies" estas macros, aunque parezcan redundantes.
3. Los capítulos 3 (3.1–3.5) y 4–7 conservan su número en ambos documentos: no los renumeres.
4. Si un capítulo reutilizado debe mostrarse con otro número en la v2, usa este mismo mecanismo; **no dupliques archivos**.
5. Las referencias en prosa a otras secciones ("sección 1.3.1", "Capítulo 4") deben ser válidas en el documento donde se escriben. En `secciones/` (compartido) evita referencias que cambien de número entre documentos.

## Verificación después de tocar `secciones/` o `config/`

1. Compilar **ambos** documentos (`scripts/compilar.ps1`).
2. Confirmar que `main.toc` no cambió respecto a antes de la edición (cambios de índice solo si eran intencionales).
3. Revisar que no haya `^!` (errores) ni `undefined` en `main.log` y `main_v2.log`.

## Compilación

```
pdflatex -interaction=nonstopmode main_v2.tex
biber --winunicode main_v2
pdflatex -interaction=nonstopmode main_v2.tex   (dos veces)
```
Igual para `main`. O bien: `powershell -File scripts/compilar.ps1 -Doc ambos`.
Si `*.aux` se corrompe tras una interrupción (`Missing \begin{document}`), borrar el `.aux` del documento afectado y recompilar.
Nota: `main.pdf` está versionado en git aunque `.gitignore` lo excluya; al recompilar aparecerá como modificado.
