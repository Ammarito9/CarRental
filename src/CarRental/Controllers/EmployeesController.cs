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
            // Ensure nested object exists for the form bindings (Person.*)
            return View(new Employee { Person = new Person() });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Create(Employee employee)
        {
            if (!ModelState.IsValid)
                return View(employee);

            // ✅ 1) Create Person first (PersonId generated)
            var person = new Person();
            _context.People.Add(person);

            // Copy values from posted Person into tracked Person (no manual mapping)
            if (employee.Person != null)
                _context.Entry(person).CurrentValues.SetValues(employee.Person);

            _context.SaveChanges(); // PersonId is now generated

            // ✅ 2) Create Employee with the same PersonId (shared PK)
            var emp = new Employee();
            _context.Employees.Add(emp);

            _context.Entry(emp).CurrentValues.SetValues(employee);
            emp.PersonId = person.PersonId; // important
            emp.Person = null;              // prevent EF trying to insert Person again

            _context.SaveChanges();
            return RedirectToAction(nameof(Index));
        }

        [HttpGet]
        public IActionResult Edit(int? id)
        {
            if (id == null) return NotFound();

            var employee = _context.Employees.Include(e => e.Person)
                .Include(e => e.Manager)
                .FirstOrDefault(e => e.PersonId == id);
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
