# apunte_clase6_bda_columnares_y_lenguaje_r

GUÍA INTEGRAL DE ESTUDIO — CLASE 6
Bases de Datos Columnares (Teorema CAP & NoSQL) e Introducción al Lenguaje R / RStudio
--- TABLA ---
📌 OBJETIVO PEDAGÓGICO DE LA CLASE 6: Esta guía reúne la teoría de Bases de Datos NoSQL y Columnares (Teorema CAP, Modelo ACID, Cassandra vs. SQL) y los fundamentos esenciales del Lenguaje R y RStudio (sintaxis, estructuras de datos, Tidyverse vs. R Base), conectando la teoría académica con su aplicación práctica para exámenes y el Trabajo Práctico Final de la UTN.
--- FIN TABLA ---

Módulo 1: Bases de Datos y Big Data — El Teorema CAP y el Universo NoSQL
1.1 El Modelo ACID de las Bases Relacionales (SQL)
Las bases de datos relacionales tradicionales (SQL) fueron diseñadas bajo el modelo ACID, el cual exige que cada transacción en el sistema de gestión garantice cuatro pilares fundamentales:

Atómico (Atomic): Cada transacción se ejecuta por completo (commit) o falla por entero. Nunca puede quedar una transacción a medias impactada en la base de datos.
Consistente (Consistent): Las transacciones respetan todas las reglas del modelo de datos. No puede haber contradicciones ni registros incompletos que violen restricciones.
Aislado (Isolated): Las transacciones simultáneas no confirmadas están aisladas entre sí, evitando que una transacción incompleta afecte a otra.
Durable (Durable): Una vez confirmada la transacción, los cambios persisten de manera permanente en el tiempo, incluso ante fallos del sistema.
1.2 La Conjetura / Teorema de Brewer (Teorema CAP - MIT, 2002)
Demostrado por Fox, Gilbert y Nancy Lynch (MIT), el Teorema CAP establece que en un sistema web distribuido es imposible garantizar simultáneamente las tres propiedades siguientes:

Consistencia (Consistency - C): Todos los nodos leen la misma información al mismo tiempo. Cualquier lectura retorna la escritura más reciente.
Disponibilidad (Availability - A): Todo nodo disponible responde a cada petición de lectura o escritura sin fallar ni bloquearse.
Tolerancia a Particiones (Partition Tolerance - P): El sistema continúa funcionando aunque la red sufra cortes, caídas de nodos o pérdida de mensajes entre servidores.
--- TABLA ---
💡 EL 'TRADE-OFF' O COMPROMISO DE NO-SQL: Las bases SQL eligen CA (Consistencia + Disponibilidad en un solo servidor), pero ante una falla de red se bloquean por completo ('se cayó el sistema'). En cambio, el universo NoSQL nace para trabajar en entornos distribuidos aceptando tolerar particiones (P), sacrificando la consistencia inmediata a cambio de disponibilidad permanente.
--- FIN TABLA ---

1.3 Clasificación de Bases de Datos NoSQL

--- TABLA ---
Tipo de NoSQL | Ejemplo | Clasificación CAP | Comportamiento ante Falla de Red
Documental | MongoDB | CP (Consistencia + Partición) | Prioriza que los datos sean exactos y correctos. Ante una falla de red prefiere dar error o bloquear escrituras antes que desincronizarse.
Columnar | Cassandra | AP (Disponibilidad + Partición) | Prioriza disponibilidad total. Permite escribir y leer siempre en los nodos activos; acepta devolver datos temporalmente desactualizados hasta resincronizar.
Caché / Key-Value | Redis | AP / Configurable | Prioriza velocidad extrema en memoria local. La replicación asíncrona puede permitir lecturas temporales no actualizadas.
--- FIN TABLA ---

1.4 El Teorema 4 y la 'Conexión-t' (Consistencia Eventual)
El Teorema 4 del paper demuestra que es posible implementar un algoritmo modificado que garantice Conexión-t: si la red permanece estable y conectada durante al menos un intervalo de tiempo t, la consistencia total entre los nodos queda completamente restaurada. Esto da origen al concepto de Consistencia Eventual (Eventual Consistency) que rige a la mayoría de los sistemas modernos de Big Data.
Módulo 2: Bases de Datos Columnares (Apache Cassandra) vs. SQL en Big Data
Las bases de datos columnares como Apache Cassandra fueron creadas específicamente para superar las limitaciones estructurales de las bases relacionales al trabajar con volúmenes gigantescos de información (Big Data). Su arquitectura descentralizada masterless elimina el nodo maestro único, distribuyendo los datos de manera homogénea entre múltiples servidores.
Cuadro Comparativo de Examen: SQL Relacional vs. Columnares (Cassandra)

