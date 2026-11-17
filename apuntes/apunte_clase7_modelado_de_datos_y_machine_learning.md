# apunte_clase7_modelado_de_datos_y_machine_learning

GUÍA OFICIAL DE ESTUDIO - CLASE 7
INTRODUCCIÓN AL MODELADO DE DATOS Y MACHINE LEARNING
Cátedra: Introducción al Análisis de Datos — UTN Avellaneda
Material Integrado: Transcripción Clase 7, Presentación de Modelado y Pautas del TP Final

1. Los Tres Objetivos del Análisis de Datos: Describir, Inferir y Predecir
El análisis de datos persigue transformar datos crudos en conocimiento útil para la toma de decisiones. Según el alcance de la investigación y la cantidad de datos disponibles, se identifican tres grandes objetivos fundamentales:
a) Análisis Descriptivo:  Trabaja con la totalidad de la población (por ejemplo, un censo completo). Resume lo sucedido mediante tablas de frecuencia, promedios o porcentajes directos sin realizar suposiciones ni estimaciones sobre datos faltantes.
b) Análisis Inferencial:  Trabaja a partir de una muestra representativa de la población (como la Encuesta Permanente de Hogares - EPH del INDEC). Pretende extrapolar o generalizar los hallazgos de la muestra hacia todo el universo mediante estimaciones de intervalo, pruebas de hipótesis y la aplicación del Teorema Central del Límite (TCL).
c) Análisis Predictivo / Modelado:  Pretende estimar valores futuros o desconocidos a partir de patrones observados en datos históricos. Ejemplos clásicos son el pronóstico meteorológico o la estimación del valor comercial de una propiedad. Los modelos predictivos son probabilísticos (contienen un grado de incertidumbre e intervalo de confianza) y nunca son 100% infalibles.
--- TABLA ---
📌 DIFERENCIA ENTRE CIENCIAS EXACTAS Y SOCIALES EN MODELADO
En Ciencias Sociales y Economía, los modelos predictivos enfrentan una cantidad infinita de variables no controlables (comportamientos individuales, cambios políticos). Por ello, un modelo con un coeficiente de determinación R² de 0.30 a 0.50 en Ciencias Sociales se considera un logro excelente, mientras que en Ciencias Exactas se exigirían valores superiores a 0.90.
--- FIN TABLA ---

2. Aprendizaje Automático (Machine Learning) vs. Análisis Tradicional
El modelado de datos abarca tanto las técnicas estadísticas clásicas como las metodologías modernas de aprendizaje automático. Aunque están estrechamente relacionados, existen diferencias conceptuales estructurales:
--- TABLA ---
Criterio | Análisis Estadístico Tradicional | Aprendizaje Automático (Machine Learning)
Actor Principal | Analistas humanos mediante métodos hipotético-deductivos. | Programas de computadora que 'aprenden' de la experiencia (datos).
Supuestos de Estructura | Exige validar supuestos estrictos (Normalidad, Homoscedasticidad, No colinealidad). | Evita imponer supuestos rígidos sobre la estructura de los datos.
Enfoque Principal | Prioriza la interpretabilidad de coeficientes y la explicación de causas. | Prioriza la capacidad predictiva sobre la interpretabilidad (Caja Negra).
Escala de Datos | Funciona eficientemente en muestras pequeñas y medianas. | Requiere grandes volúmenes de datos (Big Data) para superar umbrales de rendimiento.
--- FIN TABLA ---

Definición Formal de Mitchell (1997) para Machine Learning
Según la definición académica clásica formulada por Tom Mitchell, se dice que un programa de computadora aprende de la experiencia E con respecto a una clase de tareas T y una medida de rendimiento P, si su rendimiento en las tareas T (medido por P) mejora con la experiencia E.
Experiencia (E): Conjunto de datos e información masiva provista al algoritmo para entrenar.
Tarea (T): La función específica a resolver (ej. predecir si un cliente no responderá su ingreso o clasificar una transacción).
Medida de Rendimiento (P): La métrica objetiva con la que se evalúa la efectividad (ej. Coeficiente R², Precisión, Exactitud, Matriz de Confusión).
3. Criterios de Clasificación de los Modelos Estadísticos
En el examen final y en la práctica profesional, los modelos estadísticos se categorizan según 7 criterios fundamentales:
A. Según la Existencia y Tipo de Variable Dependiente
1. Aprendizaje Supervisado: Existe una variable respuesta o dependiente (Y) que se intenta predecir a partir de variables independientes (X). Se divide en dos clases:
   • Regresión: La variable dependiente Y es CUANTITATIVA CONTINUA (ej. Ingreso P21, Precio de una casa, Temperatura).
   • Clasificación: La variable dependiente Y es CUALITATIVA / CATEGÓRICA (ej. Adulto vs Niño, Cliente moroso vs Puntual, Ocupado vs Desocupado).
