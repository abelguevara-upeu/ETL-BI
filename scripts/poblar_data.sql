/* Populate Dim_Transportista table */

INSERT INTO Northwind_Mart.dbo.Dim_Transportista (Transportista_Nombre, Transportista_Codigo)
SELECT CompanyName, ShipperID
FROM Northwind.dbo.Shippers;

/* Populate Dim_Cliente table */
INSERT INTO Northwind_Mart.dbo.Dim_Cliente (
    Cliente_Compania, Cliente_Codigo, Cliente_Contacto, Cliente_Titulo_Cont,
    Cliente_Direccion, Cliente_Ciudad, Cliente_Region, Cliente_CodigoPostal,
    Cliente_Pais, Cliente_Telefono, Cliente_Fax
)
SELECT
    CompanyName,
    CustomerID,
    ContactName,
    ContactTitle,
    Address,
    City,
    ISNULL(Region, 'Otros'),
    PostalCode,
    Country,
    Phone,
    Fax
FROM Northwind.dbo.Customers;

/* Populate Dim_Tiempo table */
INSERT INTO Northwind_Mart.dbo.Dim_Tiempo (
    Tiempo_DiaSemana, Tiempo_Trimestre, Tiempo_Dia_Annio, Tiempo_Semana_Annio,
    Tiempo_Mes, Tiempo_Annio, Tiempo_Fecha, Tiempo_MesAnnio
)
SELECT DISTINCT
    DATENAME(dw, s.ShippedDate) AS Tiempo_DiaSemana,
    DATEPART(qq, s.ShippedDate) AS Tiempo_Trimestre,
    DATEPART(dy, s.ShippedDate) AS Tiempo_Dia_Annio,
    DATEPART(wk, s.ShippedDate) AS Tiempo_Semana_Annio,
    DATEPART(mm, s.ShippedDate) AS Tiempo_Mes,
    DATEPART(yy, s.ShippedDate) AS Tiempo_Annio,
    s.ShippedDate AS Tiempo_Fecha,
    DATENAME(month, s.ShippedDate) + '_' + DATENAME(year, s.ShippedDate) AS Tiempo_MesAnnio
FROM Northwind.dbo.Orders s
WHERE s.ShippedDate IS NOT NULL;

/* Populate Dim_Producto table */
INSERT INTO Northwind_Mart.dbo.Dim_Producto (
    Producto_Nombre, Producto_Sustituto, Producto_Categoria, Producto_Codigo, Producto_PrecioUnit
)
SELECT
    p.ProductName,
    s.CompanyName,
    c.CategoryName,
    p.ProductID,
    p.UnitPrice
FROM Northwind.dbo.Products p
INNER JOIN Northwind.dbo.Suppliers s ON p.SupplierID = s.SupplierID
INNER JOIN Northwind.dbo.Categories c ON p.CategoryID = c.CategoryID;

/* Populate Dim_Empleado table */
INSERT INTO Northwind_Mart.dbo.Dim_Empleado (
    Empleado_Nombre, Empleado_FechaCont, Empleado_Codigo
)
SELECT
    LastName,
    HireDate,
    EmployeeID
FROM Northwind.dbo.Employees;

/* Populate Fact_Ventas table */
INSERT INTO Northwind_Mart.dbo.Fact_Ventas (
    Tiempo_key, Cliente_key, Transportista_key, Producto_key, Empleado_key,
    FechaRequerida, Flete_lineaItem, Total_lineaItem, Cantidad_lineaItem, Descuento_lineaItem
)
SELECT
    t.Tiempo_key,
    c.Cliente_key,
    tr.Transportista_key,
    p.Producto_key,
    e.Empleado_key,
    o.RequiredDate,
    o.Freight * od.Quantity / (SELECT SUM(Quantity) FROM Northwind.dbo.[Order Details] od2 WHERE od2.OrderID = o.OrderID) AS Flete_linialtem,
    od.UnitPrice * od.Quantity AS Total_liniealtemp,
    od.Quantity AS Cantidad_lineaItem,
    od.Discount * od.UnitPrice * od.Quantity AS Descuento_lineaItem
FROM Northwind.dbo.Orders o
INNER JOIN Northwind.dbo.[Order Details] od ON o.OrderID = od.OrderID
INNER JOIN Northwind_Mart.dbo.Dim_Producto p ON od.ProductID = p.Producto_Codigo
INNER JOIN Northwind_Mart.dbo.Dim_Cliente c ON o.CustomerID COLLATE Modern_Spanish_CI_AS = c.Cliente_Codigo COLLATE Modern_Spanish_CI_AS
INNER JOIN Northwind_Mart.dbo.Dim_Tiempo t ON o.ShippedDate = t.Tiempo_Fecha
INNER JOIN Northwind_Mart.dbo.Dim_Transportista tr ON o.ShipVia = tr.Transportista_Codigo
INNER JOIN Northwind_Mart.dbo.Dim_Empleado e ON o.EmployeeID = e.Empleado_Codigo
WHERE o.ShippedDate IS NOT NULL;
