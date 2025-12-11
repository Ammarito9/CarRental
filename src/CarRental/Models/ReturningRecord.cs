using System;
using System.Collections.Generic;

namespace CarRental.Models;

public partial class ReturningRecord
{
    public int RecordCode { get; set; }

    public int? ContractId { get; set; }

    public DateOnly? ActualReturnDate { get; set; }

    public string? FinalVehicleCheckNotes { get; set; }

    public int? ConsumedMileage { get; set; }

    public int? LateDays { get; set; }

    public decimal? AdditionalCharge { get; set; }

    public virtual RentalContract? Contract { get; set; }
}