--- TABLA ---
Eje de Análisis | Bases Relacionales (SQL) | Bases Columnares (Cassandra)
Escalabilidad | Vertical: Requiere un único servidor cada vez más potente (agregar RAM y CPU resulta exponencialmente costoso). | Horizontal: Escala linealmente agregando nodos estándar al clúster (mucho más económico y sin límite práctico).
Almacenamiento y Lectura | Basado en Filas: Lee registros completos en disco, desperdiciando recursos de I/O cuando solo se necesitan 2 o 3 columnas de 100 disponibles. | Basado en Columnas: Lee únicamente las columnas requeridas para la consulta, acelerando drásticamente las agregaciones.
Velocidad e Ingesta | Validaciones ACID pesadas y transacciones complejas que ralentizan la ingesta masiva de escrituras. | Diseñada para ingerir millones de escrituras por segundo sin bloqueos pesados ni validaciones de bloqueo global.
Tolerancia a Fallos | Punto Único de Falla (Single Point of Failure): Si se cae el servidor maestro, todo el sistema queda inoperativo. | Masterless (Sin Máster): Ningún nodo es indispensable. Si cae un centro de cómputos o nodo, los demás continúan operando normalmente.
--- FIN TABLA ---

Módulo 3: Introducción al Lenguaje R y RStudio
3.1 Origen y Características de R
R es un entorno y lenguaje de programación libre e interpretado, desarrollado originalmente en los Laboratorios Bell como reimplementación de código abierto del lenguaje S. Está especialmente diseñado para el análisis estadístico, la manipulación de datos y la generación de gráficos de alta calidad.

Aunque formalmente se define como multiparadigma, la programación orientada a objetos en R es poco intuitiva y ruda. En la práctica profesional del análisis de datos, R se utiliza principalmente bajo el paradigma funcional y estructurado.
3.2 Sintaxis Esencial y Operadores

Asignación de Objetos: Se realiza mediante el operador de flecha `<-` (preferido en la comunidad) o el signo `=`. La flecha permite asignar a izquierda (`x <- 10`) o a derecha (`10 -> x`).
Instalación y Carga de Paquetes: Se instalan con `install.packages("nombre")` y se cargan en la sesión activa con `library(nombre)`.
Funciones y Comentarios: Las funciones se declaran con `function(...)` y los comentarios se inician con el símbolo numeral `#`.
Consulta de Ayuda: Para consultar la documentación oficial de una función se usa `help(nombre)` o el prefijo `?nombre`. Para librerías completas se usa `??libreria`.
Operadores Matemáticos: Suma `+`, Resta `-`, Multiplicación `*`, División `/`, Exponencial `^` o `**`, Módulo/Resto `%%` y División Entera `%/%`.
Operadores Lógicos: Menor `<`, Mayor `>`, Igual `==`, Distinto `!=`, Negación `!`, Y lógico `&`, O lógico `|`.
El Operador Pipe (`%>%` o `|>`): Permite encadenar operaciones secuenciales de forma limpia y legible (`datos %>% filter(...) %>% group_by(...) %>% summarize(...)`).
3.3 Tipos de Datos Atómicos y el 'Factor'
R posee los tipos de datos atómicos habituales: Numeric (decimales), Integer (enteros), Character (cadenas de texto), Logical (`TRUE`/`FALSE`) y Complex.


--- TABLA ---
⚠️ CONCEPTO CLAVE DE EXAMEN — EL TIPO DE DATO 'FACTOR': El 'Factor' es un tipo de dato especial de R creado específicamente para representar variables Categóricas (nominales u ordinales) mediante niveles ('levels'). A diferencia de una cadena de texto común, R reconoce internamente que un Factor representa categorías discretas, impidiendo operaciones matemáticas inválidas y activando automáticamente las fórmulas y pruebas estadísticas adecuadas para variables cualitativas.
--- FIN TABLA ---

Módulo 4: Estructuras de Datos y Ecosistemas (R Base vs. Tidyverse)
4.1 Estructuras de Datos en R

