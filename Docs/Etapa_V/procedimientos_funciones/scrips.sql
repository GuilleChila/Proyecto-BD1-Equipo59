use LaptopDeel;

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