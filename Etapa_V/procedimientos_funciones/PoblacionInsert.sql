use LaptopDeel;
-- SCRIPT: POBLACIÓN CON INSERTs DIRECTOS + MÉTRICAS

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- 2. Variables para medir el tiempo transcurrido con precisión
DECLARE @Inicio DATETIME2 = SYSDATETIME();
DECLARE @Fin DATETIME2;

PRINT '--------------------------------------------------';
PRINT 'INICIANDO CARGA DE DATOS MEDIANTE INSERTs DIRECTOS...';
PRINT '--------------------------------------------------';

BEGIN TRANSACTION;
BEGIN TRY
    
 
    INSERT INTO PROCESADOR (marca, generacion, velocidad, nucleos, hilos, tiene_grafica) VALUES 
    ('Intel', '12th Gen', 3.5, 10, 16, 1),
    ('AMD', 'Ryzen 7', 3.2, 8, 16, 1);

    -- Pantallas
    INSERT INTO PANTALLA (pulgadas, tipo, tactil, tasa_refresco) VALUES 
    (15.6, 'IPS', 0, 144),
    (17.3, 'OLED', 0, 240);

    -- Tarjetas Gráficas (vram_capacidad como número entero)
    INSERT INTO TARJETA_GRAFICA (marca, modelo, vram_capacidad, tipo_memoria) VALUES 
    ('NVIDIA', 'RTX 3060', 6, 'GDDR6'),
    ('NVIDIA', 'RTX 3070 Ti', 8, 'GDDR6X');

    -- Memorias RAM (capacidad y velocidad como números enteros)
    INSERT INTO RAM (generacion, capacidad, velocidad) VALUES 
    ('DDR4', 16, 3200),
    ('DDR5', 32, 4800);

    -- Almacenamiento (capacidad y velocidad como números enteros)
    INSERT INTO ALMACENAMIENTO (tipo, capacidad, velocidad) VALUES 
    ('NVMe M.2 SSD', 512, 3500),
    ('NVMe M.2 SSD', 1000, 7000);

    -- Categorías
    INSERT INTO CATEGORIA (nombre, descripcion) VALUES 
    ('Gaming', 'Laptops de alto rendimiento para juegos y diseño gráfico'),
    ('Trabajo', 'Laptops optimizadas para productividad y portabilidad');
  
    INSERT INTO NOTEBOOK (marca, modelo, precio, stock, id_procesador, id_pantalla, id_tarjeta_grafica) VALUES 
    ('Asus', 'ROG Strix G15', 1250.00, 10, 1, 1, 1),
    ('Lenovo', 'Legion 5 Pro', 1650.00, 7, 2, 2, 2);

    
    -- Relación Notebook - Categoría
    INSERT INTO NOTEBOOK_CATEGORIA (id_notebook, id_categoria) VALUES (1, 1), (2, 1);

    -- Relación Notebook - RAM
    INSERT INTO NOTEBOOK_RAM (id_notebook, id_ram) VALUES (1, 1), (2, 2);

    -- Relación Notebook - Almacenamiento
    INSERT INTO NOTEBOOK_ALMACENAMIENTO (id_notebook, id_almacenamiento) VALUES (1, 1), (2, 2);

    -- Si todo sale bien, confirmamos la transacción
    COMMIT TRANSACTION;
    PRINT '¡Transacción completada con éxito!';

END TRY
BEGIN CATCH
    -- Si ocurre un error, deshacemos todo para no dejar la BD inconsistente
    ROLLBACK TRANSACTION;
    PRINT 'Error detectado. Se ha realizado un ROLLBACK.';
    PRINT ERROR_MESSAGE();
END CATCH;

-- 3. Calcular el tiempo final transcurrido
SET @Fin = SYSDATETIME();

-- Desactivar estadísticas para limpiar la salida
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

-- 4. Mostrar el resultado en pantalla (Pestaña Resultados)
SELECT 
    'INSERTs Directos' AS Metodo_Utilizado,
    DATEDIFF(millisecond, @Inicio, @Fin) AS Tiempo_Total_Milisegundos;