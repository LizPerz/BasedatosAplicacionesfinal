-- consultas avanzadas 
--seleccionar cuantos productos tiene cada categoria
--Agrupaciones (group by)
select * from Products
--nunca podemos poner una funcion de agregado en una columna como el count
select CategoryID, COUNT(*) FROM Products
SELECT CategoryID from Products
SELECT COUNT(*) from Products

select CategoryID, COUNT(*) FROM Products
GROUP BY CategoryID

SELECT * from Categories
--alias de tabla foreign key products 
select c.CategoryName, COUNT(*) as 'numero de productos '
from Categories as c
INNER JOIN Products as p 
on c.CategoryID=p.CategoryID
GROUP BY c.CategoryName;

-- Consultar para mostrar todos los productos juntos con sus categorias y sus precios 
Select  from Categories
SELECT*from Products

Select c.CategoryName,p.UnitPrice  from Categories as c 
INNER JOIN Products as p
on c.CategoryID=p.CategoryID

--Consulta para mostrar los nombres de los productos y los nombres d es sus proveedores 
Select s.CompanyName as 'Nombre del proveedor',p.ProductName 'Nombre del producto'  from Products as p
INNER JOIN Suppliers as s
on p.SupplierID= s.SupplierID
order by s.CompanyName
--Selelcionar las ordenes de compra mostrando los nombres de los productos y sus importes 
select od.OrderID as 'numero de orden ', p.ProductName as 'Nombre del producto ',
(od.Quantity  * od. UnitPrice) as 'importe'
from [Order Details] as od 
INNER JOIN
Products as p 
on od.ProductID=p.ProductID
where (od.Quantity*od.UnitPrice)<=1500
ORDER by 'importe' desc

--Mostrar las ordenes de compra y los empleados que las  realizaron 
SELECT o.OrderID as 'Numero de orden',
CONCAT(e.FirstName,'',e.LastName) as 'nombre completo'  --aqui para que se ponga junto el first y last
from Employees as e 
INNER JOIN Orders as o 
on o.EmployeeID=e.EmployeeID
where YEAR(OrderDate) in ('1996','199');
--selaccionar las ordenes mostrando los clientes a los que se les hicieron las cantidades vendidas y los nombres de los productos

--Ejercicio 1: Obtener el nombre del cliente y el nombre del empleado del representante de ventas de cada pedido.
SELECT o. OrderID as 'Numero de orden',
o.OrderDate as 'Fecha orden',
c.CompanyName as 'Nombre del cliente',
CONCAT(e.FirstName,'',e.LastName) as 'nombre del empleado'
 from Employees as e 
INNER JOIN 
orders as o
on e.EmployeeID= o. EmployeeID
INNER JOIN 
Customers as C 
on o.CustomerID= c.CustomerID 
--Ejercicio 2: Mostrar el nombre del producto, el nombre del proveedor y el precio unitario de cada producto.
Select p.ProductName as 'Nombre del producto', 
s.CompanyName as 'Nombre del proveedor',
p.UnitPrice as 'precio'
from Products as p
INNER JOIN Suppliers as s 
on p.SupplierID= s.SupplierID;

SELECT p.ProductName,s.CompanyName,p.UnitPrice
 FROM (
    select SupplierID,ProductName,UnitPrice from Products
 ) as P
 INNER JOIN
 Suppliers as s 
 on p.SupplierID=s.SupplierID;

SELECT p.ProductName,s.CompanyName,p.UnitPrice
 from (
    select SupplierID,CompanyName
    from Suppliers
 )as s
 INNER JOIN
 products as p 
 on p.SupplierID= s.SupplierID;
--Ejercicio 3: Listar el nombre del cliente, el ID del pedido y la fecha del pedido para cada pedido.
SELECT * from Orders
SELECT *  from Customers

Select c.CompanyName as 'Nombre de cliente',
 o.OrderID as ' Numero de orden', 
 o.OrderDate as 'Fecha de orden',
YEAR(o.OrderDate) as 'Año de compra',
MONTH(o.OrderDate) as 'Mes de compra',
DAY(o.OrderDate) as 'Dia de compra'
from Customers as c
INNER JOIN Orders as o
on c.CustomerID=o.CustomerID
----------------------------------------------------------

