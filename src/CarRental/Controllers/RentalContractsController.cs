using System.Linq;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using CarRental.Data;
using CarRental.Models;

namespace CarRental.Controllers
{
    [Authorize] // ✅ protect all actions (remove if you want public browsing)
    public class RentalContractsController : Controller
    {
        private readonly CarRentalDbContext _context;

        public RentalContractsController(CarRentalDbContext context)
        {
            _context = context;
        }

        // GET: RentalContracts
        public IActionResult Index()
        {
            var rentals = _context.RentalContracts
                .Include(r => r.Customer)
                .Include(r => r.Car);

            return View(rentals.ToList());
        }

        // GET: RentalContracts/Details/5
        public IActionResult Details(int? id)
        {
            if (id == null) return NotFound();

            var rental = _context.RentalContracts
                .Include(r => r.Customer)
                .Include(r => r.Car)
                .FirstOrDefault(r => r.ContractId == id);

            if (rental == null) return NotFound();

            return View(rental);
        }

        // GET: RentalContracts/Create
        public IActionResult Create()
        {
            PopulateDropDowns();
            return View();
        }

        // POST: RentalContracts/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Create(RentalContract rental)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    _context.RentalContracts.Add(rental);
                    _context.SaveChanges(); // DB triggers run here
                    return RedirectToAction(nameof(Index));
                }
                catch (DbUpdateException ex)
                {
                    ModelState.AddModelError(
                        string.Empty,
                        ex.InnerException?.Message ?? ex.Message
                    );
                }
            }

            PopulateDropDowns();
            return View(rental);
        }

        // GET: RentalContracts/Edit/5
        public IActionResult Edit(int? id)
        {
            if (id == null) return NotFound();

            var rental = _context.RentalContracts.Find(id);
            if (rental == null) return NotFound();

            PopulateDropDowns();
            return View(rental);
        }

        // POST: RentalContracts/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Edit(int id, RentalContract rental)
        {
            if (id != rental.ContractId) return NotFound();

            // Optional rule (keep or remove)
            int days = rental.EndingDate.Value.DayNumber - rental.StartingDate.Value.DayNumber;
            if (days > 30 && !User.IsInRole("Admin"))
                ModelState.AddModelError("", "Rentals longer than 30 days must be created/approved by an Admin.");

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(rental);
                    _context.SaveChanges(); // BEFORE UPDATE trigger runs here
                    return RedirectToAction(nameof(Index));
                }
                catch (DbUpdateException ex)
                {
                    ModelState.AddModelError(
                        string.Empty,
                        ex.InnerException?.Message ?? ex.Message
                    );
                }
            }

            PopulateDropDowns();
            return View(rental);
        }

        // GET: RentalContracts/Delete/5
        public IActionResult Delete(int? id)
        {
            if (id == null) return NotFound();

            var rental = _context.RentalContracts
                .Include(r => r.Customer)
                .Include(r => r.Car)
                .FirstOrDefault(r => r.ContractId == id);

            if (rental == null) return NotFound();

            return View(rental);
        }

        // POST: RentalContracts/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public IActionResult DeleteConfirmed(int id)
        {
            var rental = _context.RentalContracts.Find(id);
            if (rental != null)
            {
                _context.RentalContracts.Remove(rental);
                _context.SaveChanges();
            }

            return RedirectToAction(nameof(Index));
        }

        // Helper: dropdowns for Create/Edit
        private void PopulateDropDowns()
        {
            // RentalContracts.CustomerID -> Customers.PersonID
            ViewBag.CustomerId = new SelectList(_context.Customers, "PersonId", "PersonId");

            // RentalContracts.CarID -> CarsCatalogs.CarID
            ViewBag.CarId = new SelectList(_context.CarsCatalogs, "CarId", "CarName");

            // RentalContracts.PaymentID is NOT NULL in your DB
            ViewBag.PaymentId = new SelectList(_context.Payments, "PaymentId", "PaymentId");

            // RentalContracts.ApprovedByID is NOT NULL in your DB
            ViewBag.ApprovedById = new SelectList(_context.Employees, "PersonId", "PersonId");
        }
    }
}
