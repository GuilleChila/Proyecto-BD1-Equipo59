# LaptopDeel — Sistema de Gestión y Venta Asistida de Notebooks

> **Materia:** Base de Datos I (2026)  
> **Carrera:** Licenciatura en Sistemas de Información  
> **Institución:** Facultad de Ciencias Exactas y Naturales y Agrimensura (FaCENA) — UNNE  
> **Grupo:** Equipo 59  

---

## Integrantes del Equipo
* **Chilavert Rauschmair, Guillermo**
* **Depretto, Leandro**
* **Romero, Sebastián**
* **Chavarría, Tomás**
* **Degregorio, Matías**

---

##  Descripción del Proyecto

**LaptopDeel** es una solución integral orientada al salón comercial y a la administración de un local físico especializado en la comercialización de notebooks.

El software surge ante la necesidad de optimizar la atención en mostrador mediante el modelo de **venta asistida**: asiste a los vendedores para interpretar rápidamente los requerimientos del cliente (presupuesto, perfiles de uso, marcas y requerimientos de hardware) y transformarlos en filtros precisos del catálogo en tiempo real.

El sistema garantiza:
* **Asesoramiento técnico ágil:** Comparación técnica de modelos y consulta visual de stock disponible en mostrador.
* **Integridad transaccional e histórica:** Desacople entre los precios de lista y los valores históricos facturados en cada detalle de venta.
* **Consistencia de inventario:** Reserva temporal de stock durante la confección de la orden y control de existencias previo al cierre de la venta.

---

##  Estructura del Repositorio

El repositorio organiza el ciclo de diseño del modelo de datos dividido en etapas de entrega:

```text
├── Docs/
│   ├── Etapa-01/
│   │   ├── descripcionLaptopDeel.md     # Descripción general del sistema y alcance
│   │   ├── reglas de negocio laptopdeel.docx # Documento fuente de reglas de negocio
│   │   └── reglas-negocios.md           # Especificación formal de reglas de negocio
│   └── Etapa-02/
│       ├── LaptopDeel - Esquema Relacional.md # Pasaje a tablas, claves primarias y foráneas
│       ├── LaptopDeel-ER.png            # Diagrama Entidad-Relación (DER)
│       └── normalizacion.md             # Justificación de formas normales (1FN, 2FN, 3FN / FNBC)
└── README.md                            # Portada general y documentación del proyecto
