--STORE PROCEDURES
-----------------------Ejemplo 1)---------------------------

--CREAR UN SP
CREATE PROCEDURE Procedure_ciclo
AS
BEGIN
    DECLARE @I as INT
    set @I=1
    WHILE(@I <=10)
BEGIN
        PRINT 'El primer valor es' + CAST (@I AS VARCHAR)
        SET @I=@I+1
    END
END

-- EJECUTAR SP
DECLARE @II INT =1
WHILE @II <=2
BEGIN
    EXEC Procedure_ciclo
    SET @II =@II+1
END

----------------------Ejemplo 2)----------------------
CREATE PROCEDURE Procedure_Ciclo_SUMA
AS
BEGIN
    DECLARE @I as INT
    set @I=1
    DECLARE @II as INT
    SET @II=5
    WHILE(@I <=10)
BEGIN
        PRINT 'La suma es: ' + CAST (@I AS VARCHAR)
        SET @I=@I+@II
    END
END

--EJECUTAR
DECLARE @III INT =1
WHILE @III <=2
BEGIN
    EXEC Procedure_Ciclo_Reto
    SET @III =@III+1
END

----------------------Ejemplo 3)--------------------------
--Crear un store procedure que calcule el area de un circulo


create or alter Procedure SP_Calcular_Area_Circulo
@radio float, --parametro entrada
@area float output --parametro salida
as
begin
	set @area = PI() * @radio * @radio
end;

go

Declare @resultado float
exec SP_Calcular_Area_Circulo @radio=22.3, @area=@resultado output

print 'El valor del area es: '+cast(@resultado as varchar)
go


----------------------Ejemplo 3)--------------------------

--Crerar un store procedure que imprima a los empleados
CREATE OR ALTER PROCEDURE SP_Obtener_Informacion_Empleado
@employeeID int=-1,
@lastName varchar(20) output,
@nombre varchar(10) output
AS
BEGIN
	IF @employeeID <> -1
	BEGIN
		SELECT @nombre=FirstName,@lastName=LastName 
		FROM Employees
		where EmployeeID=@employeeID
	END
	ELSE
	BEGIN
		PRINT('El valor del empleado no es valido')
	END
END

--Ejecutar
DECLARE @firstname as nvarchar(10),
@lastname nvarchar(20)

exec SP_Obtener_Informacion_Empleado @employeeID=1,
@nombre=@firstname output, @lastName=@lastname output

Print('El nombre es: '+@firstname)
Print('El apellido es: '+@lastname)

-----------------Verificar si el empleado existe

create or alter proc sp_obtener_informacion_empleado2
@employeeid int = -1,
@apellido nvarchar(20) output,
@nombre as nvarchar(10) output
AS
begin

   DECLARE @existe int
   set @existe=(select count(*) from Employees where EmployeeID =@employeeid)
   -- select @existe = count(*) from Employees where EmployeeID =@employeeid
   

   IF @existe > 0
   begin
    Select @nombre = FirstName, @apellido=lastname
    from Employees
    where EmployeeID = @employeeid
   end
   else
   begin
   if @existe = 0
   begin
      print 'El id del empleado no existe'
   end
  end
end


--__________________________________________________________________________________________________________________________--
--TRIGGERS
--Crear trigger que identifica elemento que se ejecuto

--------------------UNA INSERCCION
CREATE TRIGGER TG_Verificar_Inserccion
on Tabla1
AFTER INSERT
AS
BEGIN
	PRINT 'Se ejecuto el evento insert en l atabla'
END

--ejecutar
INSERT INTO Tabla1
values (1,'nombre')

-------------------UN DELETE
CREATE TRIGGER TG_Verificar_Delete2
on Tabla1
AFTER DELETE
AS
BEGIN
	PRINT 'Se ejecuto el evento delete en la tabla 1'
END

--ejecutar
DELETE Tabla1
where ID=1



