-- TEMA: OPTIMIZACIÓN DE CONSULTAS A TRAVÉS DE ÍNDICES
-- Objetivo: medir cómo cambia el rendimiento de una consulta por período
--           sobre una tabla con 1.000.000 de registros en tres escenarios:
--             A) sin índice
--             B) con un índice agrupado (clustered) sobre la fecha
--             C) con un índice no agrupado de cobertura (fecha + INCLUDE)





-- CREACIÓN DE LA TABLA DE PRUEBA
USE LaptopDeel;
GO

-- Se trabaja sobre una tabla de prueba (VENTA_HISTORICA) y no sobre VENTA,
-- porque VENTA ya tiene un índice agrupado en su clave primaria y una tabla
-- solo puede tener un índice agrupado.

-- Estructura similar a VENTA, con un campo fecha SIN índice.
-- La clave primaria se declara NONCLUSTERED a propósito: así la tabla no
-- tiene índice agrupado y se puede crear uno más adelante (Escenario B).
CREATE TABLE VENTA_HISTORICA (
    id_venta    BIGINT IDENTITY(1,1) NOT NULL,
    fecha_venta DATE NOT NULL,
    monto_total DECIMAL(12,2) NOT NULL,
    id_usuario  INT NOT NULL,
    id_Cliente  INT NOT NULL,
    CONSTRAINT PK_VentaHistorica PRIMARY KEY NONCLUSTERED (id_venta)
);
GO






-- CARGA MASIVA DE 1.000.000 DE REGISTROS

-- Cada fila tiene una fecha al azar entre 2020-01-01 y 2024-12-30,
-- un monto al azar y un usuario/cliente al azar entre 1 y 8.
WITH Numeros AS (
    SELECT TOP (1000000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)
INSERT INTO VENTA_HISTORICA (fecha_venta, monto_total, id_usuario, id_Cliente)
SELECT
    DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 1825), '2020-01-01'),
    ABS(CHECKSUM(NEWID()) % 1500000) + 50000,
    ABS(CHECKSUM(NEWID()) % 8) + 1,
    ABS(CHECKSUM(NEWID()) % 8) + 1
FROM Numeros;
GO

-- Verificaciones de la carga
SELECT COUNT(*) AS CantidadRegistros   
FROM VENTA_HISTORICA;

SELECT TOP 10 *
FROM VENTA_HISTORICA;

EXEC sp_helpindex 'VENTA_HISTORICA';   -- solo debe figurar el índice de la clave primaria
GO









-- ESCENARIO A - CONSULTA SIN ÍNDICE

-- Antes de cada medición se ejecuta "CHECKPOINT; DBCC DROPCLEANBUFFERS;" para
-- limpiar la memoria y que cada escenario parta en igualdad de condiciones
-- (usar solamente en un equipo de pruebas).
-- En SSMS, activar el plan de ejecución real con Ctrl+M antes de cada consulta.

SET STATISTICS TIME ON;   -- mide tiempo de CPU y tiempo total
SET STATISTICS IO ON;     -- mide lecturas lógicas
GO

CHECKPOINT;
DBCC DROPCLEANBUFFERS;
GO

-- Ventas del primer trimestre de 2023.
SELECT
    id_venta,
    fecha_venta,
    monto_total
FROM VENTA_HISTORICA
WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-03-31';











-- ESCENARIO B - ÍNDICE AGRUPADO SOBRE LA FECHA

-- Ordena físicamente la tabla por fecha_venta.
CREATE CLUSTERED INDEX IX_VentaHistorica_Fecha
ON VENTA_HISTORICA(fecha_venta);
GO

CHECKPOINT;
DBCC DROPCLEANBUFFERS;
GO

-- Misma consulta.
SELECT
    id_venta,
    fecha_venta,
    monto_total
FROM VENTA_HISTORICA
WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-03-31';










-- ESCENARIO C - ÍNDICE NO AGRUPADO CON COBERTURA

-- BORRAR EL ÍNDICE AGRUPADO
DROP INDEX IX_VentaHistorica_Fecha
ON VENTA_HISTORICA;
GO

-- Indexa por fecha_venta e INCLUYE las demás columnas que pide la consulta,
-- para que SQL Server pueda responder usando solamente el índice, sin
-- acceder a la tabla
CREATE NONCLUSTERED INDEX IX_VentaHistorica_Fecha_Cobertura
ON VENTA_HISTORICA(fecha_venta)
INCLUDE (id_venta, monto_total);
GO

CHECKPOINT;
DBCC DROPCLEANBUFFERS;
GO

-- Misma consulta
SELECT
    id_venta,
    fecha_venta,
    monto_total
FROM VENTA_HISTORICA
WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-03-31';
