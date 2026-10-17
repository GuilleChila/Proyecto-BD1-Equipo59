# Reporte agregado por vendedor / gerente

## 1. Necesidad de información que resuelve
Medir el desempeño comercial de cada vendedor y gerente en un período
configurable: cantidad de ventas, facturación total, ticket promedio y
venta máxima. El reporte debe incluir a todo el personal con esos roles,
incluso a quienes no registraron ninguna venta confirmada en el período.

## 2. Estrategia SQL utilizada
- `INNER JOIN` entre `USUARIO` y `ROL`: todo usuario tiene un rol
  obligatorio, así que el JOIN interno no pierde ningún usuario.
- `LEFT JOIN` entre `USUARIO` y `VENTA`: a diferencia del `INNER JOIN`,
  conserva en el resultado a los vendedores que todavía no vendieron en
  el período. Con `INNER JOIN` esos usuarios directamente desaparecerían
  del reporte.
- Las condiciones de `estado = 'Confirmada'` y de rango de fechas van
  dentro del `ON` del `LEFT JOIN`, no en un `WHERE` aparte — si se
  filtraran después con `WHERE`, SQL Server descartaría también las filas
  de vendedores sin ventas (`NULL`), anulando el efecto del `LEFT JOIN`.
- `WHERE r.descripcion IN ('Vendedor', 'Gerente')` limita el universo de
  personas al rol correspondiente.
- `GROUP BY` por vendedor, para que `COUNT`, `SUM`, `AVG` y `MAX` calculen
  un resultado por persona.
- `ISNULL(..., 0)` convierte a 0 los totales de quienes no tienen ventas
  en el período, ya que las funciones de agregación sobre un grupo sin
  filas de `VENTA` devuelven `NULL`.
- Parámetros `@fecha_desde` y `@fecha_hasta` mediante `DECLARE`.

## 3. Resultado esperado
Una fila por cada usuario con rol Vendedor o Gerente, ordenada de mayor a
menor total facturado. Los vendedores sin ventas confirmadas en el
período aparecen igual, con sus columnas en 0, en lugar de quedar
excluidos del listado.
