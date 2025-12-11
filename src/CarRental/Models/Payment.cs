using System;
using System.Collections.Generic;

namespace CarRental.Models;

public partial class Payment
{
    public int PaymentId { get; set; }

    public int? DiscountId { get; set; }

    public int? PaymentType { get; set; }

    public decimal? TotalPrice { get; set; }

    public decimal? PaidPrice { get; set; }

    public int? IssuedBy { get; set; }

    public virtual Discount? Discount { get; set; }

    public virtual Employee? IssuedByNavigation { get; set; }

    public virtual ICollection<RentalContract> RentalContracts { get; set; } = new List<RentalContract>();
}
