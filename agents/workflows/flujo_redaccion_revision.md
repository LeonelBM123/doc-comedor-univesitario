# 🔄 Flujo de Trabajo: Redacción, Revisión y Cierre Editorial

Este documento define el procedimiento estandarizado que deben seguir el usuario y los agentes para redactar o modificar cualquier sección del documento académico bajo normas APA 7.

---

## 🔄 Fase 0: Ingreso de Texto en Bruto (carpeta `texto_formatter/`)

1. Si el usuario dispone de texto fuente sin formato (prosa, borradores, notas), debe depositarlo en [`texto_formatter/`](file:///c:/Users/PC/Documents/doc-comedor/texto_formatter).
2. El agente debe **leer** los archivos depositados y aplicar el protocolo definido en [`agents/rules/01_carpeta_texto_formatter.md`](file:///c:/Users/PC/Documents/doc-comedor/agents/rules/01_carpeta_texto_formatter.md).
3. Al concluir la conversión, los archivos fuente se trasladan a `texto_formatter/procesados/` para evitar reprocesamiento.

---

## 📈 Etapas del Flujo

### Fase 1: Planificación (Rol: Orquestador)
1. El usuario define el objetivo de la sección (por ejemplo, redactar la metodología o la discusión).
2. El **Orquestador** evalúa el alcance, determina qué subsecciones (niveles 2 y 3) son requeridas y crea o asigna el archivo modular en `secciones/XX_nombre.tex`.
3. Se asegura de que la sección esté invocada en [`main.tex`](file:///c:/Users/PC/Documents/doc-comedor/main.tex) con `\input{secciones/XX_nombre}`.

### Fase 2: Redacción Científica (Rol: Redactor Académico)
1. El **Redactor** escribe el contenido directamente en el archivo modular asignado.
2. Aplica la jerarquía correcta de encabezados (`\subsection`, `\subsubsection`, `\paragraph`).
3. Inserta llamadas de citas provisionales (`\parencite{clave_autor}`, `\textcite{clave_autor}`) para cada postulado teórico o dato empírico.
4. Genera el borrador completo y lo entrega para revisión bibliográfica.

### Fase 3: Validación Bibliográfica (Rol: Bibliógrafo)
1. El **Bibliógrafo** extrae todas las claves de citas utilizadas en la nueva sección.
2. Compara las claves contra [`referencias.bib`](file:///c:/Users/PC/Documents/doc-comedor/referencias.bib).
3. Si alguna clave no existe:
   - Recaba los metadatos fidedignos (autores, título, revista, año, DOI).
   - Registra la entrada BibTeX formateada en `referencias.bib`.
4. Valida que no existan alucinaciones y que la ortografía de los autores coincida con el texto.

### Fase 4: Auditoría de Estilo y Maquetación (Rol: Auditor de Estilo)
1. El **Auditor** examina el archivo generado:
   - Tablas con `booktabs` (`\toprule`, `\midrule`, `\bottomrule`), sin líneas verticales.
   - Figuras con número y título arriba, notas al pie.
   - Notación estadística formal (*$p < .05$*, cursivas).
2. Aplica la lista de verificación [`checklist_apa7.md`](file:///c:/Users/PC/Documents/doc-comedor/agents/workflows/checklist_apa7.md).
3. Corrige o sugiere ajustes tipográficos inmediatos.

### Fase 5: Compilación y Cierre
1. Se compila el documento maestro (`main.tex` con `pdflatex` + `biber`).
2. Se verifica la ausencia de advertencias de citas no resueltas (*undefined references*).
3. Se entrega el resultado compilado al usuario.
