using System;
using System.Collections.Generic;

namespace PruebaTecnica2025.Models;

public partial class Producto
{
    public int CodigoProducto { get; set; }

    public string Nombre { get; set; } = null!;

    public int CodigoCategoria { get; set; }

    public virtual Categorium CodigoCategoriaNavigation { get; set; } = null!;

    public virtual ICollection<Ventum> Venta { get; set; } = new List<Ventum>();
}