--------------------UN UPDATE
CREATE TRIGGER TG_Verificar_Update
on Tabla1
AFTER UPDATE
AS
BEGIN
	PRINT 'Se ejecuto el evento update en la tabla 1'
END

--ejecutar
Update Tabla1
set nombre= 'Nombre nuevo'
where ID=1

--------------------Verificar un insert en la tabla Categories
USE Northwind;

CREATE OR ALTER TRIGGER Verificar_Inserted_Categories
ON Categories
AFTER INSERT
AS
BEGIN
	SELECT CategoryID,categoryName,[Description] FROM inserted
END

--ejecutar
INSERT INTO Categories (categoryName, [Description])
VALUES ('CategoriaNueva','Prueba de Triggers')



-----------------------

CREATE OR ALTER TRIGGER Verificar_Inserted_Deleted
ON Categories
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	IF EXISTS(SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
	BEGIN
		PRINT('Existeb datos en la tabla Inserted, Se ejecuto un insert')
	END
	
	IF EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
	BEGIN
		PRINT('Existeb datos en la tabla Delete, se realizo un delete')
	END
	ELSE IF EXISTS(SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
	BEGIN
		PRINT('Existen datos en ambas tablas, Se ejecuto un update')
	END
END

INSERT INTO Categories(CategoryName, [Description])
VALUES ('11','Pimpon ES UN MUÑECO')

UPDATE Categories
SET [Description]= 'Pimpon es un muñeco'
WHERE CategoryName=10

-----------------------------------------------------------------------------------------------
---Mas ejemplos
create procedure SP_Prueba1
as
print 'Hola mundo'

 Execute SP_Prueba1

 create proc sp_consulta
 as
 select * from Product
 where City 'CACA'

 execute sp_consulta

 create proc sp_restarexistencia
 @codproc as varchar (4),
 @cantidad as int
 as
 update productos set existencia = existencia-@cantidad
 where cod_product=@codproct

 select * from Productos

 exec sp_RestarExistencias 'A003',45


 create proc sp_sumarexistencia
 @codproc as varchar (4),
 @cantidad as int
 as
 update productos set existencia = existencia+@cantidad
 where cod_product=@codproct

 exec sp_sumarExistencias 'A003',45
 --------------------------------------------------------
 ---una lista de gerentes para un empleado específico.
CREATE PROCEDURE managers
    @BusinessEntityID INT
AS
BEGIN
    SET NOCOUNT ON;

    WITH EmployeeCTE AS (
        SELECT 
            e.BusinessEntityID, 
            e.OrganizationNode AS ManagerID, 
            0 AS RecursionLevel
        FROM 
            HumanResources.Employee e
        WHERE 
            e.BusinessEntityID = @BusinessEntityID
        UNION ALL
        SELECT 
            e.BusinessEntityID, 
            e.OrganizationNode AS ManagerID, 
            cte.RecursionLevel + 1
        FROM 
            HumanResources.Employee e
            INNER JOIN EmployeeCTE cte ON e.BusinessEntityID = cte.ManagerID
    )
    SELECT 
        cte.BusinessEntityID, 
        p.FirstName AS Nombre, 
        p.LastName AS Apellido, 
        e.JobTitle AS Titulo, 
        e.OrganizationNode AS GerenteID, 
        cte.RecursionLevel AS NivelRecursivo
    FROM 
        EmployeeCTE cte
        INNER JOIN HumanResources.Employee e ON cte.BusinessEntityID = e.BusinessEntityID
        INNER JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
    ORDER BY 
        cte.RecursionLevel, p.LastName;
END;


-------------------------STOREPROCEDURE---------------------------------------
declare @x INT
set @x=10

print 'El valor de x es: '+ cast(@x as VARCHAR)

if @x >=0
BEGIN
    print 'El numero es positivo'
END
ELSE
BEGIN
    PRINT 'El numero es negativo'
END

DECLARE @i as INT
set @i=1
while (@i<=10)
BEGIN
    print cast (@i as VARCHAR)
    set @i=@i+1
end;

/*DECLARE @i INT
set @i = 1 
while @i <=10
begin 
print 'El primer valor es' + cast(@i as varchar)
set @i= @1+1
end */

------crear un sp
create procedure  procedure_ciclo
as
begin
    DECLARE @i INT
    set @i = 1

    while @i<=10
begin
        print 'El primer valor es' + cast(@i as varchar)
        set @i= @i + 1
    end
end ;

-----Lo puso para dos veces 
declare @ii int = 1

while  @ii <= 2
begin
exec procedure_ciclo
set @ii = @ii +1
end

-------sp - suma1 realizar un sp que sume dos numeros cualquiera y que imprima el resultado----

create procedure  sp_suma1
as
begin
    DECLARE @suma INT
    set @suma = 4 + 5

        print 'La suma es:' + cast (@suma as varchar)
    end

execute  sp_suma1






--Tarea realizar un sp que muestre todas las ventas realizadas por cliente para un año cualquiera

select c.CompanyName as 'Nombre del Cliente', 
Sum(od.Quantity * od.UnitPrice) as 'Total' 
from customers as c
INNER JOIN orders as o 
ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] as od
on od.OrderID = o.OrderID
where DATEPART(YEAR,o.OrderDate) = 1996
GROUP BY c.CompanyName;


CREATE OR ALTER PROC sp_ventasporcliente
   --Parametros
   @year as int 
AS   
BEGIN
   select c.CompanyName as 'Nombre del Cliente', 
    Sum(od.Quantity * od.UnitPrice) as 'Total' 
    from customers as c
    INNER JOIN orders as o 
    ON c.CustomerID = o.CustomerID
    INNER JOIN [Order Details] as od
    on od.OrderID = o.OrderID
    where DATEPART(YEAR,o.OrderDate) = @year
    GROUP BY c.CompanyName

END;

--Ejecutar sp
EXEC sp_ventasporcliente 1997

execute sp_ventasporcliente 1996

exec sp_ventasporcliente @year = 1998

--Ejercicio1: Realizar un store procedure que muestre un reporte de ventas por cliente y producto(agrupado),de un rango de fecha.

select c.CompanyName as 'Nombre del Cliente', 
p.ProductName as 'Nombr del producto'
from customers as c
INNER JOIN Products as p
ON c.CustomerID = p.CategoryID
INNER JOIN [Order Details] as od
on od.OrderID = 
where DATEPART(YEAR,o.OrderDate) = 1996
GROUP BY c.CompanyName;

select * FROM Products


--Ejercicio2: Realizar un store procedure que inserte un cliente nuevo
CREATE OR ALTER PROC agregar_cliente
--Parametros de entrada
    @CustomerID nchar(5) ,
    @CompanyName nvarchar(40),
    @ContactName nvarchar(30) =  null,
    @ContactTitle nvarchar(30) =  null,
    @Address nvarchar(60) =  null,
    @City nvarchar(15) =  null,
    @Region nvarchar(15) =  null,
    @PostalCode nvarchar(10) =  null,
    @Country nvarchar(15) =  null,
    @Phone nvarchar(24) =  null,
    @Fax nvarchar(24) =  null
AS
BEGIN
    INSERT INTO [dbo].[Customers]
           ([CustomerID]
           ,[CompanyName]
           ,[ContactName]
           ,[ContactTitle]
           ,[Address]
           ,[City]
           ,[Region]
           ,[PostalCode]
           ,[Country]
           ,[Phone]
           ,[Fax])
     VALUES (@CustomerID
           ,@CompanyName
           ,@ContactName
           ,@ContactTitle
           ,@Address
           ,@city
           ,@Region
           ,@PostalCode
           ,@Country
           ,@Phone
           ,@Fax)
END;
GO

select * from Customers

--Agrega el cliente
begin TRANSACTION
exec agregar_cliente
    @CustomerID = 'GTIG3' ,
    @CompanyName = 'Patito de Huele',
    @ContactName = 'Edith campos',
    @ContactTitle = 'Tutora',
    @Address = 'calle del infierno',
    @City = 'Tula',
    @Region = 'Sur',
    @PostalCode = '42800',
    @Country = 'Mexico',
    @Phone = '33-345678'

--Seleccionamos nuestro cliente que agregamos recientemente
select * from Customers
where CustomerID = 'GTIG3'
-----------------------------------------------------------------------------------
---SP total de ventas agrupado por proveedor en un rango de fechas 
---supplers con products y order details 

--sp 
create or alter procedure sp_ventas_proveedor ---el alter para cambios 
@year int, @month int, @day int 
as 
begin 
--CONSULTA
select s.CompanyName,
sum(od.UnitPrice *od.Quantity) as TOTAL
from 
Suppliers as s
inner join Products as p 
on s.SupplierID = p.SupplierID
inner join [Order Details] as od
on p.ProductID = od.ProductID
inner join orders as o 
on o.OrderID = od.OrderID 
where datepart (year, o.OrderDate)=@year
and datepart (month, o.OrderDate)=@month
and datepart (day, o.OrderDate)=@day
group by s.CompanyName
order by s.CompanyName;
end 

go

--formas de ejecutar un SP 
execute sp_ventas_proveedor 1996,07,04; --sin rango
exec sp_ventas_proveedor 1996,07,04;
execute sp_ventas_proveedor @day=04, @year=1996, @month=07

--crear un SP que permita visualizar cuantas ordenes se han hecho por año y pais 
--count (*)
--count (campo)
--max (campo)
--min (campo)

create or alter procedure sp_ordenes     ---el alter para cambios 
AS
BEGIN
    SELECT 
        YEAR(o.OrderDate) AS Año,
        c.Country AS Pais,
        COUNT(o.OrderID) AS NumeroOrdenes
    FROM 
        Orders o
        INNER JOIN Customers c ON o.CustomerID = c.CustomerID
    GROUP BY 
        YEAR(o.OrderDate), 
        c.Country
    ORDER BY 
        Año, 
        Pais;
END;
GO
---Ejecutar sp
exec sp_ordenes

----crear un sp que inserte o actualice los registros nuevos o los cambios en la tabla product, supplier,customers,employees
----------------------------Product-------------------------------------------
CREATE PROCEDURE Producto
    @ProductID INT,
    @ProductName NVARCHAR(40),
    @SupplierID INT,
    @CategoryID INT,
    @QuantityPerUnit NVARCHAR(20),
    @UnitPrice DECIMAL(18, 2),
    @UnitsInStock SMALLINT,
    @UnitsOnOrder SMALLINT,
    @ReorderLevel SMALLINT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Products WHERE ProductID = @ProductID)
    BEGIN
        UPDATE Products
        SET ProductName = @ProductName,
            SupplierID = @SupplierID,
            CategoryID = @CategoryID,
            QuantityPerUnit = @QuantityPerUnit,
            UnitPrice = @UnitPrice,
            UnitsInStock = @UnitsInStock,
            UnitsOnOrder = @UnitsOnOrder,
            ReorderLevel = @ReorderLevel
        WHERE ProductID = @ProductID;
    END
    ELSE
    BEGIN
        INSERT INTO Products (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel)
        VALUES (@ProductName, @SupplierID, @CategoryID, @QuantityPerUnit, @UnitPrice, @UnitsInStock, @UnitsOnOrder, @ReorderLevel);
    END
