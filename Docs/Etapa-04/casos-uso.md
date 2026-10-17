# Casos de uso — Etapa IV

Esta etapa resuelve tres necesidades de información del negocio mediante
scripts SQL independientes, ubicados en `sql/consultas/`. Este documento
resume qué resuelve cada uno; el detalle técnico de cada consulta está en
su propio archivo.

| Caso de uso | Script | Necesidad de negocio |
|---|---|---|
| Comprobante de venta | `Factura.sql` | Mostrar el encabezado, detalle y total de una venta puntual, como un ticket o factura. |
| Reporte por vendedor/gerente | `reporte_vendedores.sql` | Medir el desempeño de ventas de cada vendedor-gerente en un período, también se hace un reporte de categorias. |
| Ranking de notebooks por categoría | `NotebookMasVendidaPorCategoria.sql` | Identificar qué notebooks se vendieron más dentro de cada categoría, en unidades y en dinero recaudado. |

Cada script se documenta en detalle en:
- `docs/etapa-04/comprobante-venta.md`
- `docs/etapa-04/informe-ventas.md`
- `docs/etapa-04/consulta-avanzada.md`
