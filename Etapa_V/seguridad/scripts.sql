USE LaptopDeel;
GO
-- ==============================================================================
-- PARTE 1: PERMISOS A NIVEL DE USUARIOS
-- ==============================================================================
-- Crear los Logins (usuarios del servidor)
CREATE LOGIN usuario_admin WITH PASSWORD = 'Admin123*';
CREATE LOGIN usuario_lector WITH PASSWORD = 'Lector123*';
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

-- ==============================================================================
-- PARTE 2: PERMISOS A NIVEL DE ROLES
-- ==============================================================================
CREATE LOGIN usuario_con_rol WITH PASSWORD = 'Rol123*';
CREATE LOGIN usuario_sin_rol WITH PASSWORD = 'Rol456*';
GO

CREATE USER usuario_con_rol FOR LOGIN usuario_con_rol;
CREATE USER usuario_sin_rol FOR LOGIN usuario_sin_rol;
GO

CREATE ROLE rol_consulta_notebooks;
GRANT SELECT ON dbo.NOTEBOOK TO rol_consulta_notebooks;
GO

ALTER ROLE rol_consulta_notebooks ADD MEMBER usuario_con_rol;
GO

-- ==============================================================================
-- PRUEBAS DE SEGURIDAD
-- ==============================================================================

--PRUEBA 1: INSERT DIRECTO (Usuario Lector - DEBE FALLAR)';
EXECUTE AS USER = 'usuario_lector';
INSERT INTO VENTA (estado, monto_total, id_usuario, id_Cliente) VALUES ('Pendiente', 100, 1, 1);
REVERT;
GO

--'PRUEBA 2: INSERT MEDIANTE SP (Usuario Lector - DEBE FUNCIONAR)';
EXECUTE AS USER = 'usuario_lector';
EXEC dbo.sp_RegistrarVentaSimple 1, 2, 1, 1, 'Transferencia';
REVERT;
GO

--'PRUEBA 3: SELECT EN NOTEBOOK (Usuario CON Rol - DEBE FUNCIONAR)';
EXECUTE AS USER = 'usuario_con_rol';
SELECT TOP 2 id_notebook, marca, modelo FROM NOTEBOOK;
REVERT;
GO

--'PRUEBA 4: SELECT EN NOTEBOOK (Usuario SIN Rol - DEBE FALLAR)';
EXECUTE AS USER = 'usuario_sin_rol';
SELECT TOP 2 id_notebook, marca, modelo FROM NOTEBOOK;
REVERT;
GO
