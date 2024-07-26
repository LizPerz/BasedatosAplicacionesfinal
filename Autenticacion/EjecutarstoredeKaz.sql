use Northwind
exec  [dbo].[spu_agregar_venta]
@CustomerID='ALFKI',
@EmployeeID=1,
@OrderDate= '2024-07-26',
@RequiredDate='2024-07-26',
@ShippedDate= '2024-07-26',
@ShipVia=1,
@ProductID = 2,
@Quantity =10
