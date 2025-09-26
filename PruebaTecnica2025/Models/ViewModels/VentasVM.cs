namespace PruebaTecnica2025.Models.ViewModels
{
    public class VentasVM
    {
        public int CodigoVenta { get; set; }
        public DateOnly? FechaVenta { get; set; }
        public string NombreProducto { get; set; }
        public string NombreCategoria { get; set; }
    }
}
