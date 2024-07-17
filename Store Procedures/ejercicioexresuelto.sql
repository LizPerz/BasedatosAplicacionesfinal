-----Examen de SP----------
---Ejercicio 1----
/*crear un procedimiento almacenado que reciba como parametro el ID de un producto y devuelva infromacion
del producto junto con el nombre de la subcategoria y categoria a la que pertenece.
si el producto no existe, devolver un mensaje adecuado 
1. el rpocedimiento debe aceptar un parametro de entrada @productId de tipo int 
2. si el porducto no existe, devolver un mensaje 'Producto no encontrado '
3. si el producto existe devolver infromacion del producto, subcategoria y categoria 
con la base AdventureWorks2016*/
CREATE PROCEDURE sp_producto
    @productId INT
AS
BEGIN
    -- Verificar si el producto existe
    IF NOT EXISTS (SELECT 1 FROM Production.Product WHERE ProductID = @productId)
    BEGIN
        -- Si el producto no existe, devolver mensaje
        SELECT 'Producto no encontrado' AS Mensaje;
        RETURN;
    END

    -- Si el producto existe, devolver información del producto, subcategoría y categoría
    SELECT 
        p.ProductID,
        p.Name AS ProductName,
        p.ProductNumber,
        p.Color,
        p.StandardCost,
        p.ListPrice,
        p.Size,
        p.Weight,
        p.ProductSubcategoryID,
        ps.Name AS SubcategoryName,
        pc.ProductCategoryID,
        pc.Name AS CategoryName
    FROM 
        Production.Product p
        LEFT JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
        LEFT JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
    WHERE 
        p.ProductID = @productId;
END
GO
EXEC sp_producto @productId = 1;


---Ejercicio2---
/*Crear un procedimiento almacenado que actualice el precio de lista de un producto
si su nuevo precio es mayor que el precio Actual. El procedimiento debe registrar esta operacion en una tabla de auditoria
1. crear el procedimiento almancenado 
2. el procedimeitno debe de aceptar los parametros @productid de tipo int y newprice de tipo money 
3. Actualizar el precio de lista del producto 
4. registrae la operacion en la tabla productpricehistory 
creamos la tabla  productpricehistory 
create table production.productpricehistory (
productid int ,
oldprice money ,
newprice money,
changedate DATETIME DEFAULT GETDATE() )
con la base datos AdeventureWORKS2016*/

CREATE TABLE Production.ProductPriceHistory (
    ProductID INT,
    OldPrice MONEY,
    NewPrice MONEY,
    ChangeDate DATETIME DEFAULT GETDATE()
);
GO

CREATE PROCEDURE sp_UpdateProductPrice
    @productId INT,
    @newPrice MONEY
AS
BEGIN
    DECLARE @currentPrice MONEY;

    -- Obtener el precio actual del producto
    SELECT @currentPrice = ListPrice
    FROM Production.Product
    WHERE ProductID = @productId;

    -- Verificar si el producto existe
    IF @currentPrice IS NULL
    BEGIN
        -- Si el producto no existe, devolver mensaje
        SELECT 'Producto no encontrado' AS Mensaje;
        RETURN;
    END

    -- Verificar si el nuevo precio es mayor que el precio actual
    IF @newPrice > @currentPrice
    BEGIN
        -- Actualizar el precio de lista del producto
        UPDATE Production.Product
        SET ListPrice = @newPrice
        WHERE ProductID = @productId;

        -- Registrar la operación en la tabla de auditoría
        INSERT INTO Production.ProductPriceHistory (ProductID, OldPrice, NewPrice, ChangeDate)
        VALUES (@productId, @currentPrice, @newPrice, GETDATE());

        SELECT 'Precio actualizado exitosamente' AS Mensaje;
    END
    ELSE
    BEGIN
        SELECT 'El nuevo precio debe ser mayor que el precio actual' AS Mensaje;
    END
END
GO
EXEC sp_UpdateProductPrice @productId = 1, @newPrice = 180.00;

SELECT 
    ProductID, 
    Name, 
    ListPrice 
FROM 
    Production.Product 
WHERE 
    ProductID = 1; -- Reemplaza 1 con el ID de tu producto


SELECT 
    ProductID, 
    OldPrice, 
    NewPrice, 
    ChangeDate 
FROM 
    Production.ProductPriceHistory 
WHERE 
    ProductID = 1; -- Reemplaza 123 con el ID de tu producto
/*ORDER BY 
    ChangeDate DESC; -- Ordenar por fecha de cambio para ver los registros más recientes primero*/
