# Carpeta de Figuras

Coloca aquí todas las imágenes, gráficos, fotografías o diagramas del documento.

## Recomendaciones APA 7:
- Formatos recomendados: `.pdf` o `.eps` para gráficos vectoriales; `.png` de alta resolución (mínimo 300 ppp) para imágenes de mapa de bits.
- Recuerda que en APA 7, el número y título de la figura van **encima** de la imagen:
  ```latex
  \begin{figure}[h]
      \caption{Diagrama de Flujo del Proceso Experimental}
      \label{fig:diagrama}
      \centering
      \includegraphics[width=0.8\textwidth]{figuras/mi_grafico.png}
      \begin{figurenotes}
          \small
          \item \textit{Nota.} Adaptado de los registros internos del laboratorio.
      \end{figurenotes}
  \end{figure}
  ```
