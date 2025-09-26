using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PruebaTecnica2025.Data;
using PruebaTecnica2025.Models;

namespace PruebaTecnica2025.Controllers
{
    public class ProductosController : Controller
    {
        public readonly ApplicationDbContext _context;

        public ProductosController(ApplicationDbContext context)
        {
            _context = context;
        }
        public async Task<IActionResult> Index()
        {
            return View(await _context.Productos
                .Include(c => c.CodigoCategoriaNavigation)
                .Select(s=> new Producto() 
                { 
                    CodigoProducto = s.CodigoProducto,
                    Nombre = s.Nombre,
                    CodigoCategoriaNavigation = s.CodigoCategoriaNavigation
                })
                .OrderBy(o => o.Nombre)
                .ToListAsync());
        }
    }
}
