use LaptopDeel;

------------------
--procedimientos--
------------------
-- PROCEDIMIENTO: Registrar venta simple
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

-- PRUEBA DEL PROCEDIMIENTO
EXEC dbo.sp_RegistrarVentaSimple @id_cliente = 1, @id_usuario = 2, @id_notebook = 1, @cantidad = 1, @metodo_pago = 'Efectivo';
GO


// Procedimiento para insertar una notebook en la base de datos

CREATE PROCEDURE SP_Notebooks_Insertar
    @p_id_ram INT,
    @p_id_procesador INT,
    @p_id_almacenamiento INT,
    @p_id_pantalla INT,
    @p_marca VARCHAR(100),
    @p_modelo VARCHAR(100),
    @p_precio DECIMAL(10,2),
    @p_stock INT,
    @p_id_tarjetaGrafica INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO notebooks (
        id_ram, id_procesador, id_almacenamiento, id_pantalla, 
        marca, modelo, precio, stock, eliminado, id_tarjetaGrafica
    )
    VALUES (
        @p_id_ram, @p_id_procesador, @p_id_almacenamiento, @p_id_pantalla, 
        @p_marca, @p_modelo, @p_precio, @p_stock, 0, @p_id_tarjetaGrafica
    );
    SELECT SCOPE_IDENTITY() AS NuevoID;
END
GO

//Procedimiento para actualizar una notebook en la base de datos    
CREATE PROCEDURE SP_Notebooks_Actualizar
    @p_id_notebook INT,
    @p_id_ram INT,
    @p_id_procesador INT,
    @p_id_almacenamiento INT,
    @p_id_pantalla INT,
    @p_marca VARCHAR(100),
    @p_modelo VARCHAR(100),
    @p_precio DECIMAL(10,2),
    @p_stock INT,
    @p_id_tarjetaGrafica INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE notebooks
    SET 
        id_ram = @p_id_ram,
        id_procesador = @p_id_procesador,
        id_almacenamiento = @p_id_almacenamiento,
        id_pantalla = @p_id_pantalla,
        marca = @p_marca,
        modelo = @p_modelo,
        precio = @p_precio,
        stock = @p_stock,
        id_tarjetaGrafica = @p_id_tarjetaGrafica
    WHERE id_notebook = @p_id_notebook;
    
    -- Opcional: Podés devolver la cantidad de filas afectadas si lo necesitás validar en C#
    -- SELECT @@ROWCOUNT AS FilasAfectadas;
END 

//Procedimiento para desactivar (borrado lógico) una notebook en la base de datos           
CREATE PROCEDURE SP_Notebooks_Desactivar
    @p_id_notebook INT
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE notebooks
    SET eliminado = 1
    WHERE id_notebook = @p_id_notebook; 
    
END
GO
-------------
--Funciones--
-------------

-- FUNCIONES PARA EL DASHBOARD Y GRILLAS DE INVENTARIO
go
CREATE FUNCTION dbo.fn_EvaluarEstadoStock (@stockActual INT)
RETURNS VARCHAR(20)
AS
BEGIN
   RETURN CASE 
        WHEN @stockActual <= 0 THEN 'AGOTADO'
        WHEN @stockActual <= 5 THEN 'CRÍTICO'
        WHEN @stockActual <= 15 THEN 'BAJO'
        ELSE 'ÓPTIMO'
    END;
END;
GO

-- Ejemplo de uso para tu grilla de inventario:
SELECT 
    marca, 
    modelo, 
    stock, 
    dbo.fn_EvaluarEstadoStock(stock) AS Alerta_Inventario 
FROM NOTEBOOK;

--Función para obtener estadísticas de compras de un cliente específico
GO
CREATE FUNCTION dbo.fn_EstadisticasComprasCliente (@idCliente INT)
RETURNS TABLE
AS
RETURN 
(
    SELECT 
       c.id_Cliente,
       c.nombre,
       c.apellido,
       c.telefono,
       ISNULL(SUM(d.subtotal), 0) AS Total_Invertido,
       ISNULL(SUM(d.cantidad), 0) AS Cantidad_Comprada
    FROM CLIENTE c
    LEFT JOIN VENTA v ON c.id_Cliente = v.id_Cliente
    LEFT JOIN DETALLE_VENTA d ON v.id_venta = d.id_venta
    WHERE c.id_Cliente = @idCliente
    GROUP BY 
       c.id_Cliente,
       c.nombre,
       c.apellido,
       c.telefono
);
GO

-- Ejemplo de uso para la grilla de inventario
SELECT * FROM dbo.fn_EstadisticasComprasCliente(1);

--Función para obtener el total de ventas y cantidad de ventas por mes para un año específico
GO
CREATE FUNCTION dbo.fn_VentasAnualesDashboard (@anio INT)
RETURNS @Reporte TABLE 
(
    NroMes INT,
    Mes VARCHAR(15),
    CantidadVentas INT,
    TotalRecaudado DECIMAL(18,2)
)
AS
BEGIN
    -- PASO 1: Generamos los 12 meses arrancando con 0 ventas y $0.
    -- Así nos aseguramos de que el reporte o gráfico en C# siempre tenga 12 filas.
    DECLARE @contadorMes INT = 1;
    WHILE @contadorMes <= 12
    BEGIN
        INSERT INTO @Reporte (NroMes, Mes, CantidadVentas, TotalRecaudado)
        VALUES (
            @contadorMes, 
            CHOOSE(@contadorMes, 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'), 
            0, 
            0.00
        );
        SET @contadorMes = @contadorMes + 1;
    END

    -- PASO 2: Volcamos los datos reales de tu tabla VENTA.
    -- (Nota: Si tu columna de fecha se llama distinto, por ejemplo "fecha_venta", cambialo acá abajo).
    UPDATE r
    SET r.CantidadVentas = v.Cant,
        r.TotalRecaudado = v.Total
    FROM @Reporte r
    INNER JOIN (
        SELECT 
            MONTH(fecha_hora) AS mes_venta, 
            COUNT(id_venta) AS Cant,
            SUM(monto_total) AS Total
        FROM VENTA
        WHERE YEAR(fecha_hora) = @anio       
        GROUP BY MONTH(fecha_hora)
    ) v ON r.NroMes = v.mes_venta;

    RETURN;
END;
GO

-- Ejemplo de uso para llenar el gráfico del Dashboard en C#:
SELECT * FROM dbo.fn_VentasAnualesDashboard(2026);
GO