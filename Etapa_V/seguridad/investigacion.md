# Seguridad: Usuarios y Roles

## 1. Definición y objetivo
La seguridad en una base de datos permite controlar quién accede a la información y qué operaciones puede realizar. SQL Server permite administrar permisos de dos formas principales:
- **A nivel de Usuarios:** Asignando permisos directamente a un usuario específico.
- **A nivel de Roles:** Agrupando permisos en un "rol" y luego asignando usuarios a ese rol, facilitando la administración masiva.

El objetivo es aplicar el **Principio de Mínimo Privilegio**, dándole a cada trabajador solo los accesos que necesita para su puesto, protegiendo así la información sensible y evitando modificaciones accidentales o no autorizadas.

## 2. Ventajas y aplicaciones
- **Seguridad y protección de datos:** Evita que usuarios malintencionados borren o modifiquen información crítica.
- **Mantenibilidad:** Si cambian los permisos de un puesto (ej. "Vendedor"), solo se modifica el Rol, en lugar de modificar usuario por usuario.
- **Aplicación en LaptopDeel:** Un vendedor en el mostrador no debe poder alterar los precios de las notebooks (`UPDATE NOTEBOOK`), pero sí debe poder registrar una venta. Mediante la seguridad, le denegamos el acceso directo a la tabla, pero le damos permiso para ejecutar el procedimiento de ventas.

## 3. Caso concreto aplicado al sistema
Se implementaron dos escenarios para demostrar el control de accesos:
1. **Permisos Directos:** Se creó el `usuario_lector` con permiso de lectura (`SELECT`) en el catálogo y permiso de ejecución (`EXECUTE`) sobre `sp_RegistrarVentaSimple`. Se demostró que si intenta hacer un `INSERT` directo en la tabla `VENTA`, el motor lo rechaza; pero si ejecuta el Procedimiento Almacenado, la venta se registra con éxito.
2. **Permisos por Roles:** Se creó el rol `rol_consulta_notebooks` con permiso de `SELECT`. Se asignó al `usuario_con_rol`, quien pudo hacer la consulta. El `usuario_sin_rol` intentó lo mismo y recibió un error de acceso denegado.

## 4. Implementación y evidencias
Ver `scripts.sql`. Las pruebas se realizan utilizando la instrucción `EXECUTE AS USER` para simular la sesión de cada usuario sin necesidad de cerrar y abrir SSMS.
