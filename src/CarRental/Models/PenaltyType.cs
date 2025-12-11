using System;
using System.Collections.Generic;

namespace CarRental.Models;

public partial class PenaltyType
{
    public int PenaltyTypeId { get; set; }

    public string? TypeName { get; set; }

    public string? Discription { get; set; }

    public virtual ICollection<Penalty> Penalties { get; set; } = new List<Penalty>();
}
