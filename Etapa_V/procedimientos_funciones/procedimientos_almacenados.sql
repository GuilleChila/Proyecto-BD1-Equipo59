USE LaptopDeel;
GO

-- PROCEDIMIENTOS ALMACENADOS


-- PROCEDIMIENTO 1: Insertar una notebook
CREATE OR ALTER PROCEDURE dbo.SP_Notebooks_Insertar
    @marca              VARCHAR(50),
    @modelo             VARCHAR(50),
    @precio             DECIMAL(12,2),
    @stock              INT,
    @id_procesador      INT,
    @id_pantalla        INT,
    @id_tarjeta_grafica INT = NULL,
    @id_notebook        INT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO NOTEBOOK (marca, modelo, precio, stock, id_procesador, id_pantalla, id_tarjeta_grafica)
    VALUES (@marca, @modelo, @precio, @stock, @id_procesador, @id_pantalla, @id_tarjeta_grafica);

    SET @id_notebook = SCOPE_IDENTITY();
END;
GO


-- PROCEDIMIENTO 2: Modificar una notebook
CREATE OR ALTER PROCEDURE dbo.SP_Notebooks_Actualizar
    @id_notebook        INT,
    @marca              VARCHAR(50),
    @modelo             VARCHAR(50),
    @precio             DECIMAL(12,2),
    @stock              INT,
    @id_procesador      INT,
    @id_pantalla        INT,
    @id_tarjeta_grafica INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE NOTEBOOK
    SET marca              = @marca,
        modelo             = @modelo,
        precio             = @precio,
        stock              = @stock,
        id_procesador      = @id_procesador,
        id_pantalla        = @id_pantalla,
        id_tarjeta_grafica = @id_tarjeta_grafica
    WHERE id_notebook = @id_notebook;
END;
GO


-- PROCEDIMIENTO 3: Eliminar una notebook
CREATE OR ALTER PROCEDURE dbo.SP_Notebooks_Eliminar
    @id_notebook INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM NOTEBOOK
    WHERE id_notebook = @id_notebook;
END;
GO


-- PROCEDIMIENTO 4: Registrar venta simple (lo usa el tema Seguridad)
CREATE OR ALTER PROCEDURE dbo.sp_RegistrarVentaSimple
    @id_cliente INT, @id_usuario INT, @id_notebook INT, @cantidad INT, @metodo_pago NVARCHAR(50)
AS
BEGIN
    DECLARE @precio DECIMAL(12,2);
    DECLARE @id_venta INT;

    SELECT @precio = precio FROM NOTEBOOK WHERE id_notebook = @id_notebook;

    INSERT INTO VENTA (estado, monto_total, id_usuario, id_Cliente)
    VALUES ('Confirmada', (@precio * @cantidad), @id_usuario, @id_cliente);
    SET @id_venta = SCOPE_IDENTITY();

    INSERT INTO VENTA_METODO_PAGO (id_venta, metodo_pago) VALUES (@id_venta, @metodo_pago);
    INSERT INTO DETALLE_VENTA (id_notebook, id_venta, cantidad, precio_unitario) VALUES (@id_notebook, @id_venta, @cantidad, @precio);

    PRINT 'Venta registrada con ID: ' + CAST(@id_venta AS VARCHAR);
END;
GO




-- PRUEBA DE LOS PROCEDIMIENTOS (INSERT, UPDATE y DELETE invocando procedimientos)


-- 1) INSERT mediante procedimiento: se insertan 3 notebooks
DECLARE @id1 INT, @id2 INT, @id3 INT;

EXEC dbo.SP_Notebooks_Insertar @marca = 'Demo', @modelo = 'Demo A', @precio = 900000,  @stock = 5,
     @id_procesador = 3, @id_pantalla = 1, @id_tarjeta_grafica = NULL, @id_notebook = @id1 OUTPUT;

EXEC dbo.SP_Notebooks_Insertar @marca = 'Demo', @modelo = 'Demo B', @precio = 1400000, @stock = 3,
     @id_procesador = 4, @id_pantalla = 2, @id_tarjeta_grafica = 2, @id_notebook = @id2 OUTPUT;

EXEC dbo.SP_Notebooks_Insertar @marca = 'Demo', @modelo = 'Demo C', @precio = 600000,  @stock = 12,
     @id_procesador = 7, @id_pantalla = 6, @id_tarjeta_grafica = NULL, @id_notebook = @id3 OUTPUT;

SELECT * FROM NOTEBOOK WHERE id_notebook IN (@id1 , @id2 , @id3);   -- Resultado esperado: 3 filas

-- 2) UPDATE mediante procedimiento: se modifica la notebook Demo A
EXEC dbo.SP_Notebooks_Actualizar @id_notebook = @id1, @marca = 'Demo', @modelo = 'Demo A MODIFICADO',
     @precio = 950000, @stock = 8, @id_procesador = 3, @id_pantalla = 1, @id_tarjeta_grafica = NULL;

SELECT * FROM NOTEBOOK WHERE id_notebook = @id1;   -- Resultado esperado: Demo A cambió a 'Demo A Pro', precio 950000, stock 8

-- 3) DELETE mediante procedimiento: se elimina la notebook Demo B
EXEC dbo.SP_Notebooks_Eliminar @id_notebook = @id2;

SELECT * FROM NOTEBOOK WHERE id_notebook IN (@id1 , @id2 , @id3);   -- Resultado esperado: quedan 2 filas (Demo A Pro y Demo C)
GO