Vectores (c): Se crean con la función de combinación `c(1, 2, 3)`. Son estrictamente homogéneos (todos sus elementos deben ser del mismo tipo). Se accede a sus elementos con un solo corchete `vector[1]` (notar que en R los índices empiezan en 1, no en 0).
Secuencias (seq): Vectores numéricos ordenados con distancia fija generados mediante `seq(from=1, to=10, by=2)` o el operador dos puntos `1:10`.
Listas (list): Estructuras heterogéneas que pueden contener objetos de distintos tipos y tamaños (incluso vectores, matrices u otros DataFrames). Se accede a sus elementos con doble corchete `lista[[1]]`.
Matrices (matrix / dim): Arreglos bidimensionales homogéneos construidos asignando dimensiones a un vector mediante `dim()` o `matrix()`.
Data Frames (data.frame): Tablas bidimensionales compuestas por listas de vectores de igual longitud. Es la estructura reina del análisis de datos en R que inspiró la creación de los DataFrames en Pandas.
4.2 Dos Formas de Utilizar R: R Base vs. Tidyverse

--- TABLA ---
Criterio | R Base (Core) | Tidyverse (Ecosistema)
Filosofía y Sintaxis | Utiliza las funciones del tronco nativo de R. Sintaxis técnica con corchetes y lógica matricial, con mayor curva de aprendizaje para no programadores. | Colección de paquetes posteriores (`dplyr`, `ggplot2`, `tidyr`, `readr`) orientados a 'no programadores'. Sintaxis concisa de alto nivel con pipes (`%>%`).
Rendimiento en Big Data | Útil en operaciones simples, pero menos optimizado al procesar grandes volúmenes de datos. | Librerías altamente optimizadas en C++ diseñadas para manipular grandes tablas de datos con máxima velocidad.
--- FIN TABLA ---

4.3 Entorno RStudio, Formato RDS y Proyectos (.Rproj)
RStudio (desarrollado por Posit) es el entorno de desarrollo integrado (IDE) estándar para R. Se divide en cuatro cuadrantes:
1) Script (arriba-izquierda): Edición de código y documentos dinámicos RMarkdown.
2) Consola (abajo-izquierda): Ejecución directa de comandos en tiempo real.
3) Entorno / Environment (arriba-derecha): Muestra las variables, objetos cargados y memoria utilizada.
4) Archivos / Gráficos / Paquetes (abajo-derecha): Visor de archivos locales, renders de plots, gestor de paquetes y ayuda.

RStudio permite gestionar proyectos mediante archivos .Rproj, fijando automáticamente la ruta de trabajo. Asimismo, permite importar múltiples formatos (CSV, TXT, Excel, SAS, SPSS, Stata) y guardar objetos nativos o modelos entrenados en formato RDS (.rds), un contenedor binario ultraliviano.
Módulo 5: Banco de Preguntas de Examen y Solucionario Técnico
P1: ¿Por qué una base de datos relacional tradicional (SQL) se bloquea o cae ante fallos de red en un entorno distribuido?
Respuesta: Porque las bases SQL están diseñadas bajo el modelo ACID y priorizan la Consistencia (C) y la Disponibilidad (A) sobre la Tolerancia a Particiones (P). Según el Teorema CAP, es imposible garantizar las tres al mismo tiempo; por ende, cuando la red falla o se particiona, SQL detiene la transacción o bloquea escrituras para evitar que la información se vuelva inconsistente.
P2: ¿Cuáles son las ventajas teóricas de una base de datos columnar como Cassandra al trabajar con Big Data frente a SQL?
Respuesta: Presenta cuatro ventajas clave: 1) Escalabilidad Horizontal (escala agregando nodos estándar en lugar de agrandar un único servidor costoso); 2) Lectura Eficiente por Columnas (lee solo las columnas consultadas sin procesar filas completas); 3) Ingesta Masiva sin Bloqueos (diseñada para millones de escrituras por segundo); y 4) Arquitectura Masterless (sin punto único de falla, el clúster sigue operando si un nodo cae).
P3: ¿Qué diferencia existe entre un vector (c) y una lista (list) en R?
Respuesta: Un vector es una estructura homogénea (todos sus elementos deben pertenecer estrictamente al mismo tipo de dato) y sus elementos se acceden con corchete simple [i]. En cambio, una lista es una estructura heterogénea (puede almacenar objetos de distintos tipos y tamaños, como DataFrames y matrices) y sus elementos se acceden con doble corchete [[i]].
P4: ¿Por qué se afirma que el tipo de dato 'Factor' es fundamental para el análisis estadístico en R?
Respuesta: Porque el 'Factor' es la estructura nativa para representar variables Categóricas (nominales u ordinales) mediante niveles (levels). Le indica formalmente al motor de R que no se trata de texto plano, evitando cálculos inapropiados (como intentar promediar palabras) y aplicando las pruebas estadísticas y gráficos correctos para variables cualitativas.