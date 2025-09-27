# Datos personales para uso de evaluador

**Nombre:** William Eduardo Gómez Morales  
**Puesto a aplicar:** Desarrollador JR

## Instrucciones para Evaluador

Para la realización de este ejercicio usamos una base de datos en Docker, por lo que si el evaluador desea hacer uso de una base de datos de Docker, dejo a continuación el comando que utilicé para la creación de la base de datos con las credenciales:

### Crear y ejecutar contenedor SQL Server

```bash
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=PasswordPruebaGD2025" -e "MSSQL_PID=Express" -p 1433:1433 --name sqlserver-dev --restart unless-stopped -v sqlserver_data:/var/opt/mssql -d mcr.microsoft.com/mssql/server:2022-latest
```
# Ejerccicio 1 Base de Datos
En el repositorio se incluye el archivo "SQL-Creacion-consulta.sql" que contiene tanto la creacion de base de datos, trablas y el llenado del las 3 tablas

![Imagen que muestra el diagrama de entidad relacion](https://raw.githubusercontent.com/williamgomez686/PruebaTecnica2025/refs/heads/master/PruebaTecnica2025/wwwroot/image/Diagrama_tablas.png)
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


# Ejercicio 2 ASP.NET Core con Gestor de Plantillas

## Datos relevantes en la creación del ejercicio de ASP.NET

### Tecnologías utilizadas

Como parte del segundo ejercicio, las tecnologías utilizadas son:

* **ASP.NET Core versión 9**
* Acceso a la base de datos **Entity Framework Database First** con inyección de dependencias con el DbContext en los controladores
* Arquitectura del proyecto **Patrón de arquitectura MVC**
* Para las vistas **HTML, Bootstrap 5 y vistas de Razor**

## Configuración de Base de Datos

Como dato importante, la cadena de conexión que se usa en este ejercicio está pensada para solicitar usuario y contraseña ya que se conecta a una base de datos de Docker. Si el evaluador desea usar una base de datos instalada en su equipo local, es libre de cambiar la cadena de conexión por la de su equipo. Ahora, si utiliza el despliegue de un contenedor de Docker como los describo más arriba, no es necesario hacer ningún cambio a la cadena de conexión.

### Archivo appsettings.json

A continuación se muestra cómo está el archivo `appsettings.json` para que el evaluador considere qué cadena de conexión usará. Si en su equipo tiene instalado el servidor de base de datos SQL Server, deberá usar la cadena de conexión llamada `"DefaultConnection"`. Si usa una instancia de Docker o algún servidor externo que solicite datos como usuario y contraseña, puede usar la cadena de conexión `"DockerSQL"`.

```json
{
  "ConnectionStrings": {
    "DockerSQL": "Data Source=127.0.0.1;Initial Catalog=pruebatecnica;User Id=sa;Password=PasswordPruebaGD2025;TrustServerCertificate=True",
    "DefaultConnection": "Data Source=TuServidorDB\\SQLEXPRESS;Database=TuBaseDeDatos;Trusted_Connection=True;MultipleActiveResultSets=true;"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*"
}
```

### Configuración en Program.cs

Dependiendo de qué cadena de conexión usará, asegúrese de elegir correctamente en el archivo `Program.cs`, ya que por defecto está usando `"DockerSQL"`:

```csharp
var connectionString = builder.Configuration.GetConnectionString("DockerSQL") ?? throw new InvalidOperationException("Connection string 'DefaultConnection' not found.");
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(connectionString));
builder.Services.AddDatabaseDeveloperPageExceptionFilter();
```

## Implementación del Ejercicio

Continuando con el ejercicio, se encuentra en el controlador llamado **VentasController**:

```csharp
[HttpGet]
public async Task<IActionResult> Ejercicio(int CodCategoria, int anio)
{
    int anioFiltro = (anio > 0) ? anio : 2019;

    var categoriasConVentas = await _context.Categoria
        .Where(c => c.Productos.Any(p => p.Venta.Any(v => v.Fecha.HasValue && v.Fecha.Value.Year == anioFiltro)))
        .OrderBy(c => c.Nombre)
        .ToListAsync();

    ViewBag.ListaCategorias = new SelectList(categoriasConVentas, "CodigoCategoria", "Nombre");
    ViewBag.AnioSeleccionado = anioFiltro;

    var resultado = new List<VentasVM>();

    if (CodCategoria > 0)
    {
        resultado = await _context.Venta
                                .Where(v => v.CodigoProductoNavigation.CodigoCategoria == CodCategoria && v.Fecha.HasValue && v.Fecha.Value.Year == anio)
                                .OrderBy(v => v.Fecha)
                                .Select(s => new VentasVM
                                {
                                    CodigoVenta = s.CodigoVenta,
                                    FechaVenta = s.Fecha,
                                    NombreProducto = s.CodigoProductoNavigation.Nombre,
                                    //NombreCategoria = s.CodigoProductoNavigation.CodigoCategoriaNavigation.Nombre
                                })
                                .ToListAsync();
    }

    return View(resultado);    
}
```

## Capturas de la Aplicación

### Página de Inicio

La vista está accesible de forma sencilla en el inicio:

![Página de inicio de la aplicación](https://raw.githubusercontent.com/williamgomez686/PruebaTecnica2025/refs/heads/master/PruebaTecnica2025/wwwroot/image/inicio.png)

### Vista Inicial del Ejercicio

Vista del ejercicio que primero carga sin datos, ya que así lo solicita el ejercicio:

![Vista inicial del ejercicio sin datos](https://raw.githubusercontent.com/williamgomez686/PruebaTecnica2025/refs/heads/master/PruebaTecnica2025/wwwroot/image/inicioejercicio.png)

### Resultados con Filtros

Al seleccionar una categoría, muestra los resultados:

![Vista con resultados filtrados por categoría](https://raw.githubusercontent.com/williamgomez686/PruebaTecnica2025/refs/heads/master/PruebaTecnica2025/wwwroot/image/busquedaFiltros.png)
