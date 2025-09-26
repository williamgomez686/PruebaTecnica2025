using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PruebaTecnica2025.Data;
using PruebaTecnica2025.Models.ViewModels;

namespace PruebaTecnica2025.Controllers
{
    public class VentasController : Controller
    {
        public readonly ApplicationDbContext _context;
        public VentasController(ApplicationDbContext context)
        {
                _context = context;
        }
        [HttpGet]
        public async Task<ActionResult> Index()
        {
            return View(await _context.Venta
                                        .Include(v=>v.CodigoProductoNavigation)
                                        .Include(pc=>pc.CodigoProductoNavigation.CodigoCategoriaNavigation)
                                        .OrderBy(o => o.Fecha)
                                        .Select(s => new VentasVM
                                        {
                                            CodigoVenta = s.CodigoVenta,
                                            FechaVenta = s.Fecha,
                                            NombreProducto = s.CodigoProductoNavigation.Nombre,
                                            NombreCategoria = s.CodigoProductoNavigation.CodigoCategoriaNavigation.Nombre
                                        })
                                        .Take(10)
                                        .ToListAsync());
        }

        [HttpGet]
        public async Task<IActionResult> Ejercicio()
        {
            _con
        }
    }
}
