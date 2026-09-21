Reglas de negocio

Stock
	• RN.01: No se puede confirmar una venta si la cantidad solicitada supera el stock disponible de una notebook.
	• RN.02: La actualización de decremento del stock se ejecutará al confirmarse la venta. Si la transacción de la venta falla o se cancela antes de su confirmación, el stock retenido temporalmente debe liberarse en el acto. 
	• RN.03: Toda notebook con 3 unidades o menos en stock debe ser señalada como "stock bajo" al vendedor durante la venta.
	• RN.04: Todo incremento de Stock en la entidad Notebook debe ser registrado por un Usuario Administrador del sistema. 
	
Precios
	• RN.05: El precio unitario en el detalle de venta se registra con el valor actual del Precio de la Notebook al momento exacto de la transacción. 
	• RN.06: Cualquier actualización o cambio en el precio de lista de una Notebook no afectará a las ventas ya concretadas 
	• RN.07: El monto total en la Venta debe reflejar la suma aritmética de los valores subtotales de notebook asociadas en el Detalle de venta. 
	
	
Clientes
	• RN.08: Todo cliente debe estar debidamente registrado en el sistema antes de asociarlo a una operación de venta. 
	
Ventas
	• RN.09: Toda venta debe registrarse con un método de pago válido y previamente definido. No se admiten ventas sin método de pago.
	• RN.10: Toda orden de venta debe expirar y liberar el stock retenido temporalmente si no es confirmada o pagada en un lapso máximo de 15 minutos desde su creación en el mostrador.
	• RN.11: Toda Venta debe estar vinculada obligatoriamente a un Usuario vendedor.
	• RN.12: Una venta confirmada no puede modificarse ni eliminarse. Solo puede ser anulada por un Administrador, quedando registrada como anulada, y las unidades vendidas vuelven al stock.
  • RN.13: Una notebook solo puede venderse si tiene registrados marca, modelo, procesador, memoria RAM, almacenamiento, tarjeta gráfica, pantalla y precio de lista.
