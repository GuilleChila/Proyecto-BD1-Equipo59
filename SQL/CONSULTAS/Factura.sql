--ENCABEZADO DE LA FACTURA
DECLARE @id_venta INT = 1; -- Cambiar por el numero de venta a facturar 
--Funciona como un parámetro para definir de qué venta concreta se quieren obtener los datos
SELECT
    v.id_venta                          AS [Nro. Factura],
    v.fecha_hora                        AS [Fecha y Hora],
    v.estado                            AS [Estado],
    u.Nombre + ' ' + u.Apellido         AS [Vendedor],
    c.nombre + ' ' + c.apellido         AS [Cliente],
    c.DNI                               AS [DNI Cliente],
    c.IVA                               AS [Condición IVA],
    c.Direccion                         AS [Dirección],
    ISNULL(vmp.metodo_pago, '—')        AS [Método de Pago] -- Si el cliente no tiene un método registrado (es decir, el valor es NULL), la función ISNULL lo reemplaza por un guion
FROM VENTA v
INNER JOIN USUARIO u               ON v.id_usuario = u.id_usuario
INNER JOIN CLIENTE c               ON v.id_Cliente = c.id_Cliente
LEFT  JOIN VENTA_METODO_PAGO vmp   ON v.id_venta = vmp.id_venta -- Esto garantiza que, incluso si la venta aún no tiene asignado un método de pago, la venta se siga mostrando en el resultado
WHERE v.id_venta = @id_venta;
