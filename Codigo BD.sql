USE [papeleria]
GO
/****** Object:  StoredProcedure [dbo].[actualizardetalle]    Script Date: 19/07/2021 0:47:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[actualizardetalle]  
@id int,
@cod_prod int,
@cant int,
@precio money,
@preciototal money,
@monto money,
@devuelta money
as
insert into detalle_factura (id_detalle, cod_prod, cantidad, precio, preciototal, monto, devuelta) values(@id, @cod_prod, @cant, @precio,@preciototal,@monto,@devuelta)

GO
/****** Object:  StoredProcedure [dbo].[actualizarfactura]    Script Date: 19/07/2021 0:47:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[actualizarfactura]
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

GO
/****** Object:  StoredProcedure [dbo].[compramarca]    Script Date: 19/07/2021 0:47:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[compramarca]
@marca varchar(max),
@cantidad int 
as
begin
SELECT id_comp,proveedores.nombre,Compra.fecha_compra,Compra.precio_unid, Compra.cantidad,Productos.nombre,marca.marca, Compra.precio_total from Compra inner join marca on marca.codigo_marca=Compra.marca
inner join Productos on Productos.codigo_prod=Compra.codigo_prod inner join proveedores on proveedores.id_prov=Compra.proveedor where marca.marca=@marca or Compra.cantidad=@cantidad
end

GO
/****** Object:  StoredProcedure [dbo].[cuenta_c]    Script Date: 19/07/2021 0:47:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[cuenta_c]
@fecha Date
as
begin
SELECT * from cuenta_cobrar where fecha= @fecha
end

GO
/****** Object:  StoredProcedure [dbo].[datosfactura]    Script Date: 19/07/2021 0:47:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[datosfactura] @cod_fact int
as
select  codigo_fact, empleados.nombre as empleado, clientes.nombre as cliente, factura.fecha, Productos.nombre as producto, detalle_factura.cantidad,detalle_factura.precio,detalle_factura.preciototal, detalle_factura.monto, detalle_factura.devuelta ,cuenta_cobrar.monto_pagar
from factura inner join detalle_factura on factura.id_detalle=detalle_factura.id_detalle
inner join empleados on factura.cod_empleado=empleados.cod_empleado
inner join clientes on factura.Cod_cliente=clientes.Cod_cliente
inner join cuenta_cobrar on factura.id_cuentac=cuenta_cobrar.id_cobrar
inner join Productos on detalle_factura.cod_prod=Productos.codigo_prod
where factura.codigo_fact=@cod_fact and empleados.estado=1 and clientes.estado=1

GO
/****** Object:  StoredProcedure [dbo].[GuardardETalle]    Script Date: 19/07/2021 0:47:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create proc [dbo].[GuardardETalle]
@codFact int,
@codprod int,
@cantidad int,
@precio money,
@preciototal money,
@monto money,
@devuelta money
as
insert into detalle_factura values  (@codFact,@codprod,@cantidad,@precio,@preciototal,@monto,@devuelta)
GO
/****** Object:  StoredProcedure [dbo].[GuardarFactura]    Script Date: 19/07/2021 0:47:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[GuardarFactura]
@codEmpleado int,
@codCliente int,
@fecha datetime,
@id_cuenta int
as
insert into factura values  (@codEmpleado,@codCliente,@fecha,@id_cuenta)
GO
/****** Object:  StoredProcedure [dbo].[impresion]    Script Date: 19/07/2021 0:47:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[impresion]
as
begin
select cod_ci,modos.modo,cantidad as cliente,fecha,copiaeimpresion1.precio,copiaeimpresion1.precio_total, copiaeimpresion1.monto_pagado,copiaeimpresion1.devuelta from copiaeimpresion1
inner join modos on modos.id_modo= copiaeimpresion1.id_modo
end

GO
/****** Object:  StoredProcedure [dbo].[insertarCobrar]    Script Date: 19/07/2021 0:47:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[insertarCobrar]
@feha datetime,
@monto money,
@codcliente int
as
insert into cuenta_cobrar values  (@feha,@monto,@codcliente)
GO
/****** Object:  StoredProcedure [dbo].[produto_marca_prov]    Script Date: 19/07/2021 0:47:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[produto_marca_prov]
as
begin
select codigo_prod, productos.Nombre,Cantidad,marca.marca,precio_unit,proveedores.nombre as proveedor from  Productos
inner join marca on marca.codigo_marca= Productos.Marca inner join proveedores
ON proveedores.id_prov= Productos.proveedor
end


GO
/****** Object:  Table [dbo].[clientes]    Script Date: 19/07/2021 0:47:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[clientes](
	[Cod_cliente] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](50) NULL,
	[apellido] [varchar](50) NULL,
	[edad] [int] NULL,
	[telefono] [varchar](15) NULL,
	[direccion] [varchar](50) NULL,
	[Genero] [varchar](1) NULL,
	[estado] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Cod_cliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Compra]    Script Date: 19/07/2021 0:47:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Compra](
	[id_comp] [int] IDENTITY(1,1) NOT NULL,
	[proveedor] [int] NULL,
	[fecha_compra] [datetime] NULL,
	[precio_unid] [money] NULL,
	[cantidad] [int] NULL,
	[codigo_prod] [int] NULL,
	[marca] [int] NULL,
	[precio_total] [money] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_comp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[copiaeimpresion1]    Script Date: 19/07/2021 0:47:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[copiaeimpresion1](
	[cod_ci] [int] IDENTITY(1,1) NOT NULL,
	[id_modo] [varchar](6) NULL,
	[cantidad] [int] NULL,
	[fecha] [datetime] NULL,
	[precio] [money] NULL,
	[precio_total] [money] NULL,
	[monto_pagado] [money] NULL,
	[devuelta] [money] NULL,
 CONSTRAINT [PK_copiaeimpresion1] PRIMARY KEY CLUSTERED 
(
	[cod_ci] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[cuenta_cobrar]    Script Date: 19/07/2021 0:47:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cuenta_cobrar](
	[id_cobrar] [int] IDENTITY(1,1) NOT NULL,
	[fecha] [datetime] NULL,
	[monto_pagar] [decimal](18, 0) NULL,
	[Cod_cliente] [int] NULL,
 CONSTRAINT [PK__cuenta_c__642A1651F2D400ED] PRIMARY KEY CLUSTERED 
(
	[id_cobrar] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[detalle_factura]    Script Date: 19/07/2021 0:47:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[detalle_factura](
	[id_detalle] [int] IDENTITY(1,1) NOT NULL,
	[codigo_fact] [int] NULL,
	[cod_prod] [int] NULL,
	[cantidad] [int] NULL,
	[precio] [decimal](18, 0) NULL,
	[preciototal] [decimal](18, 0) NULL,
	[monto] [decimal](18, 0) NULL,
	[devuelta] [decimal](18, 0) NULL,
 CONSTRAINT [PK_detalle_factura] PRIMARY KEY CLUSTERED 
(
	[id_detalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[empleados]    Script Date: 19/07/2021 0:47:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[empleados](
	[cod_empleado] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](50) NULL,
	[apellido] [varchar](50) NULL,
	[cedula] [varchar](13) NULL,
	[edad] [int] NULL,
	[telefono] [varchar](12) NULL,
	[correo_electronico] [varchar](40) NULL,
	[direccion] [varchar](50) NULL,
	[Genero] [varchar](1) NULL,
	[sueldo] [money] NULL,
	[estado] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[cod_empleado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[factura]    Script Date: 19/07/2021 0:47:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[factura](
	[codigo_fact] [int] IDENTITY(1,1) NOT NULL,
	[cod_empleado] [int] NULL,
	[Cod_cliente] [int] NULL,
	[fecha] [datetime] NULL,
	[id_cuentac] [int] NULL,
 CONSTRAINT [PK_factura] PRIMARY KEY CLUSTERED 
(
	[codigo_fact] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[marca]    Script Date: 19/07/2021 0:47:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[marca](
	[codigo_marca] [int] IDENTITY(1,1) NOT NULL,
	[marca] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[codigo_marca] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[modos]    Script Date: 19/07/2021 0:47:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[modos](
	[id_modo] [varchar](6) NOT NULL,
	[modo] [varchar](15) NULL,
	[precio] [decimal](18, 0) NULL,
 CONSTRAINT [PK__modos__82CF9D13C19E574E] PRIMARY KEY CLUSTERED 
(
	[id_modo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Productos]    Script Date: 19/07/2021 0:47:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Productos](
	[codigo_prod] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](30) NULL,
	[cantidad] [int] NULL,
	[marca] [int] NULL,
	[precio_unit] [decimal](18, 0) NULL,
	[proveedor] [int] NULL,
 CONSTRAINT [PK__Producto__B61D7E893379982B] PRIMARY KEY CLUSTERED 
(
	[codigo_prod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[proveedores]    Script Date: 19/07/2021 0:47:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[proveedores](
	[id_prov] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](35) NULL,
	[Direccion] [varchar](50) NULL,
	[Telefono] [varchar](18) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_prov] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[usuario]    Script Date: 19/07/2021 0:47:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[usuario](
	[id_usuario] [int] IDENTITY(1,1) NOT NULL,
	[NOMBRE] [varchar](50) NULL,
	[USUARIO] [varchar](50) NULL,
	[CONTRASEÑA] [varchar](50) NULL,
	[TIPO_USUARIO] [varchar](50) NULL,
	[cod_empleado] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Compra] ADD  CONSTRAINT [DF_Compra_fecha_compra]  DEFAULT (getdate()) FOR [fecha_compra]
GO
ALTER TABLE [dbo].[copiaeimpresion1] ADD  CONSTRAINT [DF__copiaeimp__fecha__24927208]  DEFAULT (getdate()) FOR [fecha]
GO
ALTER TABLE [dbo].[cuenta_cobrar] ADD  CONSTRAINT [DF__cuenta_co__fecha__267ABA7A]  DEFAULT (getdate()) FOR [fecha]
GO
ALTER TABLE [dbo].[factura] ADD  DEFAULT (getdate()) FOR [fecha]
GO
ALTER TABLE [dbo].[Compra]  WITH CHECK ADD  CONSTRAINT [FK_Compra_marca] FOREIGN KEY([marca])
REFERENCES [dbo].[marca] ([codigo_marca])
GO
ALTER TABLE [dbo].[Compra] CHECK CONSTRAINT [FK_Compra_marca]
GO
ALTER TABLE [dbo].[Compra]  WITH CHECK ADD  CONSTRAINT [FK_Compra_Productos] FOREIGN KEY([codigo_prod])
REFERENCES [dbo].[Productos] ([codigo_prod])
GO
ALTER TABLE [dbo].[Compra] CHECK CONSTRAINT [FK_Compra_Productos]
GO
ALTER TABLE [dbo].[Compra]  WITH CHECK ADD  CONSTRAINT [FK_Compra_proveedores1] FOREIGN KEY([proveedor])
REFERENCES [dbo].[proveedores] ([id_prov])
GO
ALTER TABLE [dbo].[Compra] CHECK CONSTRAINT [FK_Compra_proveedores1]
GO
ALTER TABLE [dbo].[copiaeimpresion1]  WITH CHECK ADD  CONSTRAINT [FK_copiaeimpresion1_modos] FOREIGN KEY([id_modo])
REFERENCES [dbo].[modos] ([id_modo])
GO
ALTER TABLE [dbo].[copiaeimpresion1] CHECK CONSTRAINT [FK_copiaeimpresion1_modos]
GO
ALTER TABLE [dbo].[cuenta_cobrar]  WITH CHECK ADD  CONSTRAINT [FK_cuenta_cobrar_clientes] FOREIGN KEY([Cod_cliente])
REFERENCES [dbo].[clientes] ([Cod_cliente])
GO
ALTER TABLE [dbo].[cuenta_cobrar] CHECK CONSTRAINT [FK_cuenta_cobrar_clientes]
GO
ALTER TABLE [dbo].[detalle_factura]  WITH CHECK ADD  CONSTRAINT [FK_detalle_factura_factura] FOREIGN KEY([codigo_fact])
REFERENCES [dbo].[factura] ([codigo_fact])
GO
ALTER TABLE [dbo].[detalle_factura] CHECK CONSTRAINT [FK_detalle_factura_factura]
GO
ALTER TABLE [dbo].[detalle_factura]  WITH CHECK ADD  CONSTRAINT [FK_detalle_factura_Productos] FOREIGN KEY([cod_prod])
REFERENCES [dbo].[Productos] ([codigo_prod])
GO
ALTER TABLE [dbo].[detalle_factura] CHECK CONSTRAINT [FK_detalle_factura_Productos]
GO
ALTER TABLE [dbo].[factura]  WITH CHECK ADD  CONSTRAINT [FK_factura_clientes] FOREIGN KEY([Cod_cliente])
REFERENCES [dbo].[clientes] ([Cod_cliente])
GO
ALTER TABLE [dbo].[factura] CHECK CONSTRAINT [FK_factura_clientes]
GO
ALTER TABLE [dbo].[factura]  WITH CHECK ADD  CONSTRAINT [FK_factura_cuenta_cobrar] FOREIGN KEY([id_cuentac])
REFERENCES [dbo].[cuenta_cobrar] ([id_cobrar])
GO
ALTER TABLE [dbo].[factura] CHECK CONSTRAINT [FK_factura_cuenta_cobrar]
GO
ALTER TABLE [dbo].[factura]  WITH CHECK ADD  CONSTRAINT [FK_factura_empleados] FOREIGN KEY([cod_empleado])
REFERENCES [dbo].[empleados] ([cod_empleado])
GO
ALTER TABLE [dbo].[factura] CHECK CONSTRAINT [FK_factura_empleados]
GO
ALTER TABLE [dbo].[Productos]  WITH CHECK ADD  CONSTRAINT [FK_Productos_marca1] FOREIGN KEY([marca])
REFERENCES [dbo].[marca] ([codigo_marca])
GO
ALTER TABLE [dbo].[Productos] CHECK CONSTRAINT [FK_Productos_marca1]
GO
ALTER TABLE [dbo].[Productos]  WITH CHECK ADD  CONSTRAINT [FK_Productos_proveedores] FOREIGN KEY([proveedor])
REFERENCES [dbo].[proveedores] ([id_prov])
GO
ALTER TABLE [dbo].[Productos] CHECK CONSTRAINT [FK_Productos_proveedores]
GO
ALTER TABLE [dbo].[usuario]  WITH CHECK ADD  CONSTRAINT [FK_usuario_empleados] FOREIGN KEY([id_usuario])
REFERENCES [dbo].[empleados] ([cod_empleado])
GO
ALTER TABLE [dbo].[usuario] CHECK CONSTRAINT [FK_usuario_empleados]
GO
