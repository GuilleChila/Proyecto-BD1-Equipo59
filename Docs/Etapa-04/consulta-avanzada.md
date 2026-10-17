# Consulta Avanzada - Análisis de Ventas de Notebooks por Categoría

Este documento acompaña al script SQL de la consulta de negocio avanzada desarrollada para la materia de **Bases de Datos I 2026**.

## 1. Descripción de la Consulta

El objetivo principal de esta consulta es **identificar las notebooks vendidas agregadas por categoría**, calculando tanto el volumen total de unidades vendidas como la recaudación total generada por cada modelo. Además, aplica un filtro sobre los datos agregados para retornar únicamente aquellos productos que superen un umbral mínimo de rendimiento comercial.

## 2. Lógica y Estructura Técnica

La consulta cumple rigurosamente con los requisitos técnicos exigidos mediante los siguientes componentes:

1. **Combinación de Múltiples Tablas (`INNER JOIN`):**
   Relaciona 4 tablas del modelo entidad-relación:

   * `CATEGORIA` 

   * `NOTEBOOK_CATEGORIA` 

   * `NOTEBOOK` 

   * `DETALLE_VENTA`

2. **Agrupación de Datos (`GROUP BY`):**
   Consolida las ventas agrupando por la clave de la categoría y por cada notebook específica (`id_notebook`, `marca`, `modelo`), permitiendo aplicar funciones de agregación sobre cada combinación.

3. **Cálculo de Agregaciones (`SUM`):**

   * `SUM(dv.cantidad)`: Calcula el número total de unidades vendidas de cada equipo.

   * `SUM(dv.subtotal)`: Calcula el acumulado monetario generado por las ventas de ese equipo.

4. **Filtro de Agregación (`HAVING`):**
   Utiliza la cláusula `HAVING` para filtrar los grupos después de realizar las sumatorias. Permite definir una condición de negocio.

5. **Ordenamiento (`ORDER BY`):**
   Organiza los resultados alfabéticamente por categoría y, dentro de cada una, ubica primero los productos con mayor número de unidades vendidas.

## 3. Casos de Uso en la Vida Real (Aplicación de Negocio)

Este tipo de consulta analítica es fundamental en entornos comerciales y e-commerce por las siguientes razones:

* **Gestión de Inventario y Stock (Reaprovisionamiento):** Permite al departamento de compras identificar los productos *best-sellers*

* **Toma de Decisiones de Marketing y Promociones:** Identifica productos de baja rotación dentro de una categoría para diseñar promociones, liquidaciones o paquetes de descuento (*bundles*).

* **Análisis de Rentabilidad por Cuentas:** Ayuda a la gerencia a entender qué segmentos de producto (ej. *Gamers*, *Oficina*, *Gama Alta*) generan la mayor parte de los ingresos reales de la empresa.

* **Evaluación de Rendimiento de Catálogo:** Sirve como insumo para reportes ejecutivos o paneles de BI (Power BI, Tableau), mostrando qué marcas y modelos dentro de una categoría específica dominan la preferencia de los clientes.