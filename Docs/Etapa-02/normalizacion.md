En el siguiente texto explicamos como verificamos que las tablas de nuestro esquema relacional cumplen con la 1FN y 2FN hasta alcanzar la 3FN

## Primera Forma Normal (1FN)

- Se garantizó la atomicidad en todas las entidades separando los atributos compuestos del DER (por ejemplo, los nombres y apellidos de clientes y usuarios se dividieron en columnas independientes: `Nombre` y `Apellido`).

- Los grupos repetitivos correspondientes a los componentes múltiples de las notebooks (varias memorias RAM, múltiples tipos de almacenamiento o múltiples categorías) fueron eliminados de la tabla principal `NOTEBOOK` y trasladados a tablas asociativas independientes (`NOTEBOOK_RAM`, `NOTEBOOK_ALMACENAMIENTO`, `NOTEBOOK_CATEGORIA`).

## Segunda Forma Normal (2FN)

- Las tablas con claves primarias simples (`USUARIO`, `CLIENTE`, `NOTEBOOK`, `VENTA`, etc.) cumplen con la 2FN de forma directa, ya que no poseen claves compuestas.

- En las tablas con claves primarias compuestas como `DETALLE_VENTA` con clave primaria (`id_notebook`, `id_venta`), los atributos no clave (como `cantidad` y `precio_unitario`) dependen por completo de toda la clave compuesta y no de una parte de ella. No existen dependencias parciales. Lo mismo se cumple con la tabla `NOTEBOOK_CATEGORIA`, la cual posee una clave primaria compuesta (`id_notebook`, `id_categoria`)

- Las tablas `NOTEBOOK_RAM` y `NOTEBOOK_ALMACENAMIENTO` originalmente tenian clave primaria compuesta porque la relacion entre las entidades era N:M, pero se incluyo una clave primaria simple en cada tabla para que una notebook pueda tener, por ejemplo, dos ram del mismo tipo insertadas a la vez.

## Tercera Forma Normal (3FN)

- Se revisó que en entidades como `CLIENTE` o `USUARIO`, datos como el Correo, Teléfono o Dirección dependan exclusivamente de su identificador único (`id_Cliente` o `id_usuario`) y no de otros atributos no clave.

  Lo mismo aplica para las especificaciones técnicas en `PROCESADOR`, `PANTALLA` y `TARJETA_GRAFICA`, donde las características (velocidad, núcleos, pulgadas, etc.) dependen únicamente de su identificador primario.

  El esquema actual no presenta dependencias transitivas.
