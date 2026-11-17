# apunte_clase4_exploratorio_y_estadistica

APUNTE COMPLETO DE ESTUDIO — CLASE 4
Análisis Exploratorio de Datos y Estadística Descriptiva
Cátedra: Introducción al Análisis de Datos (UTN Avellaneda) | Prof. Luis Nahuel Fernández
Basado en la Transcripción Completa de Clase, Presentaciones Teóricas y Libro AID 2022
📌 CELEBRACIÓN Y OBJETIVO DE ESTE MATERIAL:
¡Felicitaciones por haber aprobado el primer examen! Este apunte retoma el estudio profundo para la segunda etapa del curso. Contiene todo lo trabajado en la Clase 4: Análisis Univariado, Bivariado y Multivariado, Análisis de Frecuencias, Medidas de Tendencia Central, Posición y Dispersión, Coeficientes de Asimetría, Curtosis, Covarianza y Correlación (Pearson vs. Spearman).
Módulo 1: Contexto del EDA y Análisis de Frecuencias
El Análisis Exploratorio de Datos (EDA - Exploratory Data Analysis) es la etapa inmediatamente posterior al Data Cleaning (Limpieza de Datos). Mientras que en la limpieza se corrigen inconsistencias y nulos gruesos, el EDA es el proceso donde el analista explora la estructura interna del dataset para construir un relato conceptual, encontrar patrones y entender la distribución de las variables.
1.1 ¿Qué es el Análisis de Frecuencias?
En términos sencillos, hacer un análisis de frecuencia es contar cuantas veces aparece una categoría o rango dentro de una variable. No requiere operaciones matemáticas sofisticadas, pero es el primer abordaje fundamental que realiza todo analista de datos.
Variables Categóricas (Cualitativas): Se realiza un conteo simple de la cantidad de veces que se repite cada categoría (frecuencia absoluta) y el porcentaje correspondiente respecto del total (frecuencia relativa o porcentual). Ejemplo en el dataset de League of Legends visto en clase: el 28.5% de los personajes son 'Luchadores', el 21.5% 'Magos', etc.
Variables Cuantitativas Continuas: Dado que las variables continuas poseen infinitos valores posibles, no es práctico contar valor por valor. Por ello, se agrupan los datos en intervalos o rangos (cortes) y se cuenta cuántos registros caen en cada intervalo. Ejemplo: agrupar la edad en rangos de '0 a 16 años', '17 a 35 años', '36 a 50 años', etc.
--- TABLA ---
💡 Tip Fijo de Parcial del Profesor:
Pregunta típica de examen: ¿Cómo se realiza el análisis de frecuencias para datos cualitativos frente a datos cuantitativos continuos?
Respuesta: En datos cualitativos se hace un conteo directo por cada categoría definida. En datos cuantitativos continuos se realiza una categorización previa creando intervalos o rangos de agrupamiento (cortes) y luego se cuentan los registros dentro de cada rango.
--- FIN TABLA ---

Módulo 2: Medidas de Tendencia Central (Resúmenes Univariados)
Las medidas de tendencia central son resúmenes estadísticos que buscan condensar o sintetizar toda la información de una variable en un único valor representativo. Si un dataset contiene 45.000 filas y 180 columnas, la tabla en sí misma es inabarcable para un ser humano; las medidas de tendencia central permiten resumirla.
2.1 La Media Aritmética, Geométrica y Podada
Media Aritmética (Promedio Clásico): Es la suma de todos los valores dividida por el número total de observaciones. Es extremadamente sensible a valores extremos altos o bajos (outliers). Ejemplo: si 4 personas ganan $100.000 y el CEO gana $50.000.000, el promedio da $10.080.000, distorsionando la realidad de la mayoría.
Media Geométrica: Se calcula multiplicando todos los elementos y extrayendo la raíz enésima del producto. Su gran ventaja es que suaviza el impacto de los valores extremos altos. Se utiliza cuando los valores crecen de forma multiplicativa o exponencial.
Media Podada (Trimmed Mean): Excluye un porcentaje de los valores extremos de ambas puntas del dataset (por ejemplo, descartando el 5% más bajo y el 5% más alto). Permite calcular un promedio limpio de la influencia de los outliers sin eliminar los datos del dataset original.
2.2 La Mediana y la Moda
La Mediana (El Centro Estadístico): Es el valor que ocupa la posición central en un conjunto de datos previamente ordenados de menor a mayor. Divide la distribución en dos partes exactamente iguales: el 50% de las observaciones queda por debajo y el 50% por encima. Su propiedad principal es ser ROBUSTA (no se ve afectada por valores extremos).
La Moda (El Valor Más Frecuente): Es la categoría o valor numérico que más veces se repite en el conjunto de datos. Es la única medida de tendencia central aplicable a variables Categóricas Nominales.
--- TABLA ---
Medida | Definición Sencilla | Aplica a Variables | Resistencia a Outliers
Media | Suma de valores dividida por el número total (N) | Cuantitativas (Discretas y Continuas) | ❌ No resistente (Muy sensible)
Mediana | Valor que ocupa la posición central del 50% | Cuantitativas y Categóricas Ordinales | ✅ Altamente resistente (Robusta)
Moda | El dato que más veces se repite | Todas (Única para Categóricas Nominales) | ✅ Altamente resistente
--- FIN TABLA ---

