Reglas de negocio

Stock\
	• RN.01: No se puede confirmar una venta si la cantidad solicitada supera el stock disponible de una notebook.\
	• RN.02: La actualización de decremento del stock se ejecutará al confirmarse la venta. Si la transacción de la venta falla o se cancela antes de su confirmación, el stock retenido temporalmente debe liberarse en el acto. \
	• RN.03: Toda notebook con 3 unidades o menos en stock debe ser señalada como "stock bajo" al vendedor durante la venta.\
	• RN.04: Todo incremento de Stock en la entidad Notebook debe ser registrado por un Usuario Administrador del sistema. \
	\
Precios\
	• RN.05: El precio unitario en el detalle de venta se registra con el valor actual del Precio de la Notebook al momento exacto de la transacción.\
	• RN.06: Cualquier actualización o cambio en el precio de lista de una Notebook no afectará a las ventas ya concretadas \
	• RN.07: El monto total en la Venta debe reflejar la suma aritmética de los valores subtotales de notebook asociadas en el Detalle de venta.\
	
Equipos y Componentes\
	• RN.08: Toda notebook registrada en el sistema debe detallar obligatoriamente qué procesador, memoria RAM, almacenamiento y pantalla tiene.\
	• RN.09: Una notebook puede registrarse sin una tarjeta gráfica dedicada; en ese caso, el sistema asumirá que utiliza la gráfica integrada del procesador. \
 	• RN.10: Toda notebook debe estar clasificada dentro de una única categoría (como Gamer, Oficina o Ultrabook) para mantener organizado el catálogo. \
 	• RN.11: Si el procesador de una notebook no incluye gráficos integrados, el sistema exigirá que se le registre obligatoriamente una tarjeta gráfica dedicada.\

	
Clientes\
	• RN.12: Todo cliente debe estar debidamente registrado en el sistema antes de asociarlo a una operación de venta. \
	• RN.13: Todo usuario registrado en el sistema debe tener asignado un único rol que defina claramente sus permisos (por ejemplo, 	Vendedor o Administrador).\
	• RN.14: No se puede registrar a un usuario si su DNI o correo electrónico ya están vinculados a otra cuenta existente en el sistema.\
	• RN.15: No se puede registrar más de una vez al mismo cliente basándose en su DNI, CUIT o condición frente al IVA. \
	• RN.16: Todo cliente puede tener registrados múltiples números de teléfono y correos electrónicos para asegurar diferentes formas de contacto.\
	
Ventas\
	• RN.17: Toda venta debe registrarse con un método de pago válido y previamente definido. No se admiten ventas sin método de pago.\
	• RN.18: Toda orden de venta debe expirar y liberar el stock retenido temporalmente si no es confirmada o pagada en un lapso máximo de 15 minutos desde su creación en el mostrador.\
	• RN.19: Toda Venta debe estar vinculada obligatoriamente a un Usuario vendedor.\
	• RN.20: Una venta confirmada no puede modificarse ni eliminarse. Solo puede ser anulada por un Administrador, quedando registrada como anulada, y las unidades vendidas vuelven al stock.\
    • RN.21: Una notebook solo puede venderse si tiene registrados marca, modelo, procesador, memoria RAM, almacenamiento, tarjeta gráfica, pantalla y precio de lista.\
	• RN.22: El subtotal de cada producto en la venta debe calcularse de manera automática multiplicando la cantidad de unidades solicitadas por el precio unitario vigente. \
	• RN.23: Un mismo modelo de notebook no puede aparecer en dos líneas separadas dentro del ticket de una misma venta. Si el cliente lleva más de una unidad, solo se debe aumentar la cantidad en la línea ya existente. \
 	• RN.24: No se puede generar, procesar ni confirmar una venta si no tiene al menos una notebook agregada al detalle. \
	• RN.25: La fecha y hora de la venta se registrarán automáticamente basándose en el reloj del sistema al momento de crearla, y ningún usuario del mostrador podrá modificarlas. \
	• RN.26: Toda venta debe indicar en todo momento en qué estado se encuentra (Pendiente, Confirmada, Anulada o Expirada) y bajo ninguna circunstancia puede quedar sin estado. \

