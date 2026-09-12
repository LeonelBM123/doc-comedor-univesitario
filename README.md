# Plantilla LaTeX APA 7.ª Edición (Arquitectura Modular y Flujo de Agentes)

Este proyecto proporciona una infraestructura modular y escalable en **LaTeX** configurada bajo el estándar **APA 7** (American Psychological Association, 7.ª edición), equipada con un sistema de directivas y roles para **Agentes de Inteligencia Artificial**.

---

## 📁 Estructura del Proyecto

```text
doc-comedor/
├── main.tex                  # Archivo maestro orquestador
├── config/                   # Preámbulo y metadatos del documento
│   ├── paquetes.tex          # Librerías (biblatex, booktabs, babel, csquotes...)
│   └── metadatos.tex         # Título, autor, asignatura, profesor, resumen y keywords
├── secciones/                # Capítulos y secciones modulares (flujo IMRyD)
│   ├── 01_introduccion.tex   # Planteamiento del problema y objetivos
│   ├── 02_metodo.tex         # Diseño, participantes, instrumentos y procedimiento
│   ├── 03_resultados.tex     # Análisis descriptivo, pruebas estadísticas y tablas
│   ├── 04_discusion.tex      # Interpretación de hallazgos y limitaciones
│   ├── 05_conclusiones.tex   # Conclusiones finales y trabajo futuro
│   └── 99_anexos.tex         # Apéndices, cuestionarios y material suplementario
├── tablas/                   # Tablas independientes en formato booktabs
├── figuras/                  # Gráficos, esquemas e ilustraciones
├── referencias.bib           # Base de datos bibliográfica en formato BibTeX
├── agents/                   # Contexto, roles y flujos para agentes de IA
│   ├── README.md             # Mapa del sistema y guía de invocación de agentes
│   ├── roles/                # Roles especializados (Orquestador, Redactor, Bibliógrafo, Auditor)
│   └── workflows/            # Procedimiento paso a paso y Checklist interactivo APA 7
├── .agents/                  # Reglas nativas para Antigravity IDE (.agents/rules/)
├── AGENTS.md                 # Directiva maestra global para agentes de IA en el repositorio
├── .gitignore                # Archivos auxiliares de LaTeX a ignorar
└── README.md                 # Este manual de uso
```

---

## 🤖 Sistema de Agentes de IA

El proyecto cuenta con 4 roles especializados documentados en [`agents/`](file:///c:/Users/PC/Documents/doc-comedor/agents):

1. **Orquestador / Editor en Jefe** ([`agents/roles/01_orquestador.md`](file:///c:/Users/PC/Documents/doc-comedor/agents/roles/01_orquestador.md)): Planifica la estructura y asigna tareas.
2. **Redactor Académico** ([`agents/roles/02_redactor_academico.md`](file:///c:/Users/PC/Documents/doc-comedor/agents/roles/02_redactor_academico.md)): Redacta la prosa formal en `secciones/`.
3. **Bibliógrafo y Gestor de Citas** ([`agents/roles/03_bibliografo_citas.md`](file:///c:/Users/PC/Documents/doc-comedor/agents/roles/03_bibliografo_citas.md)): Audita y valida `referencias.bib`.
4. **Auditor de Estilo y Maquetación** ([`agents/roles/04_auditor_estilo_apa.md`](file:///c:/Users/PC/Documents/doc-comedor/agents/roles/04_auditor_estilo_apa.md)): Aplica el [Checklist APA 7](file:///c:/Users/PC/Documents/doc-comedor/agents/workflows/checklist_apa7.md).

---

## 🚀 Opciones de Uso

### 1. Formato Estudiante (`stu`) vs Manuscrito/Artículo (`man`)
En el archivo [`main.tex`](file:///c:/Users/PC/Documents/doc-comedor/main.tex), la primera línea define la modalidad:
- `\documentclass[stu, 12pt, spanish]{apa7}`: **Formato para Estudiantes**. Incluye portada con asignatura, profesor, fecha y filiación universitaria.
- `\documentclass[man, 12pt, spanish]{apa7}`: **Formato Manuscrito/Profesional**. Formato preparado para envío a revistas académicas (incluye encabezado *running head* y nota de autor).

### 2. Idioma
La clase incluye la opción `spanish` y `es-tabla` en `config/paquetes.tex` para adaptar automáticamente encabezados, resumen (*Abstract*), tablas ("Tabla" en lugar de "Cuadro"), figuras y bibliografía al español.

---

## ⚙️ Cómo Compilar el Proyecto

### Opción A: Compilación Local (VS Code / TeXworks / Terminal)
Para compilar correctamente las citas con `biblatex` y `biber`, ejecuta el siguiente flujo:

```bash
pdflatex main.tex
biber --winunicode main
pdflatex main.tex
pdflatex main.tex
```
> [!TIP]
> En entornos Windows con soporte UTF-8, el flag `--winunicode` en `biber` garantiza la detección correcta del archivo de control `main.bcf`.

Si usas `latexmk`:
```bash
latexmk -pdf main.tex
```

### Opción B: Overleaf
1. Comprime todo el contenido del directorio en un archivo `.zip` (manteniendo las carpetas `secciones/`, `config/`, `figuras/`, `tablas/`).
2. En Overleaf, selecciona **New Project** > **Upload Project**.
3. Asegúrate de que el motor de compilación esté configurado en **pdfLaTeX** y el procesador de bibliografía en **Biber**.

---

## 📌 Guía Rápida de Comandos de Cita

| Tipo de Cita | Comando LaTeX | Resultado Ejemplo |
| :--- | :--- | :--- |
| **Cita Parentética** | `\parencite{apa2020}` | (American Psychological Association, 2020) |
| **Cita Narrativa** | `\textcite{knuth1984tex}` | Knuth (1984) |
| **Página Específica** | `\parencite[p.~15]{apa2020}` | (American Psychological Association, 2020, p. 15) |
| **Múltiples Fuentes** | `\parencite{apa2020, einstein1905}` | (American Psychological Association, 2020; Einstein, 1905) |
