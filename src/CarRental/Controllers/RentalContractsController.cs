using System.Linq;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using CarRental.Data;
using CarRental.Models;

namespace CarRental.Controllers
{
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
            // Include related entities for display
            var rentals = _context.RentalContracts
                .Include(r => r.Customer)   // change if your nav property name is different
                .Include(r => r.Car);       // e.g. .Include(r => r.CarsCatalog)

            return View(rentals.ToList());
        }

        // GET: RentalContracts/Details/5
        public IActionResult Details(int? id)
        {
            if (id == null)
                return NotFound();

            var rental = _context.RentalContracts
                .Include(r => r.Customer)
                .Include(r => r.Car)
                .FirstOrDefault(r => r.ContractId == id);   // change ContractId if needed

            if (rental == null)
                return NotFound();

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
                    _context.SaveChanges();      // triggers fire here
                    return RedirectToAction(nameof(Index));
                }
                catch (DbUpdateException ex)
                {
                    // Trigger RAISE EXCEPTION messages come here
                    ModelState.AddModelError(string.Empty,
                        ex.InnerException?.Message ?? "An error occurred while creating the rental contract.");
                }
            }

            PopulateDropDowns();
            return View(rental);
        }

        // GET: RentalContracts/Edit/5
        public IActionResult Edit(int? id)
        {
            if (id == null)
                return NotFound();

            var rental = _context.RentalContracts.Find(id);
            if (rental == null)
                return NotFound();

            PopulateDropDowns();
            return View(rental);
        }

        // POST: RentalContracts/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Edit(int id, RentalContract rental)
        {
            if (id != rental.ContractId)   // adjust ContractId if different
                return NotFound();

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(rental);
                    _context.SaveChanges();    // BEFORE UPDATE trigger runs here
                    return RedirectToAction(nameof(Index));
                }
                catch (DbUpdateException ex)
                {
                    ModelState.AddModelError(string.Empty,
                        ex.InnerException?.Message ?? "An error occurred while updating the rental contract.");
                }
            }

            PopulateDropDowns();
            return View(rental);
        }

        // GET: RentalContracts/Delete/5
        public IActionResult Delete(int? id)
        {
            if (id == null)
                return NotFound();

            var rental = _context.RentalContracts
                .Include(r => r.Customer)
                .Include(r => r.Car)
                .FirstOrDefault(r => r.ContractId == id);

            if (rental == null)
                return NotFound();

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

        // Helper: check existence
        private bool RentalContractExists(int id)
        {
            return _context.RentalContracts.Any(e => e.ContractId == id);
        }

        // Helper: dropdowns for Create/Edit
        private void PopulateDropDowns()
        {
            // Customers dropdown
            ViewBag.CustomerId = new SelectList(
                _context.Customers,
                "CustomerId",   // value
                "CustomerId"    // text (change to FullName if you add it)
            );

            // Cars dropdown
            ViewBag.CarId = new SelectList(
                _context.CarsCatalogs,
                "CarId",        // or "PlateNumber" if that’s your FK
                "CarName"       // text shown in dropdown
            );
        }
    }
}
