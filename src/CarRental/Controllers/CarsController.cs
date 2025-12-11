using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using CarRental.Data;
using CarRental.Models;

namespace CarRental.Controllers
{
    public class CarsController : Controller
    {
        private readonly CarRentalDbContext _context;

        public CarsController(CarRentalDbContext context)
        {
            _context = context;
        }

        // GET: Cars
        public IActionResult Index()
        {
            var cars = _context.CarsCatalogs
                .Include(c => c.CarCategory)
                .ToList();

            return View(cars);
        }

        // GET: Cars/Details/5
        public IActionResult Details(int? id)
        {
            if (id == null)
                return NotFound();

            var car = _context.CarsCatalogs
                .Include(c => c.CarCategory)
                .FirstOrDefault(c => c.CarId == id);

            if (car == null)
                return NotFound();

            return View(car);
        }

        // GET: Cars/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: Cars/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Create(CarsCatalog car)
        {
            if (ModelState.IsValid)
            {
                _context.CarsCatalogs.Add(car);
                _context.SaveChanges();
                return RedirectToAction(nameof(Index));
            }

            return View(car);
        }

        // GET: Cars/Edit/5
        public IActionResult Edit(int? id)
        {
            if (id == null)
                return NotFound();

            var car = _context.CarsCatalogs.Find(id);
            if (car == null)
                return NotFound();

            return View(car);
        }

        // POST: Cars/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Edit(int id, CarsCatalog car)
        {
            if (id != car.CarId)
                return NotFound();

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(car);
                    _context.SaveChanges();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!CarExists(id))
                        return NotFound();
                    else
                        throw;
                }

                return RedirectToAction(nameof(Index));
            }

            return View(car);
        }

        // GET: Cars/Delete/5
        public IActionResult Delete(int? id)
        {
            if (id == null)
                return NotFound();

            var car = _context.CarsCatalogs
                .Include(c => c.CarCategory)
                .FirstOrDefault(c => c.CarId == id);

            if (car == null)
                return NotFound();

            return View(car);
        }

        // POST: Cars/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public IActionResult DeleteConfirmed(int id)
        {
            var car = _context.CarsCatalogs.Find(id);
            if (car != null)
            {
                _context.CarsCatalogs.Remove(car);
                _context.SaveChanges();
            }

            return RedirectToAction(nameof(Index));
        }

        private bool CarExists(int id)
        {
            return _context.CarsCatalogs.Any(e => e.CarId == id);
        }
    }
}