END;
GO
---ejecutar sp
EXEC Producto 
    @ProductID = 1, 
    @ProductName = 'Camaron', 
    @SupplierID = 1, 
    @CategoryID = 1, 
    @QuantityPerUnit = '5', 
    @UnitPrice = 18.00, 
    @UnitsInStock = 39, 
    @UnitsOnOrder = 0, 
    @ReorderLevel = 10;
	select * from Products;
	-------------Supliers----------------------------------------
	CREATE PROCEDURE Supliers
    @SupplierID INT,
    @CompanyName NVARCHAR(40),
    @ContactName NVARCHAR(30),
    @ContactTitle NVARCHAR(30),
    @Address NVARCHAR(60),
    @City NVARCHAR(15),
    @Region NVARCHAR(15),
    @PostalCode NVARCHAR(10),
    @Country NVARCHAR(15),
    @Phone NVARCHAR(24),
    @Fax NVARCHAR(24),
    @HomePage NTEXT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Suppliers WHERE SupplierID = @SupplierID)
    BEGIN
        UPDATE Suppliers
        SET CompanyName = @CompanyName,
            ContactName = @ContactName,
            ContactTitle = @ContactTitle,
            Address = @Address,
            City = @City,
            Region = @Region,
            PostalCode = @PostalCode,
            Country = @Country,
            Phone = @Phone,
            Fax = @Fax,
            HomePage = @HomePage
        WHERE SupplierID = @SupplierID;
    END
    ELSE
    BEGIN
        INSERT INTO Suppliers (CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax, HomePage)
        VALUES (@CompanyName, @ContactName, @ContactTitle, @Address, @City, @Region, @PostalCode, @Country, @Phone, @Fax, @HomePage);
    END
