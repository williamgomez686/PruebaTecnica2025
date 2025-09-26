using System;
using System.Collections.Generic;

namespace PruebaTecnica2025.Models;

public partial class Categorium
{
    public int CodigoCategoria { get; set; }

    public string Nombre { get; set; } = null!;

    public virtual ICollection<Producto> Productos { get; set; } = new List<Producto>();
}
