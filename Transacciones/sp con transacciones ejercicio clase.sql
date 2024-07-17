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