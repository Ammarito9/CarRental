-- seeding data

-- 1) Car categories
INSERT INTO "CarCategories" ("CategoryID", "CategoryName", "PricePerDay") VALUES
(1, 'Economy', 50.00),
(2, 'SUV',     80.00),
(3, 'Luxury', 150.00);

-- 2) Discounts
INSERT INTO "Discounts" ("DiscountID", "DiscountPercentage", "Note") VALUES
(1, 0,  'No discount'),
(2, 10, 'Monthly rental discount'),
(3, 20, 'VIP customer discount');

-- 3) Persons (2 customers + 2 employees)
INSERT INTO "Persons" (
    "PersonID", "NationalID",  "FirstName", "LastName",
    "Age", "Gender", "PhoneNumber", "Address", "Email", "DateOfBirth"
) VALUES
(1, '12345678901', 'John',  'Doe',     30, 'M', '05001112233', 'Istanbul, TR', 'john.doe@example.com',  '1994-05-10'),
(2, '23456789012', 'Jane',  'Smith',   28, 'F', '05002223344', 'Sakarya, TR',  'jane.smith@example.com','1996-03-22'),
(3, '34567890123', 'Ali',   'Yilmaz',  40, 'M', '05003334455', 'Istanbul, TR', 'ali.yilmaz@example.com','1984-01-15'),
(4, '45678901234', 'Ayse',  'Kara',    26, 'F', '05004445566', 'Sakarya, TR',  'ayse.kara@example.com', '1998-09-05');

-- 4) Licenses (for customers)
INSERT INTO "Licenses" (
    "LicenceNumberID", "LicenceNumber", "StartingDate", "EndingDate", "IsValid"
) VALUES
(1, 'TR-CUST1-001', '2018-01-01', '2030-01-01', TRUE),
(2, 'TR-CUST2-002', '2019-06-15', '2031-06-14', TRUE),
(3, 'TR-OLD-003',   '2010-01-01', '2020-01-01', FALSE);  -- example of invalid/expired

-- 5) Customers (PK = PersonID)
INSERT INTO "Customers" ("PersonID", "LicenceNumberID") VALUES
(1, 1),
(2, 2);

-- 6) Employees (PersonID 3 is manager, 4 reports to 3)
INSERT INTO "Employees" (
    "PersonID", "Salary",  "Permissions", "JobStartingDate", "JobEndingDate", "ManagerID"
) VALUES
(3, 1500.00, 2, '2020-01-01', NULL,        NULL),  -- manager
(4, 1000.00, 1, '2022-05-10', NULL,        3);     -- regular employee under 3

-- 7) Cars catalog
INSERT INTO "CarsCatalogs" (
    "CarID", "CarCategoryID", "PlateNumber", "CarName",
    "Status", "FuelType", "FuelLevel", "DistanceKM", "ModelYear"
) VALUES
(1, 1, '34ABC123', 'Toyota Corolla', 1, 0, 80,  50000, '2018'),
(2, 2, '34SUV456', 'Nissan Qashqai', 1, 0, 60,  75000, '2019'),
(3, 3, '34LUX789', 'BMW 5 Series',   2, 0, 50, 120000, '2017');  -- Status 2 = Under Maintenance

-- 8) Payments
INSERT INTO "Payments" (
    "PaymentID", "DiscountID", "PaymentType",
    "TotalPrice", "PaidPrice", "IssuedBy"
) VALUES
(1, 2, 1, 500.00, 500.00, 3),  -- Credit card, 10% discount, issued by Ali
(2, 1, 0, 300.00, 300.00, 4);  -- Cash, no discount, issued by Ayse

-- 9) Rental contracts
INSERT INTO "RentalContracts" (
    "ContractID", "CustomerID", "CarID",
    "StartingDate", "EndingDate",
    "PaymentID", "ApprovedByID"
) VALUES
(1, 1, 1, '2024-01-01', '2024-01-05', 1, 3),  -- John rents Corolla
(2, 2, 2, '2024-02-10', '2024-02-12', 2, 3);  -- Jane rents Qashqai

-- 10) Penalty types
INSERT INTO "PenaltyTypes" ("PenaltyTypeID", "TypeName", "Description") VALUES
(1, 'Late Return', 'Additional fee for late vehicle return.'),
(2, 'Damage',      'Fee for damages found on the vehicle.'),
(3, 'Cleaning',    'Extra cleaning required after return.');

-- 11) Penalties
INSERT INTO "Penalties" (
    "PenaltyID", "PenaltyTypeID", "ContractID", "PenaltyPrice", "Note"
) VALUES
(1, 1, 2, 50.00, 'Returned one day late.'),
(2, 3, 2, 30.00, 'Car required deep cleaning.');

-- 12) Returning records
INSERT INTO "ReturningRecords" (
    "RecordCode", "ContractID", "ActualReturnDate",
    "FinalVehicleCheckNotes", "ConsumedMileage",
    "LateDays", "AdditionalCharge"
) VALUES
(1, 1, '2024-01-05', 'No issues. Vehicle in good condition.', 600, 0,  0.00),
(2, 2, '2024-02-13', 'Minor dirt inside, late return.',       350, 1, 80.00);
