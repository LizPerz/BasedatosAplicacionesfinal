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
	
