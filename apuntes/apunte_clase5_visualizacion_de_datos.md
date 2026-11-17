# apunte_clase5_visualizacion_de_datos

APUNTE DE ESTUDIO INTEGRAL: CLASE 5
Visualización de Datos con Python: Matplotlib & Seaborn
Cátedra: Introducción al Análisis de Datos (UTN)
Tabla de Contenidos Automática

1. Fundamentos y Utilidad de la Visualización de Datos
La visualización de datos es el paso posterior al Data Cleaning y forma parte fundamental del Análisis Exploratorio de Datos (EDA). Cuando nos enfrentamos a datasets masivos de miles de filas y cientos de columnas, leer tablas directamente es inabarcable e poco intuitivo para el ser humano. Los gráficos funcionan como resúmenes visuales e intuitivos que permiten resumir grandes volúmenes de información y detectar patrones que las métricas numéricas aisladas podrían ocultar.
“Realizar visualizaciones informativas es una de las tareas más importantes en análisis de datos. Puede ser parte del proceso de exploración, por ejemplo, para identificar con facilidad valores atípicos o transformaciones de datos necesarias, o como una manera de generar ideas para modelos.” (Wes McKinney, creador de Pandas).
--- TABLA ---
💡 Propósitos Principales de la Visualización
 / 1. Exploración Rápida: Identificar anomalías, valores atípicos (outliers) y distribuciones de forma inmediata. / 2. Generación de Hipótesis: Detectar tendencias o correlaciones entre variables para alimentar modelos analíticos. / 3. Comunicación Efectiva: Presentar resultados a decisiones de negocio de forma clara y sintética sin abrumar con código.
--- FIN TABLA ---

2. Matplotlib: La API Fundamental de Gráficos en Python
Matplotlib es la librería base de gráficos en Python. Se importa por convención mediante import matplotlib.pyplot as plt. Es una API altamente flexible que soporta múltiples servidores de interfaz gráfica y permite exportar figuras en formatos como PNG, JPG o PDF.
Paradigmas de Construcción: Funcional vs. Orientado a Objetos
En la materia se destacan dos formas de trabajar con Matplotlib:

Paradigma Funcional: Se van llamando comandos secuenciales de forma directa (ej. plt.plot(), plt.title(), plt.xlabel(), plt.show()). Es rápido para pruebas simples pero menos escalable para tableros o gráficos complejos.
Paradigma Orientado a Objetos (OO): Se crean explícitamente objetos de las clases Figure (el lienzo contenedor), Axes (el gráfico o sub-gráfico individual con sus ejes) y Axis (las escalas numéricas). Ejemplo: fig, ax = plt.subplots(). Permite control total sobre múltiples subplots.
--- TABLA ---
Función de Matplotlib | Descripción y Utilidad en el Código
plt.show() | Imprime la figura actual en pantalla o notebook.
plt.close() | Libera el espacio en memoria RAM correspondiente a una figura.
plt.savefig('nombre.png') | Guarda la figura generada en el disco en el formato especificado.
plt.tight_layout() | Ajusta automáticamente las márgenes y espacios entre subplots.
plt.title('Título') | Establece el título principal de la figura o del eje.
plt.xlabel() / plt.ylabel() | Agrega etiquetas descriptivas a los ejes X e Y.
plt.legend() | Despliega el recuadro con la leyenda descriptiva de las series.
--- FIN TABLA ---

3. Tipos de Gráficos Univariados y Bivariados Esenciales
Histograma vs. Gráfico de Barras (¡Pregunta Clave de Examen!)
El profesor Fernández remarcó especialmente en clase la diferencia conceptual entre el Histograma y el Gráfico de Barras:
Histograma (plt.hist / sns.histplot): Se utiliza EXCLUSIVAMENTE para variables cuantitativas continuas. Divide la variable en intervalos o franjas (denominados bins) y cuenta cuántos registros caen en cada intervalo. Visualmente, LAS BARRAS ESTÁN PEGADAS (CONTIGUAS) porque los intervalos numéricos no tienen espacio en blanco entre sí.
Gráfico de Barras (plt.bar / sns.barplot / sns.countplot): Se utiliza para variables categóricas o cualitativas. Compara frecuencias por grupos o categorías. Visualmente, LAS BARRAS ESTÁN SEPARADAS POR ESPACIOS EN BLANCO porque las categorías son mutuamente excluyentes y no continuas.
--- TABLA ---
💡 Regla de Reconocimiento de Examen
 / En el parcial, si te muestran un gráfico y te preguntan de qué tipo es: / • Si las barras están pegadas y el eje X muestra rangos numéricos continuos -> HISTOGRAMA. / • Si las barras están separadas por espacios en blanco y el eje X muestra categorías (ej. Tipo de personaje, Nivel educativo) -> GRÁFICO DE BARRAS.
--- FIN TABLA ---

