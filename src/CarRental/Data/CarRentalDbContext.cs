using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using CarRental.Models;
namespace CarRental.Data;

public partial class CarRentalDbContext : DbContext
{
    public CarRentalDbContext()
    {
    }

    public CarRentalDbContext(DbContextOptions<CarRentalDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<CarCategory> CarCategories { get; set; }

    public virtual DbSet<CarsCatalog> CarsCatalogs { get; set; }

    public virtual DbSet<Customer> Customers { get; set; }

    public virtual DbSet<Discount> Discounts { get; set; }

    public virtual DbSet<Employee> Employees { get; set; }

    public virtual DbSet<License> Licenses { get; set; }

    public virtual DbSet<Payment> Payments { get; set; }

    public virtual DbSet<Penalty> Penalties { get; set; }

    public virtual DbSet<PenaltyType> PenaltyTypes { get; set; }

    public virtual DbSet<Person> People { get; set; }

    public virtual DbSet<RentalContract> RentalContracts { get; set; }

    public virtual DbSet<ReturningRecord> ReturningRecords { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        => optionsBuilder.UseNpgsql("Host=localhost;Port=5432;Database=CarRentalDB;Username=postgres;Password=0000");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<CarCategory>(entity =>
        {
            entity.HasKey(e => e.CategoryId).HasName("pk_carcategories");

            entity.Property(e => e.CategoryId).HasColumnName("CategoryID");
            entity.Property(e => e.CategoryName).HasMaxLength(50);
            entity.Property(e => e.PricePerDay).HasColumnType("money");
        });

        modelBuilder.Entity<CarsCatalog>(entity =>
        {
            entity.HasKey(e => e.CarId).HasName("pk_carscatalogs");

            entity.Property(e => e.CarId).HasColumnName("CarID");
            entity.Property(e => e.CarCategoryId).HasColumnName("CarCategoryID");
            entity.Property(e => e.CarName).HasMaxLength(50);
            entity.Property(e => e.DistanceKm).HasColumnName("DistanceKM");
            entity.Property(e => e.ModelYear).HasMaxLength(4);
            entity.Property(e => e.PlateNumber).HasMaxLength(15);

            entity.HasOne(d => d.CarCategory).WithMany(p => p.CarsCatalogs)
                .HasForeignKey(d => d.CarCategoryId)
                .HasConstraintName("fk_carscatalogs_carcategoryid_carcategories");
        });

        modelBuilder.Entity<Customer>(entity =>
        {
            entity.HasKey(e => e.PersonId).HasName("pk_customers");

            entity.Property(e => e.PersonId)
                .ValueGeneratedNever()
                .HasColumnName("PersonID");
            entity.Property(e => e.LicenceNumberId).HasColumnName("LicenceNumberID");

            entity.HasOne(d => d.LicenceNumber).WithMany(p => p.Customers)
                .HasForeignKey(d => d.LicenceNumberId)
                .HasConstraintName("fk_customers_licencenumberid_licenses");

            entity.HasOne(d => d.Person).WithOne(p => p.Customer)
                .HasForeignKey<Customer>(d => d.PersonId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_customers_personid_person");
        });

        modelBuilder.Entity<Discount>(entity =>
        {
            entity.HasKey(e => e.DiscountId).HasName("pk_discounts");

            entity.Property(e => e.DiscountId).HasColumnName("DiscountID");
        });

        modelBuilder.Entity<Employee>(entity =>
        {
            entity.HasKey(e => e.PersonId).HasName("pk_employees");

            entity.Property(e => e.PersonId)
                .ValueGeneratedNever()
                .HasColumnName("PersonID");
            entity.Property(e => e.ManagerId).HasColumnName("ManagerID");
            entity.Property(e => e.Salary).HasColumnType("money");

            entity.HasOne(d => d.Manager).WithMany(p => p.InverseManager)
                .HasForeignKey(d => d.ManagerId)
                .HasConstraintName("fk_employees_managerid_employees");

            entity.HasOne(d => d.Person).WithOne(p => p.Employee)
                .HasForeignKey<Employee>(d => d.PersonId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_employees_personid_person");
        });

        modelBuilder.Entity<License>(entity =>
        {
            entity.HasKey(e => e.LicenceNumberId).HasName("pk_licenses");

            entity.Property(e => e.LicenceNumberId).HasColumnName("LicenceNumberID");
            entity.Property(e => e.LicenceNumber).HasMaxLength(20);
        });

        modelBuilder.Entity<Payment>(entity =>
        {
            entity.HasKey(e => e.PaymentId).HasName("pk_payments");

            entity.Property(e => e.PaymentId).HasColumnName("PaymentID");
            entity.Property(e => e.DiscountId).HasColumnName("DiscountID");
            entity.Property(e => e.PaidPrice).HasColumnType("money");
            entity.Property(e => e.TotalPrice).HasColumnType("money");

            entity.HasOne(d => d.Discount).WithMany(p => p.Payments)
                .HasForeignKey(d => d.DiscountId)
                .HasConstraintName("fk_payments_discountid_discounts");

            entity.HasOne(d => d.IssuedByNavigation).WithMany(p => p.Payments)
                .HasForeignKey(d => d.IssuedBy)
                .HasConstraintName("fk_payments_issuedby_employees");
        });

        modelBuilder.Entity<Penalty>(entity =>
        {
            entity.HasKey(e => e.PenaltyId).HasName("pk_penalties");

            entity.Property(e => e.PenaltyId).HasColumnName("PenaltyID");
            entity.Property(e => e.ContractId).HasColumnName("ContractID");
            entity.Property(e => e.PenaltyPrice).HasColumnType("money");
            entity.Property(e => e.PenaltyTypeId).HasColumnName("PenaltyTypeID");

            entity.HasOne(d => d.Contract).WithMany(p => p.Penalties)
                .HasForeignKey(d => d.ContractId)
                .HasConstraintName("fk_penalties_contractid_rentalcontracts");

            entity.HasOne(d => d.PenaltyType).WithMany(p => p.Penalties)
                .HasForeignKey(d => d.PenaltyTypeId)
                .HasConstraintName("fk_penalties_penaltytypeid_penaltytypes");
        });

        modelBuilder.Entity<PenaltyType>(entity =>
        {
            entity.HasKey(e => e.PenaltyTypeId).HasName("pk_penaltytypes");

            entity.Property(e => e.PenaltyTypeId).HasColumnName("PenaltyTypeID");
            entity.Property(e => e.TypeName).HasMaxLength(50);
        });

        modelBuilder.Entity<Person>(entity =>
        {
            entity.HasKey(e => e.PersonId).HasName("pk_persons");

            entity.ToTable("Person");

            entity.Property(e => e.PersonId).HasColumnName("PersonID");
            entity.Property(e => e.Email).HasMaxLength(50);
            entity.Property(e => e.FirstName).HasMaxLength(20);
            entity.Property(e => e.Gender).HasMaxLength(1);
            entity.Property(e => e.LastName).HasMaxLength(20);
            entity.Property(e => e.NationalId)
                .HasMaxLength(11)
                .IsFixedLength()
                .HasColumnName("NationalID");
            entity.Property(e => e.PhoneNumber).HasMaxLength(15);
        });

        modelBuilder.Entity<RentalContract>(entity =>
        {
            entity.HasKey(e => e.ContractId).HasName("pk_rentalcontracts");

            entity.Property(e => e.ContractId).HasColumnName("ContractID");
            entity.Property(e => e.ApprovedById).HasColumnName("ApprovedByID");
            entity.Property(e => e.CarId).HasColumnName("CarID");
            entity.Property(e => e.CustomerId).HasColumnName("CustomerID");
            entity.Property(e => e.PaymentId).HasColumnName("PaymentID");

            entity.HasOne(d => d.ApprovedBy).WithMany(p => p.RentalContracts)
                .HasForeignKey(d => d.ApprovedById)
                .HasConstraintName("fk_rentalcontracts_approvedbyid_employees");

            entity.HasOne(d => d.Car).WithMany(p => p.RentalContracts)
                .HasForeignKey(d => d.CarId)
                .HasConstraintName("fk_rentalcontracts_carid_carscatalogs");

            entity.HasOne(d => d.Customer).WithMany(p => p.RentalContracts)
                .HasForeignKey(d => d.CustomerId)
                .HasConstraintName("fk_rentalcontracts_customerid_customers");

            entity.HasOne(d => d.Payment).WithMany(p => p.RentalContracts)
                .HasForeignKey(d => d.PaymentId)
                .HasConstraintName("fk_rentalcontracts_paymentid_payments");
        });

        modelBuilder.Entity<ReturningRecord>(entity =>
        {
            entity.HasKey(e => e.RecordCode).HasName("pk_returningrecords");

            entity.Property(e => e.AdditionalCharge).HasColumnType("money");
            entity.Property(e => e.ContractId).HasColumnName("ContractID");

            entity.HasOne(d => d.Contract).WithMany(p => p.ReturningRecords)
                .HasForeignKey(d => d.ContractId)
                .HasConstraintName("fk_returningrecords_contractid_rentalcontracts");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
