# Reglas de Trabajo APA 7.ª Edición en LaTeX

Este archivo define las reglas activas para agentes que editen código fuente LaTeX (`.tex`) y bases de datos bibliográficas (`.bib`) en este espacio de trabajo.

## 1. Reglas de Sintaxis LaTeX para APA 7
- Utilizar la clase `apa7` (`\documentclass[stu|man, 12pt, spanish]{apa7}`).
- No cargar paquetes que colisionen con `apa7` (evitar `geometry`, `fancyhdr` o `titlesec`, ya que `apa7` administra márgenes, encabezados y fuentes).
- Para tablas, usar **siempre** `booktabs`: `\toprule`, `\midrule`, `\bottomrule`. Jamás usar barras verticales `|` en la definición de columnas (`{lcc}` o `{lp{5cm}}`, nunca `{|l|c|c|}`).
- Para citas, usar exclusivamente los comandos de `biblatex-apa`:
  - `\parencite{key}` o `\parencite[p.~XX]{key}` para citas parentéticas.
  - `\textcite{key}` o `\textcite[p.~XX]{key}` para citas narrativas.
  - No usar `\cite{}` genérico.

## 2. Validación de Fuentes Bibliográficas
- Antes de insertar cualquier cita en un archivo `.tex`, verificar que la clave exista en [`referencias.bib`](file:///c:/Users/PC/Documents/doc-comedor/referencias.bib).
- Si la fuente es nueva, agregar la entrada a [`referencias.bib`](file:///c:/Users/PC/Documents/doc-comedor/referencias.bib) con todos los campos obligatorios: `author`, `title`, `year`, `journal`/`publisher`, y `doi` cuando esté disponible.
- Todos los autores con nombres compuestos o instituciones deben agruparse con llaves dobles si es necesario (ejemplo: `author = {{American Psychological Association}}`).

## 3. Modularidad y Trabajo Seguro
- El contenido del documento reside en [`secciones/`](file:///c:/Users/PC/Documents/doc-comedor/secciones). Modificar únicamente el archivo correspondiente al objetivo de la tarea.
- Mantener los comandos `\input{...}` en [`main.tex`](file:///c:/Users/PC/Documents/doc-comedor/main.tex) limpios y organizados.
