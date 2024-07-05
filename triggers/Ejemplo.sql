--Sintaxis----
/* CREATE TRIGGER nombre-trigger
ON nombre-tabla
AFTER  insert,delete,update
AS
BEGIN
-----CODIGO
END */
CREATE DATABASE pruebatriggersg3
go
USE pruebatriggersg3
---crear tablas ---
CREATE TABLE tabla1
(
id int not null primary key,
nombre varchar(50) not null
);
go



---triggers
-----TRiggers que verifica el evento que se ejecuto
---tambien se puede utilizar como una restriccion 

create or alter TRIGGER tg_verificar_insercion 
ON tabla1 --tabla asociado
AFTER INSERT
AS 
begin
print 'se ejecuto el evento insert en la tabla1'
end;

insert into tabla1
Values (1,'Nombre1')

---delete 
create or alter TRIGGER tg_verificar_delete 
ON tabla1 --tabla asociado
AFTER delete
AS 
begin
print 'se ejecuto el evento delete en la tabla1'
end;

delete  tabla1
where id=1

insert into tabla1 
values (1,'Nombre1')
-----UPDATE---
create or alter TRIGGER tg_verificar_UPDATE
ON tabla1 --tabla asociado
AFTER UPDATE
AS 
begin
print 'se ejecuto el evento UPDATE en la tabla1'
end;

Update  tabla1
set nombre= 'Nombre Nuevo'
where id=1;

insert into tabla1 
values (1,'Nombre1')

----Eliminar triggers 
drop trigger  tg_verificar_insercion 
drop trigger  tg_verificar_delete 
drop trigger  tg_verificar_UPDATE

---crear otro triggers 
create trigger verdificar_contenido_inserted 
on Tabla1
after insert
as 
begin
---Ver los datos de la tabla inserted 
select * from inserted;---toma los datos de la tabla que esta asociada 
end;
insert into tabla1 
values (2, 'Nombre2')

select * from tabla1

insert into tabla1 
values (4, 'Nombre4'), (5,'nombre5')


----usar northwind --
use Northwind

CREATE OR ALTER TRIGGER verificar_inserted_categories 
on categories 
After insert
AS
begin
select categoryid, categoryname, [description] from inserted;
end

insert into categories (categoryname, description)
values ('CategoriaNueva','Prueba Triggers') 

create or alter trigger verificar_update_categories
on categories
after update --Actualiza---
as
begin 
select  categoryid, categoryname, [description] from inserted; --en inserted lo guarda ahi y tambien en deleted en update en los dos
select  categoryid, categoryname, [description] from deleted;
end

begin transaction  ---Es un conjunto de actividades actualiza, elimina, inserta
/*confirmar-> commit 
cancelar -> rollback */

update categories
set categoryname = 'CategoriaOtra',
[description] = 'Si esta bien '
where categoryid=9


drop  trigger verificar_inserted_categories


create or alter trigger verificar_inserted_deleted
on categories
after insert, update, delete 
as
begin 
if exists(select 1 from inserted) and not exists(select 1 from deleted)
begin
print('Existen datos en la tabla inserted, se ejecuto un insert')
end

if exists (select 1 from deleted ) and
not exists (select 1 from inserted)
begin 
print 'Existen datos de la tabla deleted, se realizo un delete '
end
else if exists (select 1 from deleted ) and
 exists (select 1 from inserted)
begin 
print 'Existen datos de las dos tablas, se realizo update '
end 
end;


insert into categories (categoryname, [Description])
values ('categoria10','Pipon')

---crear un trigger en la base de datos pruebatriggers, para la tabla empleados, este triggers debe evitar que se interten 
---o modifiquen salarios mayores a 50000
use pruebatriggersg3

--crear una tabla 
create table empleado (
id int not null primary key,
nombre varchar(50) not null, 
salario money not null);

create or alter trigger verificar_salario 
on empleado
after insert, update 
as 
begin 
if exists (select 1 from inserted) and
not exists (select 1 from deleted)
begin 
Declare @salarionuevo money 
set @salarionuevo = (select salario from inserted)
if @salarionuevo > 50000
begin 
raiserror ('El salario es mayor a 50000 y no esta permitido', 16,1)
rollback transaction 
end
end
end;
