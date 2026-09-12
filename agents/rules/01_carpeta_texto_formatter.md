# 📥 Regla: Carpeta `texto_formatter/` (Buzón de Texto a Formatear)

## Objetivo
El usuario puede depositar **texto en bruto** (sin formato LaTeX: prosa continua, borradores, extractos de Word/PDF, notas sueltas) en la carpeta [`texto_formatter/`](file:///c:/Users/PC/Documents/doc-comedor/texto_formatter) para que los agentes lo transformen en redacción académica bajo normas **APA 7 en LaTeX**.

Esta carpeta es el **único buzón de entrada de texto fuente**. Cuando el usuario indique que el contenido proviene de `texto_formatter/`, ningún agente debe redactar el texto "desde cero": debe partir del material depositado.

---

## 📁 Ubicación y Estructura

```text
texto_formatter/           # Buzón de entrada (SOLO LECTURA para agentes)
├── README.md              # Instrucciones de uso
└── procesados/            # Archivos fuente ya convertidos (traslado tras el procesamiento)
```

---

## 🔄 Contrato de Entrada / Salida

| Dirección | Ubicación | Descripción |
| :--- | :--- | :--- |
| **ENTRADA** | `texto_formatter/` | Archivos de texto depositados por el usuario (`.txt`, `.md`, extractos). |
| **SALIDA** | `secciones/XX_*.tex` | Prosa convertida a APA 7 en la arquitectura modular. |
| **SALIDA** | `config/metadatos.tex` | Resumen/metadatos si procede. |
| **SALIDA** | `referencias.bib` | Fuentes verificadas registradas por el Bibliógrafo. |

---

## 🛠️ Protocolo Obligatorio al Detectar Archivos en `texto_formatter/`

1. **LEER** el/los archivos depositados por el usuario.
2. **PLANIFICAR** el desglose del contenido según el índice vigente del documento (rol **Orquestador**).
3. **REDACTAR** en español académico formal, mapeando el contenido a la jerarquía de encabezados APA 7 (5 niveles): `\section`, `\subsection`, `\subsubsection`, `\paragraph`, `\subparagraph`.
4. **CITAR** únicamente fuentes verificadas (existentes en `referencias.bib` o registradas por el **Bibliógrafo**). **PROHIBIDO inventar autores, años o DOIs** (ver `AGENTS.md`, regla CERO ALUCINACIONES).
5. **NO EDITAR** el contenido original dentro de `texto_formatter/`; es un buzón de solo lectura.
6. **TRASLADAR** el archivo fuente procesado a `texto_formatter/procesados/` al concluir la conversión, para evitar reprocesamiento.
7. **COMPILAR** (`pdflatex -interaction=nonstopmode main.tex` + `biber --winunicode main`) y verificar ausencia de errores y referencias no resueltas.
8. **INFORMAR** al usuario del resultado, indicando los archivos generados o modificados en `secciones/`.

---

## 👥 Agentes Responsables

| Rol | Responsabilidad en este flujo |
| :--- | :--- |
| **Orquestador** (`roles/01_orquestador.md`) | Supervisa el plan de conversión y el desglose temático. |
| **Redactor Académico** (`roles/02_redactor_academico.md`) | Ejecuta la conversión del texto crudo a prosa APA 7. |
| **Bibliógrafo** (`roles/03_bibliografo_citas.md`) | Registra en `referencias.bib` y valida las fuentes citadas. |
| **Auditor de Estilo** (`roles/04_auditor_estilo_apa.md`) | Verifica el formato final contra el Checklist APA 7. |