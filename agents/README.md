# 👥 Sistema de Agentes Especializados para Documentos APA 7

Bienvenido al sistema de agentes para la redacción, citación, revisión y maquetación de documentos académicos en **LaTeX** conforme al estándar **APA 7.ª edición**.

Este marco de trabajo divide las responsabilidades del proceso editorial entre cuatro roles de agentes de IA con especializaciones definidas, permitiendo un flujo de trabajo ordenado, libre de inconsistencias y con trazabilidad académica rigurosa.

---

## 🗺️ Mapa de Roles y Especialidades

| Rol | Archivo de Contexto | Responsabilidad Principal |
| :--- | :--- | :--- |
| **1. Orquestador / Editor en Jefe** | [`roles/01_orquestador.md`](file:///c:/Users/PC/Documents/doc-comedor/agents/roles/01_orquestador.md) | Coordina el proyecto, define la estructura del índice, desglosa tareas y vela por la coherencia global del manuscrito. |
| **2. Redactor Académico** | [`roles/02_redactor_academico.md`](file:///c:/Users/PC/Documents/doc-comedor/agents/roles/02_redactor_academico.md) | Redacta las secciones con voz formal académica, claridad explicativa y aplicación rigurosa de niveles de encabezado. |
| **3. Bibliógrafo y Gestor de Citas** | [`roles/03_bibliografo_citas.md`](file:///c:/Users/PC/Documents/doc-comedor/agents/roles/03_bibliografo_citas.md) | Gestiona `referencias.bib`, previene citas alucinadas, verifica DOIs y asegura el uso correcto de `\parencite` y `\textcite`. |
| **4. Auditor de Estilo y Maquetación** | [`roles/04_auditor_estilo_apa.md`](file:///c:/Users/PC/Documents/doc-comedor/agents/roles/04_auditor_estilo_apa.md) | Audita tablas (`booktabs`), figuras, notas, formato tipográfico y verifica el cumplimiento de la lista de chequeo APA 7. |

---

## 🔄 Flujo Operativo del Sistema

```text
[ Usuario / Requerimiento ]
[ Texto en bruto depositado en texto_formatter/ ] ──► (se convierte a APA 7 LaTeX)
            │
            ▼
┌───────────────────────────────┐
│     01. ORQUESTADOR           │  ◄── Planifica índice y tareas
└──────────────┬────────────────┘
               │
               ▼
┌───────────────────────────────┐
│     02. REDACTOR ACADÉMICO    │  ◄── Redacta sección modular (secciones/XX_*.tex)
└──────────────┬────────────────┘
               │
               ▼
┌───────────────────────────────┐
│     03. BIBLIÓGRAFO & CITAS   │  ◄── Valida fuentes en referencias.bib y sintaxis
└──────────────┬────────────────┘
               │
               ▼
┌───────────────────────────────┐
│     04. AUDITOR DE ESTILO     │  ◄── Aplica Checklist APA 7 (tablas, encabezados)
└──────────────┬────────────────┘
               │
               ▼
[ Documento Compilable y Aprobado ]
```

---

## 📁 Estructura del Directorio `agents/`

```text
agents/
├── README.md                           # Este archivo (visión general)
├── rules/
│   └── 01_carpeta_texto_formatter.md   # Regla: buzón de entrada de texto a formatear
├── roles/
│   ├── 01_orquestador.md               # Prompt y directrices del Editor en Jefe
│   ├── 02_redactor_academico.md        # Prompt y estilo del Redactor Académico
│   ├── 03_bibliografo_citas.md         # Prompt y reglas del Gestor de Citas
│   └── 04_auditor_estilo_apa.md        # Prompt y reglas del Auditor de Estilo
└── workflows/
    ├── flujo_redaccion_revision.md     # Procedimiento paso a paso para cada sección
    └── checklist_apa7.md               # Lista de verificación pre-entrega
```

---

## 📥 Buzón de Entrada: Carpeta `texto_formatter/`

La carpeta [`texto_formatter/`](file:///c:/Users/PC/Documents/doc-comedor/texto_formatter) es el **buzón de entrada** donde el usuario deposita texto en bruto (prosa, borradores, notas sin formato LaTeX) que debe ser convertido a redacción académica **APA 7 en LaTeX**.

- Es un buzón de **solo lectura**: los agentes nunca editan el contenido original.
- Al procesarlo, el texto convertido se escribe directamente en `secciones/`, en la sección que indique el usuario.

Todo agente debe cumplir la regla completa en [`agents/rules/01_carpeta_texto_formatter.md`](file:///c:/Users/PC/Documents/doc-comedor/agents/rules/01_carpeta_texto_formatter.md).

---

## 💡 Cómo Usar los Contextos de los Agentes

Puedes invocar a un agente específico en tu prompt de conversación adjuntando su rol o instruyendo a Antigravity:

> *"Actúa bajo el rol de **Bibliógrafo y Gestor de Citas** ([`agents/roles/03_bibliografo_citas.md`](file:///c:/Users/PC/Documents/doc-comedor/agents/roles/03_bibliografo_citas.md)) y audita todas las citas en [`secciones/01_introduccion.tex`](file:///c:/Users/PC/Documents/doc-comedor/secciones/01_introduccion.tex) contra [`referencias.bib`](file:///c:/Users/PC/Documents/doc-comedor/referencias.bib)."*

> *"Actúa bajo el rol de **Auditor de Estilo APA** ([`agents/roles/04_auditor_estilo_apa.md`](file:///c:/Users/PC/Documents/doc-comedor/agents/roles/04_auditor_estilo_apa.md)) y valida la Tabla 1 según las normas de `booktabs`."*
