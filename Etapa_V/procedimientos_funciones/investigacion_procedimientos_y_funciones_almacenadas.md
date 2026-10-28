# Investigación Técnica: Procedimientos y Funciones Almacenadas en Bases de Datos Relacionales

En los Sistemas de Gestión de Bases de Datos Relacionales (SGBD), los **procedimientos almacenados** y las **funciones almacenadas** son programas o bloques de código procedural que se compilan y almacenan directamente en el servidor de base de datos.

## 1. Definición de Conceptos

### Procedimientos Almacenados (*Stored Procedures*)

Un procedimiento almacenado es un conjunto ejecutable de sentencias SQL y estructuras de control (bucles, condicionales, manejo de excepciones, etc.).

* **Propósito:** Ejecutar operaciones complejas de manipulación de datos (insertar, actualizar, eliminar), automatizar procesos batch o gestionar transacciones de negocio.

* **Retorno:** No requiere obligatoriamente retornar un valor escalar. Puede devolver cero, uno o múltiples valores mediante parámetros de salida (`OUT` o `INOUT`), o retornar conjuntos de resultados (*Result Sets*).

* **Manejo Transaccional:** Tienen la capacidad autónoma de gestionar transacciones (`COMMIT`, `ROLLBACK`, `SAVEPOINT`).

### Funciones Almacenadas (*Stored Functions*)

Una función almacenada es una estructura de código compilado diseñada explícitamente para realizar un cálculo o transformación de datos a partir de valores de entrada y devolver un resultado.

* **Propósito:** Encapsular lógica de cálculo reutilizable, transformaciones de texto/fecha o consultas repetitivas de valor único.

* **Retorno:** **Obligatorio**. Debe retornar explícitamente un único valor de tipo escalar (entero, cadena, fecha, booleano) o, en dialectos avanzados, un tipo estructurado / tabla (*Table-Valued Functions*).

* **Contexto de uso:** Se integra directamente en las sentencias DQL/DML de SQL.

## 2. Ventajas Operativas

El uso de código almacenado en el motor de base de datos ofrece beneficios estratégicos para la infraestructura y el rendimiento de las aplicaciones enterprise.

### Desarrollo y Arquitectura por Capas (*N-Tier Architecture*)

1. **Desacoplamiento de la Lógica de Datos:**

   * Al encapsular las operaciones complejas de base de datos dentro de procedimientos y funciones, la **Capa de Aplicación** (Backend) no necesita conocer la estructura exacta del modelo entidad-relación (tablas, llaves primarias/foráneas, índices).

   * La capa de aplicación simplemente invoca la interfaz del procedimiento o función, logrando un alto grado de cohesión y bajo acoplamiento.

2. **Reutilización y Mantenimiento Centralizado:**

   * Múltiples aplicaciones o microservicios (web, móvil, reportes batch) pueden invocar los mismos procedimientos y funciones almacenadas.

   * Si cambia una regla de negocio que involucra los datos (por ejemplo, el cálculo de un impuesto o la lógica de descuento de inventario), solo se modifica el objeto dentro del SGBD sin requerir un *re-deploy* o nueva compilación de la capa de aplicación backend.

3. **Optimización de Tráfico de Red:**

   * En lugar de enviar múltiples sentencias SQL individuales ida y vuelta entre el servidor web y el servidor de base de datos, la aplicación envía una única llamada (`CALL mi_procedimiento(p1, p2)`).

   * Todo el procesamiento intensivo y las iteraciones ocurren localmente en la memoria del motor de base de datos.

4. **Reutilización del Plan de Ejecución:**

   * Los procedimientos y funciones son precompilados y optimizados por el RDBMS al ser creados o ejecutados por primera vez. El plan de ejecución se almacena en la memoria caché del servidor, reduciendo el overhead de análisis sintáctico (*parsing*) en ejecuciones subsecuentes.

### Control de Acceso y Bloqueo por Permisos (*Security & Access Control*)

1. **Principio de Mínimo Privilegio y Acceso Indirecto:**

   * En un entorno seguro, los usuarios o cuentas de servicio de la aplicación **no** deben tener permisos directos de lectura o escritura (`SELECT`, `INSERT`, `UPDATE`, `DELETE`) sobre las tablas base de la base de datos.

   * Se otorga únicamente el permiso `EXECUTE` sobre los procedimientos y funciones específicas.

   * **Mecanismo de Ejecución Confiada:**

     * **`SECURITY DEFINER`:** El procedimiento se ejecuta con los privilegios del usuario que lo creó (DBA/Owner). De este modo, la aplicación puede modificar datos en tablas restringidas sin poseer permisos directos sobre ellas.

     * **`SECURITY INVOKER`:** El procedimiento se ejecuta con los privilegios del usuario que realiza la llamada.