END;
GO
----Ejecutar Sp---------
EXEC Supliers
    @SupplierID = 1, 
    @CompanyName = 'Fabuloso', 
    @ContactName = 'Liz Perez', 
    @ContactTitle = 'gonzales', 
    @Address = '49 san agustin.', 
    @City = 'London', 
    @Region = NULL, 
    @PostalCode = '45860', 
    @Country = 'Mexico', 
    @Phone = '(773) 555-2222', 
    @Fax = NULL, 
    @HomePage = NULL;
	select * from Suppliers
	------------------Customers------------------
	CREATE PROCEDURE Customer
    @CustomerID NCHAR(5),
    @CompanyName NVARCHAR(40),
    @ContactName NVARCHAR(30),
    @ContactTitle NVARCHAR(30),
    @Address NVARCHAR(60),
    @City NVARCHAR(15),
    @Region NVARCHAR(15),
    @PostalCode NVARCHAR(10),
    @Country NVARCHAR(15),
    @Phone NVARCHAR(24),
    @Fax NVARCHAR(24)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @CustomerID)
    BEGIN
        UPDATE Customers
        SET CompanyName = @CompanyName,
            ContactName = @ContactName,
            ContactTitle = @ContactTitle,
            Address = @Address,
            City = @City,
            Region = @Region,
            PostalCode = @PostalCode,
            Country = @Country,
            Phone = @Phone,
            Fax = @Fax
        WHERE CustomerID = @CustomerID;
    END
    ELSE
    BEGIN
        INSERT INTO Customers (CustomerID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax)
        VALUES (@CustomerID, @CompanyName, @ContactName, @ContactTitle, @Address, @City, @Region, @PostalCode, @Country, @Phone, @Fax);
    END
