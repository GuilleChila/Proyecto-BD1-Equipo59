use LaptopDeel;

SELECT 
    c.nombre AS Categoria,
    n.marca AS Marca,
    n.modelo AS Modelo,
    SUM(dv.cantidad) AS Total_Unidades_Vendidas,
    SUM(dv.subtotal) AS Total_Recaudado
FROM dbo.CATEGORIA as c
INNER JOIN NOTEBOOK_CATEGORIA as nc ON c.id_categoria = nc.id_categoria
INNER JOIN NOTEBOOK as n ON nc.id_notebook = n.id_notebook
INNER JOIN DETALLE_VENTA as dv ON n.id_notebook = dv.id_notebook
GROUP BY 
    c.id_categoria, 
    c.nombre, 
    n.id_notebook, 
    n.marca, 
    n.modelo
HAVING 
    SUM(dv.cantidad) >= 1
ORDER BY 
    Categoria ASC, 
    Total_Unidades_Vendidas DESC;