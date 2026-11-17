# INFORME DE ANÁLISIS DE DATOS — TP FINAL
## Comparación del mercado laboral e ingresos: Gran Córdoba vs. Gran Rosario (2016–2025)

**Materia:** Introducción al Análisis de Datos — UTN Avellaneda  
**Tipo:** Segundo Parcial (Trabajo Grupal)  
**Aglomerados comparados:** Gran Córdoba (3) vs. Gran Rosario (4)  
**Período:** 2016–2025 (microdatos EPH, INDEC)  
**Fuentes:** EPH (INDEC), serie IPC (INDEC, región Pampeana)

---

## 1. Introducción y contexto socioeconómico

La Encuesta Permanente de Hogares (EPH) del INDEC es la principal fuente de información sobre mercado laboral e ingresos en Argentina. Este informe analiza la evolución de las tasas laborales (actividad, empleo, desocupación) y los ingresos reales de la población en dos aglomerados urbanos: **Gran Córdoba** y **Gran Rosario**, durante el período 2016–2025.

Se utilizaron microdatos individuales de la EPH, ponderados por el factor de expansión `PONDERA` para representar la población real. Los ingresos de la ocupación principal (`P21`) se deflactaron mediante la serie del IPC (región Pampeana) para obtener ingresos reales (`P21_real`), eliminando el efecto de la inflación.

**Justificación de los aglomerados:** Córdoba y Rosario son dos de los principales centros urbanos del interior argentino, con estructuras productivas distintas (Córdoba con mayor peso industrial y tecnológico; Rosario con mayor peso agroexportador y portuario). Esta comparación permite analizar cómo distintas bases productivas responden a los ciclos económicos.

---

## 2. Análisis univariado y tratamiento de datos

### 2.1 Exploración de datos

| Indicador | Gran Córdoba | Gran Rosario |
|---|---|---|
| Registros (personas) | 43.957 | 71.542 |
| Edad media | 37,7 | 37,1 |
| Ingreso medio real (P21_real > 0) | $9.985 | $9.471 |
| Ingreso mediano real (P21_real > 0) | $8.610 | $8.369 |

### 2.2 No respuesta a ingresos (P21 = 0)

Se detectó una alta proporción de no respuesta en la variable ingresos (`P21 = 0`):

| Aglomerado | % no respuesta (promedio 2016–2025) |
|---|---|
| Gran Córdoba | 58,2% |
| Gran Rosario | 57,0% |

La no respuesta se mantuvo estable a lo largo del período (Córdoba: 59,6% en 2016 → 56,8% en 2025; Rosario: 57,6% → 52,9%), con un leve descenso en los últimos años. Este patrón sugiere un comportamiento **MAR** (Missing At Random), condicionado a variables observadas como edad y nivel educativo.

### 2.3 Detección de outliers

Se aplicó Z-Score sobre `P21_real`. Se detectaron **2.092 valores con |Z| > 3** (ingresos extremos). Estos outliers son **legítimos** (salarios altos de profesionales y directivos) y no se eliminaron; se trataron con medidas robustas (mediana, IQR) en el análisis descriptivo.

### 2.4 Tratamiento de datos
- **Valores inconsistentes** (ej. edad > 100): no se detectaron en el período analizado.
- **Nulos en predictores** (PP3E_TOT, NIVEL_ED): se filtraron para el modelo de regresión.
- **Deflación:** todos los ingresos se convirtieron a valores reales usando el IPC (región Pampeana, base 2016).

---

## 3. Evolución comparativa del mercado laboral

### 3.1 Tasas promedio (2016–2025)

| Indicador | Gran Córdoba | Gran Rosario |
|---|---|---|
| Tasa de Actividad | 46,8% | 48,8% |
| Tasa de Empleo | 43,3% | 44,6% |
| Tasa de Desocupación | 7,57% | 8,70% |

### 3.2 Evolución de la tasa de desocupación (2025, por trimestre)

| Trimestre | Gran Córdoba | Gran Rosario |
|---|---|---|
| T1 2025 | 4,81% | 7,07% |
| T2 2025 | 7,45% | 7,70% |
| T3 2025 | 7,45% | 8,86% |
| T4 2025 | 6,37% | 6,46% |

### 3.3 Interpretación

- **Gran Rosario** presenta sistemáticamente **mayor tasa de desocupación** que Gran Córdoba (8,70% vs 7,57% promedio).
- La **tasa de actividad** es mayor en Rosario (48,8% vs 46,8%), lo que indica una mayor participación laboral.
- En 2025, ambas ciudades muestran una **desaceleración** en el último trimestre (T4), con caída de la desocupación.
- La pandemia (2020) generó un pico de desocupación en ambas ciudades, con recuperación gradual a partir de 2021.

**Gráficos sugeridos para el informe:**
- Línea temporal de las 3 tasas por aglomerado (2016–2025).
- Boxplot de ingresos reales por aglomerado.
- Histograma de P21_real.

---

## 4. Análisis de ingresos reales y brechas demográficas

### 4.1 Evolución de ingresos reales

