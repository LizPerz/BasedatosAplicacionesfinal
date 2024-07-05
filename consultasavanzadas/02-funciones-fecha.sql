-- Funciones de fecha 
--Seleccionar los años, dias, mes y cuatrimetres de las ordenes 
select GETDATE ()
SELECT DATEPART (YEAR, '2024-06-06'),
DATEPART (MONTH, '2024-06-06') AS 'MES',
DATEPART (quarter, '2024-06-06') as 'Trimestre',
DATEPART (week, '2024-06-06') as 'Semana',
DATEPART (DAY,'2024-06-06') as 'Dia',
DATEPART (weekday,'2024-06-06') as 'Dia de la semana'

set LANGUAGE spanish
select DATENAME(YEAR,OrderDate) AS 'AÑO',
DATENAME(month,OrderDate) as 'Mes',
DATENAME(quarter,OrderDate) as 'Trimetre',
DATENAME(week,OrderDate) as 'Semana',
DATENAME(day,OrderDate) as 'Día',
DATENAME(weekday,OrderDate) as 'Día de la Semana',
DATENAME(yy,OrderDate) as 'Año 2'
from Orders;

--funciones que regresa el nombre de un mes o dia etc

SELECT DATENAME (month,GETDATE()) as mes 
set LANGUAGE spanish
SELECT DATENAME (month,GETDATE()) as mes, DATENAME (weekday, GETDATE()) as dia

--Funcion para tener la diferencia entre años y meses dias etc,
SELECT DATEDIFF (year, '1983-04-06',GETDATE()) as 'tiempo de vejez'

--SEleccionar el numero de dias transcurridos entre las fechas del pedido y la fecha de entrega
SELECT*FROM ORDERS 
select orderid, DATEDIFF(day,OrderDate,shippeddate) as 'Dias transcurridos'
 from ORDERS