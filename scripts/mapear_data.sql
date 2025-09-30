/* Poblar tabla DimShipping */
SELECT
    Shippers.ShipperID,
    Shippers.CompanyName,
    Shippers.Phone
FROM Shippers;

/* Poblar tabla DimCustomer */
SELECT
    *,
    Regioncita = ISNULL(Region, 'Otros')
FROM Customers;

/* Poblar tabla DimDate */
SELECT DISTINCT
    s.ShippedDate AS TheDate,
    DateName(dw, s.ShippedDate) AS DayOfWeek,
    DatePart(mm, s.ShippedDate) AS [Month],
    DatePart(Y, s.ShippedDate) AS [Year],
    DatePart(qq, s.ShippedDate) AS [Quarter],
    DatePart(dy, s.ShippedDate) AS DayOfYear,
    DateName(month, s.ShippedDate) + '_' + DateName(year,s.ShippedDate) AS YearMonth,
    DatePart(wk, s.ShippedDate) AS WeekOfYear
FROM Orders s
    WHERE s.ShippedDate IS NOT NULL;

/* Poblar tabla DimProduct */
SELECT
    Categories.CategoryName,
    Products.ProductID,
    Products.ProductName,
    Suppliers.CompanyName,
    Products.UnitPrice
FROM Products
INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID;

/* Poblar DimEmpleado */
SELECT
    EmployeeID,
    FirstName + ',' + LastName AS EmployeeName,
    HireDate
FROM Employees

/* Poblar tabla FactSales */
SELECT
    Northwind_Mart.dbo.Dim_Tiempo.Tiempo_key,
    Northwind_Mart.dbo.Dim_Cliente.Cliente_key,
    Northwind_Mart.dbo.Dim_Transportista.Transportista_key,
    Northwind_Mart.dbo.Dim_Producto.Producto_key,
    Northwind_Mart.dbo.Dim_Empleado.Empleado_key,
    Northwind.dbo.Orders.RequiredDate,
    Northwind.dbo.Orders.Freight * Northwind.dbo.[Order Details].Quantity
        / (SELECT SUM(Quantity) FROM Northwind.dbo.[Order Details] od WHERE od.OrderID = Northwind.dbo.Orders.OrderID)
        AS LineItemFreight,
    Northwind.dbo.[Order Details].UnitPrice * Northwind.dbo.[Order Details].Quantity AS LineItemTotal,
    Northwind.dbo.[Order Details].Quantity AS LineItemQuantity,
    Northwind.dbo.[Order Details].Discount * Northwind.dbo.[Order Details].UnitPrice * Northwind.dbo.[Order Details].Quantity AS LineItemDiscount
FROM Northwind.dbo.Orders
INNER JOIN Northwind.dbo.[Order Details] ON Northwind.dbo.Orders.OrderID = Northwind.dbo.[Order Details].OrderID
INNER JOIN Northwind_Mart.dbo.Dim_Producto ON Northwind.dbo.[Order Details].ProductID = Northwind_Mart.dbo.Dim_Producto.Producto_Codigo
INNER JOIN Northwind_Mart.dbo.Dim_Cliente ON Northwind.dbo.Orders.CustomerID COLLATE Modern_Spanish_CI_AS = Northwind_Mart.dbo.Dim_Cliente.Cliente_Codigo COLLATE Modern_Spanish_CI_AS
INNER JOIN Northwind_Mart.dbo.Dim_Tiempo ON Northwind.dbo.Orders.ShippedDate = Northwind_Mart.dbo.Dim_Tiempo.Tiempo_Fecha
INNER JOIN Northwind_Mart.dbo.Dim_Transportista ON Northwind.dbo.Orders.ShipVia = Northwind_Mart.dbo.Dim_Transportista.Transportista_Codigo
INNER JOIN Northwind_Mart.dbo.Dim_Empleado ON Northwind.dbo.Orders.EmployeeID = Northwind_Mart.dbo.Dim_Empleado.Empleado_Codigo
WHERE (Northwind.dbo.Orders.ShippedDate IS NOT NULL)

