using System;
using System.Collections.Generic;

namespace CarRental.Models;

public partial class Customer
{
    public int PersonId { get; set; }

    public int? LicenceNumberId { get; set; }

    public virtual License? LicenceNumber { get; set; }

    public virtual Person Person { get; set; } = null!;

    public virtual ICollection<RentalContract> RentalContracts { get; set; } = new List<RentalContract>();
}
