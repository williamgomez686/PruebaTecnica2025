create database pruebatecnica
go
use pruebatecnica
go
create table Categoria(
	CodigoCategoria int identity (1,1) primary key,
	Nombre varchar (20) not null
)
go
create table Producto(
	CodigoProducto int identity (1,1) primary key,
	Nombre varchar (60) not null,
	CodigoCategoria int not null
	foreign key (CodigoCategoria) references Categoria(CodigoCategoria)
)
go
create table Venta(
	CodigoVenta int identity (1,1) primary key,
	Fecha date,
	CodigoProducto int not null
	foreign key (CodigoProducto) references Producto(CodigoProducto)
)
go
-- SECCIÓN 1: INSERCIÓN DE 30 CATEGORÍAS
INSERT INTO Categoria(Nombre) VALUES
('Motherboards'), ('Procesadores (CPU)'), ('Memoria RAM'), ('Tarjetas de Video'), ('Almacenamiento SSD'),
('Almacenamiento HDD'), ('Fuentes de Poder'), ('Gabinetes (Chasis)'), ('Monitores'), ('Teclados'),
('Ratones (Mice)'), ('Auriculares'), ('Webcams'), ('Impresoras'), ('Scanners'),
('Routers'), ('Switches'), ('Tarjetas de Red'), ('Sistemas Operativos'), ('Software de Oficina'),
('Software Antivirus'), ('Laptops'), ('PCs de Escritorio'), ('All-in-One'), ('Servidores'),
('Cables y Adaptadores'), ('Refrigeración CPU'), ('Ventiladores'), ('Sillas Gamer'), ('UPS y Reguladores');
GO
-- SECCIÓN 2: INSERCIÓN DE 60 PRODUCTOS
INSERT INTO Producto (Nombre, CodigoCategoria) VALUES
('ASUS ROG Strix Z790', 1), ('Gigabyte B650 AORUS', 1),
('Intel Core i9-13900K', 2), ('AMD Ryzen 9 7950X', 2), ('Intel Core i5-13600K', 2),
('Corsair Vengeance DDR5 32GB', 3), ('Kingston Fury Beast DDR4 16GB', 3),
('NVIDIA GeForce RTX 4090', 4), ('AMD Radeon RX 7900 XTX', 4), ('NVIDIA GeForce RTX 4070', 4),
('Samsung 980 Pro 1TB NVMe', 5), ('Crucial P3 2TB NVMe', 5), ('Western Digital Blue 1TB', 5),
('Seagate Barracuda 4TB', 6), ('Western Digital Black 6TB', 6),
('Corsair RM850x 850W Gold', 7), ('EVGA SuperNOVA 750 G5 Gold', 7),
('NZXT H5 Flow', 8), ('Lian Li PC-O11 Dynamic', 8),
('Dell UltraSharp 27" 4K', 9), ('LG UltraGear 27" QHD 144Hz', 9), ('ASUS TUF Gaming 24"', 9),
('Logitech MX Keys', 10), ('Razer BlackWidow V4 Pro', 10),
('Logitech G Pro X Superlight', 11), ('Razer DeathAdder V3 Pro', 11),
('Sony WH-1000XM5', 12), ('HyperX Cloud II', 12),
('Logitech C920 HD Pro', 13),
('HP LaserJet Pro M404n', 14), ('Epson EcoTank L3250', 14),
('Canon CanoScan LiDE 400', 15),
('TP-Link Archer AX55', 16), ('ASUS RT-AX86U', 16),
('Dell XPS 15', 22), ('MacBook Pro 14"', 22), ('HP Spectre x360', 22), ('Lenovo ThinkPad X1', 22),
('HP OMEN 45L Gaming', 23), ('Dell Inspiron Desktop', 23),
('Secretlab TITAN Evo', 29), ('Herman Miller Vantum', 29),
('APC Back-UPS Pro 1500VA', 30), ('Tripp Lite AVR750U', 30),
('Cable HDMI 2.1 UGREEN 2m', 26),
('Adaptador USB-C a Ethernet', 26),
('Noctua NH-D15 chromax.black', 27),
('Cooler Master Hyper 212', 27),
('be quiet! Silent Wings 4', 28),
('Corsair LL120 RGB', 28),
('Microsoft Office 365 Personal', 20),
('Windows 11 Pro', 19),
('Norton 360 Deluxe', 21),
('Microsoft Surface Laptop 5', 22),
('Acer Predator Helios 300', 22),
('Corsair K100 RGB Teclado Mecánico', 10),
('SteelSeries Apex Pro', 10),
('Logitech G502 HERO', 11);
GO
-- SECCIÓN 3: INSERCIÓN DE 220 VENTAS (20 POR AÑO DE 2015 A 2025)
-- Se utiliza un bucle para generar los datos de forma automática
DECLARE @Anio INT = 2015;
DECLARE @ContadorVentas INT;
DECLARE @FechaVenta DATE;
DECLARE @ProductoId INT;
DECLARE @DiaDelAnio INT;

-- Bucle principal para cada año
WHILE @Anio <= 2025
BEGIN
    SET @ContadorVentas = 1;
    -- Bucle anidado para generar 20 ventas por año
    WHILE @ContadorVentas <= 20
    BEGIN
        -- 1. Generar un ID de producto aleatorio (entre 1 y 60)
        SET @ProductoId = FLOOR(RAND() * 60) + 1;

        -- 2. Generar un día aleatorio del año (entre 0 y 364)
        SET @DiaDelAnio = FLOOR(RAND() * 365);

        -- 3. Crear la fecha de la venta sumando los días al inicio del año
        SET @FechaVenta = DATEADD(day, @DiaDelAnio, CAST(CAST(@Anio AS VARCHAR(4)) + '-01-01' AS DATE));

        -- 4. Insertar el registro de venta
        INSERT INTO Venta (Fecha, CodigoProducto)
        VALUES (@FechaVenta, @ProductoId);

        SET @ContadorVentas = @ContadorVentas + 1;
    END
    SET @Anio = @Anio + 1;
END


--delete from Venta

--delete from Producto

--delete from Categoria

select * from Categoria c 
go
select * from Producto p 
go
select * from Venta v order by Fecha 

--consulta para valuacion de datos
select v.CodigoVenta, v.Fecha, p.Nombre, c.Nombre  from Venta v
join Producto p on v.CodigoProducto = p.CodigoProducto
join Categoria c on p.CodigoCategoria = c.CodigoCategoria
order by Fecha, c.Nombre DESC 

--consulta para resolver el ejercicio
select -- top (1) 
c.Nombre as NombreCategoria, 
v.Fecha as Fecha
--p.Nombre 
    from Categoria c 
    join Producto p 
        on c.CodigoCategoria = p.CodigoCategoria
    join Venta v 
        on p.CodigoProducto = v.CodigoProducto
--where year(v.Fecha) = 2019 --Rango de años 2015 - 2025
order by v.Fecha DESC 