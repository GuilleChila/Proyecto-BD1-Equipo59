USE LaptopDeel;

CREATE TABLE PROCESADOR (
    id_procesador INT IDENTITY(1,1) PRIMARY KEY,
    marca         VARCHAR(50) NOT NULL,
    generacion    VARCHAR(20),
    velocidad     DECIMAL(4,2) NOT NULL,
    nucleos       INT NOT NULL,
    hilos         INT NOT NULL,
    tiene_grafica BIT NOT NULL DEFAULT 1,
    CONSTRAINT CK_Procesador_Vel     CHECK (velocidad > 0),
    CONSTRAINT CK_Procesador_Nucleos CHECK (nucleos > 0),
    CONSTRAINT CK_Procesador_Hilos   CHECK (hilos > 0)
);
GO

CREATE TABLE PANTALLA (
    id_pantalla   INT IDENTITY(1,1) PRIMARY KEY,
    pulgadas      DECIMAL(4,1) NOT NULL,
    tipo          VARCHAR(30) NOT NULL,
    tactil        BIT NOT NULL DEFAULT 0,
    tasa_refresco INT,
    CONSTRAINT CK_Pantalla_Pulgadas CHECK (pulgadas > 0),
    CONSTRAINT CK_Pantalla_Tasa     CHECK (tasa_refresco IS NULL OR tasa_refresco > 0)
);
GO


CREATE TABLE TARJETA_GRAFICA (
    id_tarjeta_grafica INT IDENTITY(1,1) PRIMARY KEY,
    marca              VARCHAR(50) NOT NULL,
    modelo             VARCHAR(50) NOT NULL,
    vram_capacidad     INT NOT NULL,
    tipo_memoria       VARCHAR(20) NOT NULL,
    CONSTRAINT CK_Tarjeta_Vram CHECK (vram_capacidad > 0)
);
GO


CREATE TABLE RAM (
    id_ram     INT IDENTITY(1,1) PRIMARY KEY,
    generacion VARCHAR(20) NOT NULL,
    capacidad  INT NOT NULL,
    velocidad  INT NOT NULL,
    CONSTRAINT CK_Ram_Capacidad CHECK (capacidad > 0),
    CONSTRAINT CK_Ram_Velocidad CHECK (velocidad > 0)
);
GO


CREATE TABLE ALMACENAMIENTO (
    id_almacenamiento INT IDENTITY(1,1) PRIMARY KEY,
    tipo              VARCHAR(20) NOT NULL,
    capacidad         INT NOT NULL,
    velocidad         INT,
    CONSTRAINT CK_Almacenamiento_Capacidad CHECK (capacidad > 0),
    CONSTRAINT CK_Almacenamiento_Velocidad  CHECK (velocidad IS NULL OR velocidad > 0)
);
GO
