-- PASO 5: Poblado inicial (DML)

-- Clases Padre no tienen dependencias
INSERT INTO ROL (descripcion) VALUES
('Administrador'),
('Vendedor'),
('Gerente');
GO

SELECT * FROM ROL;

INSERT INTO CATEGORIA (nombre, descripcion) VALUES
('Gamer',       'Notebooks de alto rendimiento para juegos'),
('Oficina',     'Equipos para tareas administrativas'),
('Ultrabook',   'Portátiles delgados y livianos'),
('Workstation', 'Equipos de alto rendimiento para tareas profesionales'),
('Económica',   'Equipos de gama baja para uso básico');
GO

SELECT * FROM CATEGORIA;

INSERT INTO PROCESADOR (marca, generacion, velocidad, nucleos, hilos, tiene_grafica) VALUES
('Intel', '12th',        2.5, 8,  16, 1),
('AMD',   'Ryzen 5000',  3.2, 6,  12, 0),
('Intel', '11th',        2.4, 4,  8,  1),
('Intel', '13th',        2.8, 10, 20, 1),
('AMD',   'Ryzen 7000',  3.5, 8,  16, 0),
('Intel', '10th',        2.2, 4,  8,  1),
('AMD',   'Ryzen 3',     3.0, 4,  8,  0),
('Intel', '12th',        2.6, 6,  12, 1);
GO

SELECT * FROM PROCESADOR;

INSERT INTO PANTALLA (pulgadas, tipo, tactil, tasa_refresco) VALUES
(15.6, 'IPS',  0, 60),
(17.3, 'IPS',  0, 144),
(14.0, 'OLED', 1, 90),
(13.3, 'IPS',  0, 60),
(16.0, 'IPS',  0, 165),
(15.6, 'TN',   0, 60),
(14.0, 'IPS',  1, 60),
(17.3, 'IPS',  0, 60);
GO

SELECT * FROM PANTALLA;

INSERT INTO TARJETA_GRAFICA (marca, modelo, vram_capacidad, tipo_memoria) VALUES
('NVIDIA', 'RTX 3050',        4, 'GDDR6'),
('NVIDIA', 'RTX 4060',        8, 'GDDR6'),
('AMD',    'Radeon RX 6600M', 8, 'GDDR6'),
('NVIDIA', 'RTX 4070',        8, 'GDDR6'),
('NVIDIA', 'GTX 1650',        4, 'GDDR5'),
('AMD',    'Radeon RX 6500M', 4, 'GDDR6'),
('NVIDIA', 'RTX 3060',        6, 'GDDR6'),
('NVIDIA', 'Quadro T1000',    4, 'GDDR6');
GO

SELECT * FROM TARJETA_GRAFICA;

INSERT INTO RAM (generacion, capacidad, velocidad) VALUES
('DDR4', 8,  3200),
('DDR4', 16, 3200),
('DDR5', 16, 4800),
('DDR4', 32, 3200),
('DDR5', 32, 5200),
('DDR4', 8,  2666),
('DDR5', 8,  4800),
('DDR4', 16, 2666);
GO

SELECT * FROM RAM;

INSERT INTO ALMACENAMIENTO (tipo, capacidad, velocidad) VALUES
('SSD', 256,  500),
('SSD', 512,  1000),
('HDD', 1024, 7200),
('SSD', 1024, 2000),
('HDD', 2048, 7200),
('SSD', 128,  450),
('SSD', 2048, 3500),
('HDD', 500,  5400);
GO

SELECT * FROM ALMACENAMIENTO;

