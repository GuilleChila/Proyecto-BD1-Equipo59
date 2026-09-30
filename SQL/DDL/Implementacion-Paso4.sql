use LaptopDeel

-- 14. VENTA
CREATE TABLE VENTA (
    id_venta    INT IDENTITY(1,1) PRIMARY KEY,
    fecha_hora  DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    estado      VARCHAR(20) NOT NULL DEFAULT 'Pendiente',
    monto_total DECIMAL(12,2) NOT NULL DEFAULT 0,
    id_usuario  INT NOT NULL,
    id_Cliente  INT NOT NULL,
    CONSTRAINT FK_Venta_Usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
    CONSTRAINT FK_Venta_Cliente FOREIGN KEY (id_Cliente) REFERENCES CLIENTE(id_Cliente),
    CONSTRAINT CK_Venta_Estado CHECK (estado IN ('Pendiente', 'Confirmada', 'Anulada', 'Expirada')),
    CONSTRAINT CK_Venta_Monto  CHECK (monto_total >= 0)
);
GO

-- 15. VENTA_METODO_PAGO
CREATE TABLE VENTA_METODO_PAGO (
    id_venta    INT NOT NULL,
    metodo_pago VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Vmp PRIMARY KEY (id_venta, metodo_pago),
    CONSTRAINT FK_Vmp_Venta FOREIGN KEY (id_venta) REFERENCES VENTA(id_venta)
);
GO

-- 16. DETALLE_VENTA
CREATE TABLE DETALLE_VENTA (
    id_notebook     INT NOT NULL,
    id_venta        INT NOT NULL,
    cantidad        INT NOT NULL,
    precio_unitario DECIMAL(12,2) NOT NULL,
    subtotal        AS (CAST(cantidad * precio_unitario AS DECIMAL(12,2))) PERSISTED, -- El CAST fuerza a que el resultado sea exactamente DECIMAL(12,2)
    CONSTRAINT PK_DV PRIMARY KEY (id_notebook, id_venta),
    CONSTRAINT FK_DV_Notebook FOREIGN KEY (id_notebook) REFERENCES NOTEBOOK(id_notebook),
    CONSTRAINT FK_DV_Venta    FOREIGN KEY (id_venta)    REFERENCES VENTA(id_venta),
    CONSTRAINT CK_Detcantidad CHECK (cantidad > 0),
    CONSTRAINT CK_Detalle_Precio   CHECK (precio_unitario >= 0)
);
GO