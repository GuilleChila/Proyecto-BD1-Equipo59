-- TRIGGER 2: AUDITORÍA DE ELIMINACIÓN DE CLIENTES
-- Tabla:     CLIENTE
-- Tipo:      AFTER DELETE
-- Objetivo:  Cuando se elimina un cliente, se guarda automáticamente una copia
--            de sus datos en una tabla de auditoría, junto con la fecha,
--            hora y usuario que realizó la eliminación.
USE LaptopDeel;
GO




-- Tabla de auditoría: guarda una copia de los datos del cliente eliminado
CREATE TABLE AUDITORIA_CLIENTE (
    id_auditoria   INT IDENTITY(1,1) PRIMARY KEY,
    id_Cliente     INT NOT NULL,
nombre         VARCHAR(50) NOT NULL,
    apellido       VARCHAR(50) NOT NULL,
    Correo         VARCHAR(100) NULL,
    Telefono       VARCHAR(20) NULL,
    Direccion      VARCHAR(150) NULL,
    IVA            VARCHAR(30) NULL,
    DNI            VARCHAR(10) NOT NULL,
fecha_hora     DATETIME2 NOT NULL,
    usuario_sql    SYSNAME NOT NULL
);
GO




-- Trigger: se dispara automáticamente después de cada DELETE sobre CLIENTE
CREATE TRIGGER trg_AuditoriaEliminarCliente
ON dbo.CLIENTE
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
-- "deleted" es una tabla temporal que contiene los registros que se acaban de eliminar. 
    INSERT INTO dbo.AUDITORIA_CLIENTE (
        id_Cliente,
        nombre,
        apellido,
        Correo,
        Telefono,
        Direccion,
        IVA,
        DNI,
        fecha_hora,
        usuario_sql
    )
    SELECT
        d.id_Cliente,
        d.nombre,
        d.apellido,
        d.Correo,
        d.Telefono,
        d.Direccion,
        d.IVA,
        d.DNI,
        SYSDATETIME(),    -- fecha y hora real del servidor
        SUSER_SNAME()      -- usuario de SQL Server que hizo el borrado
    FROM deleted d;
END;
GO




-- PRUEBA: Eliminar un cliente 
-- Paso 1: Se crea un cliente exclusivo para la prueba
SELECT *
FROM CLIENTE
WHERE DNI = '99999999';
INSERT INTO CLIENTE (nombre, apellido, DNI)
VALUES ('Chavarria', 'Tomas', '99999999');
-- Paso 2: Estado ANTES de eliminar
SELECT *
FROM CLIENTE
WHERE DNI = '99999999';
-- Paso 3: Se elimina al cliente de prueba. Esto dispara el trigger
DELETE FROM CLIENTE
WHERE DNI = '99999999';
-- Paso 4: Verificamos que el cliente ya NO está en CLIENTE en la tabla
-- Resultado: sin registro
SELECT *
FROM CLIENTE
WHERE DNI = '99999999';
-- Paso 5: Verificamos que sus datos SÍ quedaron en la auditoría
SELECT *
FROM AUDITORIA_CLIENTE
WHERE DNI = '99999999';
-- Resultado: una fila con los datos del cliente eliminado, más fecha, hora y usuario
