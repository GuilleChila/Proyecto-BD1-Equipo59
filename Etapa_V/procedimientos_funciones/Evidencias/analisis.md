# Análisis de Rendimiento y Eficacia: Inserción Directa vs. Procedimientos Almacenados

## 1. ¿Por qué los `INSERT` directos fueron más rápidos en esta prueba?

A nivel de velocidad pura (*overhead* por lote pequeño), las sentencias `INSERT` directas mostraron un tiempo menor ($15\text{ ms}$) en comparación con los procedimientos almacenados ($75\text{ ms}$). Esto se debe a los siguientes factores arquitectónicos del motor de base de datos:

1. **Menor sobrecarga de llamadas (Context Switching):** Las sentencias directas se ejecutan dentro del mismo lote plano enviado al servidor, minimizando la cantidad de cambios de contexto entre el entorno de ejecución y el intérprete de SQL.

2. **Optimización de consultas simples:** Para volúmenes pequeños de datos de prueba (*seeding* inicial), la compilación al vuelo de un bloque `INSERT` directo no sufre penalizaciones significativas de rendimiento.

## 3. ¿Por qué los Procedimientos Almacenados son más Eficaces a escala?

Aunque en esta prueba específica de pocos registros el procedimiento almacenado registró un tiempo ligeramente mayor debido a la inicialización de variables de control de IDs y la sobrecarga de la llamada `EXEC`, **su uso es altamente superior en términos de eficacia, seguridad y mantenimiento para sistemas reales**:

* **Centralización de la Lógica de Negocio:** Los procedimientos encapsulan reglas críticas (como la asignación automática por defecto de banderas lógicas como `eliminado = 0` o `eliminado = 1`). Si una regla cambia, se modifica el procedimiento en el servidor sin necesidad de recompilar ni desplegar nuevamente la aplicación cliente de escritorio.

* **Seguridad contra Inyección SQL:** Los parámetros fuertemente tipados (`@p_marca VARCHAR(100)`, `@p_precio DECIMAL(10,2)`, etc.) previenen de forma nativa ataques de inyección SQL, algo que las cadenas concatenadas de `INSERT` directos podrían propiciar si no se tratan correctamente en la aplicación.

* **Planes de Ejecución en Caché:** En entornos de producción con miles de transacciones concurrentes repetitivas, el motor de SQL Server almacena en caché el plan de ejecución de un procedimiento almacenado, reduciendo drásticamente el uso de CPU frente a sentencias sueltas que se evalúan de forma individual.

## 4. Conclusión

Para poblar la base de datos de forma masiva e inicial, las **sentencias `INSERT` directas** optimizan el tiempo de ejecución bruto. Sin embargo, para la arquitectura robusta del sistema **LaptopDeel**, el uso de **Procedimientos Almacenados** es la opción profesional recomendada porque garantiza la integridad referencial estricta, centraliza las transacciones y protege los datos de la aplicación ante futuras modificaciones estructurales.