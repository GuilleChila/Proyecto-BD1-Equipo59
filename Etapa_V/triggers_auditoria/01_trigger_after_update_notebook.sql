-- TRIGGER 1: AUDITORÍA DE MODIFICACIONES EN NOTEBOOK
-- Tabla:     NOTEBOOK
-- Tipo:      AFTER UPDATE
-- Objetivo:  Cuando se modifica cualquier dato de una notebook,
--            guarda automáticamente un historial con los valores anteriores
--            y nuevos, además de la fecha, hora en la que se produjeron los cambios y el usuario que hizo el cambio
USE LaptopDeel;
GO




-- Tabla de auditoría: sirve  como un historial para guardar y consultar los cambios realizados sobre los registros de la tabla notebook
CREATE TABLE AUDITORIA_NOTEBOOK (
    id_auditoria                INT IDENTITY(1,1) PRIMARY KEY,
    id_notebook                 INT NOT NULL,
marca_anterior               VARCHAR(50) NOT NULL,
    marca_nueva                  VARCHAR(50) NOT NULL,
modelo_anterior              VARCHAR(50) NOT NULL,
    modelo_nuevo                 VARCHAR(50) NOT NULL,
precio_anterior              DECIMAL(12,2) NOT NULL,
    precio_nuevo                 DECIMAL(12,2) NOT NULL,
stock_anterior                INT NOT NULL,
    stock_nuevo                   INT NOT NULL,
id_procesador_anterior        INT NOT NULL,
    id_procesador_nuevo           INT NOT NULL,
id_pantalla_anterior          INT NOT NULL,
    id_pantalla_nuevo             INT NOT NULL,
id_tarjeta_grafica_anterior   INT NULL,
    id_tarjeta_grafica_nuevo      INT NULL,
fecha_hora                    DATETIME2 NOT NULL,
    usuario_sql                   SYSNAME NOT NULL
);
GO




-- Trigger: se dispara automáticamente después de cada UPDATE sobre NOTEBOOK
CREATE TRIGGER trg_AuditoriaNotebook
ON dbo.NOTEBOOK
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
-- "deleted" tabla temporal que tiene los valores ANTERIORES (antes del UPDATE)
-- "inserted" tabla temporal que tiene los valores NUEVOS (después del UPDATE)
-- Se unen por id_notebook porque un mismo UPDATE puede modificar varias notebooks a la vez
    INSERT INTO dbo.AUDITORIA_NOTEBOOK (
        id_notebook,
        marca_anterior, marca_nueva,
        modelo_anterior, modelo_nuevo,
        precio_anterior, precio_nuevo,
        stock_anterior, stock_nuevo,
        id_procesador_anterior, id_procesador_nuevo,
        id_pantalla_anterior, id_pantalla_nuevo,
        id_tarjeta_grafica_anterior, id_tarjeta_grafica_nuevo,
        fecha_hora,
        usuario_sql
    )
    SELECT
        d.id_notebook,
        d.marca, i.marca,
        d.modelo, i.modelo,
        d.precio, i.precio,
        d.stock, i.stock,
        d.id_procesador, i.id_procesador,
        d.id_pantalla, i.id_pantalla,
        d.id_tarjeta_grafica, i.id_tarjeta_grafica,
        SYSDATETIME(),      -- fecha y hora real del servidor
        SUSER_SNAME()        -- usuario de SQL Server que hizo el cambio
    FROM deleted d
    INNER JOIN inserted i 
    ON d.id_notebook = i.id_notebook;
END;
GO




-- PRUEBA: Modificar precio y modelo de una notebook
-- Paso 1: Estado de la notebook 1 ANTES del cambio
SELECT *
FROM NOTEBOOK
WHERE id_notebook = 1;
-- Paso 2: Se modifica el precio y modelo. Esto dispara el trigger automáticamente
UPDATE NOTEBOOK
SET
    precio = precio + 10000,
    modelo = 'IdeaPad 5'
WHERE id_notebook = 1;
-- Paso 3: Se verifica que el cambio se aplicó en NOTEBOOK
SELECT *
FROM NOTEBOOK
WHERE id_notebook = 1;
-- Paso 4: Se verifica que el trigger registró el cambio en la auditoría, sin que nosotros hayamos hecho ningún INSERT manual
SELECT *
FROM AUDITORIA_NOTEBOOK
WHERE id_notebook = 1
ORDER BY id_auditoria DESC;