END;
GO
-----Ejecutar Sp---------------
EXEC Customer
    @CustomerID = 1, 
    @CompanyName = 'Alfreds Futterkiste', 
    @ContactName = 'Maria Anders', 
    @ContactTitle = 'Salas', 
    @Address = 'Alvarado.57', 
    @City = 'Berlin', 
    @Region = NULL, 
    @PostalCode = '12209', 
    @Country = 'Germany', 
    @Phone = '030-0074321', 
    @Fax = '030-0076545';
	select *  from Customers
	-----------------Employees-------------------------
	CREATE PROCEDURE Empleado
    @EmployeeID INT,
    @LastName NVARCHAR(20),
    @FirstName NVARCHAR(10),
    @Title NVARCHAR(30),
    @TitleOfCourtesy NVARCHAR(25),
    @BirthDate DATETIME,
    @HireDate DATETIME,
    @Address NVARCHAR(60),
    @City NVARCHAR(15),
    @Region NVARCHAR(15),
    @PostalCode NVARCHAR(10),
    @Country NVARCHAR(15),
    @HomePhone NVARCHAR(24),
    @Extension NVARCHAR(4),
    @Photo VARBINARY(MAX),
    @Notes NTEXT,
    @ReportsTo INT,
    @PhotoPath NVARCHAR(255)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmployeeID)
    BEGIN
        UPDATE Employees
        SET LastName = @LastName,
            FirstName = @FirstName,
            Title = @Title,
            TitleOfCourtesy = @TitleOfCourtesy,
            BirthDate = @BirthDate,
            HireDate = @HireDate,
            Address = @Address,
            City = @City,
            Region = @Region,
            PostalCode = @PostalCode,
            Country = @Country,
            HomePhone = @HomePhone,
            Extension = @Extension,
            Photo = @Photo,
            Notes = @Notes,
            ReportsTo = @ReportsTo,
            PhotoPath = @PhotoPath
        WHERE EmployeeID = @EmployeeID;
    END
    ELSE
    BEGIN
        INSERT INTO Employees (LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, Photo, Notes, ReportsTo, PhotoPath)
        VALUES (@LastName, @FirstName, @Title, @TitleOfCourtesy, @BirthDate, @HireDate, @Address, @City, @Region, @PostalCode, @Country, @HomePhone, @Extension, @Photo, @Notes, @ReportsTo, @PhotoPath);
    END
