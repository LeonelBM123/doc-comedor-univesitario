# 🤖 Guía Maestra para Agentes de IA en el Proyecto (APA 7 LaTeX)

Este repositorio contiene un documento académico estructurado en **LaTeX** bajo las normas **APA 7.ª edición** (American Psychological Association). Cualquier agente que colabore en este proyecto debe acatar estrictamente las siguientes directrices operativas.

---

## 🎯 Objetivo General
Mantener la máxima coherencia académica, rigor metodológico, elegancia tipográfica y cumplimiento absoluto del manual APA 7 en idioma español.

---

## 📜 Reglas Innegociables de APA 7

### 1. Citación y Bibliografía (BibLaTeX + Biber)
- **CERO ALUCINACIONES**: Queda terminantemente prohibido inventar autores, artículos, libros, años o DOIs. Toda fuente citada en el texto debe existir en [`referencias.bib`](file:///c:/Users/PC/Documents/doc-comedor/referencias.bib).
- **Tipos de Cita**:
  - **Cita parentética**: Usar `\parencite{clave}` $\rightarrow$ *(Pérez, 2023)* o `\parencite[p.~45]{clave}` $\rightarrow$ *(Pérez, 2023, p. 45)*.
  - **Cita narrativa**: Usar `\textcite{clave}` $\rightarrow$ *Pérez (2023)* o `\textcite[p.~12]{clave}` $\rightarrow$ *Pérez (2023, p. 12)*.
- **Múltiples autores en texto**:
  - 1 autor: `Pérez (2020)` / `(Pérez, 2020)`
  - 2 autores: `Pérez y Gómez (2020)` / `(Pérez & Gómez, 2020)` (manejado por `biblatex` con opción `spanish`).
  - 3 o más autores: Se cita el primero seguido de "et al." desde la primera mención (manejado automáticamente por `style=apa`).

### 2. Jerarquía de Encabezados (Headings)
APA 7 establece 5 niveles jerárquicos:
1. **Nivel 1**: `\section{...}` $\rightarrow$ Centrado, Negrita, Mayúsculas y Minúsculas.
2. **Nivel 2**: `\subsection{...}` $\rightarrow$ Alineado a la izquierda, Negrita.
3. **Nivel 3**: `\subsubsection{...}` $\rightarrow$ Alineado a la izquierda, Negrita, Cursiva.
4. **Nivel 4**: `\paragraph{Título del Nivel 4.} Texto continúa aquí...` $\rightarrow$ Con sangría, Negrita, con punto final.
5. **Nivel 5**: `\subparagraph{Título del Nivel 5.} Texto continúa aquí...` $\rightarrow$ Con sangría, Negrita, Cursiva, con punto final.

### 3. Tablas y Figuras
- **Tablas (`booktabs`)**:
  - **Prohibido el uso de líneas verticales** (`|`).
  - Usar exclusivamente `\toprule`, `\midrule` y `\bottomrule`.
  - El título va **arriba** de la tabla: Número en negrita, título descriptivo en cursiva (`\caption{...}`).
  - Las notas explicativas van **abajo** de la tabla dentro de `\begin{tablenotes} \item \textit{Nota.} ... \end{tablenotes}`.
- **Figuras**:
  - Número y título en la parte superior.
  - Formatos vectoriales o de alta resolución en la carpeta `figuras/`.
  - Notas o fuentes al pie de la figura.

---

## 🏗️ Estructura Modular del Proyecto

Los agentes deben respetar la modularidad del documento:
- **`main.tex`**: Archivo maestro que solo orquesta preámbulo, metadatos y secciones mediante `\input{...}`. No escribir texto largo directamente aquí.
- **`config/`**:
  - `paquetes.tex`: Definición de librerías y configuración de motor.
  - `metadatos.tex`: Título, autor, afiliación, curso, profesor, fecha y resumen.
- **`secciones/`**: Archivos individuales para cada apartado del documento (`01_introduccion.tex`, `02_metodo.tex`, etc.).
- **`tablas/`**: Tablas complejas o independientes para ser incluidas mediante `\input{tablas/...}`.
- **`figuras/`**: Gráficos, diagramas e imágenes.
- **`referencias.bib`**: Base de datos de fuentes verificadas.
- **`agents/`**: Directorio de documentación de roles, flujos y checklists de trabajo.
- **`agents/rules/`**: Reglas del sistema de agentes (p. ej., buzón de entrada `texto_formatter/`).
- **`texto_formatter/`**: Buzón de entrada donde el usuario deposita texto en bruto (sin formato LaTeX) para que los agentes lo conviertan a APA 7 en LaTeX. Es de SOLO LECTURA para los agentes; el texto convertido se escribe en `secciones/` (en la sección que indique el usuario). Regla obligatoria: [`agents/rules/01_carpeta_texto_formatter.md`](file:///c:/Users/PC/Documents/doc-comedor/agents/rules/01_carpeta_texto_formatter.md).
- **`.agents/`**: Reglas y skills nativas para el entorno Antigravity IDE.

---

## 🤝 Protocolo de Edición para Agentes
1. **Edición Focalizada**: Al redactar o corregir una sección, modificar **únicamente** el archivo en `secciones/` correspondiente.
2. **Verificación de Citas**: Al añadir una afirmación respaldada en literatura, registrar de inmediato la entrada BibTeX en [`referencias.bib`](file:///c:/Users/PC/Documents/doc-comedor/referencias.bib).
3. **Preservación de Comentarios**: Mantener los comentarios aclaratorios existentes en los archivos `.tex`.
4. **Tono Académico**: Redactar en español académico formal, en tercera persona o primera persona del plural formal, evitando coloquialismos, redundancias o hipérboles.
5. **Compilación Segura**: Compilar siempre con `pdflatex -interaction=nonstopmode main.tex` y `biber --winunicode main`. Si `main.aux` se corrompe tras una interrupción (`Missing \begin{document}`), eliminar `main.aux` y volver a compilar.