2. Aprendizaje No Supervisado: No existe variable dependiente (Y). El algoritmo busca patrones geométricos o agrupamientos naturales ocultos en los datos (ej. Clustering / Algoritmos K-Means).
B. Según la Cantidad de Variables Independientes
Modelos Simples: Utiliza una sola variable explicativa X para predecir Y (ej. Y = a + bX).
Modelos Múltiples: Utiliza múltiples variables explicativas X1, X2, ..., Xp para predecir Y.
C. Según la Forma de las Relaciones
Modelos Lineales: Asumen que la pendiente entre variables es constante a lo largo de todo el dominio.
Modelos No Lineales: Detectan cambios en las pendientes y curvaturas complejas en el dominio de datos.
D. Según la Existencia de Supuestos (Paramétricos vs. No Paramétricos)
Modelos Paramétricos: Exigen validar supuestos estadísticos previos (como la Distribución Normal de los errores, la Homoscedasticidad y la Ausencia de Colinealidad) para que los coeficientes sean válidos (ej. Regresión Lineal Múltiple).
Modelos No Paramétricos: No exigen supuestos sobre la distribución de las variables ni sobre los errores. Toleran datos no estructurados y relaciones no lineales (ej. Árboles de Decisión, Random Forest, Redes Neuronales).
4. Arquitecturas Algorítmicas Principales
Durante la Clase 7 se analizaron tres grandes arquitecturas de modelos:
1. Regresión Lineal Múltiple
Construye un hiperplano matemático optimizando los coeficientes beta (B0, B1, B2...) para minimizar la suma de errores cuadráticos. Genera coeficientes altamente interpretables que indican la magnitud y dirección del impacto de cada variable explicativa sobre la variable dependiente.
2. Árboles de Decisión / Árboles Binarios
Es la arquitectura de Machine Learning supervisado más intuitiva. Funciona mediante un algoritmo recursivo que realiza preguntas binarias (if-else) para dividir el dataset en grupos cada vez más homogéneos, buscando reducir la entropía (desorden) de la variable respuesta.
Mecanismo de Selección: Evalúa todas las variables explicativas y selecciona aquella con el corte que produce la mayor diferencia entre los grupos formados.
Ejemplo de División: Por ejemplo, al analizar ingresos en EPH, el árbol suele colocar en el primer nodo superior (raíz) la variable 'Nivel Educativo', dividiendo la muestra entre universitarios (ingresos altos) y no universitarios (ingresos bajos), y luego sigue subdividiendo por aglomerado o edad.
3. Redes Neuronales y Deep Learning
Inspiradas en el procesamiento biológico, están compuestas por una Capa de Entrada (Input Layer), múltiples Capas Ocultas (Hidden Layers) y una Capa de Salida (Output Layer). Al sumar 3 o más capas ocultas se habla de Aprendizaje Profundo (Deep Learning). Son modelos no paramétricos de 'Caja Negra' ideales para datos no estructurados (imágenes, texto nativo, audio).
5. Aplicación Práctica: Requisitos Clave para el TP Final de la EPH
La Clase 7 detallo las pautas normativas excluyentes para el Trabajo Práctico Final integrador:
--- TABLA ---
📌 1. DEFLACIÓN OBLIGATORIA POR INFLACIÓN (IPC)
Para comparar ingresos a lo largo del período 2016-2026, es OBLIGATORIO ajustar los valores nominales de la variable P21 por la inflación acumulada utilizando el Índice de Precios al Consumidor (IPC). Sin deflacionar, pareciera que todos los ingresos en Argentina crecen nominalmente sin parar, ocultando las caídas en términos reales a pesos constantes.
--- FIN TABLA ---

--- TABLA ---
📌 2. REQUISITO EXCLUYENTE DE PROMOCIÓN: R² > 0.30 EN ESCALA ORIGINAL
Para lograr la Promoción Directa (notas 6 a 10), el grupo debe desarrollar un modelo de regresión lineal para imputar la no respuesta de ingresos. El profesor fijó como REQUISITO TÉCNICO EXCLUYENTE que el Coeficiente de Determinación R² sea SUPERIOR A 0.30 (R² > 0.30), y la evaluación del ajuste DEBE hacerse sobre la variable de ingresos original (P21 en pesos), sin dejar la evaluación medida sobre la escala logarítmica.
--- FIN TABLA ---
