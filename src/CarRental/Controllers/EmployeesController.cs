using Microsoft.AspNetCore.Mvc;
using CarRental.Data;
using CarRental.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;

namespace CarRental.Controllers
{
    [Authorize(Roles = "Admin")]
    public class EmployeesController : Controller
    {
        private readonly CarRentalDbContext _context;

        public EmployeesController(CarRentalDbContext context) => _context = context;

        public IActionResult Index()
        {
            var employees = _context.Employees
                .Include(e => e.Person)
                .Include(e => e.Manager);

            return View(employees);
        }

        public IActionResult Details(int? id)
        {
            if (id == null) return NotFound();

            var employee = _context.Employees
                .Include(e => e.Person)
                .Include(e => e.Manager)
                .FirstOrDefault(e => e.PersonId == id);

            if (employee == null) return NotFound();

            return View(employee);
        }

        [HttpGet]
        public IActionResult Create()
        {
            return View();
        }

        [HttpPost]
        public IActionResult Create(Employee employee)
        {
            if (ModelState.IsValid)
            {
                _context.Employees.Add(employee);
                _context.SaveChanges();
                return RedirectToAction(nameof(Index));
            }

            return View(employee);
        }

        [HttpGet]
        public IActionResult Edit(int? id)
        {
            if (id == null) return NotFound();

            var employee = _context.Employees.Find(id);
            if (employee == null) return NotFound();

            return View(employee);
        }

        [HttpPost]
        public IActionResult Edit(int id, Employee employee)
        {
            if (id != employee.PersonId) return NotFound();

            if (ModelState.IsValid)
            {
                _context.Update(employee);
                _context.SaveChanges();
                return RedirectToAction(nameof(Index));
            }

            return View(employee);
        }

        [HttpGet]
        public IActionResult Delete(int? id)
        {
            if (id == null) return NotFound();

            var employee = _context.Employees
                .Include(e => e.Person)
                .Include(e => e.Manager)
                .FirstOrDefault(e => e.PersonId == id);

            if (employee == null) return NotFound();

            return View(employee);
        }

        [HttpPost, ActionName("Delete")]
        public IActionResult DeleteConfirmed(int id)
        {
            var employee = _context.Employees.Find(id);

            if (employee != null)
            {
                _context.Employees.Remove(employee);
                _context.SaveChanges();
            }

            return RedirectToAction(nameof(Index));
        }
    }
}
