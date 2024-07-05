--Crear base de datos --
CREATE DATABASE Bdventas;
-- UTILIZAR  BD--
use Bdventas;
Create table cliente (
Clienteid int not null identity (1,1), --Autoincremental-- --No se agrega en un insert int0----Todo sin foreignkey--
rfc varchar (20) not null,
curp varchar (18) not null,
nombre varchar (50) not null,
Apellido1 varchar (50) not null,
Apellido2 varchar (50) not null,
constraint pk_cliente
primary key (Clienteid), --constrain name--
constraint unico_rfc
unique (rfc),
constraint unico_curp
unique (curp));

create table contactoProveedor (--foreign
contactoid int not null identity (1,1),
proveedorid int not null,
nombres varchar (50) not null,
Apellidp1 varchar (50) not null,
Apellido2 varchar (50) not null,
constraint pk_contactoproveedor
primary key (contactoid),

)

create table provedor (
proveedorid int not null identity (1,1),
nombreEmpresa varchar (50) not null,
rfc varchar (20) not null,
calle varchar (30) not null,
colonia varchar (50) not null,
cp int not null,
paginaWeb varchar (80),
constraint pk_proveedor 
primary key (proveedorid),
constraint unico_nombreEmpresa --unicos--
unique (nombreEmpresa),
constraint unico_rfc2
unique (rfc)
);

alter table contactoProveedor
add constraint fk_contactoproveedor_provedor
foreign key (proveedorid)
references provedor (proveedorid)

create table empleado(
empleadoid int not null identity (1,1),
nombre varchar (50) not null,
Apellidp1 varchar (50) not null,
Apellido2 varchar (50) not null,
rfc varchar (20) not null,
curp varchar (18) not null,
numeroexterno int,
calle varchar (20) not null,
salario money not null,
numeronomina INT not null,
constraint pk_empleado
primary key (empleadoid),
constraint unico_rfc_empleado
unique (rfc),
constraint unico_curp_empleado
unique (curp),
constraint chk_salario
check (salario>0.0 and salario<=100000),
-- check (salario between 0.1 and 10000--
constraint unico_nomina_empleado
unique (numeronomina)
)

create table telefonoProveedor (
telefonoid int not null,
proveedorid int not null,
numerotelefono varchar (15),
constraint pk_telefono_proveedor
primary key (telefonoid, proveedorid),
constraint fk_telefonoprov_proveedor
foreign key (proveedorid)
references provedor (proveedorid)
on delete cascade 
on update cascade 
)

create table producto(
numerocontrol int not null identity(1,1),
descripción varchar (50) not null,
precio money not null,
estatus int not null,
existencia int not null,
proveedorid int not null,
constraint pk_producto
primary key (numerocontrol),
constraint unico_descripción
unique (descripción),
constraint chk_precio
check (precio between 1 and 20000),
constraint chk_estatus
check (estatus=1 or estatus=0),
constraint chk_existencia
check (existencia >0),
constraint fk_producto_proveedor 
foreign key (proveedorid)
references provedor(proveedorid)

)


create table ordencompra(
numeroorden int not null,
fechacompra date not null,
fechaentrega date not null,
clienteid int not null,
empleadoid int not null,
constraint pk_ordencompra
primary key (numeroorden),
constraint fk_ordencompra_cliente
foreign key (empleadoid)
references empleado (empleadoid)
)
create table detallecompra (
productoid int not null,
numeroorden int not null,
cantidad int not null,
preciocompra money not null
constraint pk_detallecompra
primary key (productoid,numeroorden)
constraint fk_ordencompra_producto
foreign key (productoid)
references Producto (numerocontrol),
constraint fk_ordencompra_compra
foreign key (numeroorden)
references ordencompra (numeroorden)
)