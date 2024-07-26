/* Realizar store procedure 
Actualizar el precio de los porductos y guardar en una tabla de historicodeprecios 
la tabla debe de llevar un id 
el id del porducto que se modifico
el precio anterior 
el precio nuevo 
fecha de modificacion*/
USE NORTHWIND

create table Historicoprecios (
idProducto int primary key,
precioAnterior money,
precionuevo money,
fechaModificacion DATETIME DEFAULT GETDATE() );

select * from Historicoprecios


---Crear sp 
create or alter procedure sp_Actualizarprecios
@idproducto int,
@precionuevo money 
as 
begin 
begin transaction  ---Que ejecute todo
begin try  --try y catch juntos 
declare @precioActual money; ---lo que no quiero que tome en cuenta en la hora de meter datos nuevos 

--consulta 
select @precioActual = UnitPrice
from Products
where 
ProductID = @idproducto;

update Products
set UnitPrice = @precionuevo
where ProductID = @idproducto

---Registros en la tabla de historicodeprecios 
insert into Historicoprecios (idProducto,precioAnterior,precionuevo,fechaModificacion)
values (@idproducto,@precioActual,@precionuevo,default);

commit transaction ---Hacerlo 
end try --TERMINARlo 
begin catch  ---ejecuta todo
rollback transaction  ---si lo hace y no esta completo que me regrese todo lo que hace
declare @mensajeError varchar (400)
set @mensajeError = ERROR_MESSAGE ();
print @mensajeError
end catch 
end;

select * from Products
where ProductID=1


---Aqui se ejecuta desde el store porcesudre click derecho y editamos ahi execute y editamos  

select * from [Order Details]










/*un sp que elimine una orden con su orderdetails y actualizar el stock del producto */

CREATE OR ALTER PROCEDURE sp_nuevaVenta
	@CustomerID nchar(5),
    @EmployeeID int,
    @OrderDate datetime,
    @RequiredDate datetime,
    @ShippedDate datetime,
    @ShipVia int,
    @Freight money = null,
    @ShipName nvarchar(40)=null,
    @ShipAddress nvarchar(60)=null,
    @ShipCity nvarchar(15)=null,
    @ShipRegion nvarchar(15)=null,
    @ShipPostalCode nvarchar(15) = null,
    @ShipCountry nvarchar(15) = null,
    @ProductID int,
    @UnitPrice money,
    @Quantity smallint,
    @Discount real
AS
BEGIN
Begin transaction
	begin try
	--Insertar en la tabla order
	INSERT INTO Northwind.dbo.Orders
           ([CustomerID]
           ,[EmployeeID]
           ,[OrderDate]
           ,[RequiredDate]
           ,[ShippedDate]
           ,[ShipVia]
           ,[Freight]
           ,[ShipName]
           ,[ShipAddress]
           ,[ShipCity]
           ,[ShipRegion]
           ,[ShipPostalCode]
           ,[ShipCountry])
     VALUES
           (@CustomerID,
           @EmployeeID,
           @OrderDate,
           @RequiredDate,
           @ShippedDate, 
           @ShipVia, 
           @Freight,
           @ShipName, 
           @ShipAddress, 
           @ShipCity, 
           @ShipRegion, 
           @ShipPostalCode, 
           @ShipCountry);

		   -- Obtener el ID insertado de la orden
		   Declare @orderId int
		   set @orderId = SCOPE_IDENTITY();

		   -- INSERTAR EN DETALLE_ORDEN EL PRODUCTO
		   -- OBTENER EL PRECIO DEL PRODUCTO A INSERTAR
		   DECLARE @PrecioVenta money 
		   select @PrecioVenta = UnitPrice from Products
		   where ProductID = @ProductID
		   --INSERTAR EN LA TABLA ORDER DETAILS
		   INSERT INTO Northwind.dbo.[Order Details]
           ([OrderID]
           ,[ProductID]
           ,[UnitPrice]
           ,[Quantity]
           ,[Discount])
     VALUES
           (@orderId,
           @ProductID,
           @PrecioVenta, 
           @Quantity, 
           @Discount);

		   -- actualizar la tabla products reduciendo el unitsinstock con la cantidad vendida 
		   UPDATE Northwind.dbo.Products
		   set UnitsInStock = UnitsInStock - @Quantity
		   where ProductID=@ProductID

	commit transaction
	end try
	begin catch
		rollback transaction
		declare @mensajeError varchar(400)
		set @mensajeError = ERROR_MESSAGE()
		print @mensajeError
	end catch


END




/*NOTA:
En un LEFT JOIN, la tabla a la izquierda del JOIN es la tabla principal, y la tabla a la derecha es la tabla secundaria.
Esto significa que se devuelven todas las filas de la tabla izquierda y las filas coincidentes de la tabla derecha.
SELECT columnas
FROM tabla_principal
LEFT JOIN tabla_secundaria ON tabla_principal.columna = tabla_secundaria.columna;

En un RIGHT JOIN, la tabla a la derecha del JOIN es la tabla principal, y la tabla a la izquierda es la tabla secundaria. 
Esto significa que se devuelven todas las filas de la tabla derecha y las filas coincidentes de la tabla izquierda.
SELECT columnas
FROM tabla_secundaria
RIGHT JOIN tabla_principal ON tabla_secundaria.columna = tabla_principal.columna;*/