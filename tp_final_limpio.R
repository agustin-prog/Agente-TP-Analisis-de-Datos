# ==============================================================================
# TP FINAL - INTRODUCCION AL ANALISIS DE DATOS (UTN Avellaneda)
# Aglomerados: Gran Córdoba (3) vs Gran Rosario (4)
# Periodo: 2016-2025 (2016 T1 no disponible; 2026 parcial)
# ==============================================================================
# Este script está comentado paso a paso para que puedas reutilizarlo.
# Cada bloque tiene: qué hace, por qué se hace, y qué variable produce.
# ==============================================================================

# ------------------------------------------------------------------------------
# 0. LIBRERÍAS
# ------------------------------------------------------------------------------
library(tidyverse)   # dplyr, ggplot2, tidyr, etc.
library(eph)         # Descarga de microdatos EPH (INDEC)
library(ggplot2)     # Gráficos

# ------------------------------------------------------------------------------
# 1. DESCARGA DE MICRODATOS EPH (por chunks para no romper la memoria)
# ------------------------------------------------------------------------------
# Por qué chunks: descargar 2016-2025 de una vez genera un objeto gigante en RAM.
# Solución: descargar año por año, filtrar aglomerados al instante, acumular.

anios <- 2016:2025
trims <- 1:4
eph_list <- list()

for (a in anios) {
  for (t in trims) {
    cat("Descargando", a, "T", t, "\n")
    res <- tryCatch(
      get_microdata(year = a, trimester = t, type = "individual"),
      error = function(e) NULL
    )
    # Validar que el resultado sea usable (no NULL, con columna AGLOMERADO)
    if (is.null(res) || !is.data.frame(res) ||
        !("AGLOMERADO" %in% names(res)) || nrow(res) == 0) {
      cat("   -> no disponible o inválido, se salta\n")
      next
    }
    # Filtrar aglomerados YA para no acumular basura en memoria
    res <- res %>% filter(AGLOMERADO %in% c(3, 4))
    eph_list[[length(eph_list) + 1]] <- res
    rm(res); gc()   # liberar memoria
  }
}

eph_completa <- bind_rows(eph_list)
rm(eph_list); gc()

# ------------------------------------------------------------------------------
# 2. RECODIFICACIÓN DE VARIABLES
# ------------------------------------------------------------------------------
# AGLOMERADO -> nombre legible; CH04 -> Sexo
eph_filtrada <- eph_completa %>%
  mutate(
    Nombre_Aglomerado = if_else(AGLOMERADO == 3, 'Gran Córdoba', 'Gran Rosario'),
    Sexo = if_else(CH04 == 1, 'Varón', 'Mujer')
  )

# Guardar para no re-descargar
saveRDS(eph_filtrada, "eph_filtrada.rds")

# ------------------------------------------------------------------------------
# 3. LECTURA Y PREPARACIÓN DEL IPC (serie del INDEC, CSV)
# ------------------------------------------------------------------------------
# El CSV tiene: Descripcion, Periodo (YYYYMM), Indice_IPC, Region, etc.
# Filtramos Nivel General + región Pampeana (cubre Córdoba y Rosario).
ipc_raw <- read.csv("serie_ipc_divisiones.csv", sep = ";", dec = ",",
                    stringsAsFactors = FALSE, fileEncoding = "latin1")

ipc <- ipc_raw %>%
  filter(Descripcion == "NIVEL GENERAL", Region == "Pampeana") %>%
  mutate(
    ANO = as.integer(substr(Periodo, 1, 4)),
    MES = as.integer(substr(Periodo, 5, 6)),
    TRIMESTRE = (MES - 1) %/% 3 + 1
  ) %>%
  filter(MES %in% c(3, 6, 9, 12)) %>%   # último mes de cada trimestre
  select(ANO, TRIMESTRE, periodo = Indice_IPC)

# ------------------------------------------------------------------------------
# 4. UNIÓN CON IPC Y CÁLCULO DE INGRESO REAL
# ------------------------------------------------------------------------------
eph_procesada <- eph_filtrada %>%
  left_join(ipc, by = c('ANO4' = 'ANO', 'TRIMESTRE' = 'TRIMESTRE'))

# Completar IPC faltante (2016 T2-T3) con forward+backward fill
eph_procesada <- eph_procesada %>%
  arrange(ANO4, TRIMESTRE) %>%
  group_by(Nombre_Aglomerado) %>%
  fill(periodo, .direction = "downup") %>%
  ungroup() %>%
  mutate(P21_real = P21 / (periodo / 100))

saveRDS(eph_procesada, "eph_procesada.rds")

# ------------------------------------------------------------------------------
# 5. CÁLCULO DE TASAS LABORALES PONDERADAS POR PONDERA
# ------------------------------------------------------------------------------
# Población Total = suma de PONDERA
# Ocupados = suma PONDERA donde ESTADO==1
# Desocupados = suma PONDERA donde ESTADO==2
# PEA = Ocupados + Desocupados
# Tasas = (componente / base) * 100
tasas_laborales <- eph_procesada %>%
  group_by(ANO4, TRIMESTRE, Nombre_Aglomerado) %>%
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
saveRDS(tasas_laborales, "tasas_laborales.rds")

