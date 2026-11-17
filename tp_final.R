# ==============================================================================
# SCRIPT BASE PARA TP FINAL - RSTUDIO
# Aglomerados: Gran Córdoba (3) vs Gran Rosario (4)
# Materia: Introducción al Análisis de Datos - UTN Avellaneda
# ==============================================================================

# 1. Cargar librerías
library(tidyverse)
library(eph)

vars_need <- c("ANO","TRIMESTRE","AGLOMERADO","PONDERA","ESTADO","P21",
               "CH04","CH06","NIVEL_ED","PP04B_COD","PP04D_COD","PP3E_TOT")

anios <- 2016:2026   # 2026 aún no completo; ajustá si querés incluir lo disponible
trims <- 1:4

eph_list <- list()

for (a in anios) {
  for (t in trims) {
    cat("Descargando", a, "T", t, "\n")
    res <- tryCatch(
      get_microdata(year = a, trimester = t, type = "individual"),
      error = function(e) NULL
    )
    if (is.null(res)) {
      cat("   -> no disponible, se salta\n")
      next
    }
    # Filtrar aglomerados YA para no acumular basura
    res <- res %>% filter(AGLOMERADO %in% c(3, 4))
    eph_list[[length(eph_list) + 1]] <- res
    rm(res); gc()   # liberar memoria
  }
}

eph_completa <- bind_rows(eph_list)
rm(eph_list); gc()

# Recodificar
eph_filtrada <- eph_completa %>%
  mutate(
    Nombre_Aglomerado = if_else(AGLOMERADO == 3, 'Gran Córdoba', 'Gran Rosario'),
    Sexo = if_else(CH04 == 1, 'Varón', 'Mujer')
  )

# 4. Deflación de ingresos (P21) mediante serie IPC
ipc <- get_ipc_series()
eph_procesada <- eph_filtrada %>%
  left_join(ipc, by = c('year' = 'ANO', 'trimester' = 'TRIMESTRE')) %>%
  mutate(P21_real = P21 / (periodo / 100))

# 5. Cálculo de tasas laborales ponderadas por PONDERA
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

# 6. Análisis univariado: NAs y Z-Score
eph_procesada <- eph_procesada %>%
  mutate(z_p21 = (P21 - mean(P21, na.rm = TRUE)) / sd(P21, na.rm = TRUE))

# 7. Gráficos
# Evolución de tasas
ggplot(tasas_laborales, aes(x = year, y = Tasa_Desocupacion, color = Nombre_Aglomerado)) +
  geom_line() + geom_point() + theme_minimal() +
  labs(title = "Tasa de Desocupación", x = "Año", y = "%")

# Boxplot ingresos por aglomerado
ggplot(eph_procesada, aes(x = Nombre_Aglomerado, y = P21_real)) +
  geom_boxplot() + theme_minimal()

# 8. Modelo de regresión ponderado para imputación
datos_modelo <- eph_procesada %>%
  filter(ESTADO == 1, P21 > 0, !is.na(PP3E_TOT), !is.na(NIVEL_ED))

modelo_ingresos <- lm(
  P21 ~ PP3E_TOT + CH06 + NIVEL_ED + CH04 + factor(AGLOMERADO),
  data = datos_modelo,
  weights = PONDERA
)
summary(modelo_ingresos)

# 9. Imputación de no respuesta
eph_procesada <- eph_procesada %>%
  mutate(P21_imputado = if_else(is.na(P21) | P21 == 0,
                                predict(modelo_ingresos, newdata = .),
                                P21))
PY