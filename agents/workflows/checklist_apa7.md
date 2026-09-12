# ✅ Checklist de Verificación de Calidad APA 7.ª Edición

Utiliza esta lista de verificación antes de finalizar cualquier entrega o compilar la versión definitiva del documento.

---

## 📄 1. Estructura y Portada
- [ ] La modalidad del documento (`stu` para estudiante o `man` para artículo profesional) es la correcta en `\documentclass`.
- [ ] En modalidad estudiante: título, autor, filiación institucional, curso, profesor y fecha de entrega completos en `config/metadatos.tex`.
- [ ] En modalidad manuscrito: encabezado (*running head*) definido con `\shorttitle{...}` y nota de autor si aplica.
- [ ] El resumen (*Abstract*) no supera las 250 palabras y contiene entre 3 y 5 palabras clave (*Keywords*).

---

## 📑 2. Encabezados y Jerarquía
- [ ] **Nivel 1 (`\section`)**: Centrado, negrita, mayúsculas y minúsculas.
- [ ] **Nivel 2 (`\subsection`)**: Alineado a la izquierda, negrita.
- [ ] **Nivel 3 (`\subsubsection`)**: Alineado a la izquierda, negrita, cursiva.
- [ ] **Nivel 4 (`\paragraph`)**: Con sangría, negrita, finaliza con punto. Texto continúa en la misma línea.
- [ ] **Nivel 5 (`\subparagraph`)**: Con sangría, negrita, cursiva, finaliza con punto. Texto continúa en la misma línea.
- [ ] No existen niveles de encabezado huérfanos (por ejemplo, tener un nivel 2 sin que existan al menos dos subsecciones).

---

## 📊 3. Tablas y Figuras
- [ ] Todas las tablas emplean exclusivamente `booktabs` (`\toprule`, `\midrule`, `\bottomrule`).
- [ ] **Cero líneas verticales** en las definiciones de tablas.
- [ ] El número de la tabla va en negrita arriba del cuerpo: `Tabla 1`.
- [ ] El título descriptivo de la tabla va en cursiva debajo del número de tabla.
- [ ] Las notas explicativas se incluyen abajo con el entorno `tablenotes` comenzando con `\textit{Nota.}`.
- [ ] Todas las tablas y figuras están referenciadas en el texto principal mediante `\ref{tab:...}` o `\ref{fig:...}`.

---

## 📚 4. Citación y Bibliografía
- [ ] Citas parentéticas escritas con `\parencite{...}` $\rightarrow$ *(Autor, Año)*.
- [ ] Citas narrativas escritas con `\textcite{...}` $\rightarrow$ *Autor (Año)*.
- [ ] Citas con página directa incluyen el argumento opcional: `\parencite[p.~15]{...}`.
- [ ] Todas las fuentes citadas en el texto existen en [`referencias.bib`](file:///c:/Users/PC/Documents/doc-comedor/referencias.bib).
- [ ] Todas las entradas en [`referencias.bib`](file:///c:/Users/PC/Documents/doc-comedor/referencias.bib) están libres de caracteres no escapados o llaves desbalanceadas.
- [ ] Los DOIs están registrados en formato estándar (`10.XXXX/...`).

---

## 📐 5. Estilo y Redacción Científica
- [ ] Letras estadísticas en cursiva: *$p$*, *$M$*, *$DE$*, *$F$*, *$t$*, *$r$*, *$n$*.
- [ ] Omitir cero antes del punto decimal en valores que no pueden superar 1.0 (ejemplo: *$p < .05$*, *$r = .65$*).
- [ ] Tono académico formal, claro, conciso y objetivo.
- [ ] Sin comandos obsoletos de TeX (`{\bf ...}`) ni saltos de línea forzados repetitivos (`\\\\`).

---

## 📑 6. Páginas Preliminares e Índices
- [ ] El Índice General inicia con los apartados preliminares en este orden: *Índice General*, *Índice de Tablas*, *Índice de Figuras* y después *Resumen*, *Abstract*.
- [ ] Todos los títulos del Índice General muestran líneas punteadas (puntos de guía) hacia el número de página.
- [ ] Todo párrafo inicia con sangría de primera línea de 0.5 in (1.27 cm), incluido el primero que sigue a cada encabezado de nivel.
- [ ] El texto del cuerpo está justificado a ambos márgenes.
