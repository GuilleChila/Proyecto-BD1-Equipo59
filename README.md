# LaptopDeel — Sistema de Gestión y Venta Asistida de Notebooks

> **Materia:** Base de Datos I (2026)  
> **Carrera:** Licenciatura en Sistemas de Información  
> **Institución:** Facultad de Ciencias Exactas y Naturales y Agrimensura (FaCENA) — UNNE  
> **Grupo:** Equipo 59  

---

## Índice

- [Integrantes del Equipo](#integrantes-del-equipo)
- [Descripción del Proyecto](#descripción-del-proyecto)
- [Estado del Proyecto](#estado-del-proyecto)
- [Navegación por Etapa](#navegación-por-etapa)
- [Estructura del Repositorio](#estructura-del-repositorio)
- [Tecnologías Utilizadas](#tecnologías-utilizadas)

---

## Integrantes del Equipo
* **Chilavert Rauschmair, Guillermo**
* **Depretto, Leandro**
* **Romero, Sebastián**
* **Chavarría, Tomás**
* **Degregorio, Matías**

---

## Descripción del Proyecto

**LaptopDeel** es una solución integral orientada al salón comercial y a la administración de un local físico especializado en la comercialización de notebooks.

El software surge ante la necesidad de optimizar la atención en mostrador mediante el modelo de **venta asistida**: asiste a los vendedores para interpretar rápidamente los requerimientos del cliente (presupuesto, perfiles de uso, marcas y requerimientos de hardware) y transformarlos en filtros precisos del catálogo en tiempo real.

El sistema garantiza:
* **Asesoramiento técnico ágil:** Comparación técnica de modelos y consulta visual de stock disponible en mostrador.
* **Integridad transaccional e histórica:** Desacople entre los precios de lista y los valores históricos facturados en cada detalle de venta.
* **Consistencia de inventario:** Reserva temporal de stock durante la confección de la orden y control de existencias previo al cierre de la venta.

---

## Estado del Proyecto

| Etapa | Contenido | 
|---|---
| [Etapa 01](#etapa-01--requerimientos) — Requerimientos | Descripción del caso, alcance y reglas de negocio | 
| [Etapa 02](#etapa-02--modelado) — Modelado | DER, modelo relacional y normalización | 
| [Etapa 03](#etapa-03--implementación) — Implementación | Scripts DDL/DML y pruebas de validación |
| [Etapa 04](#etapa-04--consultas) — Consultas | Casos de uso y scripts de consulta (JOIN, GROUP BY, HAVING) |
| [Etapa 05](#etapa-05--temas-técnicos) — Temas técnicos | Procedimientos y funciones, transacciones, triggers de auditoría, seguridad e índices |

---

## Navegación por Etapa

### Etapa 01 — Requerimientos

Problema de negocio que resuelve nuestro sistema: un local físico de venta de notebooks que necesita digitalizar su proceso de venta asistida. En esta etapa se relevó el dominio del negocio, se delimitó el alcance del sistema (qué funciones cubre y cuáles quedan  fuera) y se redactaron las reglas de negocio, sin entrar todavía en ningún aspecto técnico de base de datos.

| Archivo | Descripción |
|---|---|
| [descripcionLaptopDeel.md](Docs/Etapa-01/descripcionLaptopDeel.md) | Descripción general del sistema y su alcance |
| [reglas de negocio laptopdeel.docx](<Docs/Etapa-01/reglas de negocio laptopdeel.docx>) | Documento fuente de reglas de negocio |
| [reglas-negocios.md](Docs/Etapa-01/reglas-negocios.md) | Especificación formal de reglas de negocio |

### Etapa 02 — Modelado

Traduce los requerimientos de la Etapa 01 a un modelo de datos formal. Incluye el Diagrama Entidad-Relación (DER) en notación Peter Chen, su pasaje al modelo relacional (tablas, claves primarias y foráneas) y la justificación del proceso de normalización hasta Tercera Forma Normal (3FN), eliminando redundancias y dependencias parciales o transitivas detectadas en el esquema inicial.

| Archivo | Descripción |
|---|---|
| [LaptopDeel-ER.png](Docs/Etapa-02/LaptopDeel-ER.png) | Diagrama Entidad-Relación (DER) |
| [LaptopDeel - Esquema Relacional img.png](<Docs/Etapa-02/LaptopDeel - Esquema Relacional img.png>) | Esquema relacional (imagen) |
| [normalizacion.md](Docs/Etapa-02/normalizacion.md) | Justificación de formas normales (1FN, 2FN, 3FN) |

### Etapa 03 — Implementación

Lleva el modelo lógico de la Etapa 02 a SQL Server. El DDL crea las 16 tablas del sistema en cuatro scripts ordenados por dependencias (primero las tablas sin referencias externas, al final las que dependen de todas las demás), con sus claves primarias, foráneas y restricciones de integridad (`UNIQUE`, `CHECK`, valores por defecto). El DML puebla la base con datos de prueba coherentes para cada tabla. La validación de las restricciones —qué operaciones se aceptan y cuáles se rechazan, y por qué— queda documentada con ejemplos concretos en pruebas-validacion.md.

| Archivo | Descripción |
|---|---|
| [Implementacion-Paso1.sql](SQL/DDL/Implementacion-Paso1.sql) | DDL — Paso 1: creación de la base y tablas sin dependencias (`ROL`, `USUARIO`, `CLIENTE`, `CATEGORIA`) |
| [Implementacion-Paso2.sql](SQL/DDL/Implementacion-Paso2.sql) | DDL — Paso 2: componentes de hardware (`PROCESADOR`, `PANTALLA`, `TARJETA_GRAFICA`, `RAM`, `ALMACENAMIENTO`) |
| [Implementacion-paso3.sql](SQL/DDL/Implementacion-paso3.sql) | DDL — Paso 3: `NOTEBOOK` y sus tablas puente de relaciones N:M |
| [Implementacion-Paso4.sql](SQL/DDL/Implementacion-Paso4.sql) | DDL — Paso 4: `VENTA`, `DETALLE_VENTA` y `VENTA_METODO_PAGO` |
| [implementacion-paso5.sql](SQL/DML/implementacion-paso5.sql) | DML — poblado inicial con datos de prueba coherentes para cada tabla |
| [implementacion.md](Docs/Etapa-03/implementacion.md) | Cómo se tradujo cada entidad del modelo lógico a una tabla de SQL Server |
| [Restricciones-integridad.md](Docs/Etapa-03/Restricciones-integridad.md) | Detalle de cada `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE` y `CHECK`, y la regla de negocio que protege |
| [pruebas-validacion.md](Docs/Etapa-03/pruebas-validacion.md) | Ejemplos de sentencias que violan cada restricción, con el resultado esperado al ejecutarlas |

### Etapa 04 — Consultas

Resuelve tres necesidades de información del negocio mediante scripts `SELECT`: un comprobante de venta que consolida encabezado y detalle con subtotales calculados, un reporte agregado de ventas por vendedor-gerente y categoría, y una consulta de ranking que combina cuatro tablas con `JOIN` y aplica `HAVING` sobre los resultados agrupados.

| Archivo | Descripción |
|---|---|
| [Factura.sql](SQL/CONSULTAS/Factura.sql) | Comprobante de venta: encabezado, detalle por renglón y total acumulado |
| [reporte_vendedores.sql](SQL/CONSULTAS/reporte_vendedores.sql) | Reporte agregado de ventas por vendedor/gerente en un rango de fechas |
| [NotebookMasVendidaPorCategoria.sql](SQL/CONSULTAS/NotebookMasVendidaPorCategoria.sql) | Ranking de notebooks vendidas por categoría, en unidades y recaudación |
| [casos-uso.md](Docs/Etapa-04/casos-uso.md) | Resumen de las tres necesidades de negocio que resuelve esta etapa |
| [informe-ventas.md](Docs/Etapa-04/informe-ventas.md) | Necesidad, estrategia SQL y resultado esperado del reporte por vendedor |
| [consulta-avanzada.md](Docs/Etapa-04/consulta-avanzada.md) | Necesidad, estrategia SQL y resultado esperado del ranking por categoría |

### Etapa 05 — Temas técnicos

Se incorpora mecanismos avanzados de SQL Server para que la base sea más robusta, segura y fácil de mantener. Cada tema tiene su propia carpeta con un documento de investigación (definición, ventajas, caso aplicado a LaptopDeel y resultados), el script SQL de implementación y las capturas de evidencia de las pruebas.

#### Procedimientos y funciones almacenadas

Centralizan la lógica de negocio en la base: tres procedimientos para dar de alta, modificar y desactivar notebooks, un procedimiento para registrar una venta simple y tres funciones de cálculo (estado de stock, estadísticas de compras de un cliente y ventas anuales). Se compara además la carga de datos con `INSERT` directos contra la carga mediante procedimientos.

| Archivo | Descripción |
|---|---|
| [investigacion_procedimientos_y_funciones_almacenadas.md](Etapa_V/procedimientos_funciones/investigacion_procedimientos_y_funciones_almacenadas.md) | Definiciones, ventajas y diferencias entre procedimientos y funciones |
| [scrips.sql](Etapa_V/procedimientos_funciones/scrips.sql) | Creación de los procedimientos y funciones |
| [PoblacionInsert.sql](Etapa_V/procedimientos_funciones/PoblacionInsert.sql) | Carga de datos con `INSERT` directos, con métricas de tiempo |
| [PoblacionSP.sql](Etapa_V/procedimientos_funciones/PoblacionSP.sql) | Carga de datos invocando los procedimientos, con métricas de tiempo |
| [analisis.md](Etapa_V/procedimientos_funciones/Evidencias/analisis.md) | Análisis de rendimiento: inserción directa vs. procedimientos |
| [Evidencias](Etapa_V/procedimientos_funciones/Evidencias) | Capturas de las ejecuciones y de los tiempos |

#### Manejo de transacciones

Garantiza que una venta se registre completa o no se registre: el procedimiento `RegistrarVenta` valida el stock, crea la venta, inserta el detalle y descuenta el stock dentro de una transacción con `TRY/CATCH`. Se prueba un caso exitoso (`COMMIT`) y uno fallido por stock insuficiente (`ROLLBACK`) para demostrar la atomicidad.

| Archivo | Descripción |
|---|---|
| [investigacion.md](Etapa_V/transacciones/investigacion.md) | Conceptos (ACID), caso aplicado a LaptopDeel y conclusiones |
| [scripts.sql](Etapa_V/transacciones/scripts.sql) | Procedimiento `RegistrarVenta` y pruebas exitosa y fallida |
| [resultado_pruebas.md](Etapa_V/transacciones/evidencias/resultado_pruebas.md) | Detalle de cada prueba y su resultado |
| [evidencias](Etapa_V/transacciones/evidencias) | Capturas del `COMMIT`, del `ROLLBACK` y del estado de los datos |

#### Triggers de auditoría

Tres triggers sobre tres tablas: `AFTER UPDATE` sobre `NOTEBOOK` (guarda los valores anteriores y nuevos de cada modificación), `AFTER DELETE` sobre `CLIENTE` (conserva los datos del cliente eliminado) e `INSTEAD OF DELETE` sobre `VENTA` (impide eliminar ventas). Los dos de auditoría registran además la fecha, la hora y el usuario que hizo el cambio.

| Archivo | Descripción |
|---|---|
| [investigacion.md](Etapa_V/triggers_auditoria/investigacion.md) | Definición, ventajas, caso aplicado y resultados de los tres triggers |
| [01_trigger_after_update_notebook.sql](Etapa_V/triggers_auditoria/01_trigger_after_update_notebook.sql) | Auditoría de modificaciones de notebooks |
| [02_trigger_after_delete_cliente.sql](Etapa_V/triggers_auditoria/02_trigger_after_delete_cliente.sql) | Auditoría de eliminaciones de clientes |
| [03_trigger_instead_of_delete_venta.sql](Etapa_V/triggers_auditoria/03_trigger_instead_of_delete_venta.sql) | Bloqueo de eliminación de ventas |
| [evidencias](Etapa_V/triggers_auditoria/evidencias) | Capturas de las pruebas de cada trigger |

#### Seguridad: usuarios y roles

Aplica el principio de mínimo privilegio. Con permisos directos, un usuario de solo lectura no puede hacer un `INSERT` sobre `VENTA`, pero sí registrar una venta ejecutando el procedimiento autorizado. Con roles, el rol `rol_consulta_notebooks` permite consultar a quien pertenece a él y deniega el acceso a quien no.

| Archivo | Descripción |
|---|---|
| [investigacion.md](Etapa_V/seguridad/investigacion.md) | Permisos a nivel de usuarios y de roles, y caso aplicado a LaptopDeel |
| [scripts.sql](Etapa_V/seguridad/scripts.sql) | Creación de logins, usuarios, rol, permisos y pruebas |
| [evidencias](Etapa_V/seguridad/evidencias) | Capturas de las pruebas exitosas y fallidas de cada usuario |

#### Índices y optimización de consultas

Mide el efecto de los índices sobre una consulta por período en una tabla de prueba con 1.000.000 de registros, comparando tres escenarios: sin índice (`Table Scan`), con un índice agrupado sobre la fecha (`Clustered Index Seek`) y con un índice no agrupado de cobertura (`Index Seek`). Se registran tiempos, lecturas lógicas y planes de ejecución.

| Archivo | Descripción |
|---|---|
| [investigacion.md](Etapa_V/indices_optimizacion/investigacion.md) | Conceptos, comparación de los tres escenarios y conclusiones |
| [indexacion_optimizacion.sql](Etapa_V/indices_optimizacion/indexacion_optimizacion.sql) | Tabla de prueba, carga masiva y los tres escenarios |
| [evidencias](Etapa_V/indices_optimizacion/evidencias) | Capturas de mensajes y planes de ejecución |

---


## Estructura del Repositorio

```text
├── Docs/
│   ├── Etapa-01/
│   │   ├── descripcionLaptopDeel.md
│   │   ├── reglas de negocio laptopdeel.docx
│   │   └── reglas-negocios.md
│   ├── Etapa-02/
│   │   ├── LaptopDeel - Esquema Relacional img.png
│   │   ├── LaptopDeel-ER.png
│   │   └── normalizacion.md
│   ├── Etapa-03/
│   │   ├── implementacion.md
│   │   ├── Restricciones-integridad.md
│   │   └── pruebas-validacion.md
│   └── Etapa-04/
│       ├── casos-uso.md
│       ├── consulta-avanzada.md
│       └── informe-ventas.md
│
├── SQL/
│   ├── DDL/
│   │   ├── Implementacion-Paso1.sql
│   │   ├── Implementacion-Paso2.sql
│   │   ├── Implementacion-paso3.sql
│   │   └── Implementacion-Paso4.sql
│   ├── DML/
│   │   └── implementacion-paso5.sql
│   └── CONSULTAS/
│       ├── Factura.sql
│       ├── reporte_vendedores.sql
│       └── NotebookMasVendidaPorCategoria.sql
│
├── Etapa_V/
│   ├── procedimientos_funciones/
│   │   ├── investigacion_procedimientos_y_funciones_almacenadas.md
│   │   ├── scrips.sql
│   │   ├── PoblacionInsert.sql
│   │   ├── PoblacionSP.sql
│   │   └── Evidencias/
│   ├── transacciones/
│   │   ├── investigacion.md
│   │   ├── scripts.sql
│   │   └── evidencias/
│   ├── triggers_auditoria/
│   │   ├── investigacion.md
│   │   ├── 01_trigger_after_update_notebook.sql
│   │   ├── 02_trigger_after_delete_cliente.sql
│   │   ├── 03_trigger_instead_of_delete_venta.sql
│   │   └── evidencias/
│   ├── seguridad/
│   │   ├── investigacion.md
│   │   ├── scripts.sql
│   │   └── evidencias/
│   └── indices_optimizacion/
│       ├── investigacion.md
│       ├── indexacion_optimizacion.sql
│       └── evidencias/
│
└── README.md
```

---

## Tecnologías Utilizadas

- **Motor de base de datos:** Microsoft SQL Server
- **Herramienta de diseño del DER:** ERDPlus (notación Peter Chen)
- **Control de versiones:** Git / GitHub
