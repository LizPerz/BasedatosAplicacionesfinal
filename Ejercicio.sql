---Realizar un SP que permita visualizar lo vendido a los clientes mostrando el nombre del cliente y en año 
create procedure vizualizar_ventas
@Año INT 
AS
BEGIN
select
c.CompanyName as nombreCliente,
o.OrderID as IDpedido,
o.OrderDate as Fechadepedido,
od.ProductID as IDProducto,
p.ProductName as nombre_producto,
od.Quantity as cantidad,
od.UnitPrice as PrecioUnitario,
(od.Quantity*od.UnitPrice) as Totalventa

from 
Orders as o 
INNER JOIN
Customers as c 
ON o.CustomerID= c.CustomerID
INNER JOIN
[Order Details] as od 
ON
o.OrderID = od.OrderID
INNER JOIN
Products as p 
ON p.ProductID = od.ProductID
where 
year (o.OrderDate) = @Año 
ORDER by 
c.CompanyName, o.OrderDate;
END;

EXEC vizualizar_ventas @Año = 1998;

---crear un sp donde agregue un products
INSERT into 




-- Crear la base de datos AlmacenDatos
CREATE DATABASE AlmacenDatos;
GO

-- Usar la base de datos AlmacenDatos
USE AlmacenDatos;
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