Los ingresos reales (P21_real) muestran una **tendencia decreciente** en términos de poder de compra a lo largo del período, reflejando el impacto de la inflación. Córdoba mantiene ingresos medios ligeramente superiores a Rosario.

### 4.2 Brechas

- **Brecha de género:** los coeficientes de la regresión muestran que ser mujer (CH04 = 2) se asocia con un ingreso menor (coeficiente negativo significativo, p < 0,001).
- **Nivel educativo:** es la variable con mayor impacto (coeficiente ≈ $55.916 por nivel, p < 0,001). A mayor educación, mayor ingreso.
- **Horas trabajadas:** cada hora adicional se asocia con un aumento de ≈ $2.502 en el ingreso (p < 0,001).
- **Edad:** relación positiva (coeficiente ≈ $2.378 por año, p < 0,001), indicando que la experiencia laboral aumenta los ingresos.

### 4.3 Correlación
- **Pearson** entre horas e ingresos: positiva y significativa.
- **Spearman** (robusto a outliers): también positiva, confirmando la relación.

---

## 5. Modelo estadístico de imputación de ingresos

### 5.1 Especificación

Se entrenó una **regresión lineal múltiple ponderada** sobre ocupados con ingreso declarado (P21 > 0):

$$P21 \sim PP3E\_TOT + CH06 + NIVEL\_ED + CH04 + factor(AGLOMERADO)$$

con `weights = PONDERA`.

### 5.2 Resultados

| Variable | Coeficiente | p-valor | Significativo |
|---|---|---|---|
| Intercepto | -63.762 | 0,0001 | *** |
| PP3E_TOT (horas) | 2.502 | < 0,001 | *** |
| CH06 (edad) | 2.378 | < 0,001 | *** |
| NIVEL_ED | 55.916 | < 0,001 | *** |
| CH04 (sexo) | -88.486 | < 0,001 | *** |
| factor(AGLOMERADO)4 | -2.630 | 0,706 | No |

**R² = 0,042** (modelo básico) → **R² = 0,075** (modelo mejorado con interacciones).

### 5.3 Evaluación del rendimiento

El R² no alcanza el umbral de 0,3 exigido por la consigna. Se probaron modelos alternativos:
- **Modelo completo** (con factor(TRIMESTRE) e interacciones): R² = 0,080.
- **Segmentado por aglomerado:** Córdoba R² = 0,111; Rosario R² = 0,077.
- **Árbol de decisión (rpart):** xerror ≈ 0,97 (R² ≈ 0,03).

**Justificación:** la EPH presenta alta heterogeneidad (informalidad, horas no declaradas, subreporte). El profe en clase 8 estableció que el R² debe calcularse **sin transformar la variable original** (P21), por lo que no se aplicaron transformaciones (log, sqrt) para inflar el ajuste. El modelo es **explicativo**, no predictivo perfecto.

### 5.4 Imputación de no respuesta

Se imputaron los valores de P21 = 0 usando las predicciones del modelo:

| Métrica | Valor |
|---|---|
| Media original (P21 > 0) | $192.007 |
| Media imputada | $136.928 |
| Mediana imputada | $17.000 |

La imputación reduce la media porque los casos imputados (mayoritariamente de bajos ingresos) tienen predicciones menores al promedio de los declarados.

---

## 6. Conclusiones y recomendaciones de política pública

1. **Mercado laboral:** Gran Rosario presenta mayor tasa de desocupación que Gran Córdoba (8,70% vs 7,57%), aunque también mayor participación laboral. Ambas ciudades mostraron recuperación gradual post-pandemia.

2. **Ingresos:** Córdoba mantiene ingresos reales medios superiores a Rosario ($9.985 vs $9.471). La brecha de género es significativa: las mujeres ganan menos, ceteris paribus.

3. **Educación:** el nivel educativo es el principal determinante del ingreso (coeficiente ≈ $55.916 por nivel). Políticas de educación y capacitación son clave para reducir la desigualdad.

4. **No respuesta:** el 57% de los registros no declaran ingresos. Se imputó con regresión ponderada, mejorando la representatividad.

5. **Recomendaciones:**
   - Fortalecer políticas de formalización laboral (reduce la no respuesta).
   - Invertir en educación y capacitación (mayor impacto en ingresos).
   - Monitorear la evolución de la desocupación por aglomerado (Rosario requiere atención).

---

## Anexo: Variables utilizadas

| Variable | Descripción |
|---|---|
| AGLOMERADO | 3 = Gran Córdoba, 4 = Gran Rosario |
| ANO4 / TRIMESTRE | Año y trimestre de la encuesta |
| PONDERA | Factor de expansión (peso muestral) |
| ESTADO | 1 = Ocupado, 2 = Desocupado, 3 = Inactivo |
| P21 | Ingreso de la ocupación principal |
| P21_real | Ingreso real (deflactado por IPC) |
| CH04 | Sexo (1 = varón, 2 = mujer) |
| CH06 | Edad |
| NIVEL_ED | Nivel educativo |
| PP3E_TOT | Horas trabajadas |
| PP04B_COD | Características del empleo |

---

*Informe generado a partir de microdatos EPH (INDEC) y serie IPC (INDEC, región Pampeana). Periodo analizado: 2016–2025.*
PY