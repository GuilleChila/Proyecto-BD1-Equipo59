USE LaptopDeel;

CREATE TABLE NOTEBOOK (
    id_notebook        INT IDENTITY(1,1) PRIMARY KEY,
    marca              VARCHAR(50) NOT NULL,
    modelo             VARCHAR(50) NOT NULL,
    precio             DECIMAL(12,2) NOT NULL,
    stock              INT NOT NULL DEFAULT 0,
    id_procesador      INT NOT NULL,
    id_pantalla        INT NOT NULL,
    id_tarjeta_grafica INT NULL,
    CONSTRAINT FK_Notebook_Procesador FOREIGN KEY (id_procesador)      REFERENCES PROCESADOR(id_procesador),
    CONSTRAINT FK_Notebook_Pantalla   FOREIGN KEY (id_pantalla)        REFERENCES PANTALLA(id_pantalla),
    CONSTRAINT FK_Notebook_Tarjeta    FOREIGN KEY (id_tarjeta_grafica) REFERENCES TARJETA_GRAFICA(id_tarjeta_grafica),
    CONSTRAINT CK_Notebook_Precio CHECK (precio >= 0),
    CONSTRAINT CK_Notebook_Stock  CHECK (stock >= 0)
);
GO

CREATE TABLE NOTEBOOK_CATEGORIA (
    id_notebook  INT NOT NULL,
    id_categoria INT NOT NULL,
    CONSTRAINT PK_NotebookCategoria PRIMARY KEY (id_notebook, id_categoria),
    CONSTRAINT FK_NotebookCategoria_Notebook  FOREIGN KEY (id_notebook)  REFERENCES NOTEBOOK(id_notebook),
    CONSTRAINT FK_NotebookCategoria_categoria FOREIGN KEY (id_categoria) REFERENCES CATEGORIA(id_categoria)
);
GO


CREATE TABLE NOTEBOOK_RAM (
    id_notebook_ram INT IDENTITY(1,1) PRIMARY KEY,
    id_notebook     INT NOT NULL,
    id_ram          INT NOT NULL,
    CONSTRAINT FK_NotebookRam_Notebook FOREIGN KEY (id_notebook) REFERENCES NOTEBOOK(id_notebook),
    CONSTRAINT FK_NotebookRam_Ram      FOREIGN KEY (id_ram)      REFERENCES RAM(id_ram)
);
GO


CREATE TABLE NOTEBOOK_ALMACENAMIENTO (
    id_notebook_almacenamiento INT IDENTITY(1,1) PRIMARY KEY,
    id_notebook                INT NOT NULL,
    id_almacenamiento          INT NOT NULL,
    CONSTRAINT FK_NotebookAlmacenamiento_Notebook       FOREIGN KEY (id_notebook)       REFERENCES NOTEBOOK(id_notebook),
    CONSTRAINT fk_NotebookAlmacenamiento_Almacenamiento FOREIGN KEY (id_almacenamiento) REFERENCES ALMACENAMIENTO(id_almacenamiento)
);
GO
