# Pruebas de validación — Etapa III

Este documento posee algunos ejemplos de sentencias que **violan** restricciones, para dejar evidencia de que el DDL las rechaza
correctamente. 


## 1. Integridad referencial (FOREIGN KEY)

**Ejemplo:** Insertar un usuario con un rol que no existe en `ROL`.
```sql
INSERT INTO USUARIO (Nombre, Apellido, Correo, clave, fecha_nacimiento, DNI, id_Rol)
VALUES ('Test', 'Test', 'test.fk@laptopdeel.com', 'x', '2000-01-01', '99999999', 99);
```
**Resultado:** Rechazado por violación de `FK_Usuario_Rol`, ya que no existe ningún rol con `id_Rol = 99`. No se pueden crear usuarios que referencien un rol inexistente.

**Ejemplo:** Eliminar un rol que ya tiene usuarios asignados.
```sql
DELETE FROM ROL WHERE id_Rol = 2; -- 'Vendedor', usado por varios usuarios
```
**Resultado:** Rechazado por violación de `FK_Usuario_Rol`, porque existen filas en `USUARIO` que dependen de ese rol.


## 2. Restricción UNIQUE

**Ejemplo:** Insertar un usuario con un correo ya usado.
```sql
INSERT INTO USUARIO (Nombre, Apellido, Correo, clave, fecha_nacimiento, DNI, id_Rol)
VALUES ('Otro', 'Usuario', 'juan.perez@laptopdeel.com', 'hashX', '1990-01-01', '90000001', 1);
```
**Resultado:** Rechazado por violación de `UNIQUE` sobre `Correo` (ya pertenece a Juan Pérez).

**Ejemplo:** Insertar un cliente con un DNI ya usado.
```sql
INSERT INTO CLIENTE (nombre, apellido, Correo, Telefono, Direccion, IVA, DNI)
VALUES ('Otro', 'Cliente', 'otro.cliente@mail.com', '3810000000', 'Calle X', 'Consumidor Final', '11111111');
```
**Resultado:** Rechazado por violación de `UNIQUE` sobre `DNI` (ya pertenece a Pedro Álvarez).


## 3. Restricción CHECK

**Ejemplo:** Insertar una notebook con stock negativo.
```sql
INSERT INTO NOTEBOOK (marca, modelo, precio, stock, id_procesador, id_pantalla, id_tarjeta_grafica)
VALUES ('Lenovo', 'Test CHECK', 100000.00, -5, 1, 1, NULL);
```
**Resultado:** Rechazado por violación de `CK_Notebook_Stock`.

**Ejemplo:** Insertar un detalle de venta con cantidad igual a 0.
```sql
INSERT INTO DETALLE_VENTA (id_notebook, id_venta, cantidad, precio_unitario)
VALUES (1, 1, 0, 450000.00);
```
**Resultado:** Rechazado por violación de `CK_Detcantidad` (exige `cantidad > 0`). Recalcar que también fallaría por `PK_DV`, ya que el par `(id_notebook, id_venta) = (1, 1)` ya existe en los datos cargados.

