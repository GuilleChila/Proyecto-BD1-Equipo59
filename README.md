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

| Etapa | Contenido | Estado |
|---|---|---|
| [Etapa 01](#etapa-01--requerimientos) — Requerimientos | Descripción del caso, alcance y reglas de negocio | ✅ Completado |
| [Etapa 02](#etapa-02--modelado) — Modelado | DER, modelo relacional y normalización | ✅ Completado |
| [Etapa 03](#etapa-03--implementación) — Implementación | Scripts DDL/DML y pruebas de validación | ✅ Completado |
| [Etapa 04](#etapa-04--consultas) — Consultas | Casos de uso y scripts de consulta (JOIN, GROUP BY, HAVING) | ✅ Completado |
| Etapa 05 — Temas técnicos | Procedimientos, funciones, transacciones, triggers, seguridad e índices | ⏳ En desarrollo |

---


---

## Navegación por Etapa

### Etapa 01 — Requerimientos
| Archivo | Descripción |
|---|---|
| [descripcionLaptopDeel.md](Docs/Etapa-01/descripcionLaptopDeel.md) | Descripción general del sistema y su alcance |
| [reglas de negocio laptopdeel.docx](<Docs/Etapa-01/reglas de negocio laptopdeel.docx>) | Documento fuente de reglas de negocio |
| [reglas-negocios.md](Docs/Etapa-01/reglas-negocios.md) | Especificación formal de reglas de negocio |

### Etapa 02 — Modelado
| Archivo | Descripción |
|---|---|
| [LaptopDeel-ER.png](Docs/Etapa-02/LaptopDeel-ER.png) | Diagrama Entidad-Relación (DER) |
| [LaptopDeel - Esquema Relacional img.png](<Docs/Etapa-02/LaptopDeel - Esquema Relacional img.png>) | Esquema relacional (imagen) |
| [normalizacion.md](Docs/Etapa-02/normalizacion.md) | Justificación de formas normales (1FN, 2FN, 3FN) |

### Etapa 03 — Implementación
| Archivo | Descripción |
|---|---|
| [Implementacion-Paso1.sql](SQL/DDL/Implementacion-Paso1.sql) | DDL — Paso 1: ROL, USUARIO, CLIENTE, CATEGORIA |
| [Implementacion-Paso2.sql](SQL/DDL/Implementacion-Paso2.sql) | DDL — Paso 2: componentes de hardware |
| [Implementacion-paso3.sql](SQL/DDL/Implementacion-paso3.sql) | DDL — Paso 3: NOTEBOOK y tablas puente |
| [Implementacion-Paso4.sql](SQL/DDL/Implementacion-Paso4.sql) | DDL — Paso 4: VENTA, DETALLE_VENTA, VENTA_METODO_PAGO |
| [implementacion-paso5.sql](SQL/DML/implementacion-paso5.sql) | DML — poblado inicial de datos de prueba |
| [implementacion.md](Docs/Etapa-03/implementacion.md) | Traducción del modelo lógico al SGBD |
| [Restricciones-integridad.md](Docs/Etapa-03/Restricciones-integridad.md) | PK, FK, UNIQUE y CHECK definidos, y su justificación |
| [pruebas-validacion.md](Docs/Etapa-03/pruebas-validacion.md) | Evidencia de que las restricciones funcionan |

### Etapa 04 — Consultas
| Archivo | Descripción |
|---|---|
| [Factura.sql](SQL/CONSULTAS/Factura.sql) | Comprobante de venta: encabezado, detalle y totales |
| [reporte_vendedores.sql](SQL/CONSULTAS/reporte_vendedores.sql) | Reporte agregado de ventas por vendedor/gerente |
| [NotebookMasVendidaPorCategoria.sql](SQL/CONSULTAS/NotebookMasVendidaPorCategoria.sql) | Ranking de notebooks vendidas por categoría |
| [casos-uso.md](Docs/Etapa-04/casos-uso.md) | Resumen de las necesidades de información resueltas |
| [informe-ventas.md](Docs/Etapa-04/informe-ventas.md) | Documentación del reporte agregado de ventas |
| [consulta-avanzada.md](Docs/Etapa-04/consulta-avanzada.md) | Documentación de la consulta con JOIN + HAVING |

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
└── README.md
```

---

## Tecnologías Utilizadas

- **Motor de base de datos:** Microsoft SQL Server
- **Herramienta de diseño del DER:** ERDPlus (notación Peter Chen)
- **Control de versiones:** Git / GitHub
