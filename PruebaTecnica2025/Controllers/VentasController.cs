using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using PruebaTecnica2025.Data;
using PruebaTecnica2025.Models;
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
        public async Task<IActionResult> Ejercicio(int CodCategoria, int anio)
        {
            int anioFiltro = (anio>0)? anio : 2019;

            var categoriasConVentas = await _context.Categoria
                .Where(c => c.Productos.Any(p => p.Venta.Any(v => v.Fecha.HasValue && v.Fecha.Value.Year == anioFiltro)))
                .OrderBy(c => c.Nombre)
                .ToListAsync();

            ViewBag.ListaCategorias = new SelectList(categoriasConVentas, "CodigoCategoria", "Nombre");
            ViewBag.AnioSeleccionado = anioFiltro;

            var resutlado = await _context.Venta
                                        .Where(v=>v.CodigoProductoNavigation.CodigoCategoria == CodCategoria && v.Fecha.HasValue && v.Fecha.Value.Year == anio)
                                        .OrderBy(v=>v.Fecha)
                                        .Select(s => new VentasVM
                                        {
                                            CodigoVenta = s.CodigoVenta,
                                            FechaVenta = s.Fecha,
                                            NombreProducto = s.CodigoProductoNavigation.Nombre,
                                            NombreCategoria = s.CodigoProductoNavigation.CodigoCategoriaNavigation.Nombre
                                        })
                                        .ToListAsync();

            return View (resutlado);    
        }
        [HttpGet]
        public async Task<IActionResult> ListaCategorias(int id)
        {
            var venta = await _context.Categoria.Where(c=>c.CodigoCategoria == id).OrderBy(o=>o.Nombre).ToArrayAsync();
            
            return View(venta);
        }
    }
}
