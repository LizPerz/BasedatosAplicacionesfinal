---Ejercicio de base de datos BDEJEMPLO2 ----
USE BDEJEMPLO2;
SELECT * FROM Clientes;
SElect*from Pedidos;
Select * from Representantes;
select * from Productos;
select* from Oficinas;

---- Obtener una lista de pedidos junto con la información del cliente y el representante.
Select p.Num_Pedido, p.Fecha_Pedido, c.Empresa, r.Nombre
from
Pedidos as p
inner join Clientes as c 
ON p.Cliente = c.Num_Cli
inner join Representantes as r
on r.Num_Empl = p.Rep;

---Obtener una lista de todos los clientes y sus pedidos, si existen.
select c.Num_Cli, c.Empresa, p.Cliente,p.Num_Pedido
from  Clientes as c 
left join Pedidos as p 
on p.Cliente=c.Num_Cli;

---Obtener una lista de todos los representantes y los pedidos que han gestionado, si existen.
select r.Nombre, r.Puesto, p.Cliente, p.Fecha_Pedido from 
Representantes as r 
right join Pedidos as p
on r.Num_Empl= p.Rep
---Calcular el total de ventas por oficina.
SELECT o.Oficina, o.Ciudad, SUM(p.Importe) AS TotalVentas
FROM Oficinas o
INNER JOIN Pedidos p ON o.Oficina = p.Rep
GROUP BY o.Oficina, o.Ciudad;

---Contar el número de pedidos por cada representante.
select r.Num_Empl, r.Nombre, count (p.Num_Pedido) as Numeropedidos 
from 
Representantes as r 
left join Pedidos as p
on r.Num_Empl = p.Rep
where r.Num_Empl =110 --Sin este es todos los pedidos 
group by r.Num_Empl, r.Nombre;

--- Todos los pedidos realizados entre estas fechas 
SELECT Num_pedido, fecha_pedido, Cliente, Importe
FROM Pedidos
WHERE fecha_pedido BETWEEN '1989-10-10' and '1989-12-17';
---Crear un procedimiento almacenado que obtenga los pedidos de un cliente en un rango de fechas.
create or alter proc sp_Fechas 
@idCliente int,
@FechaInicio date,
@FechaFinal date
as 
begin 
select Num_Pedido,Fecha_Pedido, Importe from 
pedidos  
where Cliente = @idCliente
and Fecha_Pedido between @FechaInicio and @FechaFinal;
end;
exec @idCliente= 2101, @FechaInicio = '1990-01-03' ,  @FechaFinal= '1990-01-03'
select * from Pedidos

---Realizar una transacción que actualice el límite de crédito de un cliente y registre un pedido.
BEGIN TRANSACTION;

BEGIN TRY
    -- Actualizar el límite de crédito del cliente
    UPDATE Clientes
    SET Limite_credito = Limite_credito - 1000
    WHERE Num_Cli = 1;

    -- Insertar un nuevo pedido
    INSERT INTO Pedidos (Num_pedido, fecha_pedido, Cliente, Rep, Fab, Producto, Cantidad, Importe)
    VALUES (1001, GETDATE(), 1, 2, 'FAB', 'PROD', 10, 1000);

    -- Confirmar transacción
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    -- Revertir transacción en caso de error
    ROLLBACK TRANSACTION;
    THROW;
END CATCH;

----Obtener una lista completa de todos los clientes y representantes, mostrando los pedidos si existen.
SELECT c.Empresa, r.Nombre, p.Num_pedido, p.fecha_pedido, p.Importe
FROM Clientes c
LEFT JOIN Pedidos p ON c.Num_Cli = p.Cliente
RIGHT JOIN Representantes r ON p.Rep = r.Num_Empl;
--Obtener una lista de pedidos junto con la información del cliente y el representante.
SELECT p.Num_pedido, p.fecha_pedido, c.Empresa, r.Nombre
FROM Pedidos p
INNER JOIN Clientes c ON p.Cliente = c.Num_Cli
INNER JOIN Representantes r ON p.Rep = r.Num_Empl;
---Calcular el promedio del importe de los pedidos por cada cliente.
SELECT Cliente, AVG(Importe) AS PromedioImporte
FROM Pedidos
GROUP BY Cliente;
---Obtener una lista de clientes junto con el número total de pedidos que han realizado.
SELECT c.Num_Cli, c.Empresa, 
       (SELECT COUNT(*) 
        FROM Pedidos p 
        WHERE p.Cliente = c.Num_Cli) AS TotalPedidos
FROM Clientes c;
--Obtener una lista de representantes que no tienen pedidos.
SELECT r.Num_Empl, r.Nombre
FROM Representantes r
WHERE r.Num_Empl NOT IN (SELECT DISTINCT p.Rep FROM Pedidos p);
--Obtener una lista de clientes que tienen más de 5 pedidos.
SELECT Cliente, COUNT(*) AS TotalPedidos
FROM Pedidos
GROUP BY Cliente
HAVING COUNT(*) > 2;
-- Crear un procedimiento almacenado que devuelva el total de ventas de un representante.
CREATE PROCEDURE ObtenerVentasRepresentante
    @RepID INT,
    @TotalVentas MONEY OUTPUT
