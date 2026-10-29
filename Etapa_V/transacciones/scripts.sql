USE LaptopDeel;
GO

-- PASO 1: CREAMOS EL PROCEDIMIENTO ALMACENADO 
-- Validar stock -> Crear venta -> Insertar detalle -> Actualizar stock
CREATE OR ALTER PROCEDURE dbo.RegistrarVenta
    @id_cliente INT,
    @id_usuario INT,
    @id_notebook INT,
    @cantidad INT,
    @metodo_pago NVARCHAR(50)
AS
BEGIN
    -- 1. Validar stock (Si no hay, lanzamos error y frena todo)
    DECLARE @stock_actual INT;
    DECLARE @precio DECIMAL(12,2);
    
    SELECT @stock_actual = stock, @precio = precio 
    FROM NOTEBOOK WHERE id_notebook = @id_notebook;

    IF @stock_actual < @cantidad -- Evalúa si el inventario disponible no alcanza para cubrir el pedido.
    BEGIN
        -- THROW lanza un error que será atrapado por el CATCH de afuera
        THROW 50001, 'Error: Stock insuficiente para realizar la venta', 1; 
    END

    -- 2. Crear venta
    DECLARE @id_venta INT;
    INSERT INTO VENTA (estado, monto_total, id_usuario, id_Cliente)
    VALUES ('Confirmada', (@precio * @cantidad), @id_usuario, @id_cliente);
    
    SET @id_venta = SCOPE_IDENTITY(); -- Retorna el último ID autogenerado (columna IDENTITY) dentro de este mismo ámbito (es decir, el id_venta que se acaba de crear)

    -- Insertamos el método de pago
    INSERT INTO VENTA_METODO_PAGO (id_venta, metodo_pago) -- Asocia el método de pago especificado al registro de la venta recién creada
    VALUES (@id_venta, @metodo_pago);

    -- 3. Insertar detalle
    INSERT INTO DETALLE_VENTA (id_notebook, id_venta, cantidad, precio_unitario)
    VALUES (@id_notebook, @id_venta, @cantidad, @precio);

    -- 4. Actualizar stock
    UPDATE NOTEBOOK 
    SET stock = stock - @cantidad 
    WHERE id_notebook = @id_notebook;
END;-- Cierra el cuerpo del procedimiento y envía el lote para su compilación.
GO


-- PASO 2: PRUEBA EXITOSA
SELECT id_notebook, marca, modelo, stock FROM NOTEBOOK WHERE id_notebook = 1; -- Estado inicial

BEGIN TRY --Bloque de captura de errores
    BEGIN TRANSACTION; -- A partir de aca cualquier modificación a la base de datos queda en estado temporal hasta confirmarla o deshacerla
    
    -- Ejecutamos el SP (Pidiendo 1 notebook del ID 1, que tiene stock de sobra)
    EXEC dbo.RegistrarVenta @id_cliente = 1, @id_usuario = 2, @id_notebook = 1, @cantidad = 1, @metodo_pago = 'Efectivo';
    
    COMMIT; -- Confirma de manera permanente todos los cambios hechos durante la transacción
    PRINT 'Venta y stock quedan confirmados';
END TRY
BEGIN CATCH -- Se ejecuta automáticamente si se produce cualquier error dentro del TRY
    -- Si algo falla, verificamos si hay una transacción abierta y hacemos ROLLBACK
    IF @@TRANCOUNT > 0 ROLLBACK;
    PRINT 'Ocurrió un error inesperado';
    THROW; -- Relanza el error original para que quede registrado en el cliente
END CATCH;
GO
-- Verificacion de resultado
SELECT TOP 1 id_venta, id_Cliente, id_usuario, monto_total, estado 
FROM VENTA ORDER BY id_venta DESC;

SELECT id_notebook, marca, modelo, stock FROM NOTEBOOK WHERE id_notebook = 1;

-- PASO 3: PRUEBA FALLIDA (Error intencional para demostrar el ROLLBACK)
BEGIN TRY
    BEGIN TRANSACTION;
    
    -- Ejecutamos el SP pero pidiendo 50 notebooks
    -- Esto hará que el SP haga un THROW, y caigamos en el CATCH
    EXEC dbo.RegistrarVenta @id_cliente = 1, @id_usuario = 2, @id_notebook = 1, @cantidad = 50, @metodo_pago = 'Tarjeta';
    
    COMMIT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK;
    PRINT 'Error detectado. Haciendo ROLLBACK...';
    PRINT 'Motivo del error: ' + ERROR_MESSAGE();
    THROW; 
END CATCH;
GO
-- Verificacion de resultado
SELECT TOP 1 id_venta, id_Cliente, id_usuario, monto_total, estado 
FROM VENTA ORDER BY id_venta DESC;

SELECT id_notebook, marca, modelo, stock FROM NOTEBOOK WHERE id_notebook = 1;

-- PASO 4: VERIFICACIÓN
-- Comprobamos que la prueba fallida NO guardó nada
-- El stock de la notebook 1 debe haber bajado solo 1 unidad (por la prueba exitosa)
SELECT id_notebook, marca, modelo, stock FROM NOTEBOOK WHERE id_notebook = 1;
GO