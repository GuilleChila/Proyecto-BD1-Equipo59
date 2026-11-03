# Manejo de Transacciones y Transacciones Anidadas

## 1. Definición y Objetivo
Una **transacción** es un conjunto de operaciones SQL que se ejecutan como un único bloque lógico e indivisible. Su objetivo principal es garantizar las propiedades **ACID**:
- **Atomicidad:** Todo se ejecuta o nada se ejecuta (es el "todo o nada").
- **Consistencia:** La base de datos pasa de un estado válido a otro estado válido.
- **Aislamiento:** Las transacciones que ocurren al mismo tiempo no interfieren entre sí.
- **Durabilidad:** Una vez confirmado el cambio, este es permanente, incluso si el sistema falla.

En el sistema LaptopDeel, una venta no es solo un registro; es un proceso que involucra múltiples tablas. Si una parte falla, el resto debe deshacerse para no dejar el inventario o la facturación inconsistentes.

---

## 2. Explicación de las Cláusulas Utilizadas (Glosario Técnico)

Para implementar el control de transacciones de forma segura, utilizamos las siguientes instrucciones y estructuras de Transact-SQL:

*   **`BEGIN TRANSACTION` (o `BEGIN TRAN`)**: Es el punto de partida. Le indica al motor de SQL Server que a partir de ese momento, todas las operaciones (INSERT, UPDATE, DELETE) se guardarán en un "borrador" temporal en memoria, pero **no se harán permanentes** hasta que se lo indiquemos.
*   **`COMMIT`**: Es la orden de "Confirmar". Si todo salió bien, el `COMMIT` le dice a la base de datos que guarde definitivamente todos los cambios realizados durante la transacción. Es el equivalente a firmar un contrato.
*   **`ROLLBACK`**: Es la orden de "Revertir" o "Cancelar". Si ocurre un error, el `ROLLBACK` deshace **todos** los cambios que se hicieron desde el `BEGIN TRANSACTION` hasta ese momento. La base de datos vuelve exactamente al estado en el que estaba antes de empezar.
*   **`BEGIN TRY ... END TRY`**: Es el bloque donde colocamos el código "normal" que queremos que se ejecute (como registrar la venta). Le decimos al motor: *"Intenta hacer esto"*.
*   **`BEGIN CATCH ... END CATCH`**: Es el bloque de "rescate". Si cualquier cosa dentro del `TRY` falla (por ejemplo, un error de stock o de red), la ejecución salta automáticamente a este bloque `CATCH` en lugar de romperse. Acá adentro programamos qué hacer en caso de error (normalmente, un `ROLLBACK`).
*   **`@@TRANCOUNT`**: Es una variable global del sistema. Funciona como un **contador de transacciones abiertas**. Cada vez que hacemos `BEGIN TRAN`, suma 1. Cuando hacemos `COMMIT` o `ROLLBACK`, resta. Al usar `IF @@TRANCOUNT > 0` en el `CATCH`, nos aseguramos de que realmente haya una transacción abierta antes de intentar hacer el `ROLLBACK`, evitando errores adicionales del sistema.
*   **`THROW`**: Es una instrucción que sirve para **"lanzar" un error intencionalmente**. Si estamos dentro del `CATCH`, `THROW` (sin parámetros) vuelve a lanzar el error original hacia afuera, para que la aplicación (o el usuario) se entere de que algo falló. Si se usa con parámetros (ej. `THROW 50001, 'Error de stock', 1`), permite crear un mensaje de error personalizado.
*   **`EXEC`**: Es el comando que se usa para **ejecutar un Procedimiento Almacenado**. En nuestra solución, encapsulamos toda la lógica de la venta en el procedimiento `dbo.RegistrarVenta`, y usamos `EXEC` para llamarlo desde nuestra transacción principal.

---

## 3. Ventajas y Aplicaciones en LaptopDeel
- **Integridad total:** Evita ventas sin detalle o descuentos de stock sin ventas asociadas.
- **Manejo de errores controlado:** Mediante `TRY...CATCH`, si una operación falla, se cancela todo de forma limpia.
- **Seguridad:** La base de datos protege el inventario (RN-01) independientemente de si el software del vendedor tiene un error.

---

## 4. Caso concreto aplicado al sistema
El flujo implementado sigue el modelo **"Todo o nada"** y consta de los siguientes pasos dentro de un Procedimiento Almacenado:
1.  **Validar stock:** Se verifica que haya unidades suficientes de la notebook. Si no hay, se usa `THROW` para lanzar un error y detener el proceso.
2.  **Crear venta:** Se inserta el encabezado en la tabla `VENTA`.
3.  **Insertar detalle:** Se guardan los productos, cantidades y precios en `DETALLE_VENTA`.
4.  **Actualizar stock:** Se resta la cantidad vendida de la tabla `NOTEBOOK`.

---

## 5. Demostración y Resultados de las Pruebas
En el archivo `scripts.sql` se implementaron dos pruebas bajo el esquema `TRY/CATCH`:

-   **Prueba Exitosa:** Se realiza una venta con stock suficiente. El flujo entra al `TRY`, el procedimiento se ejecuta correctamente, y el bloque termina con un `COMMIT`, dejando la venta registrada y el stock actualizado.
-   **Prueba Fallida (Error intencional):** Se intenta vender una cantidad mayor al stock disponible (ej. 50 unidades cuando solo hay 10). El procedimiento detecta la falta de stock y lanza un error con `THROW`. El control salta al bloque `CATCH`, evalúa `@@TRANCOUNT` y ejecuta el `ROLLBACK`. 
-   **Resultado:** Al consultar la base de datos posteriormente, se confirma que **ningún registro de la venta fallida quedó guardado** y el stock no se modificó, demostrando la atomicidad.

---

## 6. Conclusiones
La implementación de transacciones y bloques de captura de errores es fundamental para un sistema comercial. Aprendimos que no basta con escribir consultas SQL correctas, sino que hay que anticipar los fallos. El uso combinado de `BEGIN TRY...CATCH`, `@@TRANCOUNT` y `THROW` permite que el sistema LaptopDeel sea robusto: si un vendedor intenta vender algo que no hay en stock, la base de datos no se corrompe, garantizando la confiabilidad del inventario y la facturación.