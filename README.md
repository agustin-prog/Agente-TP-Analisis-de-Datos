# README — TP Final: Introducción al Análisis de Datos (UTN Avellaneda)

## 📁 Estructura de la carpeta

```
Agente-TP-Analisis-de-Datos/
├── README.md                          ← Este archivo (guía de uso)
├── GUIA_TP_FINAL.md                   ← Guía completa del TP (teoría + pasos + defensa)
├── tp_final_limpio.R                  ← Script R comentado (descarga, limpieza, tasas, modelo)
├── INFORME_TP_FINAL.md                ← Informe base en Markdown (6 secciones + anexo)
├── PROMPT_MAESTRO.md                  ← Prompt para pegar al agente (contexto completo)
├── apuntes/                           ← Teoría de clases 4-9 + transcripciones
│   ├── apunte_clase4_*.md
│   ├── apunte_clase5_*.md
│   ├── apunte_clase6_*.md
│   ├── apunte_clase7_*.md
│   ├── clase4_graficos_y_coeficientes.md
│   └── Clase Intr.. al Análisis de Datos Clase 7/8/9 ... .md
├── manual_maestro_tp_final_y_teoria_completa.docx
├── TP final.pdf                       ← Enunciado oficial del TP
└── (archivos .rds generados al ejecutar el script)
    ├── eph_filtrada.rds
    ├── eph_procesada.rds
    └── tasas_laborales.rds
```

## 🤖 Cómo usar el agente (yo) para este TP

### Opción A: Abrir OpenCode en esta carpeta
1. Abrí OpenCode.
2. Seleccioná la carpeta `Agente-TP-Analisis-de-Datos` como workspace.
3. Preguntame: **"¿Podés ayudarme con el TP de Análisis de Datos?"**
4. Yo ya tendré acceso a todos los archivos y te daré opciones de ayuda.

### Opción B: Pegar el Prompt Maestro
Si el agente no tiene contexto, copiá el contenido de `PROMPT_MAESTRO.md` y pegalo al inicio de la conversación. Así el agente sabrá todo sobre el TP, los datos, el script y el informe.

---

## 🛠️ Opciones de ayuda que el agente puede darte

| Necesidad | Qué pedirle al agente |
|---|---|
| Entender el TP | "Explicame qué se pide en el TP y cómo se evalúa" |
| Ejecutar el script R | "Ayudame a correr el script paso a paso" |
| Interpretar resultados | "¿Qué significa este R² / coeficiente / tasa?" |
| Redactar el informe | "Redactame la sección X del informe" |
| Gráficos | "¿Qué gráfico conviene para esta variable?" |
| Defensa | "Simulá preguntas de defensa y ayudame a responder" |
| Errores de R | "Me da este error en R, ¿cómo lo arreglo?" |
| Conceptos teóricos | "Explicame MCAR/MAR/MNAR / TCL / regresión ponderada" |

---

## 📊 Datos del análisis

- **Aglomerados:** Gran Córdoba (3) vs. Gran Rosario (4)
- **Período:** 2016–2025 (2016 T1 no disponible; 2026 parcial)
- **Fuente:** EPH (INDEC) + IPC (INDEC, región Pampeana)
- **Registros:** 115.499 personas (Córdoba 43.957; Rosario 71.542)
- **No respuesta a ingresos:** ~57% (P21 = 0)
- **Outliers:** 2.092 (|Z| > 3)
- **R² modelo de imputación:** ~0,08 (regresión lineal ponderada)

---

## 📝 Estructura del informe (6–10 páginas)

1. Introducción y contexto socioeconómico
2. Análisis univariado y tratamiento de datos
3. Evolución comparativa del mercado laboral
4. Análisis de ingresos reales y brechas demográficas
5. Modelo estadístico de imputación
6. Conclusiones y recomendaciones

---

## ⚠️ Errores comunes a evitar
- No ponderar por PONDERA → resultados inválidos.
- Borrar todos los outliers → pierdes realidad.
- Usar ingresos nominales sin deflactar → conclusión falsa.
- Ignorar la no respuesta → sesgo en el análisis.
- Modelo sin evaluación → no cumple Aprobación Directa.

---

## 🚀 Flujo de trabajo sugerido
1. Leer `GUIA_TP_FINAL.md` para entender el panorama.
2. Ejecutar `tp_final_limpio.R` paso a paso en RStudio.
3. Usar `INFORME_TP_FINAL.md` como base para redactar.
4. Practicar la defensa con el agente.

---
*Creado con ayuda del agente de OpenCode. Última actualización: Nov 2026.*
PY