# ------------------------------------------------------------------------------
# 6. ANÁLISIS UNIVARIADO
# ------------------------------------------------------------------------------
# 6.1 Exploración por aglomerado
eph_procesada %>%
  group_by(Nombre_Aglomerado) %>%
  summarise(
    n = n(),
    edad_media = mean(CH06, na.rm = TRUE),
    ingreso_medio = mean(P21_real[P21_real > 0], na.rm = TRUE),
    ingreso_mediana = median(P21_real[P21_real > 0], na.rm = TRUE)
  )

# 6.2 No respuesta a ingresos (P21 == 0) por aglomerado y año
no_respuesta <- eph_procesada %>%
  group_by(ANO4, Nombre_Aglomerado) %>%
  summarise(
    total = n(),
    ceros = sum(P21 == 0),
    pct_ceros = round(mean(P21 == 0) * 100, 2),
    .groups = 'drop'
  )

# 6.3 Outliers con Z-Score (|Z| > 3)
eph_procesada <- eph_procesada %>%
  mutate(z_p21 = (P21_real - mean(P21_real, na.rm = TRUE)) /
                  sd(P21_real, na.rm = TRUE))
outliers <- eph_procesada %>% summarise(n = sum(abs(z_p21) > 3, na.rm = TRUE))

# 6.4 Gráficos
# Boxplot ingresos por aglomerado
ggplot(eph_procesada %>% filter(P21_real > 0),
       aes(x = Nombre_Aglomerado, y = P21_real)) +
  geom_boxplot() + labs(title = "Ingresos reales por aglomerado")

# Boxplot por nivel educativo
ggplot(eph_procesada %>% filter(P21_real > 0),
       aes(x = factor(NIVEL_ED), y = P21_real)) +
  geom_boxplot() + labs(title = "Ingresos reales por nivel educativo")

# Histograma
ggplot(eph_procesada %>% filter(P21_real > 0), aes(x = P21_real)) +
  geom_histogram(bins = 50) + labs(title = "Distribución de ingresos reales")

# ------------------------------------------------------------------------------
# 7. MODELO DE REGRESIÓN PARA IMPUTACIÓN DE NO RESPUESTA
# ------------------------------------------------------------------------------
# Filtrar ocupados con ingreso declarado y sin NA en predictores
datos_modelo <- eph_procesada %>%
  filter(ESTADO == 1, P21 > 0, !is.na(PP3E_TOT), !is.na(NIVEL_ED))

# Regresión lineal ponderada
modelo_ingresos <- lm(
  P21 ~ PP3E_TOT + CH06 + NIVEL_ED + CH04 + factor(AGLOMERADO),
  data = datos_modelo,
  weights = PONDERA
)
summary(modelo_ingresos)
r2 <- summary(modelo_ingresos)$r.squared

# Modelo mejorado (más variables e interacciones)
datos_modelo2 <- eph_procesada %>%
  filter(ESTADO == 1, P21 > 0,
         !is.na(PP3E_TOT), !is.na(NIVEL_ED), !is.na(PP04B_COD))

modelo_mejorado <- lm(
  P21 ~ PP3E_TOT + I(CH06^2) + factor(NIVEL_ED) + CH04 +
    factor(AGLOMERADO) + factor(PP04B_COD) +
    CH04:factor(NIVEL_ED),
  data = datos_modelo2,
  weights = PONDERA
)

# Imputación: reemplazar P21 == 0 con predicción del modelo
eph_procesada <- eph_procesada %>%
  mutate(
    P21_imputado = if_else(
      P21 == 0 | is.na(P21),
      predict(modelo_ingresos, newdata = .),
      P21
    )
  )

# Comparar antes/después
eph_procesada %>%
  summarise(
    media_original = mean(P21[P21 > 0], na.rm = TRUE),
    media_imputada = mean(P21_imputado, na.rm = TRUE),
    mediana_imputada = median(P21_imputado, na.rm = TRUE)
  )

# ------------------------------------------------------------------------------
# 8. GRÁFICOS COMPARATIVOS (MULTIVARIADO)
# ------------------------------------------------------------------------------
# Evolución de tasas de desocupación
ggplot(tasas_laborales, aes(x = ANO4, y = Tasa_Desocupacion,
                            color = Nombre_Aglomerado)) +
  geom_line() + geom_point() +
  labs(title = "Tasa de Desocupación por aglomerado",
       x = "Año", y = "%")

# Evolución de tasas de empleo
ggplot(tasas_laborales, aes(x = ANO4, y = Tasa_Empleo,
                            color = Nombre_Aglomerado)) +
  geom_line() + geom_point() +
  labs(title = "Tasa de Empleo por aglomerado",
       x = "Año", y = "%")

# ==============================================================================
# FIN DEL SCRIPT
# ==============================================================================
PY