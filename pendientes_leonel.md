# Pendientes de Leonel (Persona B) — documento v2

Estado al **16-nov-2026**, después de redactar los caps. 5, 7, 8, 9, 10 y 11. Lo que figura aquí son los `[PENDIENTE]` y `[VERIFICAR]` que quedan en los archivos de `secciones_v2/`. Nada de esto se puede inventar: cada punto necesita un dato real o una decisión.

## 1. Decisiones y datos que desbloquean el resto

| # | Qué falta | Quién lo da | Desbloquea |
|---|---|---|---|
| 1 | URL real del sitio de NEXWARE | Equipo | 7.2.1, 7.2.2 (QR) |
| 2 | ¿Se aplica la encuesta del cap. 8? Si sí: a quién, instrumento y muestra | Equipo | 8.9 |
| 3 | Precios y niveles de licencia | Equipo, con el costo del proyecto | 8.5.6, 8.7.3 a 8.7.7, 11.3 |
| 4 | Cuánto invertir en marketing y qué metas numéricas | Equipo | 10.1.4.4, 10.1.5 |
| 5 | Confirmar con el docente los CU a probar (propuestos: CU-02, 03 y 05) | Docente | Cap. 9 |
| 6 | Cuándo termina la implementación (bloque B) | Leonel | Resultados del cap. 9 |

## 2. Pendientes por capítulo

### Cap. 5 — Aspectos legales
- [ ] `[VERIFICAR]` Costos, plazos y porcentajes (SEPREC, licencia municipal, aportes laborales). Vienen del documento modelo; confirmarlos en los portales oficiales.
- [ ] Revisar que la forma elegida (S.R.L.) la acepten los dos socios.

### Cap. 7 — Sitio web
- [ ] 7.2.1 URL real del sitio.
- [ ] 7.2.2 Imagen del QR de esa URL, en `images/`, con figura y `\caption`.
- [ ] 7.1.5 Capturas o prototipo de las ocho pantallas (hoy solo hay descripción).
- [ ] Datos reales de contacto de NEXWARE (correo, canales).
- [ ] 7.1.5.7 Muro de comentarios: se muestra solo si hay testimonios reales.

### Cap. 8 — Estudio de mercado
- [ ] 8.4.2 `[VERIFICAR]` Búsqueda documentada de software comercial de gestión de becas en Bolivia.
- [ ] 8.5.5 Cantidad de instituciones y postulantes del mercado potencial, con fuente.
- [ ] 8.5.6 Análisis de precios (cotizaciones o tarifas reales).
- [ ] 8.7.3 Niveles de licencia y precios.
- [ ] 8.7.4 Proyección de clientes.
- [ ] 8.7.5 Proyección de ingresos.
- [ ] 8.7.6 Punto de equilibrio (con el esfuerzo de COCOMO II de 1.5.3 y los costos del cap. 6).
- [ ] 8.7.7 Conclusión de viabilidad económica.
- [ ] 8.9 Encuesta y resultados (o justificar que no se aplica).

### Cap. 9 — Pruebas
- [ ] Llenar «Resultado obtenido» de las tablas de caja blanca y caja negra al ejecutar las pruebas.
- [ ] Confirmar los grafos de flujo de caja blanca contra el código real.
- [ ] 9.3.4 Llenar la lista de comprobación.
- [ ] 9.4 Medir y registrar los tiempos de respuesta (límites de 3 s y 5 s).
- [ ] 9.3.3 Ejecutar OWASP ZAP y la prueba manual; registrar hallazgos.

### Cap. 10 — Marketing
- [ ] 10.1.4.4 Metas numéricas.
- [ ] 10.1.5.1 a 10.1.5.5 Montos del presupuesto (gestión de redes, publicidad, mensual y anual).
- [ ] 10.1.6 Piezas gráficas reales (afiche, publicación de ejemplo).

### Cap. 11 — Puesta en marcha
- [ ] 11.2 Costo mensual en AWS, Azure y GCP con las calculadoras oficiales, para la carga prevista (20,000 postulaciones y al menos 50 administrativos concurrentes).
- [ ] 11.5.1 `[VERIFICAR]` Texto de las leyes 164, 453 y 1080 y el estado de la protección de datos personales en Bolivia.
- [ ] 11.6.3 Evidencias reales del despliegue (repositorio, captura, ficha de Play Store).

### Anexos (DB-8)
- [ ] `secciones_v2/anexos_v2.tex`: carátula de la propuesta y del PAPS, y códigos QR (2 `[PENDIENTE]`).

## 3. Revisión conjunta con Mauro
- [ ] Cap. 3 sin asignar: 49 `[PENDIENTE]` (3.1, 3.5, 3.6, 3.7 a 3.9); no es parte de esta lista.
- [ ] Referencias cruzadas entre capítulos (por ejemplo, 8.4.2 cita la sección 1.4, 7.1.3 cita la 12.1.2).
- [ ] Compilar `main` y `main_v2` al cerrar cada cambio.

## 4. Orden sugerido
1. Decisiones de la sección 1 (son lo que más bloquea).
2. Cap. 7: URL y QR, que se resuelven con un solo dato.
3. Cap. 11: cotizaciones en las calculadoras oficiales y verificación de las leyes.
4. Cap. 8 y 10: precios y presupuesto, cuando el equipo los defina.
5. Cap. 9: resultados reales al terminar la implementación.
6. Anexos al final.
