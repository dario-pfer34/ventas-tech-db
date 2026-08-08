/* =====================================================
   Entregable
    Pre-entrega: Consultas SQL de negocio

             Título: Extrayendo métricas clave con SQL
   ===================================================== */



/* =====================================================
   Consulta 1 — Resumen ejecutivo mensual
   ===================================================== */

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta);

/* =====================================================
   Consulta 2 — Ranking de productos Top 5
   ===================================================== */

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;

/* =====================================================
   Consulta 3 — Clientes recurrentes
   ===================================================== */

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC, total_gastado DESC;

/* =====================================================
   Consulta 4 — Meses por encima/por debajo del promedio
   ===================================================== */

WITH ventas_por_mes AS (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)

SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado >= (
            SELECT AVG(total_facturado)
            FROM ventas_por_mes
        )
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM ventas_por_mes
ORDER BY mes;




/* =====================================================
   Al final del archivo agregá un bloque de comentarios -- con 3 hallazgos concretos que encontraste al revisar los resultados.
   ===================================================== */


   --1.El producto con id_producto = 2 (Mouse Inalámbrico) vendío 13 unidades, 
   --lo representa el 44.82% de las unidades vendidas en general, en Marzo.

   --2.Solo los clientes con id_cliente = 1, 5 y 3 superaron el ticket promedio del mes, 
   --y los dos primeros superaron x3 el ticket promedio del mes.

   --3. Aunque todos los clientes realizaron 2 pedidos, existe una diferencia
   -- importante en el gasto acumulado. El cliente con id_cliente 1 gastó 2640, mientras
   -- que el cliente con id_cliente 4 gastó 510. Esto muestra que una misma frecuencia
   -- de compra puede representar valores de facturación muy diferentes.
