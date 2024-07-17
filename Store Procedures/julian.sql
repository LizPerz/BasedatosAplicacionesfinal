---La suma total de un cliente 
use Northwind

create or alter proc sp_sumacliente
 		@CustomerID varchar (5)
		as begin 
select sum (Quantity*od.UnitPrice)from [Order Details] as od
inner join orders as o
on o.OrderID= od.OrderID
where o.CustomerID= @CustomerID
end

exec sp_sumacliente 'ALFKI';
select *from Customers