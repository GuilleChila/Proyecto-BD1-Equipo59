CREATE DATABASE LaptopDeelPrueba;

USE LaptopDeelPrueba;

-- 1. ROL
CREATE TABLE ROL (
    id_Rol INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL UNIQUE
);
GO

-- 2. USUARIO
CREATE TABLE USUARIO (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    Correo VARCHAR(150) NOT NULL UNIQUE,
    clave VARCHAR(255) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    DNI CHAR(8) NOT NULL UNIQUE,
    id_Rol INT NOT NULL,
    CONSTRAINT FK_Usuario_Rol FOREIGN KEY (id_Rol) REFERENCES ROL(id_Rol)
);
GO

-- 3. CLIENTE
CREATE TABLE CLIENTE (
    id_Cliente INT IDENTITY(1,1) PRIMARY KEY,
    nombre    VARCHAR(50) NOT NULL,
    apellido   VARCHAR(50) NOT NULL,
    Correo     VARCHAR(100),
    Telefono   VARCHAR(20),
    Direccion  VARCHAR(150),
    IVA        VARCHAR(30),
    DNI        VARCHAR(10) NOT NULL UNIQUE,
    CONSTRAINT CK_Cliente_Iva CHECK (IVA IN ('Responsable Inscripto', 'Monotributo', 'Consumidor Final', 'Exento'))
);
GO
