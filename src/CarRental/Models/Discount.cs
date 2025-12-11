using System;
using System.Collections.Generic;

namespace CarRental.Models;

public partial class Discount
{
    public int DiscountId { get; set; }

    public int? DiscountPercentage { get; set; }

    public string? Note { get; set; }

    public virtual ICollection<Payment> Payments { get; set; } = new List<Payment>();
}
