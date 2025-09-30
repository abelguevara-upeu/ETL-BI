-- Datamart para NORTHW
-- Crear la base de datos Northwind_Mart
CREATE DATABASE Northwind_Mart;
GO

USE Northwind_Mart;
GO
-- Creación de tablas de dimensiones y tabla de hechos

-- DIMENSIONES

-- Dim_Cliente
CREATE TABLE Dim_Cliente (
    Cliente_key INT IDENTITY(1,1) PRIMARY KEY,
    Cliente_Compania NVARCHAR(40),
    Cliente_Contacto NVARCHAR(30),
    Cliente_Codigo NCHAR(5),
    Cliente_Titulo_Cont NVARCHAR(30),
    Cliente_Direccion NVARCHAR(60),
    Cliente_Ciudad NVARCHAR(15),
    Cliente_Region NVARCHAR(15),
    Cliente_CodigoPostal NVARCHAR(10),
    Cliente_Pais NVARCHAR(15),
    Cliente_Telefono NVARCHAR(24),
    Cliente_Fax NVARCHAR(24)
);
GO

-- Dim_Producto
CREATE TABLE Dim_Producto (
    Producto_key INT IDENTITY(1,1) PRIMARY KEY,
    Producto_Nombre VARCHAR(40),
    Producto_Sustituto VARCHAR(40),
    Producto_Categoria VARCHAR(15),
    Producto_Codigo INT,
    Producto_PrecioUnit MONEY
);
GO

-- Dim_Transportista
CREATE TABLE Dim_Transportista (
    Transportista_key INT IDENTITY(1,1) PRIMARY KEY,
    Transportista_Nombre NVARCHAR(40),
    Transportista_Codigo INT
);
GO

-- Dim_Tiempo
CREATE TABLE Dim_Tiempo (
    Tiempo_key INT IDENTITY(1,1) PRIMARY KEY,
    Tiempo_MesAnnio NVARCHAR(30),
    Tiempo_DiaSemana NVARCHAR(20),
    Tiempo_Feriado NVARCHAR(1),
    Tiempo_FinSemana NVARCHAR(1),
    Tiempo_Trimestre INT,
    Tiempo_Dia_Annio INT,
    Tiempo_Semana_Annio INT,
    Tiempo_Mes INT,
    Tiempo_Annio INT,
    Tiempo_Fecha DATETIME
);
GO

-- Dim_Empleado
CREATE TABLE Dim_Empleado (
    Empleado_key INT IDENTITY(1,1) PRIMARY KEY,
    Empleado_Nombre NVARCHAR(30),
    Empleado_FechaCont DATETIME,
    Empleado_Codigo INT
);
GO

-- TABLA DE HECHOS - Fact_Ventas
CREATE TABLE Fact_Ventas (
    Cliente_key INT,
    Producto_key INT,
    Transportista_key INT,
    Tiempo_key INT,
    Empleado_key INT,
    -- Campos adicionales de medidas
    Descuento_lineaItem MONEY,
    Cantidad_lineaItem SMALLINT,
    Flete_lineaItem MONEY,
    Total_lineaItem MONEY,
    FechaRequerida DATETIME,
    -- Llave primaria compuesta
    PRIMARY KEY (Cliente_key, Producto_key, Transportista_key, Tiempo_key, Empleado_key),
    -- Foreign keys
    FOREIGN KEY (Cliente_key) REFERENCES Dim_Cliente(Cliente_key),
    FOREIGN KEY (Producto_key) REFERENCES Dim_Producto(Producto_key),
    FOREIGN KEY (Transportista_key) REFERENCES Dim_Transportista(Transportista_key),
    FOREIGN KEY (Tiempo_key) REFERENCES Dim_Tiempo(Tiempo_key),
    FOREIGN KEY (Empleado_key) REFERENCES Dim_Empleado(Empleado_key)
);

-- Índices para mejorar el rendimiento en consultas
CREATE INDEX IX_Fact_Ventas_Cliente ON Fact_Ventas(Cliente_key);
CREATE INDEX IX_Fact_Ventas_Producto ON Fact_Ventas(Producto_key);
CREATE INDEX IX_Fact_Ventas_Transportista ON Fact_Ventas(Transportista_key);
CREATE INDEX IX_Fact_Ventas_Tiempo ON Fact_Ventas(Tiempo_key);
CREATE INDEX IX_Fact_Ventas_Empleado ON Fact_Ventas(Empleado_key);
CREATE INDEX IX_Fact_Ventas_FechaRequerida ON Fact_Ventas(FechaRequerida);

-- Mensaje de confirmación
PRINT 'Esquema del Data Warehouse NORTHW creado exitosamente!';
