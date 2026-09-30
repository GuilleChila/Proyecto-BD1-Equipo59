
# Informe de Análisis de Restricciones e Integridad de la Base de Datos (LaptopDeel)

En el presente documento detallamos las restricciones y reglas de integridad de datos definidas para la base de datos LaptopDeel, clasificándolas según los principios de integridad del modelo relacional: Entidad, Referencial, Dominio y Unicidad.
## 1. Integridad de Entidad (Claves Primarias e Identidad)

Para garantizar que cada registro en el sistema pueda identificarse de manera unívoca y sin ambigüedades, implementamos claves primarias en todas las tablas:

- Propiedad IDENTITY(1,1): Aplicada a las claves primarias simples (ROL, USUARIO, CLIENTE, CATEGORIA, PROCESADOR, PANTALLA, TARJETA_GRAFICA, RAM, ALMACENAMIENTO, NOTEBOOK, NOTEBOOK_RAM, NOTEBOOK_ALMACENAMIENTO y VENTA). Permite que el motor de base de datos genere autonuméritos secuenciales automáticos.

- Claves Primarias Simples (PRIMARY KEY): Garantizan unicidad y crean un índice clustered por defecto.

- Claves Primarias Compuestas:
- NOTEBOOK_CATEGORIA: PK_NotebookCategoria (id_notebook, id_categoria). Previene que una misma notebook tenga duplicada una categoría.
- VENTA_METODO_PAGO: PK_Vmp (id_venta, metodo_pago).
- DETALLE_VENTA: PK_DV (id_notebook, id_venta). Evita que un mismo producto se repita en múltiples filas para una misma venta.

## 2. Integridad Referencial (Claves Foráneas)

Definimos restricciones de clave foránea (FOREIGN KEY) para preservar la consistencia entre tablas relacionadas y evitar registros huérfanos:

- USUARIO ![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABUAAAAZCAYAAADe1WXtAAABLElEQVR4AeySv2rCUBTGm0ugN7SUQgmpBJIMAYc+RZ+i0LGDS4cuFRx0cPAFHH0IN5/A3T0QyB8TIbM4SP7odzNI0DgciYt4OV/uySHnxz1fLnu4wrpDmzf1hj21LIsbhtFRVfX5nHHk8X3f30qSZCqK0m4MCtAOawrwN3IZOgnySQUhDMMFoEvYIMCSqFVVQuHTq2maLYLeGWNTgD7RM7Zt+wX5IZimaU8Y5xeVIUV5nvfxfQv6SdO0C/Aj8jJYkiSbIAhGUIeioigmsGCdZVkbfQPXdbclEY9yfOyk0HX9DeP/Qf9xHEfHzRdBZVn+wilnnucFx0DxTobip3I0fmDsOfbaIEPF5eec96IoWtUSUSRD0bNzHGctdqg2LoHWgqrFO7TqRjP5VTzdAwAA//+G4NnAAAAABklEQVQDADvpfjM5F8qPAAAAAElFTkSuQmCC) ROL: FK_Usuario_Rol
- NOTEBOOK ![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABUAAAAZCAYAAADe1WXtAAABLElEQVR4AeySv2rCUBTGm0ugN7SUQgmpBJIMAYc+RZ+i0LGDS4cuFRx0cPAFHH0IN5/A3T0QyB8TIbM4SP7odzNI0DgciYt4OV/uySHnxz1fLnu4wrpDmzf1hj21LIsbhtFRVfX5nHHk8X3f30qSZCqK0m4MCtAOawrwN3IZOgnySQUhDMMFoEvYIMCSqFVVQuHTq2maLYLeGWNTgD7RM7Zt+wX5IZimaU8Y5xeVIUV5nvfxfQv6SdO0C/Aj8jJYkiSbIAhGUIeioigmsGCdZVkbfQPXdbclEY9yfOyk0HX9DeP/Qf9xHEfHzRdBZVn+wilnnucFx0DxTobip3I0fmDsOfbaIEPF5eec96IoWtUSUSRD0bNzHGctdqg2LoHWgqrFO7TqRjP5VTzdAwAA//+G4NnAAAAABklEQVQDADvpfjM5F8qPAAAAAElFTkSuQmCC) Componentes:
- FK_Notebook_Procesador
- FK_Notebook_Pantalla
- FK_Notebook_Tarjeta (Acepta valores nulos para notebooks con gráfica integrada)

- Tablas Intermedias / Relaciones N:M:

- NOTEBOOK_CATEGORIA: FK_NotebookCategoria_Notebook y FK_NotebookCategoria_categoria
- NOTEBOOK_RAM: FK_NotebookRam_Notebook y FK_NotebookRam_Ram
- NOTEBOOK_ALMACENAMIENTO: FK_NotebookAlmacenamiento_Notebook y fk_NotebookAlmacenamiento_Almacenamiento

- Ventas y Transacciones:

- VENTA: FK_Venta_Usuario y FK_Venta_Cliente
- VENTA_METODO_PAGO: FK_Vmp_Venta
- DETALLE_VENTA: FK_DV_Notebook y FK_DV_Venta

## 3. Restricciones de Unicidad (UNIQUE)

Aplicamos la restricción UNIQUE en aquellos atributos de negocio donde no se permiten valores duplicados:

- ROL.descripcion: Unicidad en los nombres de roles.
- USUARIO.Correo y USUARIO.DNI: Cuentas de usuario e identificaciones únicas.
- CLIENTE.DNI: Identificación única por cliente.
- CATEGORIA.nombre: Evita categorías de productos duplicadas.

## 4. Integridad de Dominio

### A. Valores por Defecto (DEFAULT)

Para asegurar la consistencia del sistema en valores iniciales, definimos:

- PROCESADOR.tiene_grafica: DEFAULT 1 (True).
- PANTALLA.tactil: DEFAULT 0 (False).
- NOTEBOOK.stock: DEFAULT 0.
- VENTA.fecha_hora: DEFAULT SYSDATETIME() (Fecha y hora actual).
- VENTA.estado: DEFAULT 'Pendiente'.
- VENTA.monto_total: DEFAULT 0.

### B. Validaciones de Reglas de Negocio (CHECK)

Implementamos restricciones de verificación para evitar el ingreso de datos incoherentes o no permitidos:

- Valores numéricos positivos (> 0):

- PROCESADOR: velocidad, nucleos, hilos.
- PANTALLA: pulgadas (y tasa_refresco si no es nula).
- TARJETA_GRAFICA: vram_capacidad.
- RAM: capacidad, velocidad.
- ALMACENAMIENTO: capacidad (y velocidad si no es nula).
- DETALLE_VENTA: cantidad.

- Valores no negativos (>= 0):
- NOTEBOOK: precio, stock.
- VENTA: monto_total.
- DETALLE_VENTA: precio_unitario.

- Listas de valores permitidos (IN (...)):
- CLIENTE: IVA IN ('Responsable Inscripto', 'Monotributo', 'Consumidor Final', 'Exento')
- VENTA: estado IN ('Pendiente', 'Confirmada', 'Anulada', 'Expirada')
## 5. Columnas Calculadas Persistidas

- DETALLE_VENTA.subtotal: AS (CAST(cantidad * precio_unitario AS DECIMAL(12,2))) PERSISTED
- Efecto: Mantiene la integridad del cálculo del subtotal en base a la cantidad y el precio unitario, calculando el valor automáticamente y almacenándolo físicamente en disco (PERSISTED) para optimizar el rendimiento.

## Matriz Resumen de Integridad por Tabla

|   |   |   |   |   |   |
|---|---|---|---|---|---|
|Tabla|Clave Primaria|Claves Foráneas|Restricciones UNIQUE|Restricciones CHECK|Valores DEFAULT|
|ROL|id_Rol|-|descripcion|-|-|
|USUARIO|id_usuario|id_Rol|Correo, DNI|-|-|
|CLIENTE|id_Cliente|-|DNI|Ck_Cliente_Iva|-|
|CATEGORIA|id_categoria|-|nombre|-|-|
|PROCESADOR|id_procesador|-|-|CK_Procesador_* (Vel, Nucleos, Hilos)|tiene_grafica (1)|
|PANTALLA|id_pantalla|-|-|CK_Pantalla_* (Pulgadas, Tasa)|tactil (0)|
|TARJETA_GRAFICA|id_tarjeta_grafica|-|-|CK_Tarjeta_Vram|-|
|RAM|id_ram|-|-|CK_Ram_* (Capacidad, Velocidad)|-|
|ALMACENAMIENTO|id_almacenamiento|-|-|CK_Almacenamiento_* (Cap, Vel)|-|
|NOTEBOOK|id_notebook|id_procesador, id_pantalla, id_tarjeta_grafica|-|CK_Notebook_* (Precio, Stock)|stock (0)|
|NOTEBOOK_CATEGORIA|(id_notebook, id_categoria)|id_notebook, id_categoria|-|-|-|
|NOTEBOOK_RAM|id_notebook_ram|id_notebook, id_ram|-|-|-|
|NOTEBOOK_ALMACENAMIENTO|id_notebook_almacenamiento|id_notebook, id_almacenamiento|-|-|-|
|VENTA|id_venta|id_usuario, id_Cliente|-|CK_Venta_* (Estado, Monto)|fecha_hora, estado, monto_total|
|VENTA_METODO_PAGO|(id_venta, metodo_pago)|id_venta|-|-|-|
|DETALLE_VENTA|(id_notebook, id_venta)|id_notebook, id_venta|-|CK_Detcantidad, CK_Detalle_Precio|-|