END;
GO
	---Ejecutar SP----------------------------
	EXEC Empleado
    @EmployeeID = 1, 
    @LastName = 'Davolio', 
    @FirstName = 'Nancy', 
    @Title = 'Salas', 
    @TitleOfCourtesy = 'Ms.', 
    @BirthDate = '1948-12-08', 
    @HireDate = '1992-05-01', 
    @Address = 'CRUZ AZUL 2A', 
    @City = 'Mexico', 
    @Region = 'WA', 
    @PostalCode = '98122', 
    @Country = 'USA', 
    @HomePhone = '(206) 555-9857', 
    @Extension = '5467', 
    @Photo = NULL, 
    @Notes = 'Educaciones',
    @ReportsTo = 2, 
    @PhotoPath = 'http://accweb/emmployees/davolio.bmp';
	select * from Employees

	----****************Crear un sp que actualice la tabla ventas*****************-------------------------------
	CREATE PROCEDURE ventas
    @OrderID INT,
    @CustomerID NCHAR(5),
    @EmployeeID INT,
    @OrderDate DATETIME,
    @RequiredDate DATETIME,
    @ShippedDate DATETIME,
    @ShipVia INT,
    @Freight DECIMAL(18, 2),
    @ShipName NVARCHAR(40),
    @ShipAddress NVARCHAR(60),
    @ShipCity NVARCHAR(15),
    @ShipRegion NVARCHAR(15),
    @ShipPostalCode NVARCHAR(10),
    @ShipCountry NVARCHAR(15)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Orders WHERE OrderID = @OrderID)
    BEGIN
        -- Actualiza el registro
        UPDATE Orders
        SET CustomerID = @CustomerID,
            EmployeeID = @EmployeeID,
            OrderDate = @OrderDate,
            RequiredDate = @RequiredDate,
            ShippedDate = @ShippedDate,
            ShipVia = @ShipVia,
            Freight = @Freight,
            ShipName = @ShipName,
            ShipAddress = @ShipAddress,
            ShipCity = @ShipCity,
            ShipRegion = @ShipRegion,
            ShipPostalCode = @ShipPostalCode,
            ShipCountry = @ShipCountry
        WHERE OrderID = @OrderID;
    END
    /*ELSE
    BEGIN
      /* ---Si no existe lanze un error o manejarlo de otra manera
        RAISERROR('La orden con OrderID = %d no existe.', 16, 1, @OrderID);*/
    --end*/
