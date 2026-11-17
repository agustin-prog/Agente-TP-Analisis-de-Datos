# GUÍA COMPLETA DEL TP FINAL — Introducción al Análisis de Datos (UTN Avellaneda)

> Objetivo: que entiendas **qué se pide, por qué se pide, cómo hacerlo y cómo defenderlo**.
> Estilo: teoría formal + explicación "criolla".

---

## 0. Resumen ejecutivo (para no perderse)

- **Qué:** informe de 6–10 páginas analizando evolución de tasas laborales e ingresos en 2 aglomerados (2016–2026).
- **Con qué:** microdatos EPH (INDEC) + R (tidyverse, eph).
- **Para aprobar No Directa (4–5):** univariado + multivariado + gráficos.
- **Para Directa (6–10):** además, modelo de regresión para imputar no respuesta a ingresos (R² > 0,3).
- **Clave:** todo ponderado por PONDERA; ingresos deflactados por IPC.

---

## 1. Conceptos base (teoría + criollo)

### 1.1 EPH y microdatos
- **Formal:** la EPH es una encuesta muestral de hogares del INDEC. Los microdatos son registros individuales (persona).
- **Criollo:** no tenés datos de todos los argentinos, tenés una "muestra" representativa. Por eso cada persona viene con un "peso" (PONDERA) que dice cuántas personas reales representa.

### 1.2 PONDERA (factor de expansión)
- **Formal:** peso muestral que expande la muestra a la población.
- **Criollo:** si una persona tiene PONDERA=1000, "vale" por 1000 personas reales. Si sumás PONDERA, obtenés la población total estimada.

### 1.3 Tasas laborales
- **PEA:** Población Económicamente Activa = ocupados + desocupados.
- **Tasa de Actividad** = PEA / Población Total × 100. (¿cuántos trabajan o buscan?)
- **Tasa de Empleo** = Ocupados / Población Total × 100. (¿cuántos tienen trabajo?)
- **Tasa de Desocupación** = Desocupados / PEA × 100. (¿cuántos buscan y no encuentran?)
- **Criollo:** la desocupación puede bajar porque la gente se "rinde" y deja de buscar (inactivos), no porque consiga trabajo. Por eso mirar las 3 juntas.

### 1.4 Deflación de ingresos (IPC)
- **Formal:** los ingresos nominales se dividen por el índice de precios para obtener ingresos reales.
- **Criollo:** si te pagan 100 pesos en 2016 y 200 en 2026, no ganás el doble: la inflación se comió la mitad. P21_real te dice el poder de compra real.

### 1.5 No respuesta (NAs en P21)
- **Formal:** valores faltantes en la variable ingresos. Patrones: MCAR (al azar), MAR (condicionado a observables), MNAR (condicionado al valor mismo).
- **Criollo:** hay gente que no declara ingresos (por miedo, desconfianza, o porque son muy altos). Hay que detectarlo y, si querés nota alta, imputarlo con un modelo.

### 1.6 Outliers
- **Formal:** valores atípicos. Inconsistentes (edad 250) → eliminar. Legítimos (salarios altos) → no borrar; usar medidas robustas (mediana, IQR) o transformaciones (Z-Score).
- **Criollo:** no borres a los millonarios del dataset solo porque son "raros": son parte de la realidad.

### 1.7 Z-Score
- Z = (X − media) / desvío estándar. |Z| > 3 → outlier sospechoso.

### 1.8 Correlación
- **Pearson:** sensible a outliers (usa valores).
- **Spearman:** robusto (usa rangos/posiciones).
- **Criollo:** Pearson se "asusta" con un millonario; Spearman no.

### 1.9 Regresión lineal múltiple
- **Formal:** modela Y (ingreso) como función lineal de X (horas, edad, educación, sexo, aglomerado), con pesos.
- **Criollo:** "si trabajás más horas, tu ingreso sube X pesos, manteniendo todo lo demás igual".
- **R²:** proporción de varianza explicada. >0,3 = aceptable en microdatos de ingresos.

---

## 2. Variables de la EPH que usarás

| Variable | Qué es |
|---|---|
| AGLOMERADO | Código de ciudad (3=Córdoba, 4=Rosario) |
| ANO / TRIMESTRE | Año y trimestre |
| PONDERA | Peso muestral |
| ESTADO | 1=ocupado, 2=desocupado, 3=inactivo |
| P21 | Ingreso ocupación principal (puede ser 0/NA) |
| CH04 | Sexo (1=varón, 2=mujer) |
| CH06 | Edad |
| NIVEL_ED | Nivel educativo |
| PP04B_COD / PP04D_COD | Características del empleo |
| PP3E_TOT | Horas trabajadas |

---

## 3. Pasos detallados con código R

### Paso 1: Instalar y cargar librerías
```r
install.packages(c("tidyverse","eph"))
library(tidyverse)
library(eph)
```

### Paso 2: Descargar microdatos EPH
```r
eph_completa <- get_microdata(year = 2016:2026, trimester = 1:4, type = 'individual')
```
**Por qué:** baja todos los microdatos individuales del período. Tarda un poco.

### Paso 3: Filtrar aglomerados y recodificar sexo
```r
eph_filtrada <- eph_completa %>%
  filter(AGLOMERADO %in% c(3, 4)) %>%
  mutate(
    Nombre_Aglomerado = if_else(AGLOMERADO == 3, 'Gran Córdoba', 'Gran Rosario'),
    Sexo = if_else(CH04 == 1, 'Varón', 'Mujer')
  )
```
**Por qué:** solo nos interesan Córdoba y Rosario; recodificar hace los gráficos legibles.