2. **Prevención Efectiva contra Inyección SQL (*SQL Injection*):**

   * Al utilizar parámetros tipados en procedimientos y funciones almacenadas, el motor de base de datos trata la entrada del usuario estrictamente como datos literales y no como código SQL ejecutable, eliminando prácticamente los riesgos de vulnerabilidades por inyección SQL.

3. **Auditoría y Puntos de Control Integrados:**

   * Dado que todo acceso a los datos pasa por una capa de procedimientos almacenados, es sencillo integrar dentro de ellos registros de auditoría (*logging*), validación de reglas de seguridad o control de concurrencia a nivel de BD.

## 3. Diferencias Técnicas Fundamentales

**Sintaxis de Llamada e Invocación:**

* **Procedimiento Almacenado:** Se ejecuta mediante una sentencia explícita e independiente como `CALL nombre()` o `EXECUTE nombre()`.

  * **Función Almacenada:** Se invoca de forma embebida dentro de expresiones SQL, como en `SELECT funcion() FROM tabla;`.

  **Mecanismo de Retorno de Valores:**

  * **Procedimiento Almacenado:** El retorno es opcional. Puede no devolver nada, o bien retornar uno o múltiples valores a través de parámetros declarados como `OUT` o `INOUT`, así como conjuntos de datos (*Result Sets*).

  * **Función Almacenada:** El retorno es **obligatorio**. Debe incluir una cláusula `RETURN` explícita que devuelva un único valor escalar o un tipo estructurado (como una tabla).

  **Integración en Sentencias SQL (DQL / DML):**

  * **Procedimiento Almacenado:** **No** se puede invocar dentro de sentencias como `SELECT`, `WHERE`, `JOIN` o `HAVING`.

  * **Función Almacenada:** **Sí** se puede integrar libremente en cláusulas `SELECT`, `WHERE`, `JOIN`, `HAVING`, `GROUP BY`, etc.

  **Control de Transacciones:**

  * **Procedimiento Almacenado:** Posee control de transacciones propio. Puede ejecutar libremente sentencias de control transaccional como `COMMIT`, `ROLLBACK` y `SAVEPOINT`.

  * **Función Almacenada:** **No permite** gestionar transacciones. Las sentencias `COMMIT` o `ROLLBACK` están estrictamente prohibidas en su interior en la mayoría de los RDBMS.

  **Operaciones de Modificación de Datos (Efectos Secundarios / *Side Effects*):**

  * **Procedimiento Almacenado:** Está diseñado para realizar libremente operaciones DML (`INSERT`, `UPDATE`, `DELETE`) que alteren el estado de la base de datos.

  * **Función Almacenada:** Tiene restringido el uso de operaciones DML cuando es llamada desde un `SELECT` para prevenir efectos secundarios no deseados durante la evaluación de consultas.

  **Modo de Parámetros Permitidos:**

  * **Procedimiento Almacenado:** Admite parámetros de entrada (`IN`), salida (`OUT`) y combinados (`INOUT`).

  * **Función Almacenada:** Utiliza predominantemente parámetros de entrada (`IN`).

  **Casos de Uso Típicos:**

  * **Procedimiento Almacenado:** Flujos de procesos de negocio complejos, cargas masivas de datos (ETL), cierres de periodo, operaciones transaccionales compuestas.

  * **Función Almacenada:** Cálculos matemáticos o financieros, formateo y manipulación de cadenas/fechas, conversiones de tipo y lógica reutilizable en consultas SQL.

## 4. Conclusión

Tanto los **procedimientos almacenados** como las **funciones almacenadas** son herramientas esenciales para la abstracción y aseguramiento de la lógica de persistencia en sistemas de bases de datos relacionales:

1. Las **Funciones Almacenadas** destacan en la modularización de cálculos y transformaciones dentro de consultas SQL.

2. Los **Procedimientos Almacenados** son la piedra angular para la ejecución de procesos de negocio, control transaccional e implementación de una capa de seguridad sólida mediante la delegación de permisos `EXECUTE`.