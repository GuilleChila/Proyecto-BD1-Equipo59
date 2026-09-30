# LaptopDeel — Guía de Implementación de la Base de Datos

## 1. Introducción

Este documento describe los pasos necesarios para **implementar la base de datos LaptopDeel** en un servidor **Microsoft SQL Server** utilizando **SQL Server Management Studio (SSMS)**.

La implementación está dividida en **cinco archivos SQL** que deben ejecutarse **en orden secuencial**. Cada archivo corresponde a un bloque coherente de creación de tablas o de carga de datos.

---

## 2. Estructura de los archivos

Los scripts se encuentran en la carpeta `SQL/DDL/` del repositorio y deben ejecutarse **en este orden exacto**:

| Orden | Archivo | Contenido |
|:---:|---|---|
| 1 | `Implementacion-Paso1.sql` | Crea la base de datos `LaptopDeel` y las tablas de **catálogo base**: `ROL`, `USUARIO`, `CLIENTE`,  |
| 2 | `Implementacion-Paso2.sql` | Crea las tablas de **hardware**: `PROCESADOR`, `PANTALLA`, `TARJETA_GRAFICA`, `RAM`, `ALMACENAMIENTO` |
| 3 | `Implementacion-Paso3.sql` | Crea la tabla **`NOTEBOOK`** y las tablas asociativas de componentes: `CATEGORIA`, `NOTEBOOK_CATEGORIA`, `NOTEBOOK_RAM`, `NOTEBOOK_ALMACENAMIENTO` |
| 4 | `Implementacion-Paso4.sql` | Crea las tablas del **módulo de ventas**: `VENTA`, `VENTA_METODO_PAGO`, `DETALLE_VENTA` |
| 5 | `Implementacion-Paso5.sql` | **Carga inicial de datos** (DML) en todas las tablas, en el orden correcto según las dependencias de claves foráneas |

---

## 3. Procedimiento de ejecución

### Paso 1 — Abrir cada archivo en orden

Para cada uno de los 5 archivos:

1. En SSMS, ir a **File → Open → File...** (o `Ctrl + O`).
2. Seleccionar el archivo correspondiente (`Implementacion-Paso1.sql`, etc.).
3. Verificar que la barra de estado muestre la base **master** (excepto en el Paso 1, que crea la base).
4. Ejecutar el script completo.

### Paso 2 — Verificar cada etapa

Después de ejecutar cada archivo, se recomienda verificar que las tablas se hayan creado correctamente y que este ubicado en la base de dato LaptopDeel:

