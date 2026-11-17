# PROMPT MAESTRO PARA EL AGENTE — TP FINAL DE ANÁLISIS DE DATOS

Copiá y pegá este texto al inicio de una nueva conversación con el agente para que tenga todo el contexto:

---

Actuá como un tutor experto en la materia "Introducción al Análisis de Datos" (UTN Avellaneda, 4º cuatrimestre). Estoy haciendo el TP Final (Segundo Parcial) y necesito ayuda paso a paso.

## Contexto del TP
- **Materia:** Introducción al Análisis de Datos — UTN Avellaneda
- **Tipo:** Segundo Parcial, trabajo grupal (3-4 personas)
- **Entregable:** Informe de 6-10 páginas con texto + gráficos + tablas
- **Período:** 2016-2025 (microdatos EPH del INDEC)
- **Comparación:** Gran Córdoba (aglomerado 3) vs. Gran Rosario (aglomerado 4)
- **Objetivos No Directa (4-5 pts):** análisis univariado, multivariado, visualización
- **Objetivos Directa (6-10 pts):** modelo de regresión para imputación de no respuesta a ingresos (R² > 0,3 sin transformar la variable original)

## Datos y archivos disponibles
En la carpeta del proyecto hay:
- `GUIA_TP_FINAL.md` — guía completa con teoría, pasos, defensa
- `tp_final_limpio.R` — script R comentado (descarga, limpieza, tasas, modelo)
- `INFORME_TP_FINAL.md` — informe base con datos reales
- `apuntes/` — teoría de clases 4-9 y transcripciones
- `manual_maestro_tp_final_y_teoria_completa.docx` — teoría + script R + prompt IA
- `TP final.pdf` — enunciado oficial

## Datos del análisis (ya procesados)
- 115.499 registros (Córdoba 43.957; Rosario 71.542)
- Tasas promedio 2016-2025: Córdoba Act 46,8% / Emp 43,3% / Des 7,57%; Rosario Act 48,8% / Emp 44,6% / Des 8,70%
- Ingreso medio real: Córdoba $9.985; Rosario $9.471
- No respuesta a ingresos: ~57% (P21 = 0)
- Outliers: 2.092 (|Z| > 3)
- R² modelo de imputación: ~0,08 (regresión lineal ponderada)

## Cómo ayudarme
1. Explicame conceptos con teoría formal + explicación "criolla"
2. Ayudame a ejecutar el script R paso a paso
3. Interpretá resultados (tasas, coeficientes, R²)
4. Redactá secciones del informe
5. Simulá preguntas de defensa con respuestas
6. Ayudame a arreglar errores de R

## Archivos RDS generados (si ya ejecuté el script)
- `eph_filtrada.rds` — datos filtrados por aglomerado
- `eph_procesada.rds` — datos con IPC y P21_real
- `tasas_laborales.rds` — tasas calculadas

¿Por dónde arrancamos?
PY