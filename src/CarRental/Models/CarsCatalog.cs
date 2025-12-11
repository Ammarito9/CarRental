using System;
using System.Collections.Generic;

namespace CarRental.Models;

public partial class CarsCatalog
{
    public int CarId { get; set; }

    public int? CarCategoryId { get; set; }

    public string? PlateNumber { get; set; }

    public string? CarName { get; set; }

    public int? Status { get; set; }

    public int? FuelType { get; set; }

    public int? FuelLevel { get; set; }

    public int? DistanceKm { get; set; }

    public string? ModelYear { get; set; }

    public virtual CarCategory? CarCategory { get; set; }

    public virtual ICollection<RentalContract> RentalContracts { get; set; } = new List<RentalContract>();
}
