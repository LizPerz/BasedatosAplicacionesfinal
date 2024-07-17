--Asesoria 
--stores procedures 
--instruccions de control 
--Realiza procesos 
/*
consultas : insert update y delete 
*/

create database asesoria 
use asesoria
create table empleado (
id_empleado int primary key identity (1,1),
nombre varchar (20),
apellido1 varchar (50),
apellido2 varchar (50),
salario money) ;
insert into empleado(nombre, apellido1, apellido2, salario)
values('Luis','Herrera', 'Gallardo', '2000')

create or alter proc sp_agregar_empleado
---parametros 
@nombre varchar (20)= 'Jose',
@apellido1 varchar (20),
@apellido2 varchar (20),
@salario money 
as 
begin 
insert into empleado (nombre,apellido1,apellido2,salario)
values (@nombre,@apellido1,@apellido2,@salario);
end ;
go 

---Inovacion del sp ---
exec sp_agregar_empleado 'Ricardo', 'Ramirez','hernandez',50000;
execute sp_agregar_empleado default ,'Gonzalez','Rubio',60000;
exec sp_agregar_empleado @salario=30000,@nombre='soyla',@apellido1='Del coral', @apellido2='vaca';
select * from empleado
--Eliminar tablas
delete empleado
where id_empleado=4

--Realizar un sp que muestre el total de las compras hechas por cada una de mis clientes  northwid
/**/
use Northwind;
GO

create or alter proc sp_Consulta_comprasClientes 
as 
begin

select c.CompanyName as 'cliente', sum (od.quantity * od.unitprice)
from Customers as c                          
inner join Orders as o
on c.CustomerID=o.CustomerID
inner join [Order Details] as od 
on o.OrderID=od.OrderId
group by c.CompanyName;
end;

GO

use northwind

----EJERCCIO1--
---Obtener el total de ventas por país (necesitamos orders, customers y ordersDetails )

select c.Country, SUM(od.UnitPrice * od.Quantity) as total /** (1 - od.Discount)) AS TotalSales "con descuento del 1 "*/
from Orders as o
inner join Customers as c 
on o.CustomerID = c.CustomerID
inner join [Order Details] as od 
on o.OrderID = od.OrderID
GROUP BY 
    c.Country
ORDER BY 
    total DESC;
	go
---EJERCICIO 2---
--Encontrar el producto más vendido en cada categoría--
SELECT 
    cat.CategoryName as 'Nombre de la categoria',
    prod.ProductName as 'Nombre del producto',
    SUM(od.Quantity) AS 'Cantidad total'
FROM 
    Categories cat
    JOIN Products as prod 
	ON cat.CategoryID = prod.CategoryID
    JOIN [Order Details] as od 
	ON prod.ProductID = od.ProductID
GROUP BY 
    cat.CategoryName, prod.ProductName
	/*
HAVING 
    SUM(od.Quantity) = (
        SELECT 
            MAX(SumQuantity)
        FROM (
            SELECT 
                SUM(od2.Quantity) AS SumQuantity
            FROM 
                Products prod2
                JOIN [Order Details] od2 ON prod2.ProductID = od2.ProductID
            WHERE 
                prod2.CategoryID = cat.CategoryID
            GROUP BY 
                prod2.ProductID
        ) AS MaxQuantities
    );*/
	go

	--EJERCICIO 3---
	--Obtener los empleados que han manejado más pedidos
	SELECT em.EmployeeID 'ID del empleado',
	em.FirstName 'Nombre',
	em.LastName 'Apellido',
	COUNT(o.OrderID) AS 'Total de ordenes'
	FROM 
	Employees AS em
	inner join Orders as o 
	on em.EmployeeID = o.EmployeeID
	group by em.EmployeeID, em.FirstName, em.LastName
	order by 
	[Total de ordenes] asc;
	
	----EJECICIO 4---------
	---Encontrar los clientes que han realizado más compras

SELECT 
    c.CustomerID,
    c.CompanyName,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS Totalcompras
FROM 
    Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN  [Order Details] od ON o.OrderID = od.OrderID
GROUP BY 
    c.CustomerID, c.CompanyName
ORDER BY 
    Totalcompras DESC;

	---EJERCICIO 6---
	--Actualizar los precios de los productos de una categoría específica UN 10%

UPDATE Products
SET UnitPrice = UnitPrice * 1.10
WHERE CategoryID = (
    SELECT CategoryID
    FROM Categories
    WHERE CategoryName = 'Beverages'
);

---EJERCICIO 7---
--Contar el número de pedidos realizados en un rango de años
SELECT COUNT(*) AS TotalOrders
FROM Orders
WHERE OrderDate BETWEEN '1996-01-01' AND '1998-12-31';

--EJERICICIO 8
--Obtener el producto más caro en cada categoría
SELECT 
    c.CategoryName,
    p.ProductName,
    p.UnitPrice
