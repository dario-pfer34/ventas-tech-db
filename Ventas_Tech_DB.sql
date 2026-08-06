/* =====================================================
   CHECKPOINT: SCRIPT SQL DE INGENIERÍA DE DATOS
   Base de datos: Ventas_Tech_DB
   ===================================================== */

IF DB_ID('Ventas_Tech_DB') IS NULL
BEGIN
    CREATE DATABASE Ventas_Tech_DB;
END;
GO

USE Ventas_Tech_DB;
GO

/* Eliminar tablas si ya existen.
   Se borran primero las que tienen claves foráneas. */

DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;
GO

/* =====================================================
   SECCIÓN 1: DEFINICIÓN DEL ESQUEMA - DDL
   ===================================================== */

CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion VARCHAR(100)
);
GO

CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    ciudad VARCHAR(50),
    fecha_registro DATE NOT NULL
);
GO

CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    id_categoria INT NOT NULL,

    CONSTRAINT FK_Productos_Categorias
        FOREIGN KEY (id_categoria)
        REFERENCES categorias(id_categoria)
);
GO

CREATE TABLE ventas (
    id_venta INT PRIMARY KEY,
    fecha_venta DATE NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,

    CONSTRAINT FK_Ventas_Clientes
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente),

    CONSTRAINT FK_Ventas_Productos
        FOREIGN KEY (id_producto)
        REFERENCES productos(id_producto)
);
GO

/* =====================================================
   SECCIÓN 2: CARGA INICIAL DE DATOS - DML
   ===================================================== */

INSERT INTO categorias
    (id_categoria, nombre_categoria, descripcion)
VALUES
    (1, 'Computación', 'Laptops, PCs y monitores'),
    (2, 'Audio', 'Auriculares, parlantes y micrófonos'),
    (3, 'Accesorios', 'Mouse, teclados y otros periféricos'),
    (4, 'Gaming', 'Consolas y accesorios gamer'),
    (5, 'Redes', 'Routers, switches y repetidores');
GO

INSERT INTO clientes
    (id_cliente, nombre, email, ciudad, fecha_registro)
VALUES
    (1, 'María López', 'maria.lopez@gmail.com', 'Buenos Aires', '2024-01-15'),
    (2, 'Carlos Ruiz', 'carlos.ruiz@gmail.com', 'Córdoba', '2024-02-10'),
    (3, 'Ana Gómez', 'ana.gomez@gmail.com', 'Rosario', '2024-03-05'),
    (4, 'Juan Pérez', 'juan.perez@gmail.com', 'Mendoza', '2024-04-20'),
    (5, 'Sofía Torres', 'sofia.torres@gmail.com', 'La Plata', '2024-05-12');
GO

INSERT INTO productos
    (id_producto, nombre_producto, precio, stock, id_categoria)
VALUES
    (1, 'Laptop Lenovo IdeaPad', 1250000.00, 12, 1),
    (2, 'Monitor LG 24 pulgadas', 210000.00, 20, 1),
    (3, 'Auriculares Sony WH-CH520', 93000.00, 35, 2),
    (4, 'Parlante JBL Go 3', 75000.00, 18, 2),
    (5, 'Mouse Logitech M185', 22000.00, 60, 3),
    (6, 'Teclado Mecánico Redragon', 95000.00, 30, 3),
    (7, 'Control Xbox Series', 160000.00, 22, 4),
    (8, 'Router TP-Link AX1800', 110000.00, 15, 5);
GO

INSERT INTO ventas
    (id_venta, fecha_venta, cantidad, precio_unitario, id_cliente, id_producto)
VALUES
    (1, '2024-07-15', 1, 1250000.00, 1, 1),
    (2, '2024-07-16', 2, 22000.00, 2, 5),
    (3, '2024-07-18', 1, 110000.00, 5, 8),
    (4, '2024-07-19', 2, 93000.00, 3, 3),
    (5, '2024-07-20', 1, 210000.00, 4, 2),
    (6, '2024-07-20', 1, 75000.00, 5, 4),
    (7, '2024-07-21', 3, 22000.00, 1, 5),
    (8, '2024-07-21', 1, 95000.00, 2, 6),
    (9, '2024-07-22', 1, 160000.00, 3, 7),
    (10, '2024-07-22', 1, 1250000.00, 4, 1),
    (11, '2024-07-23', 2, 110000.00, 5, 8),
    (12, '2024-07-23', 1, 210000.00, 1, 2),
    (13, '2024-07-24', 2, 75000.00, 2, 4),
    (14, '2024-07-25', 1, 93000.00, 3, 3),
    (15, '2024-07-26', 2, 95000.00, 4, 6),
    (16, '2024-07-27', 1, 160000.00, 5, 7),
    (17, '2024-07-28', 1, 1250000.00, 2, 1);
GO

/* =====================================================
   SECCIÓN 3: CONSULTAS DE VALIDACIÓN
   ===================================================== */

SELECT * FROM categorias;
SELECT * FROM clientes;
SELECT * FROM productos;
SELECT * FROM ventas;

SELECT COUNT(*) AS TotalCategorias FROM categorias;
SELECT COUNT(*) AS TotalClientes FROM clientes;
SELECT COUNT(*) AS TotalProductos FROM productos;
SELECT COUNT(*) AS TotalVentas FROM ventas;
GO