Select c.CompanyName as 'Nombre de cliente',
 o.OrderID as ' Numero de orden', 
 o.OrderDate as 'Fecha de orden',
YEAR(o.OrderDate) as 'Año de compra',
MONTH(o.OrderDate) as 'Mes de compra',
DAY(o.OrderDate) as 'Dia de compra'
from (
    select CustomerID,CompanyName from Customers
)as c
INNER JOIN
(SELECT CustomerID,OrderID,OrderDate from Orders) as o
on c.CustomerID=o.CustomerID
--Ejercicio 4: Obtener el nombre del empleado, el título del cargo y el territorio del empleado para cada empleado.

SELECT CONCAT(e.FirstName, '' , e.LastName) as 'Nombre del empleado',
e.Title as 'Cargo', t.TerritoryDescription as 'Territorio'
from EmployeeTerritories AS et 
INNER JOIN Employees as  e 
on et.EmployeeID= e.EmployeeID  
INNER join Territories as t 
on t.TerritoryID= et.TerritoryID;
------------------------------------------------------------------------------------------

SELECT CONCAT(e.FirstName, '' , e.LastName) as 'Nombre del empleado',
e.Title as 'Cargo', t.TerritoryDescription as 'Territorio'
from (
select TerritoryID, EmployeeID from EmployeeTerritories
)as et
INNER JOIN 
(
    select EmployeeID,FirstName,LastName,Title from Employees ) as e
    on et.EmployeeID=e.EmployeeID
    INNER JOIN (select TerritoryID, TerritoryDescription from Territories) as t 
    on t.TerritoryID= et.TerritoryID

--  Ejercicio reto 
--seleccionar todas las ordenes mostrando el empleado que la realizo, el cliente al que se le vendio
--el nombre de los productos sus categorias el precio que se vendio, las unidades vendidas y el importe
-- de enero de 1997 a feb de 1998
--employees
--Customers
--products
-- categories
--order details 
--orders

select CONCAT(FirstName,'',LastName) as 'Nombre del empleado',
c.CompanyName as 'cliente',
p.ProductName as 'Nnombre dle producto',
ca.CategoryName as 'categoria',
od.UnitPrice as 'precio',
od.Quantity as 'cantidad', (od.UnitPrice * od.Quantity) as 'importe'
from Employees as e
INNER JOIN Orders as o 
on e.EmployeeID=o.EmployeeID
INNER JOIN Customers as c 
on o.CustomerID=  c.CustomerID
INNER JOIN [Order Details] as od 
on o.OrderID= od.OrderID
INNER JOIN Products as p 
on p.ProductID =od. ProductID
INNER join Categories as ca 
on ca.CategoryID = p.CategoryID
where o.OrderDate between '1997-01-01' and '1998-02-28'
and ca.CategoryName in ('Beverages')
order by c.CompanyName 

--cuanto he vendido de la categoria berberages 
select sum (od.UnitPrice*od.Quantity) as 'Total de ventas'
from Categories as c
INNER JOIN Products as p 
on c.CategoryID= p.CategoryID
INNER JOIN [Order Details] as od 
on od. ProductID=p.ProductID
INNER join Orders as o 
on o.OrderID = od.OrderID
where o.OrderDate between '1997-01-01' and '1998-02-28'
and c.CategoryName in ('Beverages');

--Ejercicio 5: Mostrar el nombre del proveedor, el nombre del contacto y el teléfono del contacto para cada proveedor.
--Ejercicio 6: Listar el nombre del producto, la categoría del producto y el nombre del proveedor para cada producto.
--Ejercicio 7: Obtener el nombre del cliente, el ID del pedido, el nombre del producto y la cantidad del producto para cada detalle del pedido.
--Ejercicio 8: Obtener el nombre del empleado, el nombre del territorio y la región del territorio para cada empleado que tiene asignado un territorio.
--Ejercicio 9: Mostrar el nombre del cliente, el nombre del transportista y el nombre del país del transportista para cada pedido enviado por un transportista.
--Ejercicio 10: Obtener el nombre del producto, el nombre de la categoría y la descripción de la categoría para cada producto que pertenece a una categoría.