create database vistaspractica;
use vistaspractica;

--crear una vista de la siguiente consulta  alter es para cambiar datos create para crear 

Alter view view_categorias_productos
as
select c.CategoryName,
p.ProductName as 'Nombre Producto',
p.UnitPrice as 'Precio',
p.UnitsInStock as 'existencia'
from 
northwind.dbo.categories as c 
INNER join northwind.dbo.Products as p 
on c.CategoryID = p.CategoryID;

select * from view_categorias_productos

select *, (precio*existencia) as [precio Inventario]
from view_categorias_productos
where [nombre categoria] in ('Beverages', 'Condiments')
order by [nombre categoria] desc;

--Seleccionar la suma del precio del inventario agrupado por categoria 
select CategoryName as 'Categoria', SUM (UnitPrice*UnitsInStock) as 'Suma precio del inventario'
 from view_categorias_productos
 GROUP BY CategoryName
