# Documentación de Pruebas de Transacciones y Atomicidad

A continuación se detallan las pruebas realizadas sobre la base de datos LaptopDeel para demostrar el manejo de transacciones, el control de errores y la propiedad de atomicidad.

## Prueba 1: Transacción Exitosa (COMMIT)
- **Objetivo:** Demostrar que una venta con stock suficiente se guarda correctamente.
- **Procedimiento:** Se ejecutó `dbo.RegistrarVenta` con cantidad = 1 para la notebook ID 1.
- **Resultado:** La transacción finalizó con `COMMIT`. Se verificó en las tablas `VENTA` y `NOTEBOOK` que el encabezado y detalle de la venta fueron creados, y que el stock disminuyó exactamente en 1 unidad (de 9 a 8).
- **Evidencia:** Fotos `evidencia1_commit_exitoso.png` y `evidencia3_commit_exitoso_tablas.png`.

## Prueba 2: Transacción Fallida con Error Intencional (ROLLBACK)
- **Objetivo:** Demostrar que si ocurre un fallo a mitad de la operación, la base de datos se revierte por completo.
- **Procedimiento:** Se ejecutó `dbo.RegistrarVenta` solicitando 50 unidades de la notebook ID 1 (el stock actual es 8).
- **Resultado:** El procedimiento detectó la falta de stock y lanzó un `THROW`. El bloque `CATCH` capturó el error, verificó `@@TRANCOUNT > 0` y ejecutó `ROLLBACK`.
- **Verificación:** Al consultar la base, se confirmó que **no se registró ninguna venta nueva** de 50 unidades y el stock **se mantuvo en 8**. Los datos quedaron totalmente consistentes.
- **Evidencia:** Fotos `evidencia4_rollback.png` y `evidencia5_rollback_datos_intactos.png`.

## Conclusión
Las pruebas confirman que la implementación del bloque `TRY...CATCH` junto con `ROLLBACK` y `COMMIT` asegura que el sistema LaptopDeel sea robusto frente a errores lógicos (como intentar vender sin stock), evitando la corrupción de datos en el inventario y la facturación.