using System;
using System.Collections.Generic;

namespace CarRental.Models;

public partial class Penalty
{
    public int PenaltyId { get; set; }

    public int? PenaltyTypeId { get; set; }

    public int? ContractId { get; set; }

    public decimal? PenaltyPrice { get; set; }

    public string? Note { get; set; }

    public virtual RentalContract? Contract { get; set; }

    public virtual PenaltyType? PenaltyType { get; set; }
}
