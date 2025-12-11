using System;
using System.Collections.Generic;

namespace CarRental.Models;

public partial class License
{
    public int LicenceNumberId { get; set; }

    public string? LicenceNumber { get; set; }

    public DateOnly? StartingDate { get; set; }

    public DateOnly? EndingDate { get; set; }

    public bool? IsValid { get; set; }

    public virtual ICollection<Customer> Customers { get; set; } = new List<Customer>();
}
