declare @x INT
set @x=10

print 'El valor de x es: '+ cast(@x as VARCHAR)

if @x >=0
BEGIN
    print 'El numero es positivo'
END
ELSE
BEGIN
    PRINT 'El numero es negativo'
END

DECLARE @i as INT
set @i=1
while (@i<=10)
BEGIN
    print cast (@i as VARCHAR)
    set @i=@i+1
end;

/*DECLARE @i INT
set @i = 1 
while @i <=10
begin 
print 'El primer valor es' + cast(@i as varchar)
set @i= @1+1
end */

------crear un sp
create procedure  procedure_ciclo
as
begin
    DECLARE @i INT
    set @i = 1

    while @i<=10
begin
        print 'El primer valor es' + cast(@i as varchar)
        set @i= @i + 1
    end
end ;

-----Lo puso para dos veces 
declare @ii int = 1

while  @ii <= 2
begin
exec procedure_ciclo
set @ii = @ii +1
end

-------sp - suma1 realizar un sp que sume dos numeros cualquiera y que imprima el resultado----

create procedure  sp_suma1
as
begin
    DECLARE @suma INT
    set @suma = 4 + 5

        print 'La suma es:' + cast (@suma as varchar)
    end

execute  sp_suma1






--Tarea realizar un sp que muestre todas las ventas realizadas por cliente para un año cualquiera

select c.CompanyName as 'Nombre del Cliente', 
Sum(od.Quantity * od.UnitPrice) as 'Total' 
from customers as c
INNER JOIN orders as o 
ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] as od
on od.OrderID = o.OrderID
where DATEPART(YEAR,o.OrderDate) = 1996
GROUP BY c.CompanyName;


CREATE OR ALTER PROC sp_ventasporcliente
   --Parametros
   @year as int 
AS   
BEGIN
   select c.CompanyName as 'Nombre del Cliente', 
    Sum(od.Quantity * od.UnitPrice) as 'Total' 
    from customers as c
    INNER JOIN orders as o 
    ON c.CustomerID = o.CustomerID
    INNER JOIN [Order Details] as od
    on od.OrderID = o.OrderID
    where DATEPART(YEAR,o.OrderDate) = @year
    GROUP BY c.CompanyName

END;

--Ejecutar sp
EXEC sp_ventasporcliente 1997

execute sp_ventasporcliente 1996

exec sp_ventasporcliente @year = 1998

--Ejercicio1: Realizar un store procedure que muestre un reporte de ventas por cliente y producto(agrupado),de un rango de fecha.

select c.CompanyName as 'Nombre del Cliente', 
p.ProductName as 'Nombr del producto'
from customers as c
INNER JOIN Products as p
ON c.CustomerID = p.CategoryID
INNER JOIN [Order Details] as od
on od.OrderID = 
where DATEPART(YEAR,o.OrderDate) = 1996
GROUP BY c.CompanyName;

select * FROM Products


--Ejercicio2: Realizar un store procedure que inserte un cliente nuevo
CREATE OR ALTER PROC agregar_cliente
--Parametros de entrada
    @CustomerID nchar(5) ,
    @CompanyName nvarchar(40),
    @ContactName nvarchar(30) =  null,
    @ContactTitle nvarchar(30) =  null,
    @Address nvarchar(60) =  null,
    @City nvarchar(15) =  null,
    @Region nvarchar(15) =  null,
    @PostalCode nvarchar(10) =  null,
    @Country nvarchar(15) =  null,
    @Phone nvarchar(24) =  null,
    @Fax nvarchar(24) =  null
AS
BEGIN
    INSERT INTO [dbo].[Customers]
           ([CustomerID]
           ,[CompanyName]
           ,[ContactName]
           ,[ContactTitle]
           ,[Address]
           ,[City]
           ,[Region]
           ,[PostalCode]
           ,[Country]
           ,[Phone]
           ,[Fax])
     VALUES (@CustomerID
           ,@CompanyName
           ,@ContactName
           ,@ContactTitle
           ,@Address
           ,@city
           ,@Region
           ,@PostalCode
           ,@Country
           ,@Phone
           ,@Fax)
END;
GO

select * from Customers

--Agrega el cliente
begin TRANSACTION
exec agregar_cliente
    @CustomerID = 'GTIG3' ,
    @CompanyName = 'Patito de Huele',
    @ContactName = 'Edith campos',
    @ContactTitle = 'Tutora',
    @Address = 'calle del infierno',
    @City = 'Tula',
    @Region = 'Sur',
    @PostalCode = '42800',
    @Country = 'Mexico',
    @Phone = '33-345678'

--Seleccionamos nuestro cliente que agregamos recientemente
select * from Customers
where CustomerID = 'GTIG3'