### Paso 4: Deflactar ingresos con IPC
```r
ipc <- get_ipc_series()
eph_procesada <- eph_filtrada %>%
  left_join(ipc, by = c('year' = 'ANO', 'trimester' = 'TRIMESTRE')) %>%
  mutate(P21_real = P21 / (periodo / 100))
```
**Por qué:** convierte ingresos nominales a reales (poder de compra).

### Paso 5: Calcular tasas laborales ponderadas
```r
tasas_laborales <- eph_procesada %>%
  group_by(year, trimester, Nombre_Aglomerado) %>%
  summarise(
    Poblacion_Total = sum(PONDERA, na.rm = TRUE),
    Ocupados = sum(PONDERA[ESTADO == 1], na.rm = TRUE),
    Desocupados = sum(PONDERA[ESTADO == 2], na.rm = TRUE),
    PEA = Ocupados + Desocupados,
    Tasa_Actividad = (PEA / Poblacion_Total) * 100,
    Tasa_Empleo = (Ocupados / Poblacion_Total) * 100,
    Tasa_Desocupacion = (Desocupados / PEA) * 100,
    .groups = 'drop'
  )
```
**Por qué:** ponderado por PONDERA para representar la población real.

### Paso 6: Análisis univariado (exploración, NAs, outliers)
```r
# NAs en P21
eph_procesada %>% summarise(na_p21 = sum(is.na(P21)), pct = mean(is.na(P21))*100)

# Z-Score de P21
eph_procesada <- eph_procesada %>%
  mutate(z_p21 = (P21 - mean(P21, na.rm=TRUE)) / sd(P21, na.rm=TRUE))

# Boxplot
ggplot(eph_procesada, aes(x = Nombre_Aglomerado, y = P21_real)) +
  geom_boxplot()
```
**Por qué:** detectar no respuesta y outliers; boxplot muestra cuartiles y puntos atípicos.

### Paso 7: Análisis multivariado y gráficos
```r
# Evolución de tasas
ggplot(tasas_laborales, aes(x = year, y = Tasa_Desocupacion, color = Nombre_Aglomerado)) +
  geom_line() + geom_point()

# Ingresos por nivel educativo
ggplot(eph_procesada, aes(x = factor(NIVEL_ED), y = P21_real)) +
  geom_boxplot()
```
**Por qué:** comparar Córdoba vs Rosario a lo largo del tiempo y por grupos.

### Paso 8: Modelo de regresión para imputación
```r
datos_modelo <- eph_procesada %>%
  filter(ESTADO == 1, P21 > 0, !is.na(PP3E_TOT), !is.na(NIVEL_ED))

modelo_ingresos <- lm(
  P21 ~ PP3E_TOT + CH06 + NIVEL_ED + CH04 + factor(AGLOMERADO),
  data = datos_modelo,
  weights = PONDERA
)
summary(modelo_ingresos)
```
**Por qué:** imputa ingresos faltantes usando predictores; ponderado para representatividad.

### Paso 9: Imputar NAs
```r
# Predecir donde P21 es NA
eph_procesada <- eph_procesada %>%
  mutate(P21_imputado = if_else(is.na(P21) | P21 == 0,
                                predict(modelo_ingresos, newdata = .),
                                P21))
```

---

## 4. Estructura del informe (6–10 págs)

1. Introducción y contexto socioeconómico.
2. Análisis univariado y tratamiento de datos.
3. Evolución comparativa del mercado laboral.
4. Ingresos reales y brechas demográficas.
5. Modelo estadístico de imputación.
6. Conclusiones y recomendaciones.

---

## 5. Checklist de trabajo

- [ ] Definir aglomerados
- [ ] Descargar datos
- [ ] Limpiar y procesar
- [ ] Calcular tasas
- [ ] Análisis univariado + outliers + NAs
- [ ] Análisis multivariado + gráficos
- [ ] Modelo de regresión (R² > 0,3)
- [ ] Imputación
- [ ] Redactar informe
- [ ] Preparar defensa

---

## 6. Preguntas de defensa (con respuesta criolla)

1. **¿Por qué ponderar?** → Porque la EPH es muestra; PONDERA expande a población.
2. **¿Por qué no borrar outliers?** → Son reales (millonarios); se usan medidas robustas.
3. **¿Qué es R² > 0,3?** → El modelo explica >30% de la varianza; aceptable en ingresos.
4. **¿Cómo interpretás un coeficiente?** → "Manteniendo todo igual, X cambia Y en β".
5. **¿Por qué la desocupación baja pero no mejora el empleo?** → Desaliento (inactividad).
6. **¿Cómo trataste la no respuesta?** → Detecté NAs, analicé patrón, imputé con regresión.

---

## 7. Errores comunes

- No ponderar → resultados inválidos.
- Borrar todos los outliers → pierdes realidad.
- Ingresos nominales sin deflactar → conclusión falsa.
- Ignorar NAs → sesgo.
- Modelo sin evaluación → no cumple Directa.
- Sin gráficos/tablas → no cumple requisitos.

---

## 8. Recursos en tu carpeta

- `manual_maestro_tp_final_y_teoria_completa.docx` → teoría + script R + prompt IA.
- `TP final.pdf` → enunciado oficial.
- `tp_final.R` → script base (ver archivo adjunto).

---

*Fin de la guía. ¡Éxitos con el TP!*
PY