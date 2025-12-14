using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
namespace CarRental.Data
{
    public class CarRentalIdentityDbContext : IdentityDbContext
    {
        public CarRentalIdentityDbContext(DbContextOptions<CarRentalIdentityDbContext> options)
            : base(options) { }
    }
}
