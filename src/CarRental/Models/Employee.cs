using System;
using System.Collections.Generic;

namespace CarRental.Models;

public partial class Employee
{
    public int PersonId { get; set; }

    public decimal? Salary { get; set; }

    public int? Permissions { get; set; }

    public DateOnly? JobStartingDate { get; set; }

    public DateOnly? JobEndingDate { get; set; }

    public int? ManagerId { get; set; }

    public virtual ICollection<Employee> InverseManager { get; set; } = new List<Employee>();

    public virtual Employee? Manager { get; set; }

    public virtual ICollection<Payment> Payments { get; set; } = new List<Payment>();

    public virtual Person Person { get; set; } = null!;

    public virtual ICollection<RentalContract> RentalContracts { get; set; } = new List<RentalContract>();
}
