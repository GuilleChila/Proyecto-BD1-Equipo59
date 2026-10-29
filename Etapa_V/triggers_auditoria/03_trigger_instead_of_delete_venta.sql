-- TRIGGER 3: BLOQUEO DE ELIMINACIÓN DE VENTAS
-- Tabla:     VENTA
-- Tipo:      INSTEAD OF DELETE
-- Objetivo:  Las ventas no se eliminan físicamente de la base de datos.
--            Forman parte del historial comercial de LaptopDeel.
--            Si se necesita cancelar una venta, se debe cambiar su estado
--            a 'Anulada', no borrar el registro.
USE LaptopDeel;
GO




CREATE TRIGGER trg_ImpedirEliminarVenta
ON VENTA
-- Cuando alguien intenta eliminar una venta, SQL Server ejecutará el código del trigger en lugar de ejecutar la eliminación
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;
-- "deleted" es una tabla temporal que contiene las filas que se intentaron eliminar.
    -- Si hay al menos un registro en esa tabla, significa que alguien ejecutó un DELETE sobre la tabla VENTA.
    IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        -- THROW reemplaza al DELETE original y no ejecuta ninguna instrucción para eliminar la venta, el registro permanece en tabla ventas
        THROW 50001,
            'No se permite eliminar ventas. Para cancelar una venta, cambie su estado a Anulada.',
            1;
    END
END;
GO




-- PRUEBA: Intento para eliminar una venta
-- Paso 1: Estado de la venta 1 ANTES del intento de eliminación
-- Resultado: la venta 1 existe, estado = 'Confirmada'
SELECT *
FROM VENTA
WHERE id_venta = 1;
-- Paso 2: Intento de eliminacion de la venta 1. Se va a disparar el trigger
-- Resultado: SQL Server NO ejecuta el borrado del registro y da el mensaje de error que definí en el trigger
DELETE FROM VENTA
WHERE id_venta = 1;
-- Paso 3: Estado DESPUÉS del intento de eliminación. Debe ser IDÉNTICO al Paso 1
-- Resultado : la fila sigue existiendo
SELECT *
FROM VENTA
WHERE id_venta = 1;
