/*Desarrolla el siguiente procedimiento almacenado utilizando la base de datos bdejemplo2 en el
sistema gestor de base de datos sql server.
Realizar un procedimiento almacenado que permita agregar un cliente de la base de datos gestionventasg1
bajo las siguientes condiciones:
a) Si los objetivos de ventas son de 20000 o menos, se tiene que agregar esa cantidad a la cuota del
representante.
b) Si los objetivos de venta son más de 20000, la cuota del representante solo se debe incrementar en
20000.
c) Además, se debe incrementar el objetivo de la oficina en la cantidad del objetivo de venta asignado*/

create or alter procedure Gestionventasg1
@NumeroCliente int,
@Empresa varchar (20),
@Rep_cliente int,
@limiteCredito Money,
@ObjetivoVenta Money
as 
Begin

insert into Clientes(Num_Cli,Empresa,Rep_Cli,Limite_Credito)
values (@NumeroCliente,@Empresa,@Rep_cliente,@limiteCredito);

IF @ObjetivoVenta <=20000
BEGIN 

UPDATE Representantes
 SET cuota = ISNULL(cuota, 0) + @ObjetivoVenta
            WHERE Num_Empl = @Rep_cliente;
        END
        ELSE
        BEGIN

 UPDATE Representantes
            SET cuota = ISNULL(cuota, 0) + 20000
            WHERE Num_Empl = @Rep_cliente;
        END

		  DECLARE @Oficina INT;
        SELECT @Oficina = Oficina_Rep
        FROM Representantes
        WHERE Num_Empl = @Rep_cliente;

		  UPDATE Oficinas
        SET Objetivo = ISNULL(Objetivo, 0) + @ObjetivoVenta
        WHERE Oficina = @Oficina;
		end;

select* from Representantes;
select * from Clientes;
