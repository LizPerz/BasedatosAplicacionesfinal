---Las transacciones son fundamentales ára asegurar la consistencia 
---y la integridad de los datos 
-----Transaccion: Es una unidad de trabajo que se ejecuta de manera
----completamente exitosa o no se ejecuta en absoluto
---Begin transaction: inicia una nueva transaccion 
--commit transaction: Confirma todos los cambios realizados durante la transaccion
---RollBack Transaction: Revierte todos los cambios realizados durante 
---la transaccion 
use Northwind
select * from Categories
begin transaction --ejecute
insert into Categories (CategoryName, Description)
values ('Categoria11','Los remediales')
--Cancelar transaccion 
Rollback transaction 
---para agregar el commit begin el insert y al final el commit 
commit transaction 