-- Cargamos Usuario y Cliente que dependen de ROL
INSERT INTO USUARIO (Nombre, Apellido, Correo, clave, fecha_nacimiento, DNI, id_Rol) VALUES
('Juan',     'Perez',      'juan.perez@laptopdeel.com',     'hash1', '1985-03-12', '12345678', 1),
('Maria',    'Gomez',      'maria.gomez@laptopdeel.com',    'hash2', '1990-07-25', '23456789', 2),
('Roberto',  'Diaz',       'roberto.diaz@laptopdeel.com',   'hash3', '1988-11-05', '34567890', 3),
('Sofia',    'Fernandez',  'sofia.fernandez@laptopdeel.com','hash4', '1995-02-18', '45678901', 2),
('Martin',   'Lopez',      'martin.lopez@laptopdeel.com',   'hash5', '1992-09-30', '56789012', 2),
('Carla',    'Ruiz',       'carla.ruiz@laptopdeel.com',     'hash6', '1998-06-14', '67890123', 1),
('Diego',    'Torres',     'diego.torres@laptopdeel.com',   'hash7', '1983-12-01', '78901234', 3),
('Valeria',  'Sosa',       'valeria.sosa@laptopdeel.com',   'hash8', '1991-04-22', '89012345', 2);
GO

SELECT * FROM USUARIO;

INSERT INTO CLIENTE (nombre, apellido, Correo, Telefono, Direccion, IVA, DNI) VALUES
('Pedro',      'Alvarez',  'pedro.alvarez@mail.com',      '3811234567', 'Av. Siempre Viva 123', 'Consumidor Final',      '11111111'),
('Lucia',      'Benitez',  'lucia.benitez@mail.com',      '3812345678', 'Calle Falsa 456',      'Responsable Inscripto', '22222222'),
('Gabriel',    'Molina',   'gabriel.molina@mail.com',     '3813456789', 'Mitre 789',            'Monotributo',           '33333333'),
('Florencia',  'Castro',   'florencia.castro@mail.com',   '3814567890', 'San Martin 234',       'Consumidor Final',      '44444444'),
('Nicolas',    'Romero',   'nicolas.romero@mail.com',     '3815678901', 'Belgrano 567',         'Exento',                '55555555'),
('Camila',     'Herrera',  'camila.herrera@mail.com',     '3816789012', 'Rivadavia 890',        'Responsable Inscripto', '66666666'),
('Tomas',      'Vega',     'tomas.vega@mail.com',         '3817890123', 'Pellegrini 123',       'Monotributo',           '77777777'),
('Agustina',   'Ortiz',    'agustina.ortiz@mail.com',     '3818901234', 'Colon 456',            'Consumidor Final',      '88888888');
GO

SELECT * FROM CLIENTE;

-- ESTO DEBE FALLAR: el rol no existe
INSERT INTO USUARIO (Nombre, Apellido, Correo, clave, fecha_nacimiento, DNI, id_Rol)
VALUES ('Test', 'Test', 'test@test.com', 'x', '2000-01-01', '99999999', 99);
GO

-- Cargamos notebook, depende de procesador, pantalla y tarjeta grafica
INSERT INTO NOTEBOOK (marca, modelo, precio, stock, id_procesador, id_pantalla, id_tarjeta_grafica) VALUES
('Lenovo', 'IdeaPad 3',     450000.00,  10, 1, 1, NULL),
('ASUS',   'ROG Strix G15', 1500000.00, 2,  2, 2, 1),
('Dell',   'XPS 13',        850000.00,  3,  3, 3, NULL),
('HP',     'Pavilion 15',   520000.00,  8,  6, 4, NULL),
('Lenovo', 'Legion 5',      1350000.00, 4,  5, 5, 2),
('Acer',   'Aspire 5',      480000.00,  12, 7, 6, NULL),
('ASUS',   'Zenbook 14',    780000.00,  5,  8, 7, NULL),
('MSI',    'Katana GF66',   1600000.00, 3,  4, 8, 4);
GO

SELECT id_notebook, marca, modelo, precio, stock FROM NOTEBOOK;

-- Cargamos las relaciones de muchos a muchos
INSERT INTO NOTEBOOK_CATEGORIA (id_notebook, id_categoria) VALUES
(1, 2),  -- Lenovo IdeaPad 3 -> Oficina
(2, 1),  -- ASUS ROG -> Gamer
(3, 3),  -- Dell XPS -> Ultrabook
(4, 5),  -- HP Pavilion -> Económica
(5, 1),  -- Lenovo Legion -> Gamer
(6, 5),  -- Acer Aspire -> Económica
(7, 3),  -- ASUS Zenbook -> Ultrabook
(8, 1);  -- MSI Katana -> Gamer
GO

