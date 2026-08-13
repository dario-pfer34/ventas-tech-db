-- =========================================================
-- M5 - Cruzando tablas para enriquecer el análisis.
-- Base utilizada: Ventas_Tech_DB
-- 
-- Nota:
-- La base disponible contiene las tablas:
-- clientes, ventas, productos y categorias.
-- No incluye las columnas segmento, region o canal.
-- Por este motivo, las consultas fueron adaptadas a la
-- estructura real de la base.
-- En la Consulta 4 se simula el canal únicamente dentro
-- de la consulta, sin modificar los datos originales.
-- =========================================================


-- =========================================================
-- CONSULTA 1 - Vista base del proyecto (INNER JOIN)
--Al combinar ventas, clientes, productos y categorías, 
--se puede analizar cada transacción con mayor contexto y calcular directamente el total_venta. 
--Esto permite identificar qué clientes compraron qué productos y a qué categoría pertenece cada venta.
-- =========================================================

SELECT 
    ventas.id_venta,
    ventas.fecha_venta,
    clientes.nombre,
    productos.nombre_producto,
    categorias.nombre_categoria,
    ventas.cantidad,
    ventas.precio_unitario,
    ventas.cantidad * ventas.precio_unitario AS total_venta
FROM ventas
INNER JOIN clientes
    ON ventas.id_cliente = clientes.id_cliente
INNER JOIN productos
    ON ventas.id_producto = productos.id_producto
INNER JOIN categorias
    ON productos.id_categoria = categorias.id_categoria;


-- =========================================================
-- CONSULTA 2 — Clientes sin ventas (LEFT JOIN)
-- Clientes registrados que no tienen ventas. Se utiliza LEFT JOIN + IS NULL. En los datos actuales no se encontraron clientes sin ventas.
-- 
--
-- No se encontraron clientes registrados sin ventas asociadas. 
-- Esto indica que, dentro del conjunto actual de datos, todos los clientes han realizado al menos una compra.
-- =========================================================

SELECT
    clientes.nombre,
    clientes.email,
    clientes.fecha_registro
FROM clientes
LEFT JOIN ventas
    ON clientes.id_cliente = ventas.id_cliente
WHERE ventas.id_venta IS NULL;


-- =========================================================
-- CONSULTA 3 — Productos sin ventas (LEFT JOIN)
-- Productos que nunca fueron vendidos. Se utiliza LEFT JOIN + IS NULL. En los datos actuales no se encontraron productos sin ventas.
--
--
-- No se encontraron productos sin ventas asociadas. 
-- Por lo tanto, todos los productos registrados en la base tuvieron al menos una transacción.
-- =========================================================

SELECT
    productos.nombre_producto,
    categorias.nombre_categoria,
    productos.precio
FROM productos
LEFT JOIN ventas
    ON productos.id_producto = ventas.id_producto
INNER JOIN categorias
    ON categorias.id_categoria = productos.id_categoria
WHERE ventas.id_venta IS NULL;

--
-- CONSULTA 4 — Consolidado por canal (UNION ALL)
-- Consolidado de ventas por canal utilizando UNION ALL.
--
-- La tabla ventas no contiene una columna canal.
-- Para demostrar el uso de UNION ALL se simulan dos canales:
-- id_venta par   = Online
-- id_venta impar = Presencial
--
-- Esta clasificación se realiza únicamente durante la consulta
-- y no modifica la información almacenada en la base.
--
--
-- La consulta permite comparar el total vendido entre los canales simulados Online y Presencial. 
-- Como la base original no contiene una columna canal, 
-- esta clasificación se utilizó únicamente para demostrar el uso de UNION ALL y GROUP BY, sin modificar los datos originales.
-- Dentro de la clasificación simulada, el canal Presencial obtuvo una facturación mayor que el canal Online.
-- =========================================================

SELECT
    canal,
    SUM(total_venta) AS total_por_canal
FROM (
    SELECT
        'Online' AS canal,
        ventas.id_venta,
        ventas.cantidad,
        ventas.precio_unitario,
        ventas.cantidad * ventas.precio_unitario AS total_venta
    FROM ventas
    WHERE ventas.id_venta % 2 = 0

    UNION ALL

    SELECT
        'Presencial' AS canal,
        ventas.id_venta,
        ventas.cantidad,
        ventas.precio_unitario,
        ventas.cantidad * ventas.precio_unitario AS total_venta
    FROM ventas
    WHERE ventas.id_venta % 2 <> 0
) AS ventas_por_canal
GROUP BY canal;