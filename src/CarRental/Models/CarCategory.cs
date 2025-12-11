using System;
using System.Collections.Generic;

namespace CarRental.Models;

public partial class CarCategory
{
    public int CategoryId { get; set; }

    public string? CategoryName { get; set; }

    public decimal? PricePerDay { get; set; }

    public virtual ICollection<CarsCatalog> CarsCatalogs { get; set; } = new List<CarsCatalog>();
}
