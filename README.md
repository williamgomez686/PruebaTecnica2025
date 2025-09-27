# Datos personales para uso de evaluador

**Nombre:** William Eduardo Gómez Morales  
**Puesto a aplicar:** Desarrollador JR

## Instrucciones para Evaluador

Para la realización de este ejercicio usamos una base de datos en Docker, por lo que si el evaluador desea hacer uso de una base de datos de Docker, dejo a continuación el comando que utilicé para la creación de la base de datos con las credenciales:

### Crear y ejecutar contenedor SQL Server

```bash
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=PasswordPruebaGD2025" -e "MSSQL_PID=Express" -p 1433:1433 --name sqlserver-dev --restart unless-stopped -v sqlserver_data:/var/opt/mssql -d mcr.microsoft.com/mssql/server:2022-latest
```

## Consulta realizada para el ejercicio

```sql
-- Consulta para resolver el ejercicio
SELECT TOP (1) 
    c.Nombre AS NombreCategoria, 
    v.Fecha AS Fecha
    -- p.Nombre 
FROM Categoria c 
    INNER JOIN Producto p 
        ON c.CodigoCategoria = p.CodigoCategoria
    INNER JOIN Venta v 
        ON p.CodigoProducto = v.CodigoProducto
-- WHERE YEAR(v.Fecha) = 2019 -- Rango de años 2015 - 2025
ORDER BY v.Fecha DESC;
```

## Razones por las que decidí estructurar de esta manera la consulta

A continuación, detallo las decisiones tomadas para estructurar la consulta, con el fin de resolver el ejercicio

**Limitación de resultados:**  --SELECT-- Iniciamos con un `TOP(1)` con el fin de limitar el número de valores devueltos, ya que está filtrado por fecha de forma descendente. Con esto garantizo que el resultado de la categoría más vendida sea la que tenga la fecha más reciente, esto de la mano con el filtro `WHERE` (que de momento está comentado ya que no me quedaba claro si la fecha para esta consulta era el 2019, dándole al evaluador la posibilidad de elegir un año a su gusto) que filtraría por el año a elección.

**Campos a mostrar:** Luego tenemos los campos a mostrar al usuario que son los que el ejercicio solicita: Nombre de la categoría y su fecha.

**Tabla base:** En el `FROM` tenemos la tabla donde buscaremos la categoría, tomándola como base y por medio de los `JOIN` navegar hasta venta y obtener la fecha.

**Joins:** En el apartado de joins hice uso de `INNER JOIN` pues necesitaba obtener todos los registros que existieran en las 3 tablas involucradas, pues no me interesan registros que se encuentren en unas tablas y en otras no.

**Filtros:** Como único filtro tengo `WHERE` que de momento está comentado, dándole la oportunidad al evaluador la posibilidad de elegir el año entre 2015 a 2025.

**Ordenamiento:** Por último usamos un `ORDER BY` para ordenar por fecha de forma descendente. Esto nos garantiza que la fecha más reciente siempre aparezca primero y al combinarla con `TOP(1)` nos aseguramos de obtener únicamente el último valor.
