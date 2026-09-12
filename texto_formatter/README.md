# 📥 texto_formatter/ (Buzón de Texto a Formatear)

## ¿Qué es?
Esta carpeta es el **buzón de entrada** del proyecto. Aquí depositas **texto en bruto** —prosa continua, borradores, notas, extractos de Word/PDF— que deseas que los agentes conviertan a **redacción académica en formato APA 7 en LaTeX**.

## ¿Cómo usarla?
1. Crea un archivo de texto (`.txt`, `.md`) dentro de esta carpeta y pega o arrastra tu contenido.
2. Indica en tu mensaje al agente que el texto está en `texto_formatter/`.
3. El agente lo leerá, lo convertirá a prosa APA 7 en `secciones/` y registrará las fuentes verificadas en `referencias.bib`.

## Reglas
- **No edites** los archivos fuente dentro de esta carpeta por ti mismo como agente: es un buzón de solo lectura.
- Tras procesar un archivo, el agente debe trasladarlo a `procesados/` para evitar reprocesamiento.
- Regla completa: [`agents/rules/01_carpeta_texto_formatter.md`](../agents/rules/01_carpeta_texto_formatter.md)