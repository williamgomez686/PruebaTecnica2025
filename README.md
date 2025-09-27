Para la realizacion de este ejercicio usamos una base de datos en Docker por lo que si el evaluador desea hacer uso de una base de datos de docker dejo a continuazion el comando que utilize para la creacion de la base de datos con las credenciales 
## Crear y ejecutar contenedor SQL Server
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=PasswordPruebaGD2025" -e "MSSQL_PID=Express" -p 1433:1433 --name sqlserver-dev --restart unless-stopped -v sqlserver_data:/var/opt/mssql -d mcr.microsoft.com/mssql/server:2022-latest

# la consulta realilzadas para el ejercicio es la sigiente 
--consulta para resolver el ejercicio
select top (1) 
c.Nombre as NombreCategoria, 
v.Fecha as Fecha
--p.Nombre 
    from Categoria c 
    join Producto p 
        on c.CodigoCategoria = p.CodigoCategoria
    join Venta v 
        on p.CodigoProducto = v.CodigoProducto
--where year(v.Fecha) = 2019 
order by v.Fecha DESC 
