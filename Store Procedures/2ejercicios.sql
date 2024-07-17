----Actualiar infromacion del cliente ---
use Northwind

create or alter proc sp_ActualizacionCliente
@nombre nvarchar(50),
@ciudad nvarchar (50),
@idcliente nchar  
as 
begin 
update Customers
set CompanyName = @nombre , City=@ciudad
where CustomerID = @idcliente;
end;

---Obtener la cantidad total de productos pedidos por cada cliente--

SELECT C.CustomerID, C.CompanyName, SUM ( OD.Quantity) AS TOTAL 
FROM Customers AS C
JOIN Orders AS O ON O.CustomerID = C.CustomerID
JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
GROUP BY C.CustomerID , C.CompanyName;