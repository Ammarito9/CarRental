using System.Linq;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using CarRental.Data;
using CarRental.Models;

namespace CarRental.Controllers
{
    public class PaymentsController : Controller
    {
        private readonly CarRentalDbContext _context;

        public PaymentsController(CarRentalDbContext context)
        {
            _context = context;
        }

        // GET: Payments
        public IActionResult Index()
        {
            var payments = _context.Payments.ToList();
            return View(payments);
        }

        // GET: Payments/Details/5
        public IActionResult Details(int? id)
        {
            if (id == null)
                return NotFound();

            var payment = _context.Payments
                .FirstOrDefault(p => p.PaymentId == id);   // change PaymentId if different

            if (payment == null)
                return NotFound();

            return View(payment);
        }

        // GET: Payments/Create
        public IActionResult Create()
        {
            PopulateDropDowns();
            return View();
        }

        // POST: Payments/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Create(Payment payment)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    _context.Payments.Add(payment);
                    _context.SaveChanges();
                    return RedirectToAction(nameof(Index));
                }
                catch (DbUpdateException ex)
                {
                    ModelState.AddModelError(string.Empty,
                        ex.InnerException?.Message ?? "An error occurred while creating the payment.");
                }
            }

            PopulateDropDowns();
            return View(payment);
        }

        // GET: Payments/Edit/5
        public IActionResult Edit(int? id)
        {
            if (id == null)
                return NotFound();

            var payment = _context.Payments.Find(id);
            if (payment == null)
                return NotFound();

            PopulateDropDowns();
            return View(payment);
        }

        // POST: Payments/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Edit(int id, Payment payment)
        {
            if (id != payment.PaymentId)   // adjust if PK name is different
                return NotFound();

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(payment);
                    _context.SaveChanges();
                    return RedirectToAction(nameof(Index));
                }
                catch (DbUpdateException ex)
                {
                    ModelState.AddModelError(string.Empty,
                        ex.InnerException?.Message ?? "An error occurred while updating the payment.");
                }
            }

            PopulateDropDowns();
            return View(payment);
        }

        // GET: Payments/Delete/5
        public IActionResult Delete(int? id)
        {
            if (id == null)
                return NotFound();

            var payment = _context.Payments
                .FirstOrDefault(p => p.PaymentId == id);

            if (payment == null)
                return NotFound();

            return View(payment);
        }

        // POST: Payments/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public IActionResult DeleteConfirmed(int id)
        {
            var payment = _context.Payments.Find(id);
            if (payment != null)
            {
                _context.Payments.Remove(payment);
                _context.SaveChanges();
            }

            return RedirectToAction(nameof(Index));
        }

        private bool PaymentExists(int id)
        {
            return _context.Payments.Any(e => e.PaymentId == id);
        }

        private void PopulateDropDowns()
        {
            // If Payment has a RentalContractId FK, keep this.
            // Adjust property names to your actual model.
            ViewBag.RentalContractId = new SelectList(
                _context.RentalContracts,
                "ContractId",   // value field
                "ContractId"    // text field (you can change later)
            );
        }
    }
}
