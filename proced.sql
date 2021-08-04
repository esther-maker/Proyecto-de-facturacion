create procedure actualizardetalle  
@id int,
@cod_prod int,
@cant int,
@precio money,
@preciototal money,
@monto money,
@devuelta money
as
insert into detalle_factura (id_detalle, cod_pro, cantidad, precio, preciototal, monto, devuelta) values(@id, @cod_prod, @cant, @precio,@preciototal,@monto,@devuelta)

create procedure actualizarfactura
@id_detalle int,
@cod_empleado int,
@cod_cliente int,
@id_cuentac int
as
declare @codigo_fact int
select @codigo_fact = MAX (codigo_fact) from factura
if @codigo_fact is null set @codigo_fact=0
set @codigo_fact= @codigo_fact+1
insert into factura (codigo_fact, id_detalle, cod_empleado, Cod_cliente, fecha, id_cuentac) values (@codigo_fact, @id_detalle,@cod_empleado,@cod_cliente, GETDATE(),@id_cuentac)
SELECT * FROM  factura WHERE codigo_fact = @codigo_fact


create procedure datosfactura @cod_fact int

as
select  codigo_fact, empleados.nombre as empleado, clientes.nombre as cliente, factura.fecha, Productos.nombre as producto, detalle_factura.cantidad,detalle_factura.precio,detalle_factura.preciototal, detalle_factura.monto, detalle_factura.devuelta ,cuenta_cobrar.monto_pagar

from factura inner join detalle_factura on factura.id_detalle=detalle_factura.id_detalle
inner join empleados on factura.cod_empleado=empleados.cod_empleado
inner join clientes on factura.Cod_cliente=clientes.Cod_cliente
inner join cuenta_cobrar on factura.id_cuentac=cuenta_cobrar.id_cobrar
inner join Productos on detalle_factura.cod_pro=Productos.codigo_prod

where factura.codigo_fact=@cod_fact and empleados.estado=1 and clientes.estado=1

