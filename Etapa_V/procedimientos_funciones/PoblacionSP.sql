use LaptopDeel;
-- SCRIPT 2: POBLACIÓN CON STORED PROCEDURES + MÉTRICAS

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- 2. Variables para medir el tiempo transcurrido con precisión
DECLARE @Inicio DATETIME2 = SYSDATETIME();
DECLARE @Fin DATETIME2;

-- Variables auxiliares para capturar los IDs generados en las maestras
DECLARE @id_proc1 INT, @id_proc2 INT;
DECLARE @id_pant1 INT, @id_pant2 INT;
DECLARE @id_tg1 INT,   @id_tg2 INT;
DECLARE @id_ram1 INT,  @id_ram2 INT;
DECLARE @id_alm1 INT,  @id_alm2 INT;
DECLARE @id_cat1 INT;

-- Variable para capturar el ID de la notebook insertada mediante el SP
DECLARE @NewNotebookID INT;

PRINT '--------------------------------------------------';
PRINT 'INICIANDO CARGA DE DATOS MEDIANTE STORED PROCEDURES...';
PRINT '--------------------------------------------------';

BEGIN TRANSACTION;
BEGIN TRY


    
    -- Procesadores
    INSERT INTO PROCESADOR (marca, generacion, velocidad, nucleos, hilos, tiene_grafica) VALUES ('Intel', '12th Gen', 3.5, 10, 16, 1);
    SET @id_proc1 = SCOPE_IDENTITY();

    INSERT INTO PROCESADOR (marca, generacion, velocidad, nucleos, hilos, tiene_grafica) VALUES ('AMD', 'Ryzen 7', 3.2, 8, 16, 1);
    SET @id_proc2 = SCOPE_IDENTITY();

    -- Pantallas
    INSERT INTO PANTALLA (pulgadas, tipo, tactil, tasa_refresco) VALUES (15.6, 'IPS', 0, 144);
    SET @id_pant1 = SCOPE_IDENTITY();

    INSERT INTO PANTALLA (pulgadas, tipo, tactil, tasa_refresco) VALUES (17.3, 'OLED', 0, 240);
    SET @id_pant2 = SCOPE_IDENTITY();

    -- Tarjetas Gráficas
    INSERT INTO TARJETA_GRAFICA (marca, modelo, vram_capacidad, tipo_memoria) VALUES ('NVIDIA', 'RTX 3060', 6, 'GDDR6');
    SET @id_tg1 = SCOPE_IDENTITY();

    INSERT INTO TARJETA_GRAFICA (marca, modelo, vram_capacidad, tipo_memoria) VALUES ('NVIDIA', 'RTX 3070 Ti', 8, 'GDDR6X');
    SET @id_tg2 = SCOPE_IDENTITY();

    -- Memorias RAM
    INSERT INTO RAM (generacion, capacidad, velocidad) VALUES ('DDR4', 16, 3200);
    SET @id_ram1 = SCOPE_IDENTITY();

    INSERT INTO RAM (generacion, capacidad, velocidad) VALUES ('DDR5', 32, 4800);
    SET @id_ram2 = SCOPE_IDENTITY();

    -- Almacenamiento
    INSERT INTO ALMACENAMIENTO (tipo, capacidad, velocidad) VALUES ('NVMe M.2 SSD', 512, 3500);
    SET @id_alm1 = SCOPE_IDENTITY();

    INSERT INTO ALMACENAMIENTO (tipo, capacidad, velocidad) VALUES ('NVMe M.2 SSD', 1000, 7000);
    SET @id_alm2 = SCOPE_IDENTITY();

    -- Categorías (si tu esquema usa la tabla intermedia NOTEBOOK_CATEGORIA)
    INSERT INTO CATEGORIA (nombre, descripcion) VALUES ('Gaming', 'Laptops de alto rendimiento para juegos y diseño gráfico');
    SET @id_cat1 = SCOPE_IDENTITY();

    
    EXEC SP_Notebooks_Insertar 
        @p_id_ram = @id_ram1, 
        @p_id_procesador = @id_proc1, 
        @p_id_almacenamiento = @id_alm1, 
        @p_id_pantalla = @id_pant1, 
        @p_marca = 'Asus', 
        @p_modelo = 'ROG Strix G15', 
        @p_precio = 1250.00, 
        @p_stock = 10, 
        @p_id_tarjetaGrafica = @id_tg1;

    -- Inserción Notebook 2
    EXEC SP_Notebooks_Insertar 
        @p_id_ram = @id_ram2, 
        @p_id_procesador = @id_proc2, 
        @p_id_almacenamiento = @id_alm2, 
        @p_id_pantalla = @id_pant2, 
        @p_marca = 'Lenovo', 
        @p_modelo = 'Legion 5 Pro', 
        @p_precio = 1650.00, 
        @p_stock = 7, 
        @p_id_tarjetaGrafica = @id_tg2;


    
    -- Actualizamos la notebook con ID 1 (ajustando precio y stock)
    EXEC SP_Notebooks_Actualizar 
        @p_id_notebook = 1, 
        @p_id_ram = @id_ram1, 
        @p_id_procesador = @id_proc1, 
        @p_id_almacenamiento = @id_alm1, 
        @p_id_pantalla = @id_pant1, 
        @p_marca = 'Asus', 
        @p_modelo = 'ROG Strix G15 (Updated)', 
        @p_precio = 1200.00, 
        @p_stock = 12, 
        @p_id_tarjetaGrafica = @id_tg1;

    EXEC SP_Notebooks_Desactivar @p_id_notebook = 2;


    -- Confirmamos transacción
    COMMIT TRANSACTION;
    PRINT '¡Transacción con Stored Procedures completada con éxito!';

END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error detectado en Stored Procedures. Se ejecutó ROLLBACK.';
    PRINT ERROR_MESSAGE();
END CATCH;

-- 3. Calcular tiempo final transcurrido
SET @Fin = SYSDATETIME();

-- Desactivar estadísticas
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

-- 4. Mostrar el resultado comparativo en pantalla
SELECT 
    'Procedimientos Almacenados' AS Metodo_Utilizado,
    DATEDIFF(millisecond, @Inicio, @Fin) AS Tiempo_Total_Milisegundos;