use LaptopDeel; 


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
            MONTH(fecha) AS mes_venta, 
            COUNT(id_venta) AS Cant,
            SUM(monto_total) AS Total
        FROM VENTA
        WHERE YEAR(fecha) = @anio       
        GROUP BY MONTH(fecha)
    ) v ON r.NroMes = v.mes_venta;

    RETURN;
END;
GO

-- Ejemplo de uso para llenar el gráfico del Dashboard en C#:
SELECT * FROM dbo.fn_VentasAnualesDashboard(2026);
GO