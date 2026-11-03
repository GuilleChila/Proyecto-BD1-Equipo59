USE LaptopDeel;
GO
-- Crear los Logins (usuarios del servidor)
CREATE LOGIN usuario_admin WITH PASSWORD = 'Admin123*';
CREATE LOGIN usuario_lector WITH PASSWORD = 'Lector123*';
GO

GO
-- Crear los Usuarios en la base de datos
CREATE USER usuario_admin FOR LOGIN usuario_admin;
CREATE USER usuario_lector FOR LOGIN usuario_lector;
GO

-- Asignar permisos
ALTER ROLE db_owner ADD MEMBER usuario_admin; -- Admin puede hacer todo
GRANT SELECT ON dbo.NOTEBOOK TO usuario_lector; -- Lector solo puede leer catálogo
GRANT EXECUTE ON dbo.sp_RegistrarVentaSimple TO usuario_lector; -- Y ejecutar ventas
GO

-- =========================================================
-- PRUEBAS (Simulando iniciar sesión como usuario_lector)
-- =========================================================
-- 1. Intento de INSERT directo (DEBE FALLAR)
EXECUTE AS USER = 'usuario_lector';
INSERT INTO VENTA (estado, monto_total, id_usuario, id_Cliente) VALUES ('Pendiente', 100, 1, 1);
REVERT;
GO
-- Resultado esperado: The INSERT permission was denied 

-- 2. Ejecución del Procedimiento (DEBE FUNCIONAR)
EXECUTE AS USER = 'usuario_lector';
EXEC dbo.sp_RegistrarVentaSimple 1, 2, 1, 1, 'Efectivo';
REVERT;
GO
-- Resultado esperado: Venta registrada.
