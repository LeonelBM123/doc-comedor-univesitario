# 📥 texto_formatter/ (Buzón de Texto a Formatear)

## ¿Qué es?
Esta carpeta es el **buzón de entrada** del proyecto. Aquí depositas **texto en bruto** —prosa continua, borradores, notas, extractos de Word/PDF— que deseas que los agentes conviertan a **redacción académica en formato APA 7 en LaTeX**.

## ¿Cómo usarla?
1. Crea un archivo de texto (`.txt`, `.md`) dentro de esta carpeta y pega o arrastra tu contenido.
2. Indica en tu mensaje al agente que el texto está en `texto_formatter/`.
3. El agente lo leerá, lo convertirá a prosa APA 7 en `secciones/` y registrará las fuentes verificadas en `referencias.bib`.

## Reglas
- **No edites** los archivos dentro de esta carpeta como agente: es un buzón de solo lectura.
- Aquí solo se colocan archivos de texto normales (`.txt`, `.md`).
- El contenido convertido se escribe directamente en `secciones/` (en la sección que indique el usuario).
- Regla completa: [`agents/rules/01_carpeta_texto_formatter.md`](../agents/rules/01_carpeta_texto_formatter.md)