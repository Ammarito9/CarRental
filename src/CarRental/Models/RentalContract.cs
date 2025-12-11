using System;
using System.Collections.Generic;

namespace CarRental.Models;

public partial class RentalContract
{
    public int ContractId { get; set; }

    public int? CustomerId { get; set; }

    public int? CarId { get; set; }

    public DateOnly? StartingDate { get; set; }

    public DateOnly? EndingDate { get; set; }

    public int? PaymentId { get; set; }

    public int? ApprovedById { get; set; }

    public virtual Employee? ApprovedBy { get; set; }

    public virtual CarsCatalog? Car { get; set; }

    public virtual Customer? Customer { get; set; }

    public virtual Payment? Payment { get; set; }

    public virtual ICollection<Penalty> Penalties { get; set; } = new List<Penalty>();

    public virtual ICollection<ReturningRecord> ReturningRecords { get; set; } = new List<ReturningRecord>();
}