END;
GO
----EJECUTAR SP---------------------
EXEC ventas 
    @OrderID = 10248,
    @CustomerID = 'VINET',
    @EmployeeID = 5,
    @OrderDate = '1996-07-04',
    @RequiredDate = '1996-08-01',
    @ShippedDate = '1996-07-16',
    @ShipVia = 3,
    @Freight = 32.38,
    @ShipName = 'cavalier',
    @ShipAddress = 'valle',
    @ShipCity = 'zaragozas',
    @ShipRegion = NULL,
    @ShipPostalCode = '51100',
    @ShipCountry = 'France';
	select * from Orders


	
	----Otro Ejerciciooo----
	---Store procedures (PARAMETROS DE SALIDA)----
	--CREAR un store procedure que calcule el area de  un circulo 

	create or alter procedure sp_Calular_Area_Circulo
	@radio float, ---parametro de entrada
	@area float output ---parametro de salida 
	AS
	BEGIN
set @area= PI() *@radio*@radio  ---set asigancion 
	END;
	GO

	---esto es un bloque de un transact
	Declare @resultado float
	execute sp_Calular_Area_Circulo @radio=22.3, @area = @resultado output
	print 'El valor del area es:' + cast(@resultado as varchar);
	GO


	----obtener el nombre d eun empleado--
	create or alter proc sp_obtener_informacion_empleado
	@employeeid int= -1,
	@apellido nvarchar(20) output,
	@nombre as nvarchar(10) output
	AS
	begin 
	IF @employeeid <> -1
	begin
	select @nombre=FirstName, @apellido=LastName  
	from Employees
	where EmployeeID = @employeeid
	end
	else 
	begin 
	print ('El valor del empleado no es valido')
	end
	end
	-----------------------------------------------------------------------------------------------------
	Declare @firstname as nvarchar (10),
	@lastname nvarchar(20)

	exec sp_obtener_informacion_empleado 
	@employeeid =1, @nombre=@FirstName output, @apellido = @LastName OUTPUT

	print ('El nombre es:' + @FirstName)
	print ('El apellido es:' + @LastName)


----verificar si el employeeid introducido existe ------------------------
create or alter proc sp_obtener_informacion_empleado2
@employeeid int = -1,
@apellido nvarchar(20) output,
@nombre as nvarchar(10) output
AS
begin

   DECLARE @existe int
   set @existe=(select count(*) from Employees where EmployeeID =@employeeid)
   -- select @existe = count(*) from Employees where EmployeeID =@employeeid
   

   IF @existe > 0
   begin
    Select @nombre = FirstName, @apellido=lastname
    from Employees
    where EmployeeID = @employeeid
   end
   else
   begin
   if @existe = 0
   begin
      print 'El id del empleado no existe'
   end
  end
end

-------------------------------------------------------------

declare @firstname as nvarchar(10),
@lastname nvarchar(20)

exec sp_obtener_informacion_empleado2
@nombre=@firstname output, @apellido = @lastname output

print ('El nombre es: ' + @firstname)
print ('El apellido es: ' + @lastname)

	/*Realizar un store procedure que guarde en una variable de salida el total de campos que ha realizado un cliente 
	dado en un rango de fechas*/

	create or alter proc sp_obtener_ventas_por_cliente
	@customerid nchar(5),
	@fechainicial date,
	@fechafinal date,
	@total decimal(10,2) output
	AS
	begin
	select  sum (od.UnitPrice *  od.Quantity) as total
	from [Order Details] as od
	inner join Orders as o 
	on od.OrderID = o.OrderID
	where CustomerID = @customerid AND
	O.OrderDate  Between @fechainicial and @fechafinal;
	END

	select * from Orders
	
---------------------------------------------------------------------------------------------
---La suma total de un cliente 
use Northwind

create or alter proc sp_sumacliente
 		@CustomerID varchar (5)
		as begin 
select sum (Quantity*od.UnitPrice)from [Order Details] as od
inner join orders as o
on o.OrderID= od.OrderID
where o.CustomerID= @CustomerID
end

exec sp_sumacliente 'ALFKI';
select *from Customers