SELECT * FROM NOTEBOOK_CATEGORIA;

-- Una notebook puede tener varias categorías (N:M): se agrega una segunda
-- categoría a la notebook 1, que ya tenía "Oficina" asignada
INSERT INTO NOTEBOOK_CATEGORIA (id_notebook, id_categoria) VALUES (1, 1);
GO

SELECT * FROM NOTEBOOK_CATEGORIA WHERE id_notebook = 1;

-- NOTEBOOK_RAM: una notebook puede tener 2 módulos de RAM del mismo tipo
-- (ej. 2 x 8GB DDR4 3200 en dual channel)
INSERT INTO NOTEBOOK_RAM (id_notebook, id_ram) VALUES
(1, 1),  -- Lenovo -> DDR4 8GB (módulo 1)
(1, 1),  -- Lenovo -> DDR4 8GB (módulo 2, mismo tipo: 2 pentes iguales)
(2, 3),  -- ASUS ROG -> DDR5 16GB
(3, 2),  -- Dell XPS -> DDR4 16GB
(4, 1),  -- HP Pavilion -> DDR4 8GB
(5, 4),  -- Legion -> DDR4 32GB
(6, 6),  -- Acer -> DDR4 8GB 2666
(7, 8),  -- Zenbook -> DDR4 16GB 2666
(8, 5);  -- Katana -> DDR5 32GB
GO

SELECT * FROM NOTEBOOK_RAM ORDER BY id_notebook;

-- NOTEBOOK_ALMACENAMIENTO: misma lógica que RAM, se permiten 2 discos
-- iguales en la misma notebook 
INSERT INTO NOTEBOOK_ALMACENAMIENTO (id_notebook, id_almacenamiento) VALUES
(1, 1),  -- Lenovo -> SSD 256
(2, 2),  -- ASUS ROG -> SSD 512
(2, 2),  -- ASUS ROG -> SSD 512 (segundo disco igual, ej. RAID)
(3, 2),  -- Dell XPS -> SSD 512
(4, 1),  -- HP Pavilion -> SSD 256
(4, 3),  -- HP Pavilion también HDD 1024
(5, 4),  -- Legion -> SSD 1024
(6, 6),  -- Acer -> SSD 128
(7, 4),  -- Zenbook -> SSD 1024
(8, 7),  -- Katana -> SSD 2048
(8, 3);  -- Katana también HDD 1024
GO

SELECT * FROM NOTEBOOK_ALMACENAMIENTO ORDER BY id_notebook;

-- Tablas de ventas (dependen de USUARIO, CLIENTE y NOTEBOOK)

INSERT INTO VENTA (id_usuario, id_Cliente, estado, monto_total) VALUES
(2, 1, 'Confirmada', 450000.00),
(4, 2, 'Confirmada', 1500000.00),
(2, 3, 'Pendiente',  850000.00),
(4, 4, 'Confirmada', 520000.00),
(2, 5, 'Anulada',    1350000.00),
(4, 6, 'Confirmada', 480000.00),
(2, 7, 'Confirmada', 780000.00),
(4, 8, 'Pendiente',  1600000.00);
GO

SELECT * FROM VENTA;

INSERT INTO DETALLE_VENTA (id_notebook, id_venta, cantidad, precio_unitario) VALUES
(1, 1, 1, 450000.00),
(2, 2, 1, 1500000.00),
(3, 3, 1, 850000.00),
(4, 4, 1, 520000.00),
(5, 5, 1, 1350000.00),
(6, 6, 1, 480000.00),
(7, 7, 1, 780000.00),
(8, 8, 1, 1600000.00);
GO

SELECT * FROM DETALLE_VENTA;

INSERT INTO VENTA_METODO_PAGO (id_venta, metodo_pago) VALUES
(1, 'Tarjeta de crédito'),
(2, 'Transferencia'),
(3, 'Efectivo'),
(4, 'Tarjeta de débito'),
(5, 'Tarjeta de crédito'),
(6, 'Efectivo'),
(7, 'Transferencia'),
(8, 'Tarjeta de débito');
GO

SELECT * FROM VENTA_METODO_PAGO;
