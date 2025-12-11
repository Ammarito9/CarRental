using System;
using System.Collections.Generic;

namespace CarRental.Models;

public partial class Person
{
    public int PersonId { get; set; }

    public string? NationalId { get; set; }

    public string? FirstName { get; set; }

    public string? LastName { get; set; }

    public short? Age { get; set; }

    public char? Gender { get; set; }

    public string? PhoneNumber { get; set; }

    public string? Address { get; set; }

    public string? Email { get; set; }

    public DateOnly? DateOfBirth { get; set; }

    public virtual Customer? Customer { get; set; }

    public virtual Employee? Employee { get; set; }
}
