use Northwind
/*
store procedure que visualice los resultados de cualquier tabla

Select * from [tabla]
*/

create or alter procedure spu_mostrarD
@tabla varchar(50)
as
begin
declare @query varchar(50)
set @query = 'select *from ' + @tabla;
exec (@query);
end;
go

create or alter procedure spu_mostrarD
@tabla nvarchar(50)
as
begin
declare @query varchar(50)
set @query = 'select *from ' + @tabla;
exec spu_mostrarD @query
end;
go

