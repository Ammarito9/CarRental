using Microsoft.AspNetCore.Mvc;
using CarRental.Data;
using CarRental.Models;

namespace CarRental.Controllers
{
  public class LicensesController : Controller
  {
    private readonly CarRentalDbContext _context;

    public LicensesController(CarRentalDbContext context) => _context = context;

    public IActionResult Index()
    {
        var licenses = _context.Licenses;
        return View(licenses);
    }

    public IActionResult Details(int? id)
    {
      if (id == null) return NotFound();

      var license = _context.Licenses
          .FirstOrDefault(l => l.LicenceNumberId == id);

      if (license == null) return NotFound();

      return View(license);
    }

    [HttpGet]
    public IActionResult Create()
    {
      return View();
    }

    [HttpPost]
    public IActionResult Create(License license)
    {
      if (ModelState.IsValid)
      {
        _context.Licenses.Add(license);
        _context.SaveChanges();
        return RedirectToAction(nameof(Index));
      }

      return View(license);
    }

    [HttpGet]
    public IActionResult Edit(int? id)
    {
      if (id == null) return NotFound();

      var license = _context.Licenses.Find(id);
      if (license == null) return NotFound();

      return View(license);
    }

    [HttpPost]
    public IActionResult Edit(int id, License license)
    {
      if (id != license.LicenceNumberId) return NotFound();

      if (ModelState.IsValid)
      {
          _context.Update(license);
          _context.SaveChanges();
          return RedirectToAction(nameof(Index));
      }

      return View(license);
    }

    [HttpGet]
    public IActionResult Delete(int? id)
    {
      if (id == null) return NotFound();

      var license = _context.Licenses
          .FirstOrDefault(l => l.LicenceNumberId == id);

      if (license == null) return NotFound();

      return View(license);
    }

    [HttpPost, ActionName("Delete")]
    public IActionResult DeleteConfirmed(int id)
    {
      var license = _context.Licenses.Find(id);

      if (license != null)
      {
          _context.Licenses.Remove(license);
          _context.SaveChanges();
      }

      return RedirectToAction(nameof(Index));
    }
  }
}