Diagrama de Dispersión (Scatter Plot)
El Scatter Plot (plt.scatter / sns.scatterplot) es la herramienta clásica de análisis bivariado cuantitativo. Representa cada observación como un punto en un plano cartesiano (X, Y) para evaluar si existe una relación, tendencia lineal o agrupamiento entre dos variables numéricas (por ejemplo, Precio vs. Dificultad o Experiencia vs. Salario).
Diagrama de Caja (Boxplot) e Interpretación en Datos Reales
El Boxplot (plt.boxplot / sns.boxplot) es un resumen gráfico univariado fundamental que resume la distribución a través de 5 números clave:
Cuartil 1 (Q1 - Percentil 25%): Límite inferior de la caja.
Mediana (Q2 - Percentil 50%): Línea central dentro de la caja.
Cuartil 3 (Q3 - Percentil 75%): Límite superior de la caja. El alto de la caja es el Rango Intercuartílico (IQR = Q3 - Q1).
Bigotes (Whiskers): Se extienden convencionalmente hasta Q1 - 1.5*IQR (Límite Inferior) y Q3 + 1.5*IQR (Límite Superior).
Valores Atípicos (Outliers): Todos los puntos que caen dibujados de forma aislada por fuera de los límites de los bigotes.
En la clase 5, el profesor mostró un caso real utilizando microdatos de la Encuesta Permanente de Hogares (EPH del INDEC) sobre la variable de ingresos laborales (P21). En datos reales con una fuerte asimetría positiva (donde la gran mayoría gana cerca del mínimo y unos pocos ganan millones), la caja se comprime cerca del cero y aparecen cientos de puntos de outliers. El profesor enfatizó que el criterio de los bigotes es maleable y que el analista debe aplicar juicio metodológico según la naturaleza del problema.
4. Visualización Avanzada con Seaborn
Seaborn (import seaborn as sns) es una librería de alto nivel orientada a gráficos estadísticos. Está totalmente integrada con DataFrames y Series de Pandas y ofrece estilos estéticos y paletas de colores prediseñadas. Permite construir gráficos complejos en una sola línea de código.
--- TABLA ---
Función de Seaborn | Descripción y Aplicación Principal
sns.pairplot(df) | Matriz de diagramas de dispersión de N x N para todas las variables numéricas. En la diagonal dibuja histogramas/KDE (univariado) y fuera de la diagonal dispersogramas (bivariado).
sns.heatmap(df.corr(), annot=True) | Mapa de calor o correlograma. Representa la matriz de correlación en una cuadrícula de colores según la magnitud numérica de r.
sns.catplot() | Permite generar sub-gráficos (como boxplots o barplots) segmentados por factores o variables categóricas en facetas.
sns.violinplot() | Combina el diagrama de caja con un gráfico de densidad KDE en espejo a los lados, mostrando la forma de la distribución e hitos de mediana.
sns.jointplot() | Gráfico de asociación conjunta: combina un scatterplot central con histogramas marginales en los bordes y línea de tendencia.
sns.swarmplot() | Gráfico de enjambre: dibuja los puntos como en un scatter plot pero ajusta lateralmente los datos para evitar que se solapen, haciendo visible el volumen exacto de casos.
--- FIN TABLA ---

5. Solucionario y Preguntas Fijas de Examen
P1: ¿Cuál es la diferencia principal entre un Histograma y un Gráfico de Barras desde el punto de vista del tipo de variable y su aspecto visual?
Respuesta: El histograma se utiliza para variables cuantitativas continuas y sus barras están totalmente pegadas (contiguas) porque representan intervalos numéricos (bins). El gráfico de barras se utiliza para variables cualitativas/categóricas y sus barras están separadas por espacios en blanco, representando grupos independientes.
P2: ¿Qué elementos componen un Diagrama de Caja (Boxplot) y cómo permite detectar valores atípicos?
Respuesta: Un Boxplot muestra el Cuartil 1 (Q1), la Mediana (Q2) y el Cuartil 3 (Q3), delimitando una caja de altura igual al Rango Intercuartílico (IQR = Q3 - Q1). Posee bigotes definidos convencionalmente entre Q1 - 1.5*IQR y Q3 + 1.5*IQR. Cualquier dato que caiga más allá de estos bigotes se dibuja como un punto suelto y se identifica como un valor atípico (outlier).
P3: ¿Qué ventaja ofrece un Gráfico de Violín sobre un Boxplot tradicional?
Respuesta: El gráfico de violín conserva la estructura y medidas de posición del Boxplot (mediana e IQR), pero le añade a los lados una estimación de densidad suavizada del núcleo (KDE en espejo), permitiendo visualizar picos de frecuencia o modas dentro de la distribución.
P4: ¿Por qué un Gráfico de Enjambre (Swarmplot) resulta útil cuando hay superposición de puntos en un Scatterplot categórico?
Respuesta: Porque en un Scatterplot estándar varios puntos situados en la misma coordenada exacta se dibujan uno encima del otro, ocultando el volumen real de datos. El Swarmplot ajusta automáticamente los puntos a los lados sin que se solapen, mostrando la densidad y frecuencia exacta de observaciones.