AS
BEGIN
    SELECT @TotalVentas = SUM(Importe)
    FROM Pedidos
    WHERE Rep = @RepID;
END;
DECLARE @Ventas MONEY;
EXEC ObtenerVentasRepresentante @RepID = 2, @TotalVentas = @Ventas OUTPUT;
SELECT @Ventas AS TotalVentas;

---Mostrar los productos con una clasificación de inventario según su stock.
SELECT id_producto, Descripcion, Stock,
       CASE 
           WHEN Stock > 100 THEN 'Alto'
           WHEN Stock BETWEEN 50 AND 100 THEN 'Medio'
           ELSE 'Bajo'
       END AS ClasificacionInventario
FROM Productos;


-------------------------
/*Un parámetro de salida (OUTPUT) en un procedimiento almacenado es un parámetro que permite devolver valores desde el procedimiento a la llamada que lo ejecuta. 
Esto es útil cuando necesitas retornar resultados calculados o determinados dentro del procedimiento.*/

-- Procedimiento almacenado spu_ObtenerInformacionCliente sin COALESCE y usando IF y ELSE
CREATE PROCEDURE spu_ObtenerInformacionCliente
    @Num_cliente INT,
    @NombreCliente VARCHAR(20) OUTPUT,
    @NombreRepresentante VARCHAR(16) OUTPUT
AS
BEGIN
    -- Obtener el nombre del cliente
    SELECT @NombreCliente = Empresa
    FROM Clientes
    WHERE Num_cliente = @Num_cliente;

    -- Verificar si el cliente tiene un representante asignado
    IF EXISTS (
        SELECT 1
        FROM Clientes c
        JOIN Representante r ON c.Rep_cliente = r.Num_Empl
        WHERE c.Num_cliente = @Num_cliente
    )
    BEGIN
        -- Obtener el nombre del representante
        SELECT @NombreRepresentante = r.Nombre
        FROM Clientes c
        JOIN Representante r ON c.Rep_cliente = r.Num_Empl
        WHERE c.Num_cliente = @Num_cliente;
    END
    ELSE
    BEGIN
        -- Si no tiene representante, asignar "No asignado"
        SET @NombreRepresentante = 'No asignado';
    END
END;
GO

-- Procedimiento almacenado spu_ActualizarLimiteCredito
CREATE PROCEDURE spu_ActualizarLimiteCredito
    @Num_cliente INT,
    @NuevoLimite MONEY,
    @Mensaje VARCHAR(50) OUTPUT
AS
BEGIN
    DECLARE @LimiteActual MONEY;
    
    -- Obtener el límite de crédito actual del cliente
    SELECT @LimiteActual = Limite_credito
    FROM Clientes
    WHERE Num_cliente = @Num_cliente;
    
    -- Verificar si el nuevo límite es mayor al actual
    IF @NuevoLimite > @LimiteActual
    BEGIN
        -- Actualizar el límite de crédito del cliente
        UPDATE Clientes
        SET Limite_credito = @NuevoLimite
        WHERE Num_cliente = @Num_cliente;
        
        SET @Mensaje = 'Límite de crédito actualizado correctamente';
    END
    ELSE
    BEGIN
        SET @Mensaje = 'El nuevo límite de crédito debe ser mayor al actual';
    END
END;
GO

-- Insertar datos de ejemplo para probar los procedimientos almacenados
INSERT INTO Clientes (Num_cliente, Empresa, Rep_cliente, Limite_credito) 
VALUES (1, 'Empresa1', 1, 5000.00), (2, 'Empresa2', NULL, 3000.00);

INSERT INTO Representante (Num_Empl, Nombre, Edad, Oficina_Rep, Puesto, Fecha_contrato, Jefe, cuota, ventas) 
VALUES (1, 'Juan Perez', 30, 1, 'Vendedor', '2020-01-01', NULL, 10000.00, 5000.00);

-- Ejecución de los procedimientos almacenados para comprobar su funcionamiento
DECLARE @NombreCliente VARCHAR(20), @NombreRepresentante VARCHAR(16), @Mensaje VARCHAR(50);

-- Probar spu_ObtenerInformacionCliente
EXEC spu_ObtenerInformacionCliente @Num_cliente = 1, @NombreCliente = @NombreCliente OUTPUT, @NombreRepresentante = @NombreRepresentante OUTPUT;
PRINT 'Cliente: ' + @NombreCliente + ', Representante: ' + @NombreRepresentante;

EXEC spu_ObtenerInformacionCliente @Num_cliente = 2, @NombreCliente = @NombreCliente OUTPUT, @NombreRepresentante = @NombreRepresentante OUTPUT;
PRINT 'Cliente: ' + @NombreCliente + ', Representante: ' + @NombreRepresentante;

-- Probar spu_ActualizarLimiteCredito
EXEC spu_ActualizarLimiteCredito @Num_cliente = 1, @NuevoLimite = 6000.00, @Mensaje = @Mensaje OUTPUT;
PRINT @Mensaje;

EXEC spu_ActualizarLimiteCredito @Num_cliente = 1, @NuevoLimite = 4000.00, @Mensaje = @Mensaje OUTPUT;
PRINT @Mensaje;

---------------------------------------------




