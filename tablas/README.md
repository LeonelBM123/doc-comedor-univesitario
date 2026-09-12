# Carpeta de Tablas

Para tablas complejas o muy extensas, es una buena práctica guardarlas en archivos `.tex` independientes dentro de esta carpeta e incluirlas en las secciones usando:

```latex
\input{tablas/mi_tabla.tex}
```

## Estándar APA 7 para Tablas:
- Usar siempre el paquete `booktabs`.
- **Prohibido el uso de líneas verticales** (`|`).
- Usar exclusivamente:
  - `\toprule`: Línea superior de la tabla.
  - `\midrule`: Línea separadora de encabezados.
  - `\bottomrule`: Línea final de cierre.
- Título descriptivo en cursiva arriba, y notas explicativas abajo con el entorno `tablenotes`.