FROM 
    Products p
    JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE 
    p.UnitPrice = (
        SELECT MAX(p2.UnitPrice)
        FROM Products p2
        WHERE p2.CategoryID = p.CategoryID
    )
ORDER BY 
    c.CategoryName;
---EJERCICIO 9
---Queremos aplicar un descuento del 5% a los productos que hayan vendido más de 1000 unidades en total.
UPDATE Products
SET UnitPrice = UnitPrice * 0.95
WHERE ProductID IN (
    SELECT ProductID
    FROM [Order Details]
    GROUP BY ProductID
    HAVING SUM(Quantity) > 1000
);

--EJERCICIO 10--
--Queremos obtener el total de ventas por año y país, mostrando el año, el país y el total de ventas.
SELECT 
    YEAR(o.OrderDate) AS Year,
    c.Country,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS Total
FROM 
    Orders o
    JOIN Customers c ON o.CustomerID = c.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY 
    YEAR(o.OrderDate), c.Country
ORDER BY 
    Year, Total  DESC;

	---EJERCICIO 11--
	---Encontrar los empleados con el mayor número de pedidos en un rango de fechas
	SELECT 
    e.EmployeeID,
    e.LastName,
    e.FirstName,
    COUNT(o.OrderID) AS Numerodeordenes 
FROM 
    Employees e
    JOIN Orders o ON e.EmployeeID = o.EmployeeID
WHERE 
    o.OrderDate BETWEEN '1997-01-01' AND '1998-12-31'
GROUP BY 
    e.EmployeeID, e.LastName, e.FirstName
ORDER BY 
    Numerodeordenes  DESC;
	---EJERCICIO 12
	--Actualizar el título de empleados basado en el número de pedidos que han manejado
	UPDATE Employees
SET Title = 'Senior'
WHERE EmployeeID IN (
    SELECT e.EmployeeID
    FROM Employees e
    JOIN Orders o ON e.EmployeeID = o.EmployeeID
    GROUP BY e.EmployeeID
    HAVING COUNT(o.OrderID) > 150
);

---EJERCCIO 13
---Obtener el total de ventas por cliente en un rango de fechas
SELECT 
    c.CustomerID,
    c.CompanyName,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSales
FROM 
    Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE 
    o.OrderDate BETWEEN '1997-01-01' AND '1998-12-31'
GROUP BY 
    c.CustomerID, c.CompanyName
ORDER BY 
    TotalSales DESC;


	--ejermplo 
	UPDATE Employees
SET Title = 'Manager'
WHERE EmployeeID = 1;

	--EJERCICIO 14
	---Queremos obtener una lista de todos los productos y sus detalles de pedidos, incluyendo los productos que no han sido pedidos.
	SELECT 
    p.ProductID,
    p.ProductName,
    od.OrderID,
    od.Quantity
FROM 
    Products p
    LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID;
	---EJERCICIO 15
	--Queremos obtener una lista de todos los pedidos y sus detalles de productos, incluyendo los pedidos que no tienen detalles.
	SELECT 
    o.OrderID,
    o.OrderDate,
    od.ProductID,
    od.Quantity
FROM 
    Orders o
    RIGHT JOIN [Order Details] od ON o.OrderID = od.OrderID;
--EJERCICIO 16
--Encontrar productos sin pedidos utilizando LEFT JOIN
SELECT 
    p.ProductID,
    p.ProductName
FROM 
    Products p
LEFT JOIN 
    [Order Details] od ON p.ProductID = od.ProductID
WHERE 
    od.OrderID IS NULL;

	---EJERCICIO 17
	--Obtener el total de ventas por país incluyendo países sin ventas utilizando RIGHT JOIN
	SELECT 
    c.Country,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSales
FROM 
    Customers c
RIGHT JOIN 
    Orders o ON c.CustomerID = o.CustomerID
RIGHT JOIN 
    [Order Details] od ON o.OrderID = od.OrderID
GROUP BY 
    c.Country
ORDER BY 
    TotalSales DESC;
	--EJERCICIO 18
	--Actualizar el estado de los pedidos con productos específicos utilizando subconsulta y LEFT JOIN

UPDATE Orders
SET orderstatus = 'Processed'
WHERE OrderID IN (
    SELECT o.OrderID
    FROM Orders o
    LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
    WHERE od.ProductID = 1
);

---ejercicio 19
--Contar el número de productos pedidos por cada categoría utilizando LEFT JOIN y GROUP BY
SELECT 
    c.CategoryName,
    COUNT(od.ProductID) AS NumberOfProductsOrdered
FROM 
    Categories c
LEFT JOIN 
    Products p ON c.CategoryID = p.CategoryID
LEFT JOIN 
    [Order Details] od ON p.ProductID = od.ProductID
GROUP BY 
    c.CategoryName
ORDER BY 
    NumberOfProductsOrdered DESC;






