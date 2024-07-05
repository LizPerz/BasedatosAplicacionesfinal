
use AdventureWorks2019;


-- CASE se puede utilizar en cualquier instrucción o
-- cláusula que permite una expresión válida.
-- Por ejemplo, puede utilizar CASE en instrucciones como
---SELECT, UPDATE, DELETE y SET,
--  y en cláusulas como <select_list>, IN, WHERE, ORDER BY y HAVING.


-- Sintaxis

-- Simple CASE expression:
-- CASE input_expression
--      WHEN when_expression THEN result_expression [ ...n ]
--      [ ELSE else_result_expression ]
-- END

-- -- Searched CASE expression:
-- CASE
--      WHEN Boolean_expression THEN result_expression [ ...n ]
--      [ ELSE else_result_expression ]
-- END


-- A. Uso de una instrucción SELECT con una expresión CASE sencilla

-- En una instrucción SELECT, una expresión CASE sencilla solo permite una
-- comprobación de igualdad; no se pueden hacer otras comparaciones.
-- En este ejemplo se utiliza la expresión CASE para cambiar la presentación de categorías
-- de línea de productos con el fin de hacerla más comprensible.

Use AdventureWorks2019;
GO

select ProductNumber, name, ProductLine
from Production.Product

create view v_reporte_Productos
AS
SELECT ProductNumber, [name], ProductLine,
    CASE ProductLine
        WHEN 'R' THEN 'Road'
        WHEN 'M' THEN 'Mountain'
        WHEN 'T' THEN 'Touring'
        WHEN 'S' THEN 'Other Sales Items'
        ELSE 'Not for sales'
        END as [Category]
FROM Production.Product
where ProductLine in ('R', 'M');

SELECT * from v_reporte_Productos

SELECT ProductNumber, [name], ProductLine,
    [Category]=CASE ProductLine
        WHEN 'R' THEN 'Road'
        WHEN 'M' THEN 'Mountain'
        WHEN 'T' THEN 'Touring'
        WHEN 'S' THEN 'Other Sales Items'
        ELSE 'Not for sales'
        END 
FROM Production.Product;

---------------------------------------------
select ProductNumber as 'NumeroProducto',
[name] as 'Nombre Producto',
[Category]=CASE ProductLine
        WHEN 'R' THEN 'Road'
        WHEN 'M' THEN 'Mountain'
        WHEN 'T' THEN 'Touring'
        WHEN 'S' THEN 'Other Sales Items'
        ELSE 'Not for sales'
        END, ListPrice as 'Precio',
        CASE
            WHEN ListPrice = 0.00 then 'Mfg item - not for resale'
            WHEN ListPrice < 50.0 then 'Under $50'
            WHEN ListPrice >= 50 AND ListPrice < 250 THEN 'Under $250'
            WHEN ListPrice >= 250 AND ListPrice < 1000 THEN 'Under $1000'
            ELSE 'Over $1000'
            END AS [Price Range]
FROM 
Production.Product

---------------IS NULL(Funcion)-------------------
select v.AccountNumber,v.name,
ISNULL(v.PurchasingWebServiceURL,'NO URL') as 'Sitio Web'
FROM
[Purchasing].[Vendor] as v

-------------IIF(FUNCION)----------------
select IIF(1=1, 'Verdadero','Falso')  as 'Resultado'
select IIF(1=2, 'Verdadero','Falso')  as 'Valor'

Select IIF(LEN('SQL SERVER')=10,'OK', 'NO OK') as 'Resultado'

SELECT e.LoginID, e.JobTitle, e.Gender, IIF(E.Gender = 'M','Hombre','Mujer') as 'Genero'
FROM HumanResources.Employee as e;

--FUNCION MARGE
--SELECT OBJECT_ID(N'tempdb..#StudentsC1')
IF OBJECT_ID (N'tempdb..#StudentsC1') is not NULL
begin
    drop table #StudentsC1;
end

CREATE TABLE #StudentsC1( --#TABLA TEMPORAL LOCALES
    StudentID       INT
    ,StudentName    VARCHAR(50)
    ,StudentStatus  BIT
);

INSERT INTO #StudentsC1(StudentID, StudentName, StudentStatus) VALUES(1,'Axel Romero',1)

INSERT INTO #StudentsC1(StudentID, StudentName, StudentStatus) VALUES(2,'Sofía Mora',1)

INSERT INTO #StudentsC1(StudentID, StudentName, StudentStatus) VALUES(3,'Rogelio Rojas',0)
INSERT INTO #StudentsC1(StudentID, StudentName, StudentStatus) VALUES(4,'Mariana Rosas',1)
INSERT INTO #StudentsC1(StudentID, StudentName, StudentStatus) VALUES(5,'Roman Zavaleta',1)

SELECT * FROM #StudentsC1


---------------------------------------------------------------------------

IF OBJECT_ID(N'tempdb..#StudentsC2') is not NULL
begin
drop table #StudentsC2
END


CREATE TABLE #StudentsC2(
    StudentID       INT
    ,StudentName    VARCHAR(50)
    ,StudentStatus  BIT
);


INSERT INTO #StudentsC2(StudentID, StudentName, StudentStatus) VALUES(1,'Axel Romero Rendón',1)
INSERT INTO #StudentsC2(StudentID, StudentName, StudentStatus) VALUES(2,'Sofía Mora Ríos',0)
INSERT INTO #StudentsC2(StudentID, StudentName, StudentStatus) VALUES(6,'Mario Gonzalez Pae',1)
INSERT INTO #StudentsC2(StudentID, StudentName, StudentStatus) VALUES(7,'Alberto García Morales',1)
SELECT * FROM #StudentsC1
select * from #StudentsC2

--actualize inserte los datos de c1 que no estan en c2
insert into #StudentsC2
select s1.StudentID, s1.StudentName, s1.StudentStatus
from #StudentsC1 as s1
left JOIN #StudentsC2 as s2
on s1.StudentID =s2.StudentID 
where s2.StudentID is null 

select count (*) from #StudentsC2

select * from 
#StudentsC1 as s1
inner JOIN #StudentsC2 as s2
on s1.StudentID=s2.StudentID

update s2
set s2.StudentName =s1.StudentName,
s2.StudentStatus = s1.StudentStatus
from 
#StudentsC1 as s1
inner JOIN #StudentsC2 as s2
on s1.StudentID=s2.StudentID