Módulo 3: Medidas de Posición y Medidas de Dispersión
3.1 Medidas de Posición (Estadísticos de Orden)
Las medidas de posición dividen a un conjunto de datos ordenados en partes porcentualmente iguales. La Mediana cumple un doble rol fundamental: es tanto una medida de tendencia central como una medida de posición (divide en 2 partes iguales).
Cuartiles (Q1, Q2, Q3): Dividen la muestra en 4 partes iguales (cada una contiene el 25% de los casos). Q1 marca el 25%, Q2 marca el 50% (Mediana) y Q3 marca el 75%.
Deciles (D1 a D9): Dividen la muestra en 10 partes iguales (cada una con el 10% de los casos).
Percentiles (P1 a P99): Dividen la muestra en 100 partes iguales. Utilizados ampliamente en estudios antropométricos y salud.
3.2 Medidas de Dispersión (Variabilidad de los Datos)
Indican el grado de concentración o alejamiento de los datos con respecto a una medida de posición o centro. Responden a la pregunta: ¿qué tan homogéneos o heterogéneos son mis datos?
Varianza Muestral (s²): Promedio de las diferencias al cuadrado respecto de la media. Se divide por (n-1) para obtener una estimación insesgada de la población. Su limitación es que sus unidades quedan elevadas al cuadrado ($pesos^2$), lo que dificulta su interpretación directa.
Desvío Estándar (s): Es la raíz cuadrada de la varianza. Al volver a las unidades originales de la variable (pesos, metros, años), es la medida de dispersión más utilizada.
Coeficiente de Variación (CV): Se calcula dividiendo el Desvío Estándar por la Media ($CV = s / \bar{x}$). Se expresa en porcentaje y permite comparar la dispersión entre variables con distintas unidades de medida o distintas escalas.
Rango Intercuartílico (IQR): Es la diferencia entre el tercer cuartil y el primer cuartil ($IQR = Q3 - Q1$). Representa la dispersión del 50% central de los datos y es la base para dibujar un Boxplot.
MAD (Median Absolute Deviation): Medida de dispersión calculada como la mediana de las desviaciones absolutas respecto a la mediana. Es la alternativa robusta al desvío estándar cuando existen outliers severos.
Módulo 4: Caracterización de la Distribución (Asimetría y Curtosis)
4.1 Coeficiente de Asimetría Muestral
Indica si la distribución de los datos se extiende simétricamente a ambos lados del centro o si se inclina hacia uno de los extremos.
Asimetría Positiva (Sesgo a la derecha): Media > Mediana > Moda. La mayoría de los datos se concentran en valores bajos (pico a la izquierda) y unos pocos valores extremos altos extienden la cola hacia la derecha, arrastrando el promedio hacia arriba. Ejemplo: Salarios o Precios de propiedades.
Simetría Perfecta (Campana de Gauss): Media = Mediana = Moda. Los datos se distribuyen de manera perfectamente balanceada alrededor del centro.
Asimetría Negativa (Sesgo a la izquierda): Moda > Mediana > Media. La mayoría de los datos se concentran en valores altos (pico a la derecha) y unos pocos valores extremos bajos extienden la cola hacia la izquierda. Ejemplo: Notas en un examen muy fácil.
--- TABLA ---
📐 Métodos de Cálculo de Asimetría:
• Coeficiente de Fisher: Eleva las diferencias al cubo respecto a la media. Sensible a outliers.
• Coeficiente de Bowley: Se basa en la distancia de los cuartiles respecto a la mediana ($Bowley = \frac{(Q3 - Mediana) - (Mediana - Q1)}{Q3 - Q1}$). Es altamente recomendado cuando la media y el desvío estándar están distorsionados por valores extremos.
--- FIN TABLA ---

4.2 Curtosis (Apuntalamiento de la Distribución)
Mide el grado de concentración de los datos en la zona central de la distribución respecto a una distribución Normal simétrica.
Leptocúrtica (Curtosis > 0 / > 3 según fórmula): Distribución muy alta y picuda en el centro, con colas pesadas. Indica alta concentración alrededor de la media.
Mesocúrtica (Curtosis = 0 / = 3): Presenta el apuntalamiento normal de la Distribución de Gauss.
Platicúrtica (Curtosis < 0 / < 3): Distribución aplastada y plana, con datos muy dispersos.
Módulo 5: Análisis Bivariado y Multivariado
5.1 Análisis Bivariado (Relación entre dos variables)
Busca analizar la variabilidad conjunta y la asociación entre dos variables $X$ e $Y$.
Covarianza Muestral: Mide el sentido de la variación conjunta. Si la covarianza es positiva, cuando $X$ aumenta $Y$ tiende a aumentar; si es negativa, cuando $X$ aumenta $Y$ disminuye. LIMITACIÓN: Su valor depende de la escala de medición de las variables (no está acotado), por lo que no permite comparar la fuerza de la asociación.
Coeficiente de Correlación de Pearson (r): Estandariza la covarianza dividiéndola por el producto de los desvíos estándar. Produce un valor acotado en el rango de -1 a +1. Donde +1 es relación directa perfecta, -1 es relación inversa perfecta y 0 indica ausencia de relación lineal. LIMITACIÓN: Es muy sensible a outliers.
Coeficiente de Correlación de Spearman (ρ): Reemplaza los valores numéricos por sus rangos (posiciones ordenadas 1°, 2°, 3°...). Es la alternativa ROBUSTA a Pearson cuando existen valores atípicos severos o distribuciones no normales.
5.2 Análisis Multivariado (Estructura de Datasets Complejos)
En el análisis multivariado, el dataset se representa mediante una matriz de N filas (registros u observaciones) y P columnas (atributos o variables).
--- TABLA ---
⚠️ Regla Clave de Complejidad Multivariada:
La complejidad del análisis estadístico y computacional NO crece principalmente con el número de filas (N), sino con el número de columnas/variables (P).
La cantidad de parámetros a estimar sigue la fórmula: (2P + P*(P-1))/2. A mayor cantidad de variables P, más complejo y costoso se vuelve el análisis debido a la necesidad de analizar las relaciones cruzadas de cada variable con todas las demás.
--- FIN TABLA ---
