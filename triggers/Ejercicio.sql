use  Northwind;
------------Examen-------------
/*Crear un tigger que permita gestionar una venta, en la cual se debe actualizar la existencia del producto
vendido, bajo las siguientes condiciones:
1) Verificar si la existencia es suficiente, si la existencia no es suficiente cancelar la interseccion.
2) Si es suficiente, agregar la venta y disminuir el stock del producto. -----"Se utiliza northwind" -------
1.- Insertar en orders
2.- Insertar en orderDetails
3.- Verificar si el unistock es suficiente 
4.- Si es suficiente aceptar la inserccion y disminuir el unistock lo vendido. */

/*Primero realizar SP para que products pase UnitsInStock*/
/*create or alter procedure Products_a_OrdersDetails
as 
begin select
od.OrderID,
od.ProductID,
od.UnitPrice,
od.Quantity,
od.Discount,
p.UnitsInStock
from [Order Details] as od 
inner join 
Products as p
on od.ProductID=p.ProductID
end; 
exec Products_a_OrdersDetails;

select*from Products;*/




create or alter trigger verificar_venta_stock
on [Order Details]
after insert,update
as
begin
	begin transaction
	declare @productid int,
	@UnitsInStock smallint,
	@orderid int,
	@quantity int

	set @quantity= (select Quantity from inserted)
    set @productid= (select ProductID from inserted)
	set @UnitsInStock=(select UnitsInStock from Products where ProductID=@productid)
	set @orderid=(select OrderID from inserted)

	if @quantity>@UnitsInStock
	begin
	rollback transaction
		raiserror('Cantidad superada en el stock, error',16,1)
	end

	if @quantity<=@UnitsInStock
	begin
		update Products set UnitsInStock=(@UnitsInStock-@quantity)
		where ProductID=@productid
	end
	commit
end;

------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
begin transaction

create or alter procedure sp_insertar_order
@OrderID int,
@ProductID int,
@Quantity smallint,
@discount real
as
begin
declare @UnitPrice money
select @UnitPrice=UnitPrice from Products where ProductID=@ProductID 
	if exists(select 1 from Products where ProductID=@ProductID)
	begin
		insert into [Order Details](OrderID,ProductID,UnitPrice,Quantity,Discount)
		values(@OrderID,@ProductID,@UnitPrice,@Quantity,@discount)
		print ('operacion exitosa') 
	end

else 
begin
print ('algo salio mal')
end
end


-----------------------------------------------------------------------------------------

declare @idproducto int=1, @idorder int=10400, @cantidad smallint=1,@descuento real=0
exec sp_insertar_order @OrderID=@idorder,@ProductID=@idproducto,@Quantity=@cantidad,@discount=@descuento

select * from Products
select * from [Order Details] where OrderID=10400

delete [Order Details] where OrderID=10400
