--Crear base de datos para demostrar el uso del left join 
create DATABASE pruebajoins;
--utilizamos la base de satos 
use pruebajoins;


--crear  la tabla categorias 
create table categoria(
    categoriaid int not null IDENTITY(1,1),
nombre VARCHAR (50) not null DEFAULT 'No Categoria',
CONSTRAINT pk_categoria
PRIMARY KEY (categoriaid)
);

-- crear la tabla de productos 
create table producto (
    productoid int not null IDENTITY (1,1),
    nombre VARCHAR (50) not NULL,
    existencia int not null,
    precio money NOT NULL,
    categoriaid int,
    CONSTRAInt pk_producto
    PRIMARY KEY (productoid),
    CONSTRAINT unico_nombre
    UNIQUE (nombre),
    constraint fk_producto_categoria
    FOREIGN KEY (categoriaid)
    REFERENCES categoria(categoriaid)
    );

    --agregar registros a la tabla categoria 
    insert into categoria(nombre)
    VALUES ('LB'),
         ('Lacteos'),
         ('Ropa'),
         ('Bebida'),
         ('Carnes frias');

 -- Agregar registros a la tabla producto 
 SELECT * FROM categoria;      

 insert into producto (nombre,existencia,precio, categoriaid)
VALUES ('Refrigerador',3,10000.0,1),
('Estufa',3,9000.04,1),
('Crema ',2,10.5,2),
('Yogurth',3,13.45,2);

select * from producto;

--inner

select*
from producto as p 
INNER join categoria  as c 
on p.categoriaid=c.categoriaid;

--consulta utilizando un left join 
--seleccionAR TODAS LAS CATEGORIAS QUE NO TIENEN ASIGNADOS PRODUCTO
select*
from categoria as c 
LEFT join producto  as p  
on p.categoriaid=c.categoriaid;

--los que son nulos 
select*
from categoria as c 
LEFT join producto  as p  
on p.categoriaid=c.categoriaid
where p.productoid is  null;
--no nulos
select *--c.categoriaid,c.nombre
from categoria as c 
LEFT join producto  as p  
on p.categoriaid=c.categoriaid
where p.productoid is not null;

--right te pone lo que coincide y abajo lo que no
select*
from producto as p  
RIGHT join categoria as c
on p.categoriaid=c.categoriaid

--full join
select*
from producto as p  
full join categoria as c
on p.categoriaid=c.categoriaid

--EJERCICIO
-- 1. CREAR UNA BASE De datos llamda ejercicio join 
create database ejerciciojoins;
use ejerciciojoins;
-- 2. crear una tabla empleados tomando como base la tabla employees de northwid (no tomar todos los datos)
SELECT *from Northwind.dbo.Employees;

select top 0 employeeid as 'empleadoid',
CONCAT(FirstName,'', LastName) as 'Nombrecompleto',
title as 'Titulo',
hiredate as 'fecha contratacion'
into ejerciciojoins.dbo.empleados
 from Northwind.dbo.Employees;

 SELECT * from  ejerciciojoins.dbo.empleados;

-- 3. llenar ña tabla consulta a la tabla employees
insert into ejerciciojoins.dbo.empleados (Nombrecompleto,Titulo,[fecha contratacion])
select 
CONCAT(firstname,'',LastName) as 'Nombrecompleto',
title as 'Titulo',
hiredate as 'fechacontratacion' 
from Northwind.dbo.Employees

SELECT top 0 * --crea uno tabla apartir de una consulta
into ejerciciojoins.dbo.dimempleados
from ejerciciojoins.dbo.empleados

SELECT * from dimempleados
-- 4. Agregar nuevos datos a la tabla empleados por lo menos dos

-- 5 actualizar l tabla empleados con los nuevos registros, a cual se llenara en una tabla llamada dim_producto

