using Microsoft.AspNetCore.Mvc;
using CarRental.Data;
using CarRental.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;

namespace CarRental.Controllers
{
   [Authorize]
  public class CustomersController : Controller
  {
    private readonly CarRentalDbContext _context;

    public CustomersController(CarRentalDbContext context) => _context = context;

    public IActionResult Index()
    {
      var customers = _context.Customers
          .Include(c => c.Person)
          .Include(c => c.LicenceNumber);

      return View(customers);
    }

    public IActionResult Details(int? id)
    {
      if (id == null) return NotFound();

      var customer = _context.Customers
          .Include(c => c.Person)
          .Include(c => c.LicenceNumber)
          .FirstOrDefault(c => c.PersonId == id);

      if (customer == null) return NotFound();

      return View(customer);
    }

    [HttpGet]
    public IActionResult Create()
    {
      return View();
    }

    [HttpPost]
    public IActionResult Create(Customer customer)
    {
      if (ModelState.IsValid)
      {
        _context.Customers.Add(customer);
        _context.SaveChanges();
        return RedirectToAction(nameof(Index));
      }

      return View(customer);
    }

    [HttpGet]
    public IActionResult Edit(int? id)
    {
      if (id == null) return NotFound();

      var customer = _context.Customers
          .Include(c => c.Person)
          .FirstOrDefault(c => c.PersonId == id.Value);

      if (customer == null) return NotFound();

      // safety: if for some reason Person doesn't exist, create one to avoid nulls
      customer.Person ??= new Person { PersonId = customer.PersonId };

      return View(customer);
    }


    [HttpPost]
    public IActionResult Edit(int id, Customer customer)
    {
      if (id != customer.PersonId) return NotFound();

      if (ModelState.IsValid)
      {
        _context.Update(customer);
        _context.SaveChanges();
        return RedirectToAction(nameof(Index));
      }

      return View(customer);
    }

    [HttpGet]
    public IActionResult Delete(int? id)
    {
      if (id == null) return NotFound();

      var customer = _context.Customers
        .Include(c => c.Person)
        .Include(c => c.LicenceNumber)
        .FirstOrDefault(c => c.PersonId == id);

      if (customer == null) return NotFound();

      return View(customer);
    }

    [HttpPost, ActionName("Delete")]
    public IActionResult DeleteConfirmed(int id)
    {
      var customer = _context.Customers.Find(id);

      if (customer != null)
      {
        _context.Customers.Remove(customer);
        _context.SaveChanges();
      }

      return RedirectToAction(nameof(Index));
    }
  }
}
