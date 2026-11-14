
-- FUNCIONES ALMACENADAS


-- FUNCIÓN 1: clasifica el stock de una notebook en una alerta de inventario
CREATE OR ALTER FUNCTION dbo.fn_EvaluarEstadoStock (@stockActual INT)
RETURNS VARCHAR(20)
AS
BEGIN
    RETURN CASE
        WHEN @stockActual = 0  THEN 'AGOTADO'
        WHEN @stockActual <= 5  THEN 'CRÍTICO'
        WHEN @stockActual <= 15 THEN 'BAJO'
        ELSE 'NORMAL'
    END;
END;
GO

-- FUNCIÓN 2: estadísticas de compras de un cliente específico
CREATE OR ALTER FUNCTION dbo.fn_EstadisticasComprasCliente (@idCliente INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        c.id_Cliente,
        c.nombre,
        c.apellido,
        c.Telefono,
        ISNULL(SUM(d.subtotal), 0) AS Total_Invertido,
        ISNULL(SUM(d.cantidad), 0) AS Cantidad_Comprada
    FROM CLIENTE c
    LEFT JOIN VENTA v         ON c.id_Cliente = v.id_Cliente
    LEFT JOIN DETALLE_VENTA d ON v.id_venta = d.id_venta
    WHERE c.id_Cliente = @idCliente
    GROUP BY c.id_Cliente, c.nombre, c.apellido, c.Telefono
);
GO

-- FUNCIÓN 3: total de ventas y cantidad de ventas por mes para un año específico
CREATE OR ALTER FUNCTION dbo.fn_VentasAnualesDashboard (@anio INT)
RETURNS @Reporte TABLE
(
    NroMes         INT,
    Mes            VARCHAR(15),
    CantidadVentas INT,
    TotalRecaudado DECIMAL(18,2)
)
AS
BEGIN
    -- Paso 1: se generan los 12 meses con 0 ventas y $0
    DECLARE @contadorMes INT = 1;
    WHILE @contadorMes <= 12
    BEGIN
        INSERT INTO @Reporte (NroMes, Mes, CantidadVentas, TotalRecaudado)
        VALUES (
            @contadorMes,
            CHOOSE(@contadorMes, 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
                                 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'),
            0,
            0.00
        );
        SET @contadorMes = @contadorMes + 1;
    END

    -- Paso 2: se completan los meses con los datos reales de VENTA
    UPDATE r
    SET r.CantidadVentas = v.Cant,
        r.TotalRecaudado = v.Total
    FROM @Reporte r
    INNER JOIN (
        SELECT
            MONTH(fecha_hora) AS mes_venta,
            COUNT(id_venta)   AS Cant,
            SUM(monto_total)  AS Total
        FROM VENTA
        WHERE YEAR(fecha_hora) = @anio
        GROUP BY MONTH(fecha_hora)
    ) v ON r.NroMes = v.mes_venta;

    RETURN;
END;
GO



-- PRUEBA DE LAS FUNCIONES

-- Función 1: alerta de inventario de cada notebook
SELECT marca, modelo, stock, dbo.fn_EvaluarEstadoStock(stock) AS Alerta_Inventario
FROM NOTEBOOK;

-- Función 2: estadísticas de compras del cliente 1
SELECT * FROM dbo.fn_EstadisticasComprasCliente(1);

-- Función 3: ventas por mes del año en curso
SELECT * FROM dbo.fn_VentasAnualesDashboard(YEAR(GETDATE()));
GO
