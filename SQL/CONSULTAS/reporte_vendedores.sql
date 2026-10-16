-- REPORTE POR VENDEDOR / GERENTE
DECLARE @fecha_desde DATE = '2026-01-01';
DECLARE @fecha_hasta DATE = '2026-12-31';

SELECT
    u.id_usuario,
    u.Nombre + ' ' + u.Apellido         AS [Vendedor],
    r.descripcion                       AS [Rol],
    COUNT(v.id_venta)                   AS [Cantidad de Ventas],
    ISNULL(SUM(v.monto_total), 0)       AS [Total Facturado],
    ISNULL(AVG(v.monto_total), 0)       AS [Promedio por Venta],
    ISNULL(MAX(v.monto_total), 0)       AS [Venta Máxima]
FROM USUARIO u
INNER JOIN ROL r       ON u.id_Rol = r.id_Rol
LEFT  JOIN VENTA v     ON u.id_usuario = v.id_usuario AND v.estado = 'Confirmada' AND CAST(v.fecha_hora AS DATE) BETWEEN @fecha_desde AND @fecha_hasta
WHERE r.descripcion IN ('Vendedor', 'Gerente')
GROUP BY u.id_usuario, u.Nombre, u.Apellido, r.descripcion
ORDER BY [Total Facturado] DESC;
GO
