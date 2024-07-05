---Realizar un SP que permita visualizar lo vendido a los clientes mostrando el nombre del cliente y en año 
CREATE PROCEDURE MostrarVentas
    @Año INT
AS
BEGIN
    SELECT 
        c.CompanyName AS NombreCliente,
        COUNT(DISTINCT o.OrderID) AS NumeroPedidos,
        SUM(od.Quantity * od.UnitPrice) AS TotalVendido
    FROM 
        Customers c
        INNER JOIN Orders o ON c.CustomerID = o.CustomerID
        INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
    WHERE 
        YEAR(o.OrderDate) = @Año
    GROUP BY 
        c.CompanyName
    ORDER BY 
        c.CompanyName;
END;
GO

-- Ejecutar el SP
EXEC MostrarVentas @Año = 1998;


---crear un sp donde agregue un product
CREATE PROCEDURE AgregarProducto
    @ProductName NVARCHAR(40),
    @SupplierID INT,
    @CategoryID INT,
    @QuantityPerUnit NVARCHAR(20),
    @UnitPrice DECIMAL(18, 2),
    @UnitsInStock SMALLINT,
    @UnitsOnOrder SMALLINT,
    @ReorderLevel SMALLINT
AS
BEGIN
    INSERT INTO Products (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel)
    VALUES (@ProductName, @SupplierID, @CategoryID, @QuantityPerUnit, @UnitPrice, @UnitsInStock, @UnitsOnOrder, @ReorderLevel);
END;
GO

-- Ejecutar el SP
EXEC AgregarProducto 
    @ProductName = 'Tortillinas', 
    @SupplierID = 1, 
    @CategoryID = 1, 
    @QuantityPerUnit = '3', 
    @UnitPrice = 20.50, 
    @UnitsInStock = 100, 
    @UnitsOnOrder = 50, 
    @ReorderLevel = 10;

	select * from Products



-- Crear la base de datos AlmacenDatos
CREATE DATABASE AlmacenDeDatosG3;
GO

-- Usar la base de datos AlmacenDatos
USE AlmacenDeDatosG3;
GO

-- Crear la tabla Customers
CREATE TABLE Customers (
    ClienteId nchar(5) NOT NULL,
    Clientebk int,
    CompanyName nvarchar(30) NULL,
    Address nvarchar(60) NULL,
    City nvarchar(15) NULL,
    Region nvarchar(15) NULL,
    Country nvarchar(15) NULL,
    CONSTRAINT PK_Customers PRIMARY KEY CLUSTERED (ClienteId)
);
GO

-- Crear la tabla Ventas
CREATE TABLE Ventas (
    ClienteId nchar(5) NOT NULL,
    ProductoId int NOT NULL,
    EmployeId int NOT NULL,
    SupplerId int NOT NULL,
    UnitPrice money NOT NULL,
    Quantity smallint NOT NULL,
    CONSTRAINT PK_Ventas PRIMARY KEY (ClienteId, ProductoId, EmployeId, SupplerId),
    CONSTRAINT FK_Ventas_Customers FOREIGN KEY (ClienteId) REFERENCES Customers(ClienteId),
    CONSTRAINT FK_Ventas_Products FOREIGN KEY (ProductoId) REFERENCES Products(ProductId),
    CONSTRAINT FK_Ventas_Employees FOREIGN KEY (EmployeId) REFERENCES Employees(EmployeeId),
    CONSTRAINT FK_Ventas_Supplier FOREIGN KEY (SupplerId) REFERENCES Supplier(ShipperId)
);
GO

-- Crear la tabla Supplier
CREATE TABLE Supplier (
    ShipperId int IDENTITY(1,1) NOT NULL,
    Shipperbk int,
    CompanyName nvarchar(40) NOT NULL,
    Country nvarchar(15) NULL,
    Address nvarchar(60) NULL,
    City nvarchar(15) NULL,
    CONSTRAINT PK_Supplier PRIMARY KEY (ShipperId)
);
GO

-- Crear la tabla Employees
CREATE TABLE Employees (
    EmployeeId int IDENTITY(1,1) NOT NULL,
    Employeebk int,
    FullName nvarchar(80) NOT NULL,
    Title nvarchar(30) NULL,
    HireDate datetime NULL,
    Address nvarchar(60) NULL,
    City nvarchar(15) NULL,
    Region nvarchar(15) NULL,
    Country nvarchar(15) NULL,
    CONSTRAINT PK_Employees PRIMARY KEY (EmployeeId)
);
GO

-- Crear la tabla Products
CREATE TABLE Products (
    ProductId int IDENTITY(1,1) NOT NULL,
    Productbk int,
    ProductName nvarchar(40) NOT NULL,
    CategoryName nvarchar(40) NOT NULL,
    CONSTRAINT PK_Products PRIMARY KEY (ProductId)
);
GO