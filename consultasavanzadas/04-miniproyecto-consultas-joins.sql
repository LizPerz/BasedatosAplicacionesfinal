create database repasojoins;
create table Proveedor (
    provid int NOT NULL IDENTITY (1,1),
    nombre VARCHAR (50) NOT NULL,
    limite_credito money not null,
    CONSTRAINT pk_proveedor
    PRIMARY KEY (provid)
);
/*aprenderme primary j+key y foreig*/
create table producto (
    prodid int not null IDENTITY (1,1),
    nombre varchar (100) not null,
    existencia int not null,
    precio money not null,
    Proveedor int 
    CONSTRAINT pk_producto
    PRIMARY key (prodid),
    CONSTRAINT fk_producto_proveedor 
    FOREIGN KEY (proveedor)
REFERENCES proveedor (provid)
);
 
--insertar datos en las tablas 
INSERT into Proveedor (nombre,limite_credito)
VALUES ('Proveedor1',100000),
 ('Proveedor1',200000),
  ('Proveedor1',300000),
   ('Proveedor1',400000),
    ('Proveedor1',500000);

    insert into producto (nombre,existencia,precio,Proveedor)
    VALUES ('Producto1',34,45.6,1),
    ('Producto2',54,45.10,1),
    ('Producto3',36,45.15,2),
    ('Producto4',24,45.25,3);
    
    SELECT * from Proveedor;
    SELECT *  from producto;

    --consultas inner join 
    --seleccionar todos los productos que tiene proveedor 

    select pr.nombre as 'nombre del porducto', pr.precio as precio, 
    pr.existencia as [existencia], p.nombre as 'Proveedor'
    from Proveedor as p 
    inner join producto as pr 
    on p.provid=pr.Proveedor;

    --Consulta left join 
    --mostrar todos los proveedores y sus respectivos productos 
    
    select pr.prodid,pr.nombre as 'nombre del porducto', pr.precio as precio, 
    pr.existencia as [existencia],p.provid, p.nombre as 'Proveedor'
    from Proveedor as p 
    left join producto as pr 
    on p.provid=pr.Proveedor;

    UPDATE Proveedor
    set nombre = 'Proveedor6' /*si lo dejo asi me puede cambiar todo*/
    where provid = 5;

    SELECT * from Proveedor;

    insert into proveedor (nombre,limite_credito)
    values ('proveedor6',45000);

    delete from Proveedor
    where provid =7;

    update Proveedor
    set nombre = 'Proveedor6'
    where provid= 6;

    --Utilizando right join 
        
    select pr.prodid,pr.nombre as 'nombre del porducto', pr.precio as precio, 
    pr.existencia as [existencia],p.provid, p.nombre as 'Proveedor'
    from Proveedor as p 
    right join producto as pr 
    on p.provid=pr.Proveedor;

    insert into producto (nombre,precio,existencia,proveedor)
    values ('Producto5', 78.8,22,null);

    --full join 
 select pr.prodid,pr.nombre as 'nombre del porducto', pr.precio as precio, 
    pr.existencia as [existencia],p.provid, p.nombre as 'Proveedor'
    from Proveedor as p 
    full join producto as pr 
    on p.provid=pr.Proveedor;

    --Seleccionar todos los proveedores que no tienen asignado producto 
select p.provid as 'Numero de proveedor', p.nombre as 'Proveedor'
    from Proveedor as p 
    full join producto as pr 
    on p.provid=pr.Proveedor  
    where pr.prodid is null;

    --Seleccionar todos los productos que no tienen proveedor 
    select pr.nombre, pr.precio,pr.existencia
    from Proveedor as p 
    right join producto as pr 
    on p.provid=pr.Proveedor  
 where p.provid is null;
