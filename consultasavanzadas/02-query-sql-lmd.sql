use [Bdventas]
--Consulta de otra base de datos "dbo" son esquemas--
select * from [Northwind].dbo.Customers;
go
select * from cliente;
go
-- Insertar en la tabla clente varios en una sola instruccion--

insert into cliente (rfc,curp,nombre,Apellido1,Apellido2)
Values ('jlhg1983154545x','PEAL050905MHGRTZA1','Alfreds Futterkiste','Perez','Atanacio')
insert into cliente (rfc,curp,nombre,Apellido1,Apellido2)
Values ('nhdsg1983154xnxjs','PEAhvh8090xhka','Yamileth','Gonz','Hernandez'),
('habasn85hs','JdjsncjES090xa','Julia','abrilz','Sanchez'),
('jdjsnfjs154js','sjajcbjs452a','Viridiana','Gallardo','Ortega');
go 
-- selecciona los datos--
select * from cliente
--Reinicia los s--
truncate table cliente
--Elimina los datos--
delete from cliente
go
--Comando para reiniciar en identity de una tabla
DBCC CHECKIDENT (cliente, RESEED, 0)
go
--	Crea una tabla aapartir de una consulta
--TOP 0 el top sirve para solo seleccionar de hasta donde quiero observar de manera ascedente--
select top 0 employeeid as 'empleado id',LastName as 'Segundo nombre',
FirstName as 'Primer nombre', --as es como--
BirthDate as 'FechaNacimiento',
HireDate as 'FechaContratacion', 
Address as 'Direccion', 
City as 'City', 
Region, PostalCode as 'CodigoPostal',
Country as 'pais'
into empleado2
from Northwind.dbo.Employees
go
--este es para consultar los finales order by desc--
SELECT TOP 5* FROM Northwind.dbo.[Order Details]
order by OrderID desc

--Insertar datos a apartir de una consulta 
insert into empleado2 (empleadoid,Segundo nombre,Primer nombre,FechaNacimiento,FechaContratacion,Direccion,City,Region,CodigoPostal,pais) --Seleccionar datos de una tabla--

select  employeeid as 'empleadoid',LastName as 'Segundo nombre',
FirstName as 'Primer nombre', --as es como--
BirthDate as 'FechaNacimiento',
HireDate as 'FechaContratacion', 
Address as 'Direccion', 
City as 'City', 
Region as 'Region',
PostalCode as 'CodigoPostal',
Country as 'pais'
from Northwind.dbo.Employees
--Alteera una tabla agregandole uns constraint de primary key--
alter table empleado2 add constraint pk_empleado2
primary key ([empleado id]) --Los corchetes es por si hay espacios--

insert into empleado2
--Eliminar tabala  es el drop--
drop table  empleado2
go 
select * from empleado2;


select * from cliente
select * from empleado

insert into empleado (nombre, Apellidp1, apellido2, curp, rfc, numeroexterno, calle, salario, numeronomina)
values ('Alan', 'Santiago', 'Molina', 'ALAN090545HM', 'ALSM056SK', 23, 'Calle del infierno', 30000.0,123456),
('Yamileth','Mejia','Rangel','YMSJAJHSS', 'gfdsgfjbfuw',null,'Calle del habanero',7680.17,23756),
('MOISES','SANTIAGO','ISIDRO','MSHSIEY54', 'HRETAZD51',null,'Calle de la gordura',20000,98765)

select * from ordencompra

--insertas orden compra no deja
insert into ordencompra
values (getDate(),'2024-06-10',1,2),
(Getdate(),'2024-07-10',6,3)

select * from producto
select ProductID,ProductName,UnitPrice,UnitsInStock,
SupplierID from Northwind.dbo.Products
select*from provedor
select*from Northwind.dbo.Suppliers
insert into provedor

select SupplierID,CompanyName,PostalCode, 'Calle del sol',City,2345 as cp,
'www.prueba.com.mx' as 'paginaweb' from Northwind.dbo.Suppliers

insert into producto(numerocontrol,descripción,precio,[estatus],existencia,proveedorid)
select ProductID,ProductName,UnitPrice,Discontinued,
UnitsInStock,SupplierID from Northwind.dbo.Products

where SupplierID =1

select * from producto

delete from producto

select * from provedor

delete from provedor

select * from ordencompra

insert into ordencompra(fechacompra

insert into detallecompra
values (2,2,20,
(select precio from producto where numerocontrol =2))

select * from detallecompra
update producto
set precio = 20.2
where numerocontrol =1
select * from producto
where numerocontrol= 1 

insert into detallecompra
values (1,1,30,
(select precio from producto where numerocontrol =1))

--seleccionar las ordenes de compra realizadas al producto 1
select *, (cantidad*preciocompra) as importe
from detallecompra --la coma es todos los cAmpos
where productoid=1
--Seleccionar el total a pagar de las ordenes que contienen el producto1
select sum(cantidad * preciocompra)as 'total'
from detallecompra
where productoid=1
--Selecciona la fecha c¿actual del sistema
select GETDATE()


select * from provedor