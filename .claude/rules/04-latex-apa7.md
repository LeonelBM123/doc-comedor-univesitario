---
paths:
  - "**/*.tex"
  - "referencias.bib"
---

# Regla: LaTeX y APA 7 (resumen operativo)

La guía completa está en `AGENTS.md` y `.agents/rules/apa7-standards.md`; este archivo solo resume lo imprescindible al editar `.tex`.

- Clase `apa7`; no cargar `geometry`, `fancyhdr` ni `titlesec`. Los paquetes se agregan **solo** en `config/paquetes.tex` (afecta a ambos documentos; recompilar los dos).
- `main.tex` y `main_v2.tex` solo orquestan con `\input`; no escribir texto largo en ellos.
- Citas: solo `\parencite{}` / `\textcite{}`; la clave debe existir en `referencias.bib` (cero fuentes inventadas).
- Tablas: `booktabs` (`\toprule`, `\midrule`, `\bottomrule`), sin líneas verticales; título arriba con `\caption`, notas abajo (`\textit{Nota.}`). Figuras: `[H]`, título arriba, nota/fuente abajo.
- Listas de tablas y figuras: usar siempre `\caption` para que aparezcan en los índices.
- Encabezados con numeración manual y, donde corresponda, las macros `\capnum` / `\pfxperfil` (ver `01-dos-documentos.md`).
- Español académico formal, tercera persona o primera del plural; sin coloquialismos.
- `texto_formatter/` es solo lectura; el texto convertido se escribe en `secciones/` o `secciones_v2/`.
- Compilar con `pdflatex -interaction=nonstopmode` + `biber --winunicode` (ver `scripts/compilar.ps1`).
