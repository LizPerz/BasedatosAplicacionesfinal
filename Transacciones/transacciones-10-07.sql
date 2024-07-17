/*
Las transacciones son fundamentales para la asegurar la consistencia y la integridad de los datos 

Transaccion: Es una unidad de trabajo que se ejecuta de manera exitosa o no se ejecuta en 
lo absoluto

Begin Transaction: inicia una nueva transaccion 
commit transaction: confirma todos los cambios realizados durante la transaccion
Rollback transaction: revierte todos los cambios realizados durante la transaccion
*/

use Northwind

select * from Categories

begin transaction

insert into Categories(CategoryName, Description)
values ('categoria11', 'los remediales')

rollback transaction